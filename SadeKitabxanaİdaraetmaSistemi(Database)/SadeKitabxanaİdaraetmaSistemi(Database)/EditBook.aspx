<%@ Page Language="C#" AutoEventWireup="true" ResponseEncoding="utf-8" Culture="az-Latn-AZ" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="SadeKitabxanaIdaraetmaSistemi_Database_.Helper" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Kitabı Redaktə et</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f4f7f9; 
            color: #333; 
            margin: 0; 
            padding: 40px 20px; 
            display: flex;
            justify-content: center;
        }

        .card { 
            background: #fff; 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.05); 
            width: 100%;
            max-width: 500px;
        }

        h2 { 
            margin-top: 0; 
            margin-bottom: 30px; 
            font-size: 24px; 
            color: #2c3e50; 
            text-align: center;
            border-bottom: 2px solid #f1f1f1;
            padding-bottom: 15px;
        }

        .form-group { margin-bottom: 20px; }
        
        .form-group label { 
            display: block;
            font-weight: 600; 
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
        }

        .form-control { 
            width: 100%; 
            padding: 12px 15px; 
            border: 1.5px solid #e1e4e8; 
            border-radius: 8px; 
            font-size: 15px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-control:focus { 
            outline: none; 
            border-color: #6f42c1; 
            box-shadow: 0 0 0 3px rgba(111, 66, 193, 0.1); 
        }

        .actions { 
            margin-top: 30px; 
            display: flex; 
            gap: 15px; 
        }

        .btn { 
            flex: 1; 
            padding: 12px; 
            border-radius: 8px; 
            font-size: 15px; 
            font-weight: 600; 
            text-decoration: none; 
            text-align: center;
            cursor: pointer; 
            transition: all 0.3s ease;
            border: none;
        }

        .btn-success { background: #6f42c1; color: #fff; }
        .btn-success:hover { background: #59359a; transform: translateY(-1px); }

        .btn-danger { background: #f8f9fa; color: #dc3545; border: 1px solid #dc3545; }
        .btn-danger:hover { background: #dc3545; color: #fff; }

        .error-msg {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="card">
        <h2>✏️ Kitabı Redaktə et</h2>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="error-msg"></asp:Label>

        <div class="form-group">
            <label>Kitabın Başlığı</label>
            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Müəllif</label>
            <asp:TextBox ID="txtAuthor" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Nəşr İli</label>
            <asp:TextBox ID="txtYear" runat="server" CssClass="form-control" 
                onkeypress="return isNumberKey_Edit(event)"></asp:TextBox>
            <asp:RegularExpressionValidator ID="revYear" runat="server" ControlToValidate="txtYear" 
                ValidationExpression="^\d*$" ErrorMessage="Zəhmət olmasa yalnız rəqəm daxil edin." 
                CssClass="error-msg" Display="Dynamic" />
        </div>

        <div class="form-group">
            <label>Janr</label>
            <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="actions">
            <asp:Button ID="btnSave" runat="server" Text="Yadda saxla" OnClick="btnSave_Click" CssClass="btn btn-success" />
            <a class="btn btn-danger" href="Books.aspx">Geri</a>
        </div>
    </form>

    <script type="text/javascript">
        function isNumberKey_Edit(evt) {
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
    return true;
}
    </script>

    <script runat="server">
        protected int BookId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int.TryParse(Request.QueryString["id"], out BookId);
            if (BookId <= 0)
            {
                Response.Redirect("Books.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBook();
            }
        }

        private void LoadBook()
        {
            try {
                Tools tools = new Tools();
                DataTable dt = tools.ExecuteReader("SELECT BookID AS Id, Title, Author, [Year], Genre FROM Books WHERE BookID=@id", 
                    new SqlParameter("@id", BookId));
                
                if (dt.Rows.Count == 0) {
                    Response.Redirect("Books.aspx");
                    return;
                }

                var row = dt.Rows[0];
                txtTitle.Text = row["Title"].ToString();
                txtAuthor.Text = row["Author"].ToString();
                txtYear.Text = row["Year"].ToString();
                txtGenre.Text = row["Genre"].ToString();
            }
            catch (Exception ex) {
                lblMessage.Text = "Məlumat yüklənərkən xəta: " + ex.Message;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            var title = txtTitle.Text.Trim();
            var author = txtAuthor.Text.Trim();
            var yearText = txtYear.Text.Trim();
            var genre = txtGenre.Text.Trim();

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(author))
            {
                lblMessage.Text = "Başlıq və Müəllif hissələri mütləqdir.";
                return;
            }

            int year = 0;
            int.TryParse(yearText, out year);

            try {
                Tools tools = new Tools();
                tools.ExecuteNonQuery("UPDATE Books SET Title=@t, Author=@a, [Year]=@y, Genre=@g WHERE BookID=@id",
                    new SqlParameter("@t", title),
                    new SqlParameter("@a", author),
                    new SqlParameter("@y", year),
                    new SqlParameter("@g", genre),
                    new SqlParameter("@id", BookId));

                Response.Redirect("Books.aspx");
            }
            catch (Exception ex) {
                lblMessage.Text = "Yadda saxlayarkən xəta baş verdi: " + ex.Message;
            }
        }
    </script>
</body>
</html>