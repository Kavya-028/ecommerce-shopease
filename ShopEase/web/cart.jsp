<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.CartItem, java.util.List" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    if (cartTotal == null) cartTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Cart - ShopEase</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; color:#333; }
        .main-content { max-width:1000px; margin:0 auto; padding:20px; }
        .page-title { font-size:20px; font-weight:bold; color:#232f3e; margin-bottom:20px; border-left:4px solid #f90; padding-left:10px; }
        .cart-layout { display:grid; grid-template-columns:1fr 280px; gap:20px; align-items:start; }
        .cart-table { background:white; border:1px solid #ddd; border-radius:4px; overflow:hidden; }
        .cart-table table { width:100%; border-collapse:collapse; }
        .cart-table th { background:#f5f5f5; padding:12px 14px; font-size:13px; text-align:left; border-bottom:1px solid #ddd; color:#555; }
        .cart-table td { padding:12px 14px; font-size:14px; border-bottom:1px solid #f0f0f0; vertical-align:middle; }
        .cart-table tr:last-child td { border-bottom:none; }
        .item-img { width:55px; height:55px; background:#f5f5f5; border-radius:4px; display:flex; align-items:center; justify-content:center; font-size:22px; overflow:hidden; }
        .item-img img { width:100%; height:100%; object-fit:cover; }
        .item-name { font-weight:bold; color:#0066c0; font-size:13px; }
        .item-price { color:#B12704; font-weight:bold; }
        .qty-form { display:flex; align-items:center; gap:6px; }
        .qty-input { width:50px; padding:5px; border:1px solid #ccc; border-radius:4px; font-size:13px; text-align:center; }
        .btn-update { background:#37475a; color:white; border:none; padding:5px 10px; border-radius:4px; font-size:12px; cursor:pointer; }
        .btn-remove { background:#c0392b; color:white; border:none; padding:5px 10px; border-radius:4px; font-size:12px; cursor:pointer; text-decoration:none; display:inline-block; }
        .item-subtotal { font-weight:bold; }
        /* Summary box */
        .cart-summary { background:white; border:1px solid #ddd; border-radius:4px; padding:18px; }
        .cart-summary h3 { font-size:16px; margin-bottom:14px; color:#232f3e; border-bottom:1px solid #eee; padding-bottom:10px; }
        .summary-row { display:flex; justify-content:space-between; font-size:14px; margin-bottom:10px; }
        .summary-row.total { font-weight:bold; font-size:16px; border-top:1px solid #eee; padding-top:10px; margin-top:6px; }
        .btn-order { width:100%; padding:11px; background:#f90; color:#111; border:none; border-radius:4px; font-size:15px; font-weight:bold; cursor:pointer; margin-top:14px; }
        .btn-order:hover { background:#e68a00; }
        .btn-continue { display:block; text-align:center; margin-top:10px; color:#0066c0; text-decoration:none; font-size:13px; }
        .empty-cart { background:white; border:1px solid #ddd; border-radius:4px; text-align:center; padding:60px 20px; }
        .empty-cart h3 { font-size:18px; margin-bottom:8px; color:#555; }
        .empty-cart p { color:#888; font-size:14px; margin-bottom:18px; }
        .btn-shop { background:#f90; color:#111; padding:10px 24px; border-radius:4px; text-decoration:none; font-weight:bold; font-size:14px; }
        .msg-error { background:#ffe0e0; color:#c0392b; padding:10px 14px; border-radius:4px; margin-bottom:14px; border-left:4px solid #c0392b; font-size:13px; }
        footer { background:#232f3e; color:#ccc; text-align:center; padding:16px; font-size:13px; margin-top:30px; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="main-content">
    <div class="page-title">&#128722; My Cart</div>

    <% if ("empty".equals(request.getParameter("error"))) { %>
    <div class="msg-error">Your cart is empty. Please add products before placing an order.</div>
    <% } %>
    <% if ("orderfailed".equals(request.getParameter("error"))) { %>
    <div class="msg-error">Order placement failed. Please try again.</div>
    <% } %>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
    <div class="empty-cart">
        <div style="font-size:50px;margin-bottom:14px;">🛒</div>
        <h3>Your cart is empty</h3>
        <p>Looks like you haven't added anything yet.</p>
        <a href="ProductServlet" class="btn-shop">Start Shopping</a>
    </div>
    <% } else { %>

    <div class="cart-layout">
        <!-- Cart Items Table -->
        <div class="cart-table">
            <table>
                <thead>
                    <tr>
                        <th colspan="2">Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% for (CartItem item : cartItems) { %>
                <tr>
                    <td>
                        <div class="item-img">
                            <% if (item.getProductImage() != null && !item.getProductImage().isEmpty()) { %>
                                <img src="<%= item.getProductImage() %>" alt="" onerror="this.parentNode.innerHTML='🛍️'" />
                            <% } else { %>🛍️<% } %>
                        </div>
                    </td>
                    <td><div class="item-name"><%= item.getProductName() %></div></td>
                    <td class="item-price">&#8377;<%= String.format("%.2f", item.getProductPrice()) %></td>
                    <td>
                        <form action="CartServlet" method="post" class="qty-form">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="cartId" value="<%= item.getCartId() %>" />
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="99" class="qty-input" />
                            <button type="submit" class="btn-update">Update</button>
                        </form>
                    </td>
                    <td class="item-subtotal">&#8377;<%= String.format("%.2f", item.getSubtotal()) %></td>
                    <td>
                        <a href="CartServlet?action=remove&cartId=<%= item.getCartId() %>"
                           class="btn-remove"
                           onclick="return confirm('Remove this item?')">Remove</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Order Summary -->
        <div class="cart-summary">
            <h3>Order Summary</h3>
            <div class="summary-row">
                <span>Items (<%= cartItems.size() %>)</span>
                <span>&#8377;<%= String.format("%.2f", cartTotal) %></span>
            </div>
            <div class="summary-row">
                <span>Delivery</span>
                <span style="color:#27ae60;">FREE</span>
            </div>
            <div class="summary-row total">
                <span>Total</span>
                <span>&#8377;<%= String.format("%.2f", cartTotal) %></span>
            </div>
            <form action="OrderServlet" method="post">
                <button type="submit" class="btn-order">Place Order</button>
            </form>
            <a href="ProductServlet" class="btn-continue">&#8592; Continue Shopping</a>
        </div>
    </div>

    <% } %>
</div>

<footer>&copy; 2025 ShopEase. Built with Java EE &bull; JSP &bull; Servlet &bull; MySQL</footer>
</body>
</html>
