using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

public partial class Recipes : System.Web.UI.Page
{
    private string currentCategory = "";
    private string currentDiet     = "";
    private string currentSearch   = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Lay tham so tu URL
            currentSearch   = Request.QueryString["q"]    ?? "";
            currentCategory = Request.QueryString["cat"]  ?? "";
            currentDiet     = Request.QueryString["diet"] ?? "";

            // Pre-select dropdown values
            txtSearch.Text = currentSearch;
            if (!string.IsNullOrEmpty(currentCategory))
                ddlCategory.SelectedValue = currentCategory;
            if (!string.IsNullOrEmpty(currentDiet))
                ddlDiet.SelectedValue = currentDiet;

            LoadRecipes(currentSearch, currentCategory, currentDiet);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        currentSearch   = txtSearch.Text.Trim();
        currentCategory = ddlCategory.SelectedValue;
        currentDiet     = ddlDiet.SelectedValue;
        LoadRecipes(currentSearch, currentCategory, currentDiet);
    }

    private void LoadRecipes(string search, string category, string diet)
    {
        // Xay dung cau SQL dong theo dieu kien loc
        string sql = @"
            SELECT r.RecipeID, r.Title, r.Description, r.ImagePath,
                   r.Category, r.DietType, r.Difficulty,
                   r.PrepTime, r.CookTime, r.Servings, r.ViewCount,
                   u.Username, u.FullName
            FROM Recipes r
            INNER JOIN Users u ON r.UserID = u.UserID
            WHERE 1=1";

        var paramList = new List<SqlParameter>();

        if (!string.IsNullOrEmpty(search))
        {
            sql += @" AND (r.Title LIKE @Search
                      OR r.Description LIKE @Search
                      OR EXISTS (
                          SELECT 1 FROM Ingredients i
                          WHERE i.RecipeID = r.RecipeID
                            AND i.Name LIKE @Search))";
            paramList.Add(new SqlParameter("@Search", "%" + search + "%"));
        }

        if (!string.IsNullOrEmpty(category))
        {
            sql += " AND r.Category = @Category";
            paramList.Add(new SqlParameter("@Category", category));
        }

        if (!string.IsNullOrEmpty(diet))
        {
            sql += " AND r.DietType = @Diet";
            paramList.Add(new SqlParameter("@Diet", diet));
        }

        sql += " ORDER BY r.CreatedAt DESC";

        DataTable dt = DatabaseHelper.ExecuteQuery(sql, paramList.ToArray());

        // Hien thi so ket qua
        recipeCount.InnerText = dt.Rows.Count.ToString();

        if (dt.Rows.Count == 0)
        {
            pnlEmpty.Visible      = true;
            rptRecipes.DataSource = null;
            rptRecipes.DataBind();
        }
        else
        {
            pnlEmpty.Visible      = false;
            rptRecipes.DataSource = dt;
            rptRecipes.DataBind();
        }
    }

    // Helper: CSS active cho danh muc
    public string GetActiveCat(string cat)
    {
        string active = cat == currentCategory
            ? "background:var(--primary);color:#fff;border-color:var(--primary);"
            : "";
        return active;
    }

    public string GetTotalTime(object prep, object cook)
    {
        int total = Convert.ToInt32(prep) + Convert.ToInt32(cook);
        return total > 0 ? total.ToString() : "N/A";
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

    public string GetImageUrl(string imagePath)
    {
        if (string.IsNullOrEmpty(imagePath) || imagePath == "default-recipe.jpg")
            return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80";
        return ResolveUrl("~/Uploads/" + imagePath);
    }
}
