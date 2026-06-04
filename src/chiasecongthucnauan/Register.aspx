<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>
    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="vi">

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng ký – Bếp mẹ Ớt</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="Assets/css/style.css" />
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="form-page">
                <div class="form-card" style="max-width:520px;">
                    <div class="form-logo">
                        <div class="logo-icon">🍳</div>
                        <h2>Tạo Tài Khoản</h2>
                        <p class="form-subtitle">Tham gia cộng đồng chia sẻ công thức nấu ăn ngay hôm nay!</p>
                    </div>

                    <asp:Label ID="lblMessage" runat="server" Visible="false" />

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Tên đăng nhập *</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                                placeholder="vd: nguyen_nau" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername"
                                ErrorMessage="Bắt buộc" CssClass="form-hint" style="color:#EF476F;" Display="Dynamic" />
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-id-card"></i> Họ và tên *</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"
                                placeholder="Nguyễn Văn A" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                                ErrorMessage="Bắt buộc" CssClass="form-hint" style="color:#EF476F;" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email *</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                            placeholder="email@example.com" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Vui lòng nhập email" CssClass="form-hint" style="color:#EF476F;"
                            Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Email không hợp lệ"
                            CssClass="form-hint" style="color:#EF476F;" Display="Dynamic" />
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-lock"></i> Mật khẩu *</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                                placeholder="Tối thiểu 6 ký tự" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                                ErrorMessage="Bắt buộc" CssClass="form-hint" style="color:#EF476F;" Display="Dynamic" />
                            <asp:CustomValidator runat="server" ControlToValidate="txtPassword"
                                ClientValidationFunction="validatePassword" ErrorMessage="Mật khẩu tối thiểu 6 ký tự"
                                CssClass="form-hint" style="color:#EF476F;" Display="Dynamic"
                                OnServerValidate="ValidatePassword" />
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-lock"></i> Xác nhận mật khẩu *</label>
                            <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control" TextMode="Password"
                                placeholder="Nhập lại mật khẩu" />
                            <asp:CompareValidator runat="server" ControlToValidate="txtConfirm"
                                ControlToCompare="txtPassword" ErrorMessage="Mật khẩu không khớp" CssClass="form-hint"
                                style="color:#EF476F;" Display="Dynamic" />
                        </div>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Đăng ký ngay" CssClass="btn btn-primary"
                        Style="width:100%;justify-content:center;margin-bottom:16px;" OnClick="btnRegister_Click" />

                    <p class="text-center" style="color:var(--text-muted);font-size:0.9rem;">
                        Đã có tài khoản?
                        <a href="Login.aspx" style="color:var(--primary);font-weight:700;">Đăng nhập</a>
                    </p>
                    <p class="text-center" style="margin-top:12px;">
                        <a href="Default.aspx" style="color:var(--text-muted);font-size:0.85rem;">
                            <i class="fas fa-arrow-left"></i> Về trang chủ
                        </a>
                    </p>
                </div>
            </div>
        </form>
        <script type="text/javascript">
            function validatePassword(sender, args) {
                args.IsValid = (args.Value.length >= 6);
            }
        </script>
    </body>

    </html>