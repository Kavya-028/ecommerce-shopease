<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.Order, java.util.List" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders - ShopEase</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; color:#333; }
        .main-content { max-width:900px; margin:0 auto; padding:20px; }
        .page-title { font-size:20px; font-weight:bold; color:#232f3e; margin-bottom:20px; border-left:4px solid #f90; padding-left:10px; }
        .msg-success { background:#e0f5e0; color:#27ae60; padding:10px 14px; border-radius:4px; margin-bottom:16px; border-left:4px solid #27ae60; font-size:13px; }
        .orders-table { background:white; border:1px solid #ddd; border-radius:4px; overflow:hidden; }
        .orders-table table { width:100%; border-collapse:collapse; }
        .orders-table th { background:#f5f5f5; padding:12px 16px; font-size:13px; text-align:left; border-bottom:1px solid #ddd; color:#555; }
        .orders-table td { padding:12px 16px; font-size:14px; border-bottom:1px solid #f0f0f0; }
        .orders-table tr:last-child td { border-bottom:none; }
        .orders-table tr:hover { background:#fafafa; }
        .order-id { font-weight:bold; color:#232f3e; }
        .order-amount { font-weight:bold; color:#B12704; }
        .order-date { color:#777; font-size:13px; }
        .badge-delivered { background:#e0f5e0; color:#27ae60; padding:3px 10px; border-radius:12px; font-size:12px; font-weight:bold; }
        .btn-view { background:#37475a; color:white; padding:5px 14px; border-radius:4px; text-decoration:none; font-size:13px; }
        .btn-view:hover { background:#232f3e; }
        .empty-orders { background:white; border:1px solid #ddd; border-radius:4px; text-align:center; padding:60px 20px; }
        .empty-orders h3 { font-size:18px; margin-bottom:8px; color:#555; }
        .empty-orders p { color:#888; font-size:14px; margin-bottom:18px; }
        .btn-shop { background:#f90; color:#111; padding:10px 24px; border-radius:4px; text-decoration:none; font-weight:bold; font-size:14px; }
        footer { background:#232f3e; color:#ccc; text-align:center; padding:16px; font-size:13px; margin-top:30px; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="main-content">
    <div class="page-title">&#128230; My Orders</div>

    <% if ("true".equals(request.getParameter("placed"))) { %>
    <div class="msg-success">&#10003; Your order has been placed successfully! Thank you for shopping with ShopEase.</div>
    <% } %>

    <% if (orders == null || orders.isEmpty()) { %>
    <div class="empty-orders">
        <div style="font-size:50px;margin-bottom:14px;">📦</div>
        <h3>No orders yet</h3>
        <p>You haven't placed any orders. Start shopping now!</p>
        <a href="ProductServlet" class="btn-shop">Shop Now</a>
    </div>
    <% } else { %>
    <div class="orders-table">
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Details</th>
                </tr>
            </thead>
            <tbody>
            <% for (Order order : orders) { %>
            <tr>
                <td class="order-id">#<%= order.getId() %></td>
                <td class="order-date"><%= order.getOrderDate() %></td>
                <td class="order-amount">&#8377;<%= String.format("%.2f", order.getTotalAmount()) %></td>
                <td><span class="badge-delivered">Delivered</span></td>
                <td>
                    <a href="OrderServlet?action=items&orderId=<%= order.getId() %>" class="btn-view">View Items</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>

<footer>&copy; 2025 ShopEase. Built with Java EE &bull; JSP &bull; Servlet &bull; MySQL</footer>
</body>
</html>
