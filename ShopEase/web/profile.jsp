<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.User" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) request.getAttribute("user");
    if (user == null) user = (User) userSession.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - ShopEase</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; color:#333; }
        .main-content { max-width:700px; margin:0 auto; padding:20px; }
        .page-title { font-size:20px; font-weight:bold; color:#232f3e; margin-bottom:20px; border-left:4px solid #f90; padding-left:10px; }
        .profile-card { background:white; border:1px solid #ddd; border-radius:4px; padding:26px; margin-bottom:20px; }
        .profile-card h3 { font-size:16px; color:#232f3e; margin-bottom:18px; padding-bottom:10px; border-bottom:1px solid #eee; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:13px; font-weight:bold; color:#555; margin-bottom:5px; }
        .form-group input { width:100%; padding:9px 12px; border:1px solid #ccc; border-radius:4px; font-size:14px; outline:none; }
        .form-group input:focus { border-color:#f90; }
        .form-group input[readonly] { background:#f9f9f9; color:#777; cursor:not-allowed; }
        .btn-save { background:#f90; color:#111; border:none; padding:9px 22px; border-radius:4px; font-size:14px; font-weight:bold; cursor:pointer; }
        .btn-save:hover { background:#e68a00; }
        .msg-success { background:#e0f5e0; color:#27ae60; padding:10px 14px; border-radius:4px; margin-bottom:14px; border-left:4px solid #27ae60; font-size:13px; }
        .msg-error { background:#ffe0e0; color:#c0392b; padding:10px 14px; border-radius:4px; margin-bottom:14px; border-left:4px solid #c0392b; font-size:13px; }
        .info-row { display:flex; margin-bottom:12px; font-size:14px; }
        .info-label { width:120px; color:#777; font-weight:bold; flex-shrink:0; }
        .info-value { color:#333; }
        footer { background:#232f3e; color:#ccc; text-align:center; padding:16px; font-size:13px; margin-top:30px; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="main-content">
    <div class="page-title">&#128100; My Profile</div>

    <!-- Account Summary -->
    <div class="profile-card">
        <h3>Account Information</h3>
        <div class="info-row"><span class="info-label">User ID</span><span class="info-value">#<%= user.getId() %></span></div>
        <div class="info-row"><span class="info-label">Full Name</span><span class="info-value"><%= user.getName() %></span></div>
        <div class="info-row"><span class="info-label">Email</span><span class="info-value"><%= user.getEmail() %></span></div>
    </div>

    <!-- Edit Profile -->
    <div class="profile-card">
        <h3>Edit Profile</h3>
        <% if (request.getAttribute("success") != null) { %>
        <div class="msg-success">&#10003; <%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="msg-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="ProfileServlet" method="post">
            <input type="hidden" name="action" value="updateProfile" />
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" value="<%= user.getName() %>" required />
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" value="<%= user.getEmail() %>" required />
            </div>
            <button type="submit" class="btn-save">Save Changes</button>
        </form>
    </div>

    <!-- Change Password -->
    <div class="profile-card">
        <h3>Change Password</h3>
        <% if (request.getAttribute("pwSuccess") != null) { %>
        <div class="msg-success">&#10003; <%= request.getAttribute("pwSuccess") %></div>
        <% } %>
        <% if (request.getAttribute("pwError") != null) { %>
        <div class="msg-error"><%= request.getAttribute("pwError") %></div>
        <% } %>
        <form action="ProfileServlet" method="post">
            <input type="hidden" name="action" value="changePassword" />
            <div class="form-group">
                <label>Current Password</label>
                <input type="password" name="currentPassword" placeholder="Enter current password" required />
            </div>
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" placeholder="Minimum 6 characters" required />
            </div>
            <div class="form-group">
                <label>Confirm New Password</label>
                <input type="password" name="confirmPassword" placeholder="Re-enter new password" required />
            </div>
            <button type="submit" class="btn-save">Change Password</button>
        </form>
    </div>

</div>

<footer>&copy; 2025 ShopEase. Built with Java EE &bull; JSP &bull; Servlet &bull; MySQL</footer>
</body>
</html>
