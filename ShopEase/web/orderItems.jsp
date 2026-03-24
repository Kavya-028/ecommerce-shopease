<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.OrderItem, java.util.List" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    Integer orderId = (Integer) request.getAttribute("orderId");

    double grandTotal = 0;
    if (orderItems != null) {
        for (OrderItem oi : orderItems) grandTotal += oi.getSubtotal();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order #<%= orderId %> - ShopEase</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; color:#333; }
        .main-content { max-width:850px; margin:0 auto; padding:20px; }
        .page-title { font-size:20px; font-weight:bold; color:#232f3e; margin-bottom:6px; border-left:4px solid #f90; padding-left:10px; }
        .back-link { font-size:13px; color:#0066c0; text-decoration:none; display:inline-block; margin-bottom:18px; }
        .order-box { background:white; border:1px solid #ddd; border-radius:4px; overflow:hidden; }
        .order-box table { width:100%; border-collapse:collapse; }
        .order-box th { background:#f5f5f5; padding:11px 16px; font-size:13px; text-align:left; border-bottom:1px solid #ddd; color:#555; }
        .order-box td { padding:12px 16px; font-size:14px; border-bottom:1px solid #f0f0f0; vertical-align:middle; }
        .order-box tr:last-child td { border-bottom:none; }
        .item-img { width:50px; height:50px; background:#f5f5f5; border-radius:4px; display:flex; align-items:center; justify-content:center; font-size:20px; overflow:hidden; }
        .item-img img { width:100%; height:100%; object-fit:cover; }
        .item-name { font-weight:bold; color:#0066c0; font-size:13px; }
        .item-price { color:#777; font-size:13px; }
        .item-subtotal { font-weight:bold; color:#B12704; }
        .total-row { background:#fff8f0; }
        .total-row td { font-weight:bold; font-size:15px; color:#232f3e; }
        footer { background:#232f3e; color:#ccc; text-align:center; padding:16px; font-size:13px; margin-top:30px; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="main-content">
    <div class="page-title">Order #<%= orderId %> — Details</div>
    <a href="OrderServlet?action=history" class="back-link">&#8592; Back to My Orders</a>

    <div class="order-box">
        <table>
            <thead>
                <tr>
                    <th colspan="2">Product</th>
                    <th>Unit Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
            <% if (orderItems != null && !orderItems.isEmpty()) {
                for (OrderItem item : orderItems) { %>
            <tr>
                <td>
                    <div class="item-img">
                        <% if (item.getProductImage() != null && !item.getProductImage().isEmpty()) { %>
                            <img src="<%= item.getProductImage() %>" alt="" onerror="this.parentNode.innerHTML='🛍️'" />
                        <% } else { %>🛍️<% } %>
                    </div>
                </td>
                <td><div class="item-name"><%= item.getProductName() %></div></td>
                <td class="item-price">&#8377;<%= String.format("%.2f", item.getPrice()) %></td>
                <td><%= item.getQuantity() %></td>
                <td class="item-subtotal">&#8377;<%= String.format("%.2f", item.getSubtotal()) %></td>
            </tr>
            <% } } %>
            <tr class="total-row">
                <td colspan="4" style="text-align:right;">Grand Total</td>
                <td>&#8377;<%= String.format("%.2f", grandTotal) %></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<footer>&copy; 2025 ShopEase. Built with Java EE &bull; JSP &bull; Servlet &bull; MySQL</footer>
</body>
</html>
