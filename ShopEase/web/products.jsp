<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.Product, java.util.List" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Product> products = (List<Product>) request.getAttribute("products");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Products - ShopEase</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; color:#333; }
        .main-content { max-width:1200px; margin:0 auto; padding:20px; }
        .page-title { font-size:20px; font-weight:bold; color:#232f3e; margin-bottom:6px; border-left:4px solid #f90; padding-left:10px; }
        .result-info { font-size:13px; color:#777; margin-bottom:16px; padding-left:14px; }
        .product-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(190px,1fr)); gap:16px; }
        .product-card { background:white; border:1px solid #ddd; border-radius:4px; padding:14px; }
        .product-card:hover { box-shadow:0 4px 12px rgba(0,0,0,0.1); }
        .product-img { width:100%; height:150px; background:#f5f5f5; border-radius:4px; display:flex; align-items:center; justify-content:center; font-size:36px; margin-bottom:10px; overflow:hidden; }
        .product-img img { width:100%; height:100%; object-fit:cover; }
        .product-name { font-size:13px; font-weight:bold; color:#0066c0; margin-bottom:5px; }
        .product-desc { font-size:12px; color:#777; margin-bottom:6px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .product-price { font-size:16px; font-weight:bold; color:#B12704; margin-bottom:10px; }
        .btn-add-cart { width:100%; padding:8px; background:#f90; color:#111; border:none; border-radius:4px; font-size:13px; font-weight:bold; cursor:pointer; }
        .btn-add-cart:hover { background:#e68a00; }
        .no-results { text-align:center; padding:60px 20px; color:#777; }
        .no-results h3 { font-size:18px; margin-bottom:8px; }
        .msg-success { background:#e0f5e0; color:#27ae60; padding:10px 14px; border-radius:4px; margin-bottom:14px; border-left:4px solid #27ae60; font-size:13px; }
        footer { background:#232f3e; color:#ccc; text-align:center; padding:16px; font-size:13px; margin-top:30px; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="main-content">

    <% if ("true".equals(request.getParameter("added"))) { %>
    <div class="msg-success">&#10003; Item added to cart successfully!</div>
    <% } %>

    <div class="page-title">
        <% if (searchKeyword != null && !searchKeyword.isEmpty()) { %>
            Search Results for: "<%= searchKeyword %>"
        <% } else if (selectedCategory != null && !selectedCategory.isEmpty()) { %>
            Category: <%= selectedCategory.substring(0,1).toUpperCase() + selectedCategory.substring(1) %>
        <% } else { %>
            All Products
        <% } %>
    </div>

    <div class="result-info">
        <%= products != null ? products.size() : 0 %> product(s) found
    </div>

    <div class="product-grid">
        <% if (products == null || products.isEmpty()) { %>
            <div class="no-results">
                <h3>No products found</h3>
                <p>Try a different search keyword or browse all products.</p>
            </div>
        <% } else {
            for (Product p : products) { %>
            <div class="product-card">
                <div class="product-img">
                    <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                        <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>" onerror="this.parentNode.innerHTML='🛍️'" />
                    <% } else { %>
                        🛍️
                    <% } %>
                </div>
                <div class="product-name"><%= p.getName() %></div>
                <div class="product-desc"><%= p.getDescription() != null ? p.getDescription() : "" %></div>
                <div class="product-price">&#8377;<%= String.format("%.2f", p.getPrice()) %></div>
                <form action="CartServlet" method="post">
                    <input type="hidden" name="action" value="add" />
                    <input type="hidden" name="productId" value="<%= p.getId() %>" />
                    <input type="hidden" name="quantity" value="1" />
                    <button type="submit" class="btn-add-cart">Add to Cart</button>
                </form>
            </div>
        <% } } %>
    </div>

</div>

<footer>&copy; 2025 ShopEase. Built with Java EE &bull; JSP &bull; Servlet &bull; MySQL</footer>
</body>
</html>
