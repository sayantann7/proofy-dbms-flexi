package com.proofy.dao;

import com.proofy.model.PlatformStat;
import com.proofy.model.CredibilityScore;
import com.proofy.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StatsDAO implements BaseDAO {

    public List<PlatformStat> getPlatformStats(int creatorId) {
        List<PlatformStat> stats = new ArrayList<>();
        String query = "SELECT p.platform_name, cps.followers, cps.avg_engagement " +
                       "FROM CREATOR_PLATFORM_STATS cps " +
                       "JOIN PLATFORM p ON cps.platform_id = p.platform_id " +
                       "WHERE cps.creator_id = ?";
                       
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, creatorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PlatformStat stat = new PlatformStat();
                    stat.setPlatformName(rs.getString("platform_name"));
                    stat.setFollowers(rs.getInt("followers"));
                    stat.setAvgEngagement(rs.getDouble("avg_engagement"));
                    stats.add(stat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public void upsertPlatformStat(int creatorId, String platformName, int followers, double avgEngagement) {
        Connection conn = null;
        PreparedStatement checkPlatformStmt = null;
        PreparedStatement insertPlatformStmt = null;
        PreparedStatement upsertStatStmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Get or Create Platform
            int platformId = -1;
            String checkQuery = "SELECT platform_id FROM PLATFORM WHERE platform_name = ?";
            checkPlatformStmt = conn.prepareStatement(checkQuery);
            checkPlatformStmt.setString(1, platformName);
            rs = checkPlatformStmt.executeQuery();

            if (rs.next()) {
                platformId = rs.getInt("platform_id");
            } else {
                String insertQuery = "INSERT INTO PLATFORM (platform_name) VALUES (?)";
                insertPlatformStmt = conn.prepareStatement(insertQuery, PreparedStatement.RETURN_GENERATED_KEYS);
                insertPlatformStmt.setString(1, platformName);
                insertPlatformStmt.executeUpdate();
                try (ResultSet generatedKeys = insertPlatformStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        platformId = generatedKeys.getInt(1);
                    }
                }
            }

            // 2. Upsert Stats using MySQL specific syntax `ON DUPLICATE KEY UPDATE`
            if (platformId != -1) {
                String upsertQuery = "INSERT INTO CREATOR_PLATFORM_STATS (creator_id, platform_id, followers, avg_engagement) " +
                                     "VALUES (?, ?, ?, ?) " +
                                     "ON DUPLICATE KEY UPDATE followers = ?, avg_engagement = ?";
                upsertStatStmt = conn.prepareStatement(upsertQuery);
                upsertStatStmt.setInt(1, creatorId);
                upsertStatStmt.setInt(2, platformId);
                upsertStatStmt.setInt(3, followers);
                upsertStatStmt.setDouble(4, avgEngagement);
                upsertStatStmt.setInt(5, followers);
                upsertStatStmt.setDouble(6, avgEngagement);
                upsertStatStmt.executeUpdate();
            }

            conn.commit(); // Commit transaction

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPlatformStmt != null) checkPlatformStmt.close();
                if (insertPlatformStmt != null) insertPlatformStmt.close();
                if (upsertStatStmt != null) upsertStatStmt.close();
                if (conn != null) conn.setAutoCommit(true);
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public CredibilityScore getLatestCredibilityScore(int creatorId) {
        String query = "SELECT * FROM CREDIBILITY_SCORE WHERE creator_id = ? ORDER BY calculated_at DESC LIMIT 1";
                       
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, creatorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    CredibilityScore score = new CredibilityScore();
                    score.setAudienceMatch(rs.getDouble("audience_match"));
                    score.setPastConversionRate(rs.getDouble("past_conversion_rate"));
                    score.setDeliveryReliability(rs.getDouble("delivery_reliability"));
                    score.setDisputePenalty(rs.getDouble("dispute_penalty"));
                    score.setFinalScore(rs.getDouble("final_score"));
                    score.setCalculatedAt(rs.getDate("calculated_at"));
                    return score;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public boolean delete(int id) throws java.sql.SQLException {
        String query = "DELETE FROM Platform_Stats WHERE stat_id = ?";
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
