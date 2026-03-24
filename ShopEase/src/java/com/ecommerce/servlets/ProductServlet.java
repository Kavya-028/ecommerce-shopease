package com.ecommerce.servlets;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Handles: product listing, search, category filter
 * URL: /ProductServlet
 */
@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String keyword  = request.getParameter("search");
        String category = request.getParameter("category");

        ProductDAO productDAO = new ProductDAO();
        List<Product> products;

        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDAO.searchProducts(keyword.trim());
            request.setAttribute("searchKeyword", keyword.trim());
        } else if (category != null && !category.trim().isEmpty()) {
            products = productDAO.getProductsByCategory(category.trim());
            request.setAttribute("selectedCategory", category.trim());
        } else {
            products = productDAO.getAllProducts();
        }

        // Cart count for header
        CartDAO cartDAO = new CartDAO();
        int cartCount = cartDAO.getCartCount(userId);

        request.setAttribute("products", products);
        request.setAttribute("cartCount", cartCount);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}
