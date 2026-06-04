using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class UserProfile : System.Web.UI.Page
{
    // Thuoc tinh hien thi tren trang
    public string AvatarLetter    = "U";
    public string FullName        = "";
    public string Email           = "";
    public string JoinDate        = "";
    public int    TotalMyRecipes  = 0;
    public int    TotalViews      = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Yeu cau dang nhap
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=Profile.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadProfile();
            LoadMyRecipes();
            LoadCategoryStats();
        }
    }

    // Lay thong tin nguoi dung tu database
    private void LoadProfile()
    {
        int userId = Convert.ToInt32(Session["UserID"]);

        string sql = @"
            SELECT Username, FullName, Email, CreatedAt
            FROM Users
            WHERE UserID = @UserID";

        SqlParameter[] p = { new SqlParameter("@UserID", userId) };
        DataTable dt = DatabaseHelper.ExecuteQuery(sql, p);

        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            FullName     = row["FullName"].ToString();
            if (string.IsNullOrEmpty(FullName)) FullName = row["Username"].ToString();
            Email        = row["Email"].ToString();
            JoinDate     = Convert.ToDateTime(row["CreatedAt"]).ToString("MM/yyyy");
            AvatarLetter = FullName.Substring(0, 1).ToUpper();
        }
    }

    // Lay danh sach cong thuc cua nguoi dung
    private void LoadMyRecipes()
    {
        int userId = Convert.ToInt32(Session["UserID"]);

        string sql = @"
            SELECT RecipeID, Title, Description, ImagePath,
                   Category, Difficulty, PrepTime, CookTime,
                   ViewCount, CreatedAt
            FROM Recipes
            WHERE UserID = @UserID
            ORDER BY CreatedAt DESC";

        SqlParameter[] p = { new SqlParameter("@UserID", userId) };
        DataTable dt = DatabaseHelper.ExecuteQuery(sql, p);

        TotalMyRecipes = dt.Rows.Count;

        // Tinh tong luot xem
        foreach (DataRow row in dt.Rows)
            TotalViews += Convert.ToInt32(row["ViewCount"]);

        if (dt.Rows.Count == 0)
        {
            pnlEmpty.Visible      = true;
            rptMyRecipes.DataSource = null;
            rptMyRecipes.DataBind();
        }
        else
        {
            pnlEmpty.Visible      = false;
            rptMyRecipes.DataSource = dt;
            rptMyRecipes.DataBind();
        }
    }

    // Thong ke so cong thuc theo danh muc
    private void LoadCategoryStats()
    {
        int userId = Convert.ToInt32(Session["UserID"]);

        string sql = @"
            SELECT Category, COUNT(*) AS Total
            FROM Recipes
            WHERE UserID = @UserID
            GROUP BY Category
            ORDER BY Total DESC";

        SqlParameter[] p = { new SqlParameter("@UserID", userId) };
        DataTable dt = DatabaseHelper.ExecuteQuery(sql, p);

        rptStats.DataSource = dt;
        rptStats.DataBind();
    }

    // Xu ly xoa cong thuc
    protected void lbDelete_Command(object sender, CommandEventArgs e)
    {
        if (e.CommandName != "Delete") return;

        int recipeId = Convert.ToInt32(e.CommandArgument);
        int userId   = Convert.ToInt32(Session["UserID"]);

        // Kiem tra quyen so huu
        string sqlCheck = "SELECT COUNT(*) FROM Recipes WHERE RecipeID=@RecipeID AND UserID=@UserID";
        int owns = Convert.ToInt32(DatabaseHelper.ExecuteScalar(sqlCheck, new SqlParameter[] {
            new SqlParameter("@RecipeID", recipeId),
            new SqlParameter("@UserID",   userId)
        }));
        if (owns == 0) return;

        // Xoa cong thuc (Ingredients & Steps tu dong xoa qua CASCADE)
        string sqlDelete = "DELETE FROM Recipes WHERE RecipeID=@RecipeID AND UserID=@UserID";
        DatabaseHelper.ExecuteNonQuery(sqlDelete, new SqlParameter[] {
            new SqlParameter("@RecipeID", recipeId),
            new SqlParameter("@UserID",   userId)
        });

        // Tai lai danh sach
        LoadProfile();
        LoadMyRecipes();
        LoadCategoryStats();

        lblMessage.Text    = "<div class='alert alert-success'><i class='fas fa-check-circle'></i> Đã xóa công thức thành công.</div>";
        lblMessage.Visible = true;
    }

    // Helper methods
    public string GetImageUrl(string imagePath)
    {
        if (string.IsNullOrEmpty(imagePath) || imagePath == "default-recipe.jpg")
            return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80";
        return ResolveUrl("~/Uploads/" + imagePath);
    }

    public string GetDifficultyClass(string d)
    {
        switch (d)
        {
            case "Dễ":  return "easy";
            case "Khó": return "hard";
            default:    return "medium";
        }
    }

    public string GetCategoryIcon(string cat)
    {
        switch (cat)
        {
            case "Món chính":    return "🍲";
            case "Tráng miệng":  return "🍮";
            case "Khai vị":      return "🥘";
            case "Ăn chay":      return "🥗";
            case "Ăn vặt":       return "🍢";
            case "Đồ uống":      return "🥤";
            default:             return "🍽️";
        }
    }
}
