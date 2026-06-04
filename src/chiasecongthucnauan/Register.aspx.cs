using System;
using System.Data;
using System.Data.SqlClient;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] != null)
            Response.Redirect("~/Default.aspx");
    }

    // Kiem tra do dai mat khau phia server (CustomValidator)
    protected void ValidatePassword(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
    {
        args.IsValid = !string.IsNullOrEmpty(args.Value) && args.Value.Length >= 6;
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string username = txtUsername.Text.Trim();
        string fullname = txtFullName.Text.Trim();
        string email    = txtEmail.Text.Trim().ToLower();
        string password = txtPassword.Text;

        // Kiem tra do dai mat khau
        if (password.Length < 6)
        {
            ShowError("Mật khẩu phải có ít nhất 6 ký tự.");
            return;
        }

        // Kiem tra username da ton tai chua
        string sqlCheck = @"
            SELECT COUNT(*) FROM Users
            WHERE Username = @Username OR Email = @Email";

        SqlParameter[] checkParams = {
            new SqlParameter("@Username", username),
            new SqlParameter("@Email",    email)
        };

        int exists = Convert.ToInt32(DatabaseHelper.ExecuteScalar(sqlCheck, checkParams));
        if (exists > 0)
        {
            ShowError("Tên đăng nhập hoặc email đã được sử dụng. Vui lòng chọn tên khác.");
            return;
        }

        // Them nguoi dung moi vao database (Luu mat khau dang text thuong theo yeu cau)
        string sqlInsert = @"
            INSERT INTO Users (Username, Email, PasswordHash, FullName)
            VALUES (@Username, @Email, @PasswordHash, @FullName)";

        SqlParameter[] insertParams = {
            new SqlParameter("@Username",     username),
            new SqlParameter("@Email",        email),
            new SqlParameter("@PasswordHash", password),
            new SqlParameter("@FullName",     fullname)
        };

        int rows = DatabaseHelper.ExecuteNonQuery(sqlInsert, insertParams);

        if (rows > 0)
        {
            // Lay thong tin nguoi dung vua dang ky de dang nhap luon
            string sqlGetUser = "SELECT UserID FROM Users WHERE Username = @Username";
            SqlParameter[] getParams = { new SqlParameter("@Username", username) };
            object userIdObj = DatabaseHelper.ExecuteScalar(sqlGetUser, getParams);

            Session["UserID"]   = userIdObj;
            Session["Username"] = username;
            Session["FullName"] = fullname;
            Session["Email"]    = email;

            Response.Redirect("~/Default.aspx");
        }
        else
        {
            ShowError("Đã xảy ra lỗi. Vui lòng thử lại.");
        }
    }

    private void ShowError(string message)
    {
        lblMessage.Text    = "<div class='alert alert-error'><i class='fas fa-exclamation-circle'></i> " + message + "</div>";
        lblMessage.Visible = true;
    }
}
