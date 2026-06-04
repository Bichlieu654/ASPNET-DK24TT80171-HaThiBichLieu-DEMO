<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RecipeDetail.aspx.cs" Inherits="RecipeDetail"
    MasterPageFile="~/Site.master" %>

    <asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
        <title>
            <%=RecipeTitle %> – Bếp mẹ Ớt
        </title>
    </asp:Content>

    <asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

        <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
            <div class="container" style="padding:80px 0;text-align:center;">
                <div class="empty-icon" style="font-size:5rem;">🍽️</div>
                <h2 style="margin:16px 0 8px;">Không tìm thấy công thức</h2>
                <p style="color:var(--text-muted);margin-bottom:24px;">Công thức này không tồn tại hoặc đã bị xóa.</p>
                <a href="Recipes.aspx" class="btn btn-primary">Xem tất cả công thức</a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlRecipe" runat="server" Visible="false">
            <div class="recipe-detail">
                <div class="container">

                    <!-- BACK BUTTON -->
                    <a href="Recipes.aspx"
                        style="display:inline-flex;align-items:center;gap:8px;color:var(--text-muted);font-weight:600;margin-bottom:24px;font-size:0.9rem;">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>

                    <!-- RECIPE HEADER -->
                    <div class="recipe-detail-header">
                        <div class="recipe-hero-img">
                            <img id="imgRecipe" runat="server" alt="Ảnh món ăn"
                                onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80'" />
                        </div>
                        <div class="recipe-info-header">
                            <div class="recipe-tags">
                                <span class="tag tag-category" id="tagCategory" runat="server"></span>
                                <span class="tag tag-diet" id="tagDiet" runat="server"></span>
                            </div>
                            <h1 id="lblTitle" runat="server"></h1>
                            <p class="recipe-description" id="lblDescription" runat="server"></p>

                            <!-- STATS -->
                            <div class="recipe-stats-grid">
                                <div class="stat-box">
                                    <div class="stat-icon">⏱️</div>
                                    <strong class="stat-val" id="lblPrepTime" runat="server"></strong>
                                    <span class="stat-lbl">phút chuẩn bị</span>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-icon">🔥</div>
                                    <strong class="stat-val" id="lblCookTime" runat="server"></strong>
                                    <span class="stat-lbl">phút nấu</span>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-icon">👥</div>
                                    <strong class="stat-val" id="lblServings" runat="server"></strong>
                                    <span class="stat-lbl">khẩu phần</span>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-icon">📊</div>
                                    <strong class="stat-val" id="lblDifficulty" runat="server"></strong>
                                    <span class="stat-lbl">độ khó</span>
                                </div>
                            </div>

                            <!-- AUTHOR -->
                            <div class="recipe-author-info">
                                <div class="author-avatar-lg" id="lblAuthorAvatar" runat="server"></div>
                                <div class="author-info-text">
                                    <div class="author-name" id="lblAuthorName" runat="server"></div>
                                    <div class="author-date">
                                        Đăng ngày <span id="lblDate" runat="server"></span>
                                        &nbsp;·&nbsp; <i class="fas fa-eye" style="color:var(--primary);"></i>
                                        <span id="lblViews" runat="server"></span> lượt xem
                                    </div>
                                </div>
                            </div>

                            <!-- OWNER ACTIONS -->
                            <asp:Panel ID="pnlOwner" runat="server" Visible="false">
                                <div style="margin-top:16px;display:flex;gap:10px;flex-wrap:wrap;">
                                    <a id="lnkEdit" runat="server" class="btn btn-outline btn-sm">
                                        <i class="fas fa-edit"></i> Chỉnh sửa
                                    </a>
                                    <asp:Button ID="btnDelete" runat="server" Text="🗑 Xóa công thức"
                                        CssClass="btn btn-danger btn-sm" OnClick="btnDelete_Click"
                                        OnClientClick="return confirm('Bạn có chắc muốn xóa công thức này?');" />
                                </div>
                            </asp:Panel>
                        </div>
                    </div>

                    <div style="display:grid;grid-template-columns:1fr 1.6fr;gap:24px;">

                        <!-- INGREDIENTS -->
                        <div>
                            <div class="content-section">
                                <h2><i class="fas fa-shopping-basket"></i> Nguyên liệu</h2>
                                <div class="ingredients-list">
                                    <asp:Repeater ID="rptIngredients" runat="server">
                                        <ItemTemplate>
                                            <div class="ingredient-item">
                                                <div class="ing-dot"></div>
                                                <span class="ing-qty">
                                                    <%#Eval("Quantity") %>
                                                        <%#Eval("Unit") %>
                                                </span>
                                                <span class="ing-name">
                                                    <%#Eval("Name") %>
                                                </span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>

                            <!-- TIPS -->
                            <asp:Panel ID="pnlTips" runat="server" Visible="false">
                                <div class="tips-box">
                                    <div class="tips-icon">💡</div>
                                    <div>
                                        <strong style="color:var(--text-dark);display:block;margin-bottom:6px;">Mẹo nấu
                                            ăn</strong>
                                        <p id="lblTips" runat="server"></p>
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>

                        <!-- STEPS -->
                        <div class="content-section">
                            <h2><i class="fas fa-list-ol"></i> Các bước thực hiện</h2>
                            <div class="steps-list">
                                <asp:Repeater ID="rptSteps" runat="server">
                                    <ItemTemplate>
                                        <div class="step-item">
                                            <div class="step-num">
                                                <%#Eval("StepNumber") %>
                                            </div>
                                            <div class="step-content">
                                                <%#Eval("Description") %>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>

                    <!-- RELATED RECIPES -->
                    <div style="margin-top:40px;">
                        <div class="section-header" style="text-align:left;margin-bottom:24px;">
                            <h2 style="font-family:'Playfair Display',serif;font-size:1.5rem;">
                                Công thức <span style="color:var(--primary);">liên quan</span>
                            </h2>
                        </div>
                        <div class="recipes-grid">
                            <asp:Repeater ID="rptRelated" runat="server">
                                <ItemTemplate>
                                    <div class="recipe-card">
                                        <div class="recipe-card-img">
                                            <a href='RecipeDetail.aspx?id=<%#Eval("RecipeID") %>'>
                                                <img src='<%#GetImageUrl(Eval("ImagePath").ToString()) %>'
                                                    alt='<%#Eval("Title") %>'
                                                    onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80'" />
                                            </a>
                                            <span class="recipe-badge">
                                                <%#Eval("Category") %>
                                            </span>
                                        </div>
                                        <div class="recipe-card-body">
                                            <h3><a href='RecipeDetail.aspx?id=<%#Eval("RecipeID") %>'>
                                                    <%#Eval("Title") %>
                                                </a></h3>
                                            <div class="recipe-meta">
                                                <span><i class="fas fa-clock"></i>
                                                    <%#(Convert.ToInt32(Eval("PrepTime")) +
                                                        Convert.ToInt32(Eval("CookTime"))) %> phút
                                                </span>
                                                <span><i class="fas fa-users"></i>
                                                    <%#Eval("Servings") %> người
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                </div>
            </div>
        </asp:Panel>

    </asp:Content>