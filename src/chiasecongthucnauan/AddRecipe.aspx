<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddRecipe.aspx.cs" Inherits="AddRecipe"
    MasterPageFile="~/Site.master" %>

    <asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
        <title>Đăng Công Thức – Bếp mẹ Ớt</title>
    </asp:Content>

    <asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="add-recipe-page">
            <div class="container">

                <div style="margin-bottom:28px;">
                    <h1 style="font-family:'Playfair Display',serif;font-size:2rem;">
                        <i class="fas fa-plus-circle" style="color:var(--primary);"></i>
                        <span id="pageTitle" runat="server">Đăng Công Thức Mới</span>
                    </h1>
                </div>

                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <!-- ===== THONG TIN CO BAN ===== -->
                <div class="add-recipe-card">
                    <h2><i class="fas fa-info-circle"></i> Thông tin cơ bản</h2>

                    <div class="form-group">
                        <label>Tên công thức *</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                            placeholder="VD: Phở bò Hà Nội truyền thống" MaxLength="200" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
                            ErrorMessage="Vui lòng nhập tên công thức" CssClass="form-hint" style="color:#EF476F;"
                            Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Mô tả ngắn</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="3" placeholder="Mô tả ngắn về món ăn, hương vị, đặc điểm..." MaxLength="1000" />
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Danh mục *</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                <asp:ListItem Value="Món chính">🍲 Món chính</asp:ListItem>
                                <asp:ListItem Value="Tráng miệng">🍮 Tráng miệng</asp:ListItem>
                                <asp:ListItem Value="Khai vị">🥘 Khai vị</asp:ListItem>
                                <asp:ListItem Value="Ăn chay">🥗 Ăn chay</asp:ListItem>
                                <asp:ListItem Value="Ăn vặt">🍢 Ăn vặt</asp:ListItem>
                                <asp:ListItem Value="Đồ uống">🥤 Đồ uống</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Chế độ ăn</label>
                            <asp:DropDownList ID="ddlDiet" runat="server" CssClass="form-control">
                                <asp:ListItem Value="Thông thường">Thông thường</asp:ListItem>
                                <asp:ListItem Value="Chay">Chay</asp:ListItem>
                                <asp:ListItem Value="Thuần chay">Thuần chay</asp:ListItem>
                                <asp:ListItem Value="Low-carb">Low-carb</asp:ListItem>
                                <asp:ListItem Value="Keto">Keto</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-clock"></i> Thời gian chuẩn bị (phút)</label>
                            <asp:TextBox ID="txtPrepTime" runat="server" CssClass="form-control" TextMode="Number"
                                Text="15" />
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-fire"></i> Thời gian nấu (phút)</label>
                            <asp:TextBox ID="txtCookTime" runat="server" CssClass="form-control" TextMode="Number"
                                Text="30" />
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-users"></i> Khẩu phần (người)</label>
                            <asp:TextBox ID="txtServings" runat="server" CssClass="form-control" TextMode="Number"
                                Text="2" />
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-chart-bar"></i> Độ khó</label>
                            <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="form-control">
                                <asp:ListItem Value="Dễ">😊 Dễ</asp:ListItem>
                                <asp:ListItem Value="Trung bình" Selected="True">😐 Trung bình</asp:ListItem>
                                <asp:ListItem Value="Khó">😤 Khó</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>

                <!-- ===== ANH MON AN ===== -->
                <div class="add-recipe-card">
                    <h2><i class="fas fa-image"></i> Ảnh món ăn</h2>
                    <div class="img-upload-area" id="uploadArea">
                        <div class="upload-icon">📷</div>
                        <p><strong>Nhấp để chọn ảnh</strong> hoặc kéo thả vào đây</p>
                        <p style="font-size:0.8rem;margin-top:4px;">JPG, PNG – Tối đa 5MB</p>
                        <asp:FileUpload ID="fuImage" runat="server" accept="image/*" onchange="previewImage(this)" />
                    </div>
                    <img id="imgPreview" alt="Xem trước"
                        style="margin-top:14px;border-radius:12px;max-height:200px;display:none;" />
                </div>

                <!-- ===== NGUYEN LIEU ===== -->
                <div class="add-recipe-card">
                    <h2><i class="fas fa-shopping-basket"></i> Nguyên liệu</h2>
                    <p class="text-muted" style="margin-bottom:16px;font-size:0.9rem;">Thêm từng nguyên liệu với số
                        lượng và đơn vị tính.</p>

                    <div class="dynamic-list" id="ingredientList">
                        <!-- Hang nguyen lieu duoc them bang JavaScript -->
                    </div>
                    <button type="button" class="btn-add-row" onclick="addIngredient()">
                        <i class="fas fa-plus"></i> Thêm nguyên liệu
                    </button>

                    <!-- Hidden field luu du lieu nguyen lieu -->
                    <asp:HiddenField ID="hfIngredients" runat="server" />
                </div>

                <!-- ===== CAC BUOC THUC HIEN ===== -->
                <div class="add-recipe-card">
                    <h2><i class="fas fa-list-ol"></i> Các bước thực hiện</h2>
                    <p class="text-muted" style="margin-bottom:16px;font-size:0.9rem;">Mô tả từng bước thực hiện rõ
                        ràng, chi tiết.</p>

                    <div class="dynamic-list" id="stepList">
                        <!-- Buoc duoc them bang JavaScript -->
                    </div>
                    <button type="button" class="btn-add-row" onclick="addStep()">
                        <i class="fas fa-plus"></i> Thêm bước
                    </button>

                    <asp:HiddenField ID="hfSteps" runat="server" />
                </div>

                <!-- ===== MEO NAU AN ===== -->
                <div class="add-recipe-card">
                    <h2><i class="fas fa-lightbulb"></i> Mẹo nấu ăn <small
                            style="font-weight:400;color:var(--text-muted);font-size:0.85rem;">(Tuỳ chọn)</small></h2>
                    <asp:TextBox ID="txtTips" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"
                        placeholder="Chia sẻ mẹo, bí quyết để món ăn ngon hơn..." MaxLength="1000" />
                </div>

                <!-- SUBMIT BUTTONS -->
                <div style="display:flex;gap:16px;justify-content:flex-end;flex-wrap:wrap;">
                    <a href="javascript:history.back()" class="btn btn-outline">
                        <i class="fas fa-times"></i> Huỷ
                    </a>
                    <asp:Button ID="btnSubmit" runat="server" Text="Đăng công thức" CssClass="btn btn-primary btn-lg"
                        OnClick="btnSubmit_Click" OnClientClick="collectData(); return true;" />
                </div>

            </div>
        </div>

        <script>
            var ingredientCount = 0;
            var stepCount = 0;

            // Them hang nguyen lieu
            function addIngredient(name, qty, unit) {
                ingredientCount++;
                var html = '<div class="dynamic-row" id="ing_' + ingredientCount + '">' +
                    '<input type="text" class="form-control ing-name" placeholder="Tên nguyên liệu" value="' + (name || '') + '" style="flex:2;" />' +
                    '<input type="text" class="form-control ing-qty"  placeholder="Số lượng" value="' + (qty || '') + '" style="flex:1;" />' +
                    '<input type="text" class="form-control ing-unit" placeholder="Đơn vị" value="' + (unit || '') + '" style="flex:1;" />' +
                    '<button type="button" class="btn-remove" onclick="removeRow(\'ing_' + ingredientCount + '\')">&times;</button>' +
                    '</div>';
                document.getElementById('ingredientList').insertAdjacentHTML('beforeend', html);
            }

            // Them buoc thuc hien
            function addStep(desc) {
                stepCount++;
                var html = '<div class="step-row" id="step_' + stepCount + '">' +
                    '<div class="step-num-label">' + stepCount + '</div>' +
                    '<textarea class="form-control step-desc" rows="2" placeholder="Mô tả bước ' + stepCount + '">' + (desc || '') + '</textarea>' +
                    '<button type="button" class="btn-remove" onclick="removeRow(\'step_' + stepCount + '\')" style="margin-top:6px;">&times;</button>' +
                    '</div>';
                document.getElementById('stepList').insertAdjacentHTML('beforeend', html);
            }

            function removeRow(id) {
                var el = document.getElementById(id);
                if (el) el.remove();
                renumberSteps();
            }

            function renumberSteps() {
                var steps = document.querySelectorAll('#stepList .step-num-label');
                steps.forEach(function (el, i) { el.textContent = (i + 1); });
            }

            // Thu thap du lieu truoc khi submit
            function collectData() {
                // Thu thap nguyen lieu
                var ings = [];
                document.querySelectorAll('#ingredientList .dynamic-row').forEach(function (row) {
                    var name = row.querySelector('.ing-name').value.trim();
                    var qty = row.querySelector('.ing-qty').value.trim();
                    var unit = row.querySelector('.ing-unit').value.trim();
                    if (name) ings.push(name + '|' + qty + '|' + unit);
                });
                document.getElementById('<%=hfIngredients.ClientID %>').value = ings.join('##');

                // Thu thap cac buoc
                var steps = [];
                document.querySelectorAll('#stepList .step-desc').forEach(function (ta) {
                    if (ta.value.trim()) steps.push(ta.value.trim());
                });
                document.getElementById('<%=hfSteps.ClientID %>').value = steps.join('##');
            }

            // Xem truoc anh
            function previewImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var img = document.getElementById('imgPreview');
                        img.src = e.target.result;
                        img.style.display = 'block';
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }

            // Khoi tao: them san 1 nguyen lieu va 1 buoc
            window.onload = function () {
                var existIng = '<%=ExistingIngredients %>';
                var existStep = '<%=ExistingSteps %>';
                if (existIng && existIng !== '') {
                    existIng.split('##').forEach(function (item) {
                        var parts = item.split('|');
                        addIngredient(parts[0], parts[1], parts[2]);
                    });
                } else {
                    addIngredient(); addIngredient(); addIngredient();
                }
                if (existStep && existStep !== '') {
                    existStep.split('##').forEach(function (s) { addStep(s); });
                } else {
                    addStep(); addStep(); addStep();
                }

                var existImg = '<%=ExistingImage %>';
                if (existImg && existImg !== '') {
                    var img = document.getElementById('imgPreview');
                    if (existImg === 'default-recipe.jpg') {
                        img.src = '<%=ResolveUrl("~/Assets/images/") %>' + existImg;
                    } else {
                        img.src = '<%=ResolveUrl("~/Uploads/") %>' + existImg;
                    }
                    img.style.display = 'block';
                }
            };
        </script>
    </asp:Content>