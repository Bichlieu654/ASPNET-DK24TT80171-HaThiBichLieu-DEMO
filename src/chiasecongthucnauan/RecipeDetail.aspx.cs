using System;
using System.Data;
using System.Data.SqlClient;

public partial class RecipeDetail : System.Web.UI.Page
{
    public string RecipeTitle = "Chi tiết công thức";
    private int recipeId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!int.TryParse(Request.QueryString["id"], out recipeId) || recipeId <= 0)
        {
            pnlNotFound.Visible = true;
            return;
        }

        if (!IsPostBack)
        {
            LoadRecipe();
        }
    }

    private void LoadRecipe()
    {
        // ===== QUERY 1: Lay thong tin cong thuc =====
        string sqlRecipe = @"
            SELECT r.RecipeID, r.Title, r.Description, r.ImagePath,
                   r.Category, r.DietType, r.Difficulty,
                   r.PrepTime, r.CookTime, r.Servings, r.Tips,
                   r.ViewCount, r.CreatedAt, r.UserID,
                   u.Username, u.FullName
            FROM Recipes r
            INNER JOIN Users u ON r.UserID = u.UserID
            WHERE r.RecipeID = @RecipeID";

        SqlParameter[] p = { new SqlParameter("@RecipeID", recipeId) };
        DataTable dt = DatabaseHelper.ExecuteQuery(sqlRecipe, p);

        if (dt.Rows.Count == 0)
        {
            pnlNotFound.Visible = true;
            return;
        }

        pnlRecipe.Visible = true;
        DataRow row = dt.Rows[0];

        // Gan du lieu len trang
        RecipeTitle          = row["Title"].ToString();
        lblTitle.InnerText   = row["Title"].ToString();
        lblDescription.InnerText = row["Description"].ToString();

        tagCategory.InnerText = row["Category"].ToString();
        tagDiet.InnerText     = row["DietType"].ToString();
        if (row["DietType"].ToString() == "Thông thường")
            tagDiet.Visible = false;

        lblPrepTime.InnerText   = row["PrepTime"].ToString();
        lblCookTime.InnerText   = row["CookTime"].ToString();
        lblServings.InnerText   = row["Servings"].ToString();
        lblDifficulty.InnerText = row["Difficulty"].ToString();

        // Author info
        string authorName = row["FullName"].ToString();
        if (string.IsNullOrEmpty(authorName)) authorName = row["Username"].ToString();
        lblAuthorName.InnerText   = authorName;
        lblAuthorAvatar.InnerText = authorName.Substring(0, 1).ToUpper();
        lblDate.InnerText         = Convert.ToDateTime(row["CreatedAt"]).ToString("dd/MM/yyyy");
        lblViews.InnerText        = row["ViewCount"].ToString();

        // Anh mon an
        string imgPath = row["ImagePath"].ToString();
        imgRecipe.Src  = (string.IsNullOrEmpty(imgPath) || imgPath == "default-recipe.jpg")
            ? "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80"
            : ResolveUrl("~/Uploads/" + imgPath);

        // Meo nau an
        string tips = row["Tips"].ToString();
        if (!string.IsNullOrEmpty(tips))
        {
            pnlTips.Visible  = true;
            lblTips.InnerText = tips;
        }

        // Hien thi nut chinh sua/xoa neu la chu cong thuc
        int authorId = Convert.ToInt32(row["UserID"]);
        if (Session["UserID"] != null && Convert.ToInt32(Session["UserID"]) == authorId)
        {
            pnlOwner.Visible  = true;
            lnkEdit.HRef      = "AddRecipe.aspx?edit=" + recipeId;
        }

        // ===== QUERY 2: Tang luot xem =====
        string sqlView = "UPDATE Recipes SET ViewCount = ViewCount + 1 WHERE RecipeID = @RecipeID";
        DatabaseHelper.ExecuteNonQuery(sqlView, new SqlParameter[] { new SqlParameter("@RecipeID", recipeId) });

        // ===== QUERY 3: Lay nguyen lieu =====
        string sqlIng = @"
            SELECT Name, Quantity, Unit
            FROM Ingredients
            WHERE RecipeID = @RecipeID
            ORDER BY SortOrder";
        DataTable dtIng = DatabaseHelper.ExecuteQuery(sqlIng, new SqlParameter[] { new SqlParameter("@RecipeID", recipeId) });
        rptIngredients.DataSource = dtIng;
        rptIngredients.DataBind();

        // ===== QUERY 4: Lay cac buoc =====
        string sqlSteps = @"
            SELECT StepNumber, Description
            FROM Steps
            WHERE RecipeID = @RecipeID
            ORDER BY StepNumber";
        DataTable dtSteps = DatabaseHelper.ExecuteQuery(sqlSteps, new SqlParameter[] { new SqlParameter("@RecipeID", recipeId) });
        rptSteps.DataSource = dtSteps;
        rptSteps.DataBind();

        // ===== QUERY 5: Cong thuc lien quan (cung danh muc) =====
        string sqlRelated = @"
            SELECT TOP 3
                r.RecipeID, r.Title, r.ImagePath, r.Category,
                r.PrepTime, r.CookTime, r.Servings
            FROM Recipes r
            WHERE r.Category = @Category
              AND r.RecipeID <> @RecipeID
            ORDER BY r.ViewCount DESC";

        SqlParameter[] relatedParams = {
            new SqlParameter("@Category",  row["Category"]),
            new SqlParameter("@RecipeID",  recipeId)
        };
        DataTable dtRelated = DatabaseHelper.ExecuteQuery(sqlRelated, relatedParams);
        rptRelated.DataSource = dtRelated;
        rptRelated.DataBind();
    }

    // Xoa cong thuc (chi chu so huu)
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        if (Session["UserID"] == null) return;

        int userId = Convert.ToInt32(Session["UserID"]);

        // Kiem tra quyen so huu
        string sqlCheck = "SELECT COUNT(*) FROM Recipes WHERE RecipeID = @RecipeID AND UserID = @UserID";
        int owns = Convert.ToInt32(DatabaseHelper.ExecuteScalar(sqlCheck, new SqlParameter[] {
            new SqlParameter("@RecipeID", recipeId),
            new SqlParameter("@UserID",   userId)
        }));
        if (owns == 0) return;

        // Xoa cong thuc (Ingredients va Steps tu dong xoa nho ON DELETE CASCADE)
        string sqlDelete = "DELETE FROM Recipes WHERE RecipeID = @RecipeID AND UserID = @UserID";
        DatabaseHelper.ExecuteNonQuery(sqlDelete, new SqlParameter[] {
            new SqlParameter("@RecipeID", recipeId),
            new SqlParameter("@UserID",   userId)
        });

        Response.Redirect("~/Profile.aspx");
    }

    public string GetImageUrl(string imagePath)
    {
        if (string.IsNullOrEmpty(imagePath) || imagePath == "default-recipe.jpg")
            return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80";
        return ResolveUrl("~/Uploads/" + imagePath);
    }
}
