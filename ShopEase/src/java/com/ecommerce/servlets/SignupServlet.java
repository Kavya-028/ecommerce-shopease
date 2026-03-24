package com.ecommerce.servlets;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Input validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Password match check
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Password length check (Java 8+ style)
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        // Check if email already exists
        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("error", "Email already registered. Please login.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Create User object and register
        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPassword(password); // In production, hash the password

        boolean isRegistered = userDAO.registerUser(user);

        if (isRegistered) {
            request.setAttribute("success", "Account created successfully! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }
}
