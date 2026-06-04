using System;

public partial class Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Xoa tat ca session
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/Default.aspx");
    }
}
