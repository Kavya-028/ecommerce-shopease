package com.ecommerce.dao;

import com.ecommerce.db.DBConnection;
import com.ecommerce.model.CartItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Cart operations
 */
public class CartDAO {

    private Connection connection;

    public CartDAO() {
        this.connection = DBConnection.getInstance().getConnection();
    }

    // Add product to cart or increase quantity if already exists
    public boolean addToCart(int userId, int productId, int quantity) {
        // Check if item already in cart
        String checkSql = "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, userId);
            checkPs.setInt(2, productId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                // Already exists → update quantity
                int existingQty = rs.getInt("quantity");
                int cartId = rs.getInt("id");
                String updateSql = "UPDATE cart SET quantity = ? WHERE id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                    updatePs.setInt(1, existingQty + quantity);
                    updatePs.setInt(2, cartId);
                    return updatePs.executeUpdate() > 0;
                }
            } else {
                // New item → insert
                String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement insertPs = connection.prepareStatement(insertSql)) {
                    insertPs.setInt(1, userId);
                    insertPs.setInt(2, productId);
                    insertPs.setInt(3, quantity);
                    return insertPs.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding to cart: " + e.getMessage());
        }
        return false;
    }

    // Get all cart items for a user (JOIN with products)
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.id AS cart_id, c.user_id, c.product_id, c.quantity, " +
                     "p.name AS product_name, p.price AS product_price, p.image_url AS product_image " +
                     "FROM cart c JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartId(rs.getInt("cart_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductName(rs.getString("product_name"));
                item.setProductPrice(rs.getDouble("product_price"));
                item.setProductImage(rs.getString("product_image"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching cart: " + e.getMessage());
        }
        return items;
    }

    // Update quantity of a cart item
    public boolean updateCartQuantity(int cartId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating cart: " + e.getMessage());
        }
        return false;
    }

    // Remove single item from cart
    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error removing from cart: " + e.getMessage());
        }
        return false;
    }

    // Clear entire cart of a user (called after placing order)
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("Error clearing cart: " + e.getMessage());
        }
        return false;
    }

    // Count total cart items for a user (for header badge)
    public int getCartCount(int userId) {
        String sql = "SELECT SUM(quantity) FROM cart WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error counting cart: " + e.getMessage());
        }
        return 0;
    }
}
