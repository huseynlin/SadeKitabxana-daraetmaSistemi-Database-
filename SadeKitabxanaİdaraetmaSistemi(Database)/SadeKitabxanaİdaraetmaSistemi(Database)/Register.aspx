<%@ Page Language="C#" AutoEventWireup="true" ResponseEncoding="utf-8" Culture="az-Latn-AZ" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="SadeKitabxanaIdaraetmaSistemi_Database_.Helper" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Register</title>
</head>
<body>
    <form id="form1" runat="server">
        <link rel="stylesheet" href="Content/site.css" />
        <div class="form-card card card-modern" style="padding:24px; margin:48px auto; max-width:520px; background:#fff;">
            <h2 style="margin-top:0;">Qeydiyyat</h2>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
            <div style="margin-top:12px;">
                <asp:Label runat="server" Text="Username:"></asp:Label><br />
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" style="width:100%; padding:8px; border-radius:6px; border:1px solid #ddd;"></asp:TextBox>
            </div>
            <div style="margin-top:12px;">
                <asp:Label runat="server" Text="Password:"></asp:Label><br />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" style="width:100%; padding:8px; border-radius:6px; border:1px solid #ddd;"></asp:TextBox>
            </div>
            <div style="margin-top:12px;">
                <asp:Label runat="server" Text="Email:"></asp:Label><br />
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" style="width:100%; padding:8px; border-radius:6px; border:1px solid #ddd;"></asp:TextBox>
            </div>
            <div style="margin-top:18px; display:flex; align-items:center; justify-content:space-between;">
                <asp:Button ID="btnRegister" runat="server" Text="Qeydiyyatdan keç" OnClick="btnRegister_Click" CssClass="btn-primary-custom btn" style="padding:10px 16px; color:#fff; border-radius:8px;" />
                &nbsp; <a href="Login.aspx" style="color:#6f42c1; text-decoration:underline;">Login</a>
            </div>
        </div>
    </form>

    <script runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure DB schema exists on first access
            try
            {
                new Tools().EnsureSchema();
            }
            catch
            {
                // ignore
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            var username = txtUsername.Text.Trim();
            var password = txtPassword.Text;
            var email = txtEmail.Text.Trim();
            if (string.IsNullOrEmpty(username))
            {
                lblMessage.Text = "Username daxil edin";
                return;
            }

            Tools tools = new Tools();
            DataTable dt = tools.ExecuteReader("SELECT * FROM Users WHERE Username=@u", new SqlParameter("@u", username));
            if (dt.Rows.Count > 0)
            {
                lblMessage.Text = "Bu username artıq mövcuddur";
                return;
            }

            tools.ExecuteNonQuery("INSERT INTO Users (Username,Password,Email) VALUES (@u,@p,@e)",
                new SqlParameter("@u", username),
                new SqlParameter("@p", password),
                new SqlParameter("@e", email));

            Response.Redirect("Login.aspx");
        }
    </script>
</body>
</html>