package com.ecommerce.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton Design Pattern for Database Connection
 */
public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String USER = "root";       // Change as per your MySQL username
    private static final String PASSWORD = "kavya1205";   // Change as per your MySQL password

    private static DBConnection instance;
    private Connection connection;

    // Private constructor - Singleton Pattern
    private DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Database Connection Failed: " + e.getMessage());
        }
    }

    // Singleton getInstance
    public static DBConnection getInstance() {
        if (instance == null || isConnectionClosed(instance.connection)) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }

    private static boolean isConnectionClosed(Connection conn) {
        try {
            return conn == null || conn.isClosed();
        } catch (SQLException e) {
            return true;
        }
    }
}
