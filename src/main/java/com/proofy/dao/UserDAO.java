package com.proofy.dao;

import com.proofy.model.User;
import com.proofy.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO implements BaseDAO {
    public User authenticateUser(String email, String password) {
        String query = "SELECT user_id, email, role, created_at FROM USER WHERE email = ? AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getDate("created_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerUser(String email, String password, String role, String name, String nicheOrIndustry, String audienceOrWebsite, String bio) {
        String insertUserQuery = "INSERT INTO USER (email, password, role, created_at) VALUES (?, ?, ?, CURRENT_DATE)";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(insertUserQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, email);
                stmt.setString(2, password);
                stmt.setString(3, role);
                int affectedRows = stmt.executeUpdate();

                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int userId = generatedKeys.getInt(1);

                        if ("creator".equals(role)) {
                            String insertCreatorQuery = "INSERT INTO CREATOR (creator_id, display_name, niche, audience_category, bio, trust_score) VALUES (?, ?, ?, ?, ?, 50.00)";
                            try (PreparedStatement cStmt = conn.prepareStatement(insertCreatorQuery)) {
                                cStmt.setInt(1, userId);
                                cStmt.setString(2, name);
                                cStmt.setString(3, nicheOrIndustry);
                                cStmt.setString(4, audienceOrWebsite);
                                cStmt.setString(5, bio);
                                cStmt.executeUpdate();
                            }
                        } else if ("brand".equals(role)) {
                            String insertBrandQuery = "INSERT INTO BRAND (brand_id, brand_name, industry, website) VALUES (?, ?, ?, ?)";
                            try (PreparedStatement bStmt = conn.prepareStatement(insertBrandQuery)) {
                                bStmt.setInt(1, userId);
                                bStmt.setString(2, name);
                                bStmt.setString(3, nicheOrIndustry);
                                bStmt.setString(4, audienceOrWebsite);
                                bStmt.executeUpdate();
                            }
                        }
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }
    
    @Override
    public boolean delete(int id) throws java.sql.SQLException {
        String query = "DELETE FROM Users WHERE user_id = ?";
        try (java.sql.Connection conn = com.proofy.util.DatabaseConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
