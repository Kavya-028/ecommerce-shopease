package com.ecommerce.model;

/**
 * Model class representing a cart item (cart JOIN product)
 */
public class CartItem {

    private int cartId;
    private int userId;
    private int productId;
    private int quantity;

    // Joined product details
    private String productName;
    private double productPrice;
    private String productImage;

    public CartItem() {}

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getProductPrice() { return productPrice; }
    public void setProductPrice(double productPrice) { this.productPrice = productPrice; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    // Java 8 style computed subtotal
    public double getSubtotal() {
        return productPrice * quantity;
    }
}
