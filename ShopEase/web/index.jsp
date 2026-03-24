<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Default landing: if logged in go to home, else go to login
    if (session.getAttribute("loggedInUser") != null) {
        response.sendRedirect("home.jsp");
    } else {
        response.sendRedirect("login.jsp");
    }
%>
