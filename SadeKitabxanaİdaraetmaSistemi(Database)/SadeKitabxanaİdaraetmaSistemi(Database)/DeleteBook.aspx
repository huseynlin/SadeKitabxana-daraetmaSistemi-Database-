<%@ Page Language="C#" AutoEventWireup="true" ResponseEncoding="utf-8" Culture="az-Latn-AZ" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="SadeKitabxanaIdaraetmaSistemi_Database_.Helper" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Delete Book</title>
</head>
<body>
    <form id="form1" runat="server">
        <link rel="stylesheet" href="Content/site.css" />
    </form>

    <script runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int id = 0;
            int.TryParse(Request.QueryString["id"], out id);
            if (id > 0)
            {
                Tools tools = new Tools();
                // Use BookID column name
                tools.ExecuteNonQuery("DELETE FROM Books WHERE BookID=@id", new SqlParameter("@id", id));
            }

            Response.Redirect("Books.aspx");
        }
    </script>
</body>
</html>