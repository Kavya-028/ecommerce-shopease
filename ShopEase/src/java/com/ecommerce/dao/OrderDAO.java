package com.ecommerce.dao;

import com.ecommerce.db.DBConnection;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Order operations
 * Uses Java 8 streams for total calculation
 */
public class OrderDAO {

    private Connection connection;

    public OrderDAO() {
        this.connection = DBConnection.getInstance().getConnection();
    }

    /**
     * Place an order - inserts into orders + order_items + clears cart
     * Uses Transaction (all or nothing)
     */
    public boolean placeOrder(int userId, List<CartItem> cartItems) {
        // Java 8 stream to calculate total
        double total = cartItems.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();

        String orderSql = "INSERT INTO orders (user_id, total_amount) VALUES (?, ?)";
        String itemSql  = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false); // Begin Transaction

            // Insert order
            int orderId = -1;
            try (PreparedStatement orderPs = connection.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderPs.setInt(1, userId);
                orderPs.setDouble(2, total);
                orderPs.executeUpdate();
                ResultSet keys = orderPs.getGeneratedKeys();
                if (keys.next()) {
                    orderId = keys.getInt(1);
                }
            }

            if (orderId == -1) {
                connection.rollback();
                return false;
            }

            // Insert order items
            try (PreparedStatement itemPs = connection.prepareStatement(itemSql)) {
                for (CartItem item : cartItems) {
                    itemPs.setInt(1, orderId);
                    itemPs.setInt(2, item.getProductId());
                    itemPs.setInt(3, item.getQuantity());
                    itemPs.setDouble(4, item.getProductPrice());
                    itemPs.addBatch();
                }
                itemPs.executeBatch();
            }

            // Clear cart
            CartDAO cartDAO = new CartDAO();
            cartDAO.clearCart(userId);

            connection.commit(); // Commit Transaction
            return true;

        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            System.err.println("Error placing order: " + e.getMessage());
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Fetch all orders of a user
    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching orders: " + e.getMessage());
        }
        return orders;
    }

    // Fetch items of a specific order (JOIN with products)
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name, p.image_url AS product_image " +
                     "FROM order_items oi JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order items: " + e.getMessage());
        }
        return items;
    }
}
