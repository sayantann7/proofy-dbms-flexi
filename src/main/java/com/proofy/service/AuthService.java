package com.proofy.service;

import com.proofy.dao.UserDAO;
import com.proofy.model.User;

public class AuthService {
    private UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public User login(String email, String password) {
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return null; // Basic validation
        }
        return userDAO.authenticateUser(email, password);
    }

    public boolean register(String email, String password, String role, String name, String nicheOrIndustry, String audienceOrWebsite, String bio) {
        if (email == null || password == null || role == null || name == null) {
            return false;
        }
        return userDAO.registerUser(email, password, role, name, nicheOrIndustry, audienceOrWebsite, bio);
    }
}
