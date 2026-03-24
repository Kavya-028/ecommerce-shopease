package com.ecommerce.servlets;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Handles all cart operations via 'action' parameter:
 *   add    → add item to cart
 *   remove → remove item from cart
 *   update → update quantity
 *   view   → show cart page
 * URL: /CartServlet
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        CartDAO cartDAO = new CartDAO();

        if ("remove".equals(action)) {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            cartDAO.removeFromCart(cartId);
            response.sendRedirect("CartServlet?action=view");
            return;
        }

        // Default: view cart
        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        double total = cartItems.stream().mapToDouble(CartItem::getSubtotal).sum();

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", total);
        request.setAttribute("cartCount", cartDAO.getCartCount(userId));
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        CartDAO cartDAO = new CartDAO();

        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity  = 1;
            try { quantity = Integer.parseInt(request.getParameter("quantity")); } catch (Exception ignored) {}
            cartDAO.addToCart(userId, productId, quantity);
            response.sendRedirect("CartServlet?action=view&added=true");

        } else if ("update".equals(action)) {
            int cartId  = Integer.parseInt(request.getParameter("cartId"));
            int qty     = Integer.parseInt(request.getParameter("quantity"));
            if (qty <= 0) {
                cartDAO.removeFromCart(cartId);
            } else {
                cartDAO.updateCartQuantity(cartId, qty);
            }
            response.sendRedirect("CartServlet?action=view");
        }
    }
}
