package com.proofy.model;

import java.sql.Date;

public class User {
    private int userId;
    private String email;
    private String role;
    private Date createdAt;

    public User() {}

    public User(int userId, String email, String role, Date createdAt) {
        this.userId = userId;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}


