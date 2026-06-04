using System;
using System.Data;
using System.Data.SqlClient;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Neu da dang nhap thi chuyen ve trang chu
        if (Session["UserID"] != null)
            Response.Redirect("~/Default.aspx");
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text;

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ShowError("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            return;
        }

        // Kiem tra mat khau dang text thuong voi database (khong ma hoa va loai bo cot IsActive khong ton tai)
        string sql = @"
            SELECT UserID, Username, FullName, Email
            FROM Users
            WHERE Username = @Username
              AND PasswordHash = @Password";

        SqlParameter[] parameters = {
            new SqlParameter("@Username", username),
            new SqlParameter("@Password", password)
        };

        DataTable dt = DatabaseHelper.ExecuteQuery(sql, parameters);

        if (dt.Rows.Count > 0)
        {
            // Luu thong tin phien dang nhap
            DataRow user = dt.Rows[0];
            Session["UserID"]   = user["UserID"];
            Session["Username"] = user["Username"];
            Session["FullName"] = user["FullName"].ToString();
            Session["Email"]    = user["Email"];

            // Chuyen den trang truoc do hoac trang chu
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl))
                Response.Redirect(returnUrl);
            else
                Response.Redirect("~/Default.aspx");
        }
        else
        {
            ShowError("Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng thử lại.");
        }
    }

    private void ShowError(string message)
    {
        lblMessage.Text    = "<div class='alert alert-error'><i class='fas fa-exclamation-circle'></i> " + message + "</div>";
        lblMessage.Visible = true;
    }
}
