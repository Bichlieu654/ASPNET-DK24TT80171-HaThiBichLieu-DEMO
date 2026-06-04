using System;
using System.Data;
using System.Data.SqlClient;

public partial class _Default : System.Web.UI.Page
{
    public int TotalRecipes = 0;
    public int TotalUsers   = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadStats();
            LoadFeaturedRecipes();
            LoadLatestRecipes();
        }
    }

    // Lay thong ke tong so cong thuc va thanh vien
    private void LoadStats()
    {
        string sqlRecipes = "SELECT COUNT(*) FROM Recipes";
        string sqlUsers   = "SELECT COUNT(*) FROM Users";

        object r = DatabaseHelper.ExecuteScalar(sqlRecipes);
        object u = DatabaseHelper.ExecuteScalar(sqlUsers);

        TotalRecipes = r != null ? Convert.ToInt32(r) : 0;
        TotalUsers   = u != null ? Convert.ToInt32(u) : 0;
    }

    // Top 6 cong thuc nhieu luot xem nhat
    private void LoadFeaturedRecipes()
    {
        string sql = @"
            SELECT TOP 6
                r.RecipeID, r.Title, r.Description, r.ImagePath,
                r.Category, r.DietType, r.Difficulty,
                r.PrepTime, r.CookTime, r.Servings, r.ViewCount,
                u.Username, u.FullName
            FROM Recipes r
            INNER JOIN Users u ON r.UserID = u.UserID
            ORDER BY r.ViewCount DESC";

        DataTable dt = DatabaseHelper.ExecuteQuery(sql);
        rptFeatured.DataSource = dt;
        rptFeatured.DataBind();
    }

    // 6 cong thuc moi nhat
    private void LoadLatestRecipes()
    {
        string sql = @"
            SELECT TOP 6
                r.RecipeID, r.Title, r.Description, r.ImagePath,
                r.Category, r.DietType, r.Difficulty,
                r.PrepTime, r.CookTime, r.Servings, r.ViewCount,
                u.Username, u.FullName
            FROM Recipes r
            INNER JOIN Users u ON r.UserID = u.UserID
            ORDER BY r.CreatedAt DESC";

        DataTable dt = DatabaseHelper.ExecuteQuery(sql);
        rptLatest.DataSource = dt;
        rptLatest.DataBind();
    }

    // Helper: tinh tong thoi gian nau
    public string GetTotalTime(object prep, object cook)
    {
        int total = Convert.ToInt32(prep) + Convert.ToInt32(cook);
        return total > 0 ? total.ToString() : "N/A";
    }

    // Helper: CSS class theo do kho
    public string GetDifficultyClass(string difficulty)
    {
        switch (difficulty)
        {
            case "Dễ": return "easy";
            case "Khó": return "hard";
            default:  return "medium";
        }
    }

    // Helper: duong dan anh
    public string GetImageUrl(string imagePath)
    {
        if (string.IsNullOrEmpty(imagePath) || imagePath == "default-recipe.jpg")
            return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80";
        return ResolveUrl("~/Uploads/" + imagePath);
    }

    // Helper: hien thi badge che do an (chi hien khi khac Thong thuong)
    public string GetDietBadge(string dietType)
    {
        if (string.IsNullOrEmpty(dietType) || dietType == "Thông thường")
            return "";
        return "<span class=\"recipe-badge diet\">" + dietType + "</span>";
    }
}