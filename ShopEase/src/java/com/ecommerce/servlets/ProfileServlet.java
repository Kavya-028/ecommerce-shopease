package com.ecommerce.servlets;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles user profile view and update
 * URL: /ProfileServlet
 */
@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        UserDAO userDAO = new UserDAO();
        CartDAO cartDAO = new CartDAO();

        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.setAttribute("cartCount", cartDAO.getCartCount(userId));
        request.getRequestDispatcher("profile.jsp").forward(request, response);
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
        UserDAO userDAO = new UserDAO();
        CartDAO cartDAO = new CartDAO();

        if ("updateProfile".equals(action)) {
            String name  = request.getParameter("name");
            String email = request.getParameter("email");

            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Name and Email cannot be empty.");
            } else {
                User user = new User();
                user.setId(userId);
                user.setName(name.trim());
                user.setEmail(email.trim());

                boolean updated = userDAO.updateUser(user);
                if (updated) {
                    // Refresh session with new name
                    session.setAttribute("userName", name.trim());
                    User updatedUser = userDAO.getUserById(userId);
                    session.setAttribute("loggedInUser", updatedUser);
                    request.setAttribute("success", "Profile updated successfully!");
                } else {
                    request.setAttribute("error", "Update failed. Email may already be in use.");
                }
            }

        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword     = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User dbUser = userDAO.getUserById(userId);

            if (!dbUser.getPassword().equals(currentPassword)) {
                request.setAttribute("pwError", "Current password is incorrect.");
            } else if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("pwError", "New password must be at least 6 characters.");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("pwError", "New passwords do not match.");
            } else {
                boolean changed = userDAO.updatePassword(userId, newPassword);
                if (changed) {
                    request.setAttribute("pwSuccess", "Password changed successfully!");
                } else {
                    request.setAttribute("pwError", "Failed to change password.");
                }
            }
        }

        // Reload user and forward back
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.setAttribute("cartCount", cartDAO.getCartCount(userId));
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
