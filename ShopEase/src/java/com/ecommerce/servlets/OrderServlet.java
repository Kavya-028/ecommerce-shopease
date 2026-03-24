package com.ecommerce.servlets;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Handles:
 *   place  → place order from current cart
 *   history → view order history
 * URL: /OrderServlet
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect("CartServlet?action=view&error=empty");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        boolean success = orderDAO.placeOrder(userId, cartItems);

        if (success) {
            response.sendRedirect("OrderServlet?action=history&placed=true");
        } else {
            response.sendRedirect("CartServlet?action=view&error=orderfailed");
        }
    }

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

        OrderDAO orderDAO = new OrderDAO();
        CartDAO cartDAO = new CartDAO();

        if ("items".equals(action)) {
            // View items of a specific order
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            List<OrderItem> items = orderDAO.getOrderItems(orderId);
            request.setAttribute("orderItems", items);
            request.setAttribute("orderId", orderId);
            request.setAttribute("cartCount", cartDAO.getCartCount(userId));
            request.getRequestDispatcher("orderItems.jsp").forward(request, response);
        } else {
            // View order history
            List<Order> orders = orderDAO.getOrdersByUser(userId);
            request.setAttribute("orders", orders);
            request.setAttribute("cartCount", cartDAO.getCartCount(userId));
            request.getRequestDispatcher("orders.jsp").forward(request, response);
        }
    }
}
