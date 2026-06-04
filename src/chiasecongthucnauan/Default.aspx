<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default"
    MasterPageFile="~/Site.master" %>

    <asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
        <title>Bếp mẹ Ớt – Trang chủ | Chia Sẻ Công Thức Nấu Ăn</title>
    </asp:Content>

    <asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

        <!-- =================== HERO =================== -->
        <section class="hero">
            <div class="hero-content">
                <div class="hero-text">
                    <h1>Nơi <span>Đam Mê Ẩm Thực</span> Được Lan Tỏa</h1>
                    <p>Cùng học hỏi, sáng tạo và lưu giữ những hương vị tuyệt vời mỗi ngày.</p>
                    <div class="hero-search">
                        <div style="display:flex;width:100%;">
                            <input type="text" id="txtHeroSearch" placeholder="Tìm món ăn, nguyên liệu..."
                                style="flex:1;padding:10px 20px;border:none;outline:none;font-family:inherit;font-size:1rem;background:transparent;"
                                onkeypress="if(event.keyCode==13){doHeroSearch();return false;}" />
                            <button type="button" class="btn btn-primary" style="border-radius:50px;padding:10px 28px;"
                                onclick="doHeroSearch()">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                        </div>
                        <script type="text/javascript">
                            function doHeroSearch() {
                                var q = document.getElementById('txtHeroSearch').value;
                                window.location.href = 'Recipes.aspx?q=' + encodeURIComponent(q);
                            }
                        </script>
                    </div>
                    <div class="hero-stats">
                        <div class="stat-item">
                            <strong id="statRecipes">
                                <%=TotalRecipes %>
                            </strong>
                            <span>Công thức</span>
                        </div>
                        <div class="stat-item">
                            <strong>
                                <%=TotalUsers %>
                            </strong>
                            <span>Thành viên</span>
                        </div>
                        <div class="stat-item">
                            <strong>6</strong>
                            <span>Danh mục</span>
                        </div>
                    </div>
                </div>
                <div class="hero-image">
                    <div class="hero-img-container">
                        <img src="Assets/images/hero-food.jpg" alt="Món ăn ngon"
                            onerror="this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500&q=80'" />
                        <div class="floating-badge badge-1">
                            <span class="badge-icon">⭐</span>
                            <div><strong>Công thức mới</strong><br /><small>Mỗi ngày</small></div>
                        </div>
                        <div class="floating-badge badge-2">
                            <span class="badge-icon">👨‍🍳</span>
                            <div><strong>Cộng đồng</strong><br /><small>Đam mê nấu ăn</small></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- =================== CATEGORIES =================== -->
        <section class="categories-section">
            <div class="container">
                <div class="section-header">
                    <h2>Khám Phá Theo <span>Danh Mục</span></h2>
                    <div class="section-divider"></div>
                </div>
                <div class="categories-grid">
                    <a href="Recipes.aspx?cat=Món+chính" class="category-card">
                        <div class="category-icon">🍲</div>
                        <div class="category-name">Món chính</div>
                    </a>
                    <a href="Recipes.aspx?cat=Tráng+miệng" class="category-card">
                        <div class="category-icon">🍮</div>
                        <div class="category-name">Tráng miệng</div>
                    </a>
                    <a href="Recipes.aspx?cat=Khai+vị" class="category-card">
                        <div class="category-icon">🥘</div>
                        <div class="category-name">Khai vị</div>
                    </a>
                    <a href="Recipes.aspx?cat=Ăn+chay" class="category-card">
                        <div class="category-icon">🥗</div>
                        <div class="category-name">Ăn chay</div>
                    </a>
                    <a href="Recipes.aspx?cat=Ăn+vặt" class="category-card">
                        <div class="category-icon">🍢</div>
                        <div class="category-name">Ăn vặt</div>
                    </a>
                    <a href="Recipes.aspx?cat=Đồ+uống" class="category-card">
                        <div class="category-icon">🥤</div>
                        <div class="category-name">Đồ uống</div>
                    </a>
                </div>
            </div>
        </section>

        <!-- =================== FEATURED RECIPES =================== -->
        <section class="recipes-section">
            <div class="container">
                <div class="section-header"
                    style="display:flex;align-items:center;justify-content:space-between;text-align:left;">
                    <div>
                        <h2>🔥 Công Thức <span>Nổi Bật</span></h2>
                        <div class="section-divider" style="margin:8px 0 0;"></div>
                    </div>
                    <a href="Recipes.aspx" class="btn btn-outline btn-sm">Xem tất cả <i
                            class="fas fa-arrow-right"></i></a>
                </div>
                <div class="recipes-grid">
                    <asp:Repeater ID="rptFeatured" runat="server">
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
                                    <%#GetDietBadge(Eval("DietType").ToString()) %>
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
        </section>

        <!-- =================== LATEST RECIPES =================== -->
        <section class="recipes-section" style="background:#fff;padding:60px 0;">
            <div class="container">
                <div class="section-header"
                    style="display:flex;align-items:center;justify-content:space-between;text-align:left;">
                    <div>
                        <h2>🆕 Công Thức <span>Mới Nhất</span></h2>
                        <div class="section-divider" style="margin:8px 0 0;"></div>
                    </div>
                    <a href="Recipes.aspx?sort=new" class="btn btn-outline btn-sm">Xem tất cả <i
                            class="fas fa-arrow-right"></i></a>
                </div>
                <div class="recipes-grid">
                    <asp:Repeater ID="rptLatest" runat="server">
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
        </section>

        <!-- =================== CTA BANNER =================== -->
        <% if (Session["UserID"]==null) { %>
            <section
                style="background:linear-gradient(135deg,var(--primary),var(--primary-dark));padding:60px 0;text-align:center;color:#fff;">
                <div class="container">
                    <div style="font-size:3rem;margin-bottom:16px;">👨‍🍳</div>
                    <h2 style="font-family:'Playfair Display',serif;font-size:2rem;margin-bottom:12px;">Bắt đầu chia sẻ
                        hôm nay!</h2>
                    <p style="font-size:1.05rem;opacity:0.9;margin-bottom:28px;">Đăng ký miễn phí và chia sẻ những công
                        thức nấu ăn yêu thích của bạn.</p>
                    <a href="Register.aspx" class="btn"
                        style="background:#fff;color:var(--primary);border-color:#fff;font-size:1rem;">
                        <i class="fas fa-user-plus"></i> Đăng ký miễn phí
                    </a>
                </div>
            </section>
            <% } %>

    </asp:Content>