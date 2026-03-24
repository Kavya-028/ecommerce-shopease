<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session guard - used in every page that includes this header
    HttpSession userSess = request.getSession(false);
    if (userSess == null || userSess.getAttribute("loggedInUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String hUserName  = (String) userSess.getAttribute("userName");
    Integer hCartCount = (Integer) request.getAttribute("cartCount");
    if (hCartCount == null) hCartCount = 0;
%>
<header style="background:#232f3e;color:white;padding:12px 30px;display:flex;align-items:center;justify-content:space-between;">
    <a href="home.jsp" style="font-size:22px;font-weight:bold;color:white;text-decoration:none;">
        Shop<span style="color:#f90;">Ease</span>
    </a>

    <form action="ProductServlet" method="get" style="display:flex;flex:1;margin:0 25px;">
        <input type="text" name="search" placeholder="Search for products..."
               value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
               style="flex:1;padding:8px 12px;font-size:14px;border:none;outline:none;border-radius:4px 0 0 4px;" />
        <button type="submit"
                style="background:#f90;border:none;padding:8px 16px;cursor:pointer;font-size:14px;font-weight:bold;border-radius:0 4px 4px 0;color:#111;">
            Search
        </button>
    </form>

    <div style="display:flex;align-items:center;gap:18px;">
        <div style="color:#ccc;font-size:13px;line-height:1.3;">
            Hello, <strong style="color:white;font-size:14px;"><%= hUserName %></strong>
        </div>
        <a href="CartServlet?action=view"
           style="color:white;text-decoration:none;font-size:14px;font-weight:bold;">
            &#128722; Cart (<%= hCartCount %>)
        </a>
        <a href="ProfileServlet" style="color:#ccc;text-decoration:none;font-size:13px;">Profile</a>
        <a href="OrderServlet?action=history" style="color:#ccc;text-decoration:none;font-size:13px;">Orders</a>
        <a href="LogoutServlet"
           style="background:#f90;color:#111;padding:6px 13px;border-radius:4px;text-decoration:none;font-size:13px;font-weight:bold;">
            Logout
        </a>
    </div>
</header>

<nav style="background:#37475a;padding:8px 30px;display:flex;gap:20px;">
    <a href="home.jsp" style="color:white;text-decoration:none;font-size:13px;">Home</a>
    <a href="ProductServlet" style="color:white;text-decoration:none;font-size:13px;">All Products</a>
    <a href="ProductServlet?category=electronics" style="color:white;text-decoration:none;font-size:13px;">Electronics</a>
    <a href="ProductServlet?category=clothing" style="color:white;text-decoration:none;font-size:13px;">Clothing</a>
    <a href="ProductServlet?category=books" style="color:white;text-decoration:none;font-size:13px;">Books</a>
    <a href="ProductServlet?category=sports" style="color:white;text-decoration:none;font-size:13px;">Sports</a>
    <a href="OrderServlet?action=history" style="color:white;text-decoration:none;font-size:13px;">My Orders</a>
</nav>
