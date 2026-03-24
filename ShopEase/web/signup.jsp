<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loggedInUser") != null) {
        response.sendRedirect("home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - ShopEase</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px 0; }
        .form-container { background:#fff; padding:35px 40px; border-radius:6px; box-shadow:0 2px 8px rgba(0,0,0,0.15); width:100%; max-width:420px; }
        .logo { text-align:center; margin-bottom:20px; font-size:26px; font-weight:bold; color:#232f3e; }
        .logo span { color:#f90; }
        h2 { text-align:center; margin-bottom:6px; color:#232f3e; font-size:20px; }
        .subtitle { text-align:center; color:#888; font-size:13px; margin-bottom:20px; }
        .form-group { margin-bottom:15px; }
        .form-group label { display:block; margin-bottom:5px; font-size:13px; font-weight:bold; color:#333; }
        .form-group input { width:100%; padding:9px 12px; border:1px solid #ccc; border-radius:4px; font-size:14px; outline:none; }
        .form-group input:focus { border-color:#f90; }
        .hint { font-size:11px; color:#999; margin-top:3px; }
        .btn-submit { width:100%; padding:10px; background:#f90; color:#111; border:none; border-radius:4px; font-size:15px; font-weight:bold; cursor:pointer; margin-top:6px; }
        .btn-submit:hover { background:#e68a00; }
        .msg-error { background:#ffe0e0; color:#c0392b; padding:9px 12px; border-radius:4px; font-size:13px; margin-bottom:14px; border-left:4px solid #c0392b; }
        .form-footer { text-align:center; margin-top:16px; font-size:13px; color:#555; }
        .form-footer a { color:#0066c0; text-decoration:none; }
        .form-footer a:hover { text-decoration:underline; }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="logo">Shop<span>Ease</span></div>
        <h2>Create Account</h2>
        <p class="subtitle">Register to start shopping</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="msg-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="SignupServlet" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="Enter your full name" required />
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Enter your email" required />
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Minimum 6 characters" required />
                <p class="hint">Must be at least 6 characters.</p>
            </div>
            <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" placeholder="Re-enter your password" required />
            </div>
            <button type="submit" class="btn-submit">Create Account</button>
        </form>
        <div class="form-footer">Already have an account? <a href="login.jsp">Sign In</a></div>
    </div>
</body>
</html>
