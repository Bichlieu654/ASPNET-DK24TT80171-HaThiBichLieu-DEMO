<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Recipes.aspx.cs" Inherits="Recipes"
    MasterPageFile="~/Site.master" %>

    <asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
        <title>Công Thức Nấu Ăn – Bếp mẹ Ớt</title>
    </asp:Content>

    <asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container" style="padding-top:40px;padding-bottom:60px;">

            <!-- Page Title -->
            <div style="margin-bottom:28px;">
                <h1 style="font-family:'Playfair Display',serif;font-size:2rem;color:var(--text-dark);">
                    <i class="fas fa-utensils" style="color:var(--primary);"></i>
                    Khám Phá Công Thức
                </h1>
                <p style="color:var(--text-muted);margin-top:6px;">
                    Tìm thấy <strong id="recipeCount" runat="server">0</strong> công thức
                </p>
            </div>

            <!-- ===== FILTER BAR ===== -->
            <div class="filter-bar">
                <h3><i class="fas fa-filter"></i> Bộ lọc tìm kiếm</h3>
                <div class="filter-grid">
                    <div class="form-group" style="margin:0;">
                        <label style="font-size:0.85rem;font-weight:700;margin-bottom:6px;display:block;">🔍 Từ
                            khóa</label>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                            placeholder="Tên món, nguyên liệu..." />
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label style="font-size:0.85rem;font-weight:700;margin-bottom:6px;display:block;">📂 Danh
                            mục</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Tất cả --</asp:ListItem>
                            <asp:ListItem Value="Món chính">🍲 Món chính</asp:ListItem>
                            <asp:ListItem Value="Tráng miệng">🍮 Tráng miệng</asp:ListItem>
                            <asp:ListItem Value="Khai vị">🥘 Khai vị</asp:ListItem>
                            <asp:ListItem Value="Ăn chay">🥗 Ăn chay</asp:ListItem>
                            <asp:ListItem Value="Ăn vặt">🍢 Ăn vặt</asp:ListItem>
                            <asp:ListItem Value="Đồ uống">🥤 Đồ uống</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label style="font-size:0.85rem;font-weight:700;margin-bottom:6px;display:block;">🌿 Chế độ
                            ăn</label>
                        <asp:DropDownList ID="ddlDiet" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Tất cả --</asp:ListItem>
                            <asp:ListItem Value="Thông thường">Thông thường</asp:ListItem>
                            <asp:ListItem Value="Chay">Chay</asp:ListItem>
                            <asp:ListItem Value="Thuần chay">Thuần chay</asp:ListItem>
                            <asp:ListItem Value="Low-carb">Low-carb</asp:ListItem>
                            <asp:ListItem Value="Keto">Keto</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div>
                        <label style="font-size:0.85rem;font-weight:700;margin-bottom:6px;display:block;">&nbsp;</label>
                        <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn btn-primary"
                            Style="width:100%;justify-content:center;" OnClick="btnSearch_Click" />
                    </div>
                </div>

                <!-- Category quick links -->
                <div style="margin-top:16px;display:flex;gap:8px;flex-wrap:wrap;">
                    <a href="Recipes.aspx" class="tag tag-category" style="<%=GetActiveCat("") %>">Tất cả</a>
                    <a href="Recipes.aspx?cat=Món+chính" class="tag tag-category" style="<%=GetActiveCat("Món chính") %>">🍲 Món chính</a>
                    <a href="Recipes.aspx?cat=Tráng+miệng" class="tag tag-category" style="<%=GetActiveCat("Tráng miệng") %>">🍮 Tráng miệng</a>
                    <a href="Recipes.aspx?cat=Khai+vị" class="tag tag-category" style="<%=GetActiveCat("Khai vị") %>">🥘 Khai vị</a>
                    <a href="Recipes.aspx?cat=Ăn+chay" class="tag tag-category" style="<%=GetActiveCat("Ăn chay") %>">🥗 Ăn chay</a>
                    <a href="Recipes.aspx?cat=Ăn+vặt" class="tag tag-category" style="<%=GetActiveCat("Ăn vặt") %>">🍢 Ăn vặt</a>
                    <a href="Recipes.aspx?cat=Đồ+uống" class="tag tag-category" style="<%=GetActiveCat("Đồ uống") %>">🥤 Đồ uống</a>
                </div>
            </div>

            <!-- ===== RECIPE LIST ===== -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="empty-state">
                    <div class="empty-icon">🍽️</div>
                    <h3>Không tìm thấy công thức nào</h3>
                    <p>Hãy thử thay đổi từ khóa hoặc bộ lọc khác.</p>
                    <a href="Recipes.aspx" class="btn btn-primary">Xem tất cả công thức</a>
                </div>
            </asp:Panel>

            <div class="recipes-grid">
                <asp:Repeater ID="rptRecipes" runat="server">
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
                                        <%#GetTotalTime(Eval("PrepTime"), Eval("CookTime")) %> phút
                                    </span>
                                    <span><i class="fas fa-users"></i>
                                        <%#Eval("Servings") %> người
                                    </span>
                                    <span><i class="fas fa-eye"></i>
                                        <%#Eval("ViewCount") %>
                                    </span>
                                </div>
                                <div class="recipe-card-footer">
                                    <div class="recipe-author">
                                        <div class="author-avatar-sm">
                                            <%#Eval("Username").ToString().Substring(0,1).ToUpper() %>
                                        </div>
                                        <%#Eval("FullName") ?? Eval("Username") %>
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

        </div>
    </asp:Content>