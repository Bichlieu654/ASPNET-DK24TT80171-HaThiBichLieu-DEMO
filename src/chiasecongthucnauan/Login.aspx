<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>
    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="vi">

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng nhập – Bếp mẹ Ớt</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="Assets/css/style.css" />
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="form-page">
                <div class="form-card">
                    <div class="form-logo">
                        <div class="logo-icon">🍳</div>
                        <h2>Đăng Nhập</h2>
                        <p class="form-subtitle">Chào mừng trở lại! Hãy đăng nhập để tiếp tục.</p>
                    </div>

                    <!-- Thong bao loi -->
                    <asp:Label ID="lblMessage" runat="server" Visible="false" />

                    <div class="form-group">
                        <label for="txtUsername"><i class="fas fa-user"></i> Tên đăng nhập</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                            placeholder="Nhập tên đăng nhập..." ClientIDMode="Static" />
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                            ErrorMessage="Vui lòng nhập tên đăng nhập" CssClass="form-hint" style="color:#EF476F;"
                            Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label for="txtPassword"><i class="fas fa-lock"></i> Mật khẩu</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                            placeholder="Nhập mật khẩu..." ClientIDMode="Static" />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                            ErrorMessage="Vui lòng nhập mật khẩu" CssClass="form-hint" style="color:#EF476F;"
                            Display="Dynamic" />
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" CssClass="btn btn-primary"
                        Style="width:100%;justify-content:center;margin-bottom:16px;" OnClick="btnLogin_Click" />

                    <p class="text-center" style="color:var(--text-muted);font-size:0.9rem;">
                        Chưa có tài khoản?
                        <a href="Register.aspx" style="color:var(--primary);font-weight:700;">Đăng ký ngay</a>
                    </p>
                    <p class="text-center" style="margin-top:12px;">
                        <a href="Default.aspx" style="color:var(--text-muted);font-size:0.85rem;">
                            <i class="fas fa-arrow-left"></i> Về trang chủ
                        </a>
                    </p>

                    <div class="alert alert-info" style="margin-top:20px;font-size:0.82rem;">
                        <i class="fas fa-info-circle"></i>
                        <strong>Tài khoản mẫu:</strong> admin / 123456
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>