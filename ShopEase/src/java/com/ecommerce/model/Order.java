package com.ecommerce.model;

import java.sql.Timestamp;

/**
 * Model class representing the 'orders' table
 */
public class Order {

    private int id;
    private int userId;
    private double totalAmount;
    private Timestamp orderDate;

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
}
