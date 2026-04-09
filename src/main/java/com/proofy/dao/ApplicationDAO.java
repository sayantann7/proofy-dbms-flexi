package com.proofy.dao;

import com.proofy.model.Application;
import com.proofy.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO implements BaseDAO {

    public boolean applyToCampaign(int creatorId, int campaignId) {
        String query = "INSERT INTO APPLICATION (creator_id, campaign_id, applied_at, status) VALUES (?, ?, CURRENT_DATE, 'pending')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, creatorId);
            stmt.setInt(2, campaignId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Application> getApplicationsByCreator(int creatorId) {
        List<Application> apps = new ArrayList<>();
        String query = "SELECT a.*, c.title AS campaign_title " +
                       "FROM APPLICATION a " +
                       "JOIN CAMPAIGN c ON a.campaign_id = c.campaign_id " +
                       "WHERE a.creator_id = ? " +
                       "ORDER BY a.applied_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, creatorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setApplicationId(rs.getInt("application_id"));
                    app.setCreatorId(rs.getInt("creator_id"));
                    app.setCampaignId(rs.getInt("campaign_id"));
                    app.setAppliedAt(rs.getDate("applied_at"));
                    app.setStatus(rs.getString("status"));
                    app.setCampaignTitle(rs.getString("campaign_title"));
                    apps.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    public List<Application> getApplicationsByBrand(int brandId) {
        List<Application> apps = new ArrayList<>();
        String query = "SELECT a.*, camp.title AS campaign_title, cr.display_name AS creator_name " +
                       "FROM APPLICATION a " +
                       "JOIN CAMPAIGN camp ON a.campaign_id = camp.campaign_id " +
                       "JOIN CREATOR cr ON a.creator_id = cr.creator_id " +
                       "WHERE camp.brand_id = ? " +
                       "ORDER BY a.applied_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, brandId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setApplicationId(rs.getInt("application_id"));
                    app.setCreatorId(rs.getInt("creator_id"));
                    app.setCampaignId(rs.getInt("campaign_id"));
                    app.setAppliedAt(rs.getDate("applied_at"));
                    app.setStatus(rs.getString("status"));
                    app.setCampaignTitle(rs.getString("campaign_title"));
                    app.setCreatorName(rs.getString("creator_name"));
                    apps.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    public boolean updateApplicationStatus(int applicationId, String status) {
        String query = "UPDATE APPLICATION SET status = ? WHERE application_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, applicationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Implementation of BaseDAO (Polymorphism)
    @Override
    public boolean delete(int id) throws java.sql.SQLException {
        String query = "DELETE FROM Applications WHERE application_id = ?";
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
