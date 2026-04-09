package com.proofy.dao;

import com.proofy.model.Campaign;
import com.proofy.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CampaignDAO implements BaseDAO {

    public List<Campaign> getCampaignsByBrand(int brandId) {
        List<Campaign> campaigns = new ArrayList<>();
        String query = "SELECT c.*, cr.niche, cr.min_engagement, cr.target_audience " +
                       "FROM CAMPAIGN c " +
                       "LEFT JOIN CAMPAIGN_REQUIREMENT cr ON c.campaign_id = cr.campaign_id " +
                       "WHERE c.brand_id = ? " +
                       "ORDER BY c.start_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, brandId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Campaign c = new Campaign();
                    c.setCampaignId(rs.getInt("campaign_id"));
                    c.setBrandId(rs.getInt("brand_id"));
                    c.setTitle(rs.getString("title"));
                    c.setBudget(rs.getDouble("budget"));
                    c.setStartDate(rs.getDate("start_date"));
                    c.setEndDate(rs.getDate("end_date"));
                    c.setStatus(rs.getString("status"));
                    c.setNiche(rs.getString("niche"));
                    c.setMinEngagement(rs.getDouble("min_engagement"));
                    c.setTargetAudience(rs.getString("target_audience"));       
                    campaigns.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return campaigns;
    }

    public List<Campaign> getAllActiveCampaigns() {
        List<Campaign> campaigns = new ArrayList<>();
        String query = "SELECT c.*, cr.niche, cr.min_engagement, cr.target_audience, b.brand_name " +
                       "FROM CAMPAIGN c " +
                       "LEFT JOIN CAMPAIGN_REQUIREMENT cr ON c.campaign_id = cr.campaign_id " +
                       "LEFT JOIN BRAND b ON c.brand_id = b.brand_id " +
                       "WHERE c.status = 'active' " +
                       "ORDER BY c.start_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Campaign c = new Campaign();
                c.setCampaignId(rs.getInt("campaign_id"));
                c.setBrandId(rs.getInt("brand_id"));
                c.setTitle(rs.getString("title"));
                c.setBudget(rs.getDouble("budget"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setStatus(rs.getString("status"));
                c.setNiche(rs.getString("niche"));
                c.setMinEngagement(rs.getDouble("min_engagement"));
                c.setTargetAudience(rs.getString("target_audience"));
                c.setBrandName(rs.getString("brand_name"));
                campaigns.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return campaigns;
    }

    public boolean createCampaignWithRequirements(Campaign c) {
        String campQuery = "INSERT INTO CAMPAIGN (brand_id, title, budget, start_date, end_date, status) VALUES (?, ?, ?, ?, ?, ?)";
        String reqQuery = "INSERT INTO CAMPAIGN_REQUIREMENT (campaign_id, niche, min_engagement, target_audience) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert Campaign
            try (PreparedStatement campStmt = conn.prepareStatement(campQuery, Statement.RETURN_GENERATED_KEYS)) {
                campStmt.setInt(1, c.getBrandId());
                campStmt.setString(2, c.getTitle());
                campStmt.setDouble(3, c.getBudget());
                campStmt.setDate(4, c.getStartDate());
                campStmt.setDate(5, c.getEndDate());
                campStmt.setString(6, c.getStatus() != null ? c.getStatus() : "active");
                campStmt.executeUpdate();

                try (ResultSet generatedKeys = campStmt.getGeneratedKeys()) {   
                    if (generatedKeys.next()) {
                        int newCampaignId = generatedKeys.getInt(1);

                        // 2. Insert Requirements
                        try (PreparedStatement reqStmt = conn.prepareStatement(reqQuery)) {
                            reqStmt.setInt(1, newCampaignId);
                            reqStmt.setString(2, c.getNiche());
                            reqStmt.setDouble(3, c.getMinEngagement());
                            reqStmt.setString(4, c.getTargetAudience());        
                            reqStmt.executeUpdate();
                        }
                    }
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }
    
    @Override
    public boolean delete(int id) throws java.sql.SQLException {
        String query = "DELETE FROM Campaigns WHERE campaign_id = ?";
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
