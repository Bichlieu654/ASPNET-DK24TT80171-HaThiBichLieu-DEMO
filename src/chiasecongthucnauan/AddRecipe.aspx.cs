using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;

public partial class AddRecipe : System.Web.UI.Page
{
    // Chuoi du lieu de dien san khi chinh sua
    public string ExistingIngredients = "";
    public string ExistingSteps       = "";
    public string ExistingImage       = "";
    private int editId = 0;
    private bool isEdit = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Kiem tra dang nhap
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=AddRecipe.aspx");
            return;
        }

        // Kiem tra che do sua
        if (int.TryParse(Request.QueryString["edit"], out editId) && editId > 0)
        {
            isEdit = true;
            if (!IsPostBack)
            {
                pageTitle.InnerText = "Chỉnh Sửa Công Thức";
                btnSubmit.Text      = "Lưu thay đổi";
                LoadRecipeForEdit();
            }
        }
        else if (!IsPostBack)
        {
            // Reset form
        }
    }

    // Load du lieu cong thuc de chinh sua
    private void LoadRecipeForEdit()
    {
        int userId = Convert.ToInt32(Session["UserID"]);

        string sql = @"
            SELECT r.* FROM Recipes r
            WHERE r.RecipeID = @RecipeID AND r.UserID = @UserID";

        SqlParameter[] p = {
            new SqlParameter("@RecipeID", editId),
            new SqlParameter("@UserID",   userId)
        };
        DataTable dt = DatabaseHelper.ExecuteQuery(sql, p);
        if (dt.Rows.Count == 0) { Response.Redirect("~/Profile.aspx"); return; }

        DataRow row = dt.Rows[0];
        txtTitle.Text       = row["Title"].ToString();
        txtDescription.Text = row["Description"].ToString();
        txtPrepTime.Text    = row["PrepTime"].ToString();
        txtCookTime.Text    = row["CookTime"].ToString();
        txtServings.Text    = row["Servings"].ToString();
        txtTips.Text        = row["Tips"].ToString();
        ddlCategory.SelectedValue   = row["Category"].ToString();
        ddlDiet.SelectedValue       = row["DietType"].ToString();
        ddlDifficulty.SelectedValue = row["Difficulty"].ToString();
        ExistingImage               = row["ImagePath"].ToString();

        // Lay nguyen lieu
        string sqlIng = "SELECT Name, Quantity, Unit FROM Ingredients WHERE RecipeID = @RecipeID ORDER BY SortOrder";
        DataTable dtIng = DatabaseHelper.ExecuteQuery(sqlIng, new SqlParameter[] { new SqlParameter("@RecipeID", editId) });
        var ings = new System.Collections.Generic.List<string>();
        foreach (DataRow r in dtIng.Rows)
            ings.Add(r["Name"] + "|" + r["Quantity"] + "|" + r["Unit"]);
        ExistingIngredients = System.Web.HttpUtility.JavaScriptStringEncode(string.Join("##", ings));

        // Lay cac buoc
        string sqlStep = "SELECT Description FROM Steps WHERE RecipeID = @RecipeID ORDER BY StepNumber";
        DataTable dtStep = DatabaseHelper.ExecuteQuery(sqlStep, new SqlParameter[] { new SqlParameter("@RecipeID", editId) });
        var steps = new System.Collections.Generic.List<string>();
        foreach (DataRow r in dtStep.Rows)
            steps.Add(r["Description"].ToString());
        ExistingSteps = System.Web.HttpUtility.JavaScriptStringEncode(string.Join("##", steps));
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int userId = Convert.ToInt32(Session["UserID"]);

        string title       = txtTitle.Text.Trim();
        string description = txtDescription.Text.Trim();
        string category    = ddlCategory.SelectedValue;
        string diet        = ddlDiet.SelectedValue;
        string difficulty  = ddlDifficulty.SelectedValue;
        int    prepTime    = int.TryParse(txtPrepTime.Text, out int pt) ? pt : 0;
        int    cookTime    = int.TryParse(txtCookTime.Text, out int ct) ? ct : 0;
        int    servings    = int.TryParse(txtServings.Text, out int sv) ? sv : 2;
        string tips        = txtTips.Text.Trim();

        if (string.IsNullOrEmpty(title))
        {
            ShowError("Vui lòng nhập tên công thức.");
            return;
        }

        // Xu ly upload anh
        string imagePath = isEdit ? "" : "default-recipe.jpg";
        if (fuImage.HasFile)
        {
            string ext      = Path.GetExtension(fuImage.FileName).ToLower();
            string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp", ".jfif" };
            if (Array.IndexOf(allowed, ext) < 0)
            {
                ShowError("Chỉ chấp nhận tệp ảnh JPG, JPEG, PNG, GIF, WEBP, JFIF.");
                return;
            }
            if (fuImage.FileBytes.Length > 5 * 1024 * 1024)
            {
                ShowError("Ảnh không được vượt quá 5MB.");
                return;
            }
            string uploadDir = Server.MapPath("~/Uploads/");
            if (!Directory.Exists(uploadDir))
                Directory.CreateDirectory(uploadDir);

            // Xóa hình ảnh cũ của công thức này nếu có để tiết kiệm bộ nhớ
            if (isEdit)
            {
                DeleteOldRecipeImage(editId, userId);
            }

            imagePath = Guid.NewGuid().ToString("N") + ext;
            fuImage.SaveAs(Path.Combine(uploadDir, imagePath));
        }

        int savedRecipeId = 0;

        if (isEdit)
        {
            // ===== UPDATE cong thuc =====
            string sqlUpdate = fuImage.HasFile
                ? @"UPDATE Recipes SET Title=@Title, Description=@Desc, Category=@Cat,
                       DietType=@Diet, Difficulty=@Diff, PrepTime=@Prep, CookTime=@Cook,
                       Servings=@Serv, Tips=@Tips, ImagePath=@Img
                    WHERE RecipeID=@RecipeID AND UserID=@UserID"
                : @"UPDATE Recipes SET Title=@Title, Description=@Desc, Category=@Cat,
                       DietType=@Diet, Difficulty=@Diff, PrepTime=@Prep, CookTime=@Cook,
                       Servings=@Serv, Tips=@Tips
                    WHERE RecipeID=@RecipeID AND UserID=@UserID";

            var upParams = new System.Collections.Generic.List<SqlParameter> {
                new SqlParameter("@Title",    title),
                new SqlParameter("@Desc",     description),
                new SqlParameter("@Cat",      category),
                new SqlParameter("@Diet",     diet),
                new SqlParameter("@Diff",     difficulty),
                new SqlParameter("@Prep",     prepTime),
                new SqlParameter("@Cook",     cookTime),
                new SqlParameter("@Serv",     servings),
                new SqlParameter("@Tips",     tips),
                new SqlParameter("@RecipeID", editId),
                new SqlParameter("@UserID",   userId)
            };
            if (fuImage.HasFile)
                upParams.Insert(9, new SqlParameter("@Img", imagePath));

            DatabaseHelper.ExecuteNonQuery(sqlUpdate, upParams.ToArray());
            savedRecipeId = editId;

            // Xoa nguyen lieu va buoc cu de them lai moi
            string sqlDelIng  = "DELETE FROM Ingredients WHERE RecipeID = @RecipeID";
            string sqlDelStep = "DELETE FROM Steps       WHERE RecipeID = @RecipeID";
            DatabaseHelper.ExecuteNonQuery(sqlDelIng,  new SqlParameter[] { new SqlParameter("@RecipeID", editId) });
            DatabaseHelper.ExecuteNonQuery(sqlDelStep, new SqlParameter[] { new SqlParameter("@RecipeID", editId) });
        }
        else
        {
            // ===== INSERT cong thuc moi =====
            string sqlInsert = @"
                INSERT INTO Recipes
                    (UserID, Title, Description, ImagePath, Category, DietType,
                     Difficulty, PrepTime, CookTime, Servings, Tips)
                OUTPUT INSERTED.RecipeID
                VALUES
                    (@UserID, @Title, @Desc, @Img, @Cat, @Diet,
                     @Diff, @Prep, @Cook, @Serv, @Tips)";

            SqlParameter[] insertParams = {
                new SqlParameter("@UserID", userId),
                new SqlParameter("@Title",  title),
                new SqlParameter("@Desc",   description),
                new SqlParameter("@Img",    imagePath),
                new SqlParameter("@Cat",    category),
                new SqlParameter("@Diet",   diet),
                new SqlParameter("@Diff",   difficulty),
                new SqlParameter("@Prep",   prepTime),
                new SqlParameter("@Cook",   cookTime),
                new SqlParameter("@Serv",   servings),
                new SqlParameter("@Tips",   tips)
            };
            object newId = DatabaseHelper.ExecuteScalar(sqlInsert, insertParams);
            savedRecipeId = Convert.ToInt32(newId);
        }

        // ===== INSERT nguyen lieu =====
        string ingData = hfIngredients.Value;
        if (!string.IsNullOrEmpty(ingData))
        {
            string[] ingItems = ingData.Split(new string[]{"##"}, StringSplitOptions.RemoveEmptyEntries);
            int order = 1;
            foreach (string item in ingItems)
            {
                string[] parts = item.Split('|');
                if (parts.Length < 1 || string.IsNullOrEmpty(parts[0].Trim())) continue;

                string sqlIng = @"
                    INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder)
                    VALUES (@RecipeID, @Name, @Qty, @Unit, @Order)";
                SqlParameter[] ingParams = {
                    new SqlParameter("@RecipeID", savedRecipeId),
                    new SqlParameter("@Name",     parts[0].Trim()),
                    new SqlParameter("@Qty",      parts.Length > 1 ? parts[1].Trim() : ""),
                    new SqlParameter("@Unit",     parts.Length > 2 ? parts[2].Trim() : ""),
                    new SqlParameter("@Order",    order++)
                };
                DatabaseHelper.ExecuteNonQuery(sqlIng, ingParams);
            }
        }

        // ===== INSERT cac buoc =====
        string stepData = hfSteps.Value;
        if (!string.IsNullOrEmpty(stepData))
        {
            string[] stepItems = stepData.Split(new string[]{"##"}, StringSplitOptions.RemoveEmptyEntries);
            int stepNum = 1;
            foreach (string step in stepItems)
            {
                if (string.IsNullOrEmpty(step.Trim())) continue;
                string sqlStep = @"
                    INSERT INTO Steps (RecipeID, StepNumber, Description)
                    VALUES (@RecipeID, @StepNum, @Desc)";
                SqlParameter[] sParams = {
                    new SqlParameter("@RecipeID", savedRecipeId),
                    new SqlParameter("@StepNum",  stepNum++),
                    new SqlParameter("@Desc",     step.Trim())
                };
                DatabaseHelper.ExecuteNonQuery(sqlStep, sParams);
            }
        }

        Response.Redirect("~/RecipeDetail.aspx?id=" + savedRecipeId);
    }

    private void ShowError(string message)
    {
        lblMessage.Text    = "<div class='alert alert-error'><i class='fas fa-exclamation-circle'></i> " + message + "</div>";
        lblMessage.Visible = true;
    }

    // Xóa file ảnh cũ của công thức trong thư mục Uploads
    private void DeleteOldRecipeImage(int recipeId, int userId)
    {
        try
        {
            string sql = "SELECT ImagePath FROM Recipes WHERE RecipeID = @RecipeID AND UserID = @UserID";
            SqlParameter[] p = {
                new SqlParameter("@RecipeID", recipeId),
                new SqlParameter("@UserID",   userId)
            };
            object img = DatabaseHelper.ExecuteScalar(sql, p);
            if (img != null && img != DBNull.Value)
            {
                string oldImg = img.ToString();
                // Không xóa ảnh mặc định
                if (!string.IsNullOrEmpty(oldImg) && oldImg != "default-recipe.jpg")
                {
                    string oldPath = Path.Combine(Server.MapPath("~/Uploads/"), oldImg);
                    if (File.Exists(oldPath))
                    {
                        File.Delete(oldPath);
                    }
                }
            }
        }
        catch (Exception)
        {
            // Bỏ qua lỗi nếu không thể xóa tệp
        }
    }
}
