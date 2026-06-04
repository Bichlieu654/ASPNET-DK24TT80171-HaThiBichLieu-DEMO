<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="UserProfile"
    MasterPageFile="~/Site.master" %>

    <asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
        <title>Trang cá nhân – Bếp mẹ Ớt</title>
    </asp:Content>

    <asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container" style="padding-top:40px;padding-bottom:60px;">

            <!-- ===== PROFILE HEADER ===== -->
            <div class="profile-header">
                <div class="profile-avatar-lg">
                    <%=AvatarLetter %>
                </div>
                <div class="profile-info">
                    <h1>
                        <%=FullName %>
                    </h1>
                    <p style="color:var(--text-muted);">
                        <i class="fas fa-envelope"></i>
                        <%=Email %>
                            &nbsp;·&nbsp;
                            <i class="fas fa-calendar-alt"></i> Tham gia <%=JoinDate %>
                    </p>
                    <div class="profile-stats">
                        <div class="profile-stat">
                            <strong>
                                <%=TotalMyRecipes %>
                            </strong>
                            <span>Công thức</span>
                        </div>
                        <div class="profile-stat">
                            <strong>
                                <%=TotalViews %>
                            </strong>
                            <span>Lượt xem</span>
                        </div>
                    </div>
                </div>
                <div style="margin-left:auto;">
                    <a href="AddRecipe.aspx" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Đăng công thức mới
                    </a>
                </div>
            </div>

            <!-- ===== THONG BAO ===== -->
            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <!-- ===== CONG THUC CUA TOI ===== -->
            <div style="margin-bottom:24px;display:flex;align-items:center;justify-content:space-between;">
                <h2 style="font-family:'Playfair Display',serif;font-size:1.6rem;">
                    📋 Công thức của tôi
                </h2>
                <span style="color:var(--text-muted);font-size:0.9rem;">
                    Tổng cộng <strong>
                        <%=TotalMyRecipes %>
                    </strong> công thức
                </span>
            </div>

            <!-- Empty state -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="empty-state">
                    <div class="empty-icon">👨‍🍳</div>
                    <h3>Bạn chưa đăng công thức nào</h3>
                    <p>Hãy chia sẻ những công thức yêu thích của bạn với cộng đồng!</p>
                    <a href="AddRecipe.aspx" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Đăng công thức đầu tiên
                    </a>
                </div>
            </asp:Panel>

            <!-- Recipe grid -->
            <div class="recipes-grid">
                <asp:Repeater ID="rptMyRecipes" runat="server">
                    <ItemTemplate>
                        <div class="recipe-card">
                            <div class="recipe-card-img">
                                <a href='RecipeDetail.aspx?id=<%#Eval("RecipeID") %>'>
                                    <img src='<%#GetImageUrl(Eval("ImagePath").ToString()) %>' alt='<%#Eval("Title") %>'
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
                                <p class="recipe-desc">
                                    <%#Eval("Description") %>
                                </p>
                                <div class="recipe-meta">
                                    <span><i class="fas fa-clock"></i>
                                        <%#(Convert.ToInt32(Eval("PrepTime")) + Convert.ToInt32(Eval("CookTime"))) %>
                                            phút
                                    </span>
                                    <span><i class="fas fa-eye"></i>
                                        <%#Eval("ViewCount") %> lượt xem
                                    </span>
                                    <span><i class="fas fa-calendar"></i>
                                        <%#Convert.ToDateTime(Eval("CreatedAt")).ToString("dd /MM/yyyy") %>
                                    </span>
                                </div>
                                <div class="recipe-card-footer">
                                    <div style="display:flex;gap:8px;">
                                        <a href='AddRecipe.aspx?edit=<%#Eval("RecipeID") %>'
                                            class="btn btn-outline btn-sm">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                        <asp:LinkButton ID="lbDelete" runat="server" CssClass="btn btn-danger btn-sm"
                                            CommandName="Delete" CommandArgument='<%#Eval("RecipeID") %>'
                                            OnClientClick="return confirm('Bạn có chắc muốn xóa công thức này?');"
                                            OnCommand="lbDelete_Command">
                                            <i class="fas fa-trash"></i> Xóa
                                        </asp:LinkButton>
                                    </div>
                                    <span
                                        class='difficulty-badge <%#GetDifficultyClass(Eval("Difficulty").ToString()) %>'>
                                        <%#Eval("Difficulty") %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- ===== THONG KE ===== -->
            <div style="margin-top:48px;">
                <h2 style="font-family:'Playfair Display',serif;font-size:1.6rem;margin-bottom:24px;">
                    📊 Thống kê theo danh mục
                </h2>
                <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:16px;">
                    <asp:Repeater ID="rptStats" runat="server">
                        <ItemTemplate>
                            <div
                                style="background:#fff;border-radius:16px;padding:20px;text-align:center;box-shadow:var(--shadow-sm);border:1px solid var(--border);">
                                <div style="font-size:2rem;margin-bottom:8px;">
                                    <%#GetCategoryIcon(Eval("Category").ToString()) %>
                                </div>
                                <div style="font-weight:800;font-size:1.5rem;color:var(--primary);">
                                    <%#Eval("Total") %>
                                </div>
                                <div style="font-size:0.85rem;color:var(--text-muted);">
                                    <%#Eval("Category") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

        </div>
    </asp:Content>