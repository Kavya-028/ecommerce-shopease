<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.User, com.ecommerce.model.Product, com.ecommerce.dao.ProductDAO, com.ecommerce.dao.CartDAO, java.util.List" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User loggedInUser = (User) userSession.getAttribute("loggedInUser");
    String userName = loggedInUser.getName();
    int userId = loggedInUser.getId();

    // Fetch products & cart count for header
    ProductDAO productDAO = new ProductDAO();
    CartDAO cartDAO = new CartDAO();
    List<Product> featuredProducts = productDAO.getAllProducts();
    int cartCount = cartDAO.getCartCount(userId);
    request.setAttribute("cartCount", cartCount);
    request.setAttribute("searchKeyword", null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopEase - Home</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f4f4; color:#333; }
        .banner { background:linear-gradient(135deg,#232f3e,#37475a); color:white; text-align:center; padding:45px 20px; margin-bottom:20px; }
        .banner h1 { font-size:28px; margin-bottom:8px; }
        .banner h1 span { color:#f90; }
        .banner p { color:#ccc; font-size:15px; margin-bottom:18px; }
        .banner-btn { background:#f90; color:#111; padding:11px 26px; border:none; border-radius:4px; font-size:14px; font-weight:bold; cursor:pointer; text-decoration:none; }
        .main-content { max-width:1200px; margin:0 auto; padding:0 20px 40px; }
        .section-title { font-size:20px; font-weight:bold; color:#232f3e; margin:22px 0 14px; border-left:4px solid #f90; padding-left:10px; }
        .category-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(130px,1fr)); gap:12px; margin-bottom:8px; }
        .category-card { background:white; border:1px solid #ddd; border-radius:4px; padding:16px 10px; text-align:center; cursor:pointer; text-decoration:none; color:#333; display:block; }
        .category-card:hover { border-color:#f90; }
        .category-card .icon { font-size:26px; margin-bottom:6px; }
        .category-card p { font-size:13px; }
        .product-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(190px,1fr)); gap:16px; }
        .product-card { background:white; border:1px solid #ddd; border-radius:4px; padding:14px; text-align:left; }
        .product-card:hover { box-shadow:0 4px 12px rgba(0,0,0,0.1); }
        .product-img { width:100%; height:150px; background:#f5f5f5; border-radius:4px; display:flex; align-items:center; justify-content:center; font-size:36px; margin-bottom:10px; overflow:hidden; }
        .product-img img { width:100%; height:100%; object-fit:cover; }
        .product-name { font-size:13px; font-weight:bold; color:#0066c0; margin-bottom:5px; }
        .product-desc { font-size:12px; color:#777; margin-bottom:6px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .product-price { font-size:16px; font-weight:bold; color:#B12704; margin-bottom:10px; }
        .btn-add-cart { width:100%; padding:8px; background:#f90; color:#111; border:none; border-radius:4px; font-size:13px; font-weight:bold; cursor:pointer; }
        .btn-add-cart:hover { background:#e68a00; }
        .msg-success { background:#e0f5e0; color:#27ae60; padding:10px 14px; border-radius:4px; margin:10px 20px; border-left:4px solid #27ae60; font-size:13px; }
        footer { background:#232f3e; color:#ccc; text-align:center; padding:16px; font-size:13px; margin-top:30px; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<% if ("true".equals(request.getParameter("added"))) { %>
<div class="msg-success">&#10003; Item added to cart successfully!</div>
<% } %>

<div class="banner">
    <h1>Welcome back, <span><%= userName %>!</span></h1>
    <p>Discover thousands of products at the best prices.</p>
    <a href="ProductServlet" class="banner-btn">Shop Now</a>
</div>

<div class="main-content">

    <div class="section-title">Shop by Category</div>
    <div class="category-grid">
        <a href="ProductServlet?category=electronics" class="category-card"><div class="icon">📱</div><p>Electronics</p></a>
        <a href="ProductServlet?category=clothing" class="category-card"><div class="icon">👕</div><p>Clothing</p></a>
        <a href="ProductServlet?category=books" class="category-card"><div class="icon">📚</div><p>Books</p></a>
        <a href="ProductServlet?category=home" class="category-card"><div class="icon">🏠</div><p>Home & Kitchen</p></a>
        <a href="ProductServlet?category=sports" class="category-card"><div class="icon">⚽</div><p>Sports</p></a>
        <a href="ProductServlet?category=toys" class="category-card"><div class="icon">🧸</div><p>Toys</p></a>
    </div>

    <div class="section-title">Featured Products</div>
    <div class="product-grid">
        <% if (featuredProducts.isEmpty()) { %>
            <p style="color:#777;font-size:14px;padding:10px 0;">No products found. Please add products to the database.</p>
        <% } %>
        <% for (Product p : featuredProducts) { %>
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
        <% } %>
    </div>

</div>

<footer>&copy; 2025 ShopEase. Built with Java EE &bull; JSP &bull; Servlet &bull; MySQL</footer>
</body>
</html>
