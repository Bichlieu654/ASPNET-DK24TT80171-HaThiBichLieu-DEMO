using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

/// <summary>
/// Lop tro giup ket noi va thao tac voi SQL Server
/// </summary>
public class DatabaseHelper
{
    // Lay chuoi ket noi tu Web.config
    private static readonly string ConnectionString =
        ConfigurationManager.ConnectionStrings["RecipeDB"].ConnectionString;

    // --------------------------------------------------
    // Lay doi tuong ket noi SQL
    // --------------------------------------------------
    public static SqlConnection GetConnection()
    {
        return new SqlConnection(ConnectionString);
    }

    // --------------------------------------------------
    // Thuc thi cau lenh SELECT → tra ve DataTable
    // --------------------------------------------------
    public static DataTable ExecuteQuery(string sql, SqlParameter[] parameters = null)
    {
        DataTable dt = new DataTable();
        using (SqlConnection conn = GetConnection())
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }
        }
        return dt;
    }

    // --------------------------------------------------
    // Thuc thi cau lenh INSERT / UPDATE / DELETE
    // Tra ve so dong bi anh huong
    // --------------------------------------------------
    public static int ExecuteNonQuery(string sql, SqlParameter[] parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteNonQuery();
            }
        }
    }

    // --------------------------------------------------
    // Thuc thi cau lenh tra ve 1 gia tri (COUNT, MAX...)
    // --------------------------------------------------
    public static object ExecuteScalar(string sql, SqlParameter[] parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteScalar();
            }
        }
    }

    // --------------------------------------------------
    // Ma hoa mat khau bang SHA-256
    // --------------------------------------------------
    public static string HashPassword(string password)
    {
        using (SHA256 sha256 = SHA256.Create())
        {
            byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
            StringBuilder sb = new StringBuilder();
            foreach (byte b in bytes)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }

    // --------------------------------------------------
    // Kiem tra mat khau
    // --------------------------------------------------
    public static bool VerifyPassword(string password, string hash)
    {
        return HashPassword(password) == hash;
    }
}
