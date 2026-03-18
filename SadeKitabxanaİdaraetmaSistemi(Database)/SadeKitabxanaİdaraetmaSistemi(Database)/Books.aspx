<%@ Page Language="C#" AutoEventWireup="true" ResponseEncoding="utf-8" Culture="az-Latn-AZ" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="SadeKitabxanaIdaraetmaSistemi_Database_.Helper" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Kitablar - İdarəetmə Paneli</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f4f7f9; 
            color: #333; 
            margin: 0; 
            padding: 40px 20px; 
        }
        .container { max-width: 1100px; margin: 0 auto; }
        
        .topbar { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 25px; 
            padding: 0 10px;
        }
        .welcome { font-size: 20px; font-weight: 500; color: #444; }
        
        .btn { 
            display: inline-block; 
            padding: 8px 16px; 
            border-radius: 6px; 
            font-size: 14px; 
            font-weight: 600; 
            text-decoration: none; 
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
        }
        .btn-logout { background: #6c757d; color: white; }
        .btn-logout:hover { background: #5a6268; }
        
        .btn-edit { background: #6f42c1; color: white !important; margin-right: 5px; }
        .btn-edit:hover { background: #59359a; transform: translateY(-1px); }
        
        .btn-delete { background: #dc3545; color: white !important; }
        .btn-delete:hover { background: #c82333; transform: translateY(-1px); }
        
        .btn-add { 
            background: #28a745; 
            color: white; 
            margin-top: 20px; 
            padding: 12px 20px; 
            font-size: 15px;
        }
        .btn-add:hover { background: #218838; box-shadow: 0 4px 8px rgba(40,167,69,0.2); }

        .card { 
            background: #fff; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
        }
        h2 { margin-top: 0; margin-bottom: 25px; font-size: 24px; color: #2c3e50; }

        .table-modern { 
            width: 100%; 
            border-collapse: collapse; 
            overflow: hidden;
        }
        .table-modern thead th { 
            background-color: #f8f9fa; 
            color: #555; 
            font-weight: 600; 
            text-align: left; 
            padding: 15px; 
            border-bottom: 2px solid #edf2f7;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        .table-modern tbody td { 
            padding: 15px; 
            border-bottom: 1px solid #f1f1f1; 
            vertical-align: middle;
            font-size: 15px;
        }
        .table-modern tbody tr:hover { background-color: #fcfcfc; }
        
        .actions-cell { text-align: right !important; white-space: nowrap; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="topbar">
                <div class="welcome">
                    👋 <asp:Label ID="lblWelcome" runat="server"></asp:Label>
                </div>
                <asp:Button ID="btnLogout" runat="server" Text="Çıxış" CssClass="btn btn-logout" OnClick="btnLogout_Click" />
            </div>

            <div class="card">
                <h2>📚 Kitab Kolleksiyası</h2>
                
                <asp:GridView ID="gvBooks" runat="server" AutoGenerateColumns="false" 
                    CssClass="table-modern" GridLines="None" 
                    OnRowDataBound="gvBooks_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" Visible="false" />
                        <asp:BoundField DataField="Title" HeaderText="Kitabın Adı" />
                        <asp:BoundField DataField="Author" HeaderText="Müəllif" />
                        <asp:BoundField DataField="Year" HeaderText="Nəşr İli" />
                        <asp:BoundField DataField="Genre" HeaderText="Janr" />
                        
                        <asp:TemplateField HeaderText="Əməliyyatlar" ItemStyle-CssClass="actions-cell" HeaderStyle-CssClass="actions-cell">
                            <ItemTemplate>
                                <a class="btn btn-edit" href='EditBook.aspx?id=<%# Eval("Id") %>'>Redaktə</a>
                                <a class="btn btn-delete" href='DeleteBook.aspx?id=<%# Eval("Id") %>' 
                                   onclick="return confirm('Bu kitabı silmək istədiyinizdən əminsiniz?');">Sil</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <a class="btn btn-add" href="AddBook.aspx">+ Yeni kitab əlavə et</a>
            </div>
        </div>
    </form>

    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            lblWelcome.Text = "Xoş gəlmisiniz, " + Server.HtmlEncode(Session["username"].ToString());

            if (!IsPostBack)
            {
                LoadBooks();
            }
        }

        private void LoadBooks()
        {
            try {
                Tools tools = new Tools();
                DataTable dt = tools.ExecuteReader("SELECT BookID AS Id, Title, Author, [Year], Genre FROM Books");
                gvBooks.DataSource = dt;
                gvBooks.DataBind();
            } catch {
                // Xəta olarsa burada idarə oluna bilər
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void gvBooks_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Başlıq sətirini standart HTML thead strukturuna salmaq üçün (CSS üçün vacibdir)
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.TableSection = TableRowSection.TableHeader;
            }
        }
    </script>
</body>
</html>