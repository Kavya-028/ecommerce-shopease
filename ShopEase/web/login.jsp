<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // If already logged in, redirect to home
    if (session.getAttribute("loggedInUser") != null) {
        response.sendRedirect("home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ShopEase</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .form-container {
            background-color: #ffffff;
            padding: 35px 40px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 400px;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 8px;
            color: #232f3e;
            font-size: 22px;
        }

        .form-container p.subtitle {
            text-align: center;
            color: #888;
            font-size: 13px;
            margin-bottom: 22px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            outline: none;
        }

        .form-group input:focus {
            border-color: #f90;
        }

        .btn-submit {
            width: 100%;
            padding: 10px;
            background-color: #f90;
            color: #111;
            border: none;
            border-radius: 4px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 6px;
        }

        .btn-submit:hover {
            background-color: #e68a00;
        }

        .msg-error {
            background-color: #ffe0e0;
            color: #c0392b;
            padding: 9px 12px;
            border-radius: 4px;
            font-size: 13px;
            margin-bottom: 14px;
            border-left: 4px solid #c0392b;
        }

        .msg-success {
            background-color: #e0f5e0;
            color: #27ae60;
            padding: 9px 12px;
            border-radius: 4px;
            font-size: 13px;
            margin-bottom: 14px;
            border-left: 4px solid #27ae60;
        }

        .form-footer {
            text-align: center;
            margin-top: 18px;
            font-size: 13px;
            color: #555;
        }

        .form-footer a {
            color: #0066c0;
            text-decoration: none;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }

        .logo {
            text-align: center;
            margin-bottom: 20px;
            font-size: 26px;
            font-weight: bold;
            color: #232f3e;
        }

        .logo span {
            color: #f90;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="logo">Shop<span>Ease</span></div>
        <h2>Sign In</h2>
        <p class="subtitle">Login to your account</p>

        <%-- Show error message if any --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="msg-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <%-- Show success message (e.g. after signup) --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="msg-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required />
            </div>

            <button type="submit" class="btn-submit">Login</button>
        </form>

        <div class="form-footer">
            Don't have an account? <a href="signup.jsp">Create one</a>
        </div>
    </div>
</body>
</html>
