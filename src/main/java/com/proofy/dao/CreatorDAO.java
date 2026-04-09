package com.proofy.dao;

import com.proofy.model.Creator;
import com.proofy.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CreatorDAO implements BaseDAO {

    public Creator getCreatorById(int creatorId) {
        String query = "SELECT * FROM CREATOR WHERE creator_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, creatorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Creator creator = new Creator();
                    creator.setCreatorId(rs.getInt("creator_id"));
                    creator.setDisplayName(rs.getString("display_name"));
                    creator.setNiche(rs.getString("niche"));
                    creator.setAudienceCategory(rs.getString("audience_category"));
                    creator.setBio(rs.getString("bio"));
                    creator.setTrustScore(rs.getDouble("trust_score"));
                    return creator;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Creator> getTopCreators() {
        List<Creator> creators = new ArrayList<>();
        String query = "SELECT * FROM CREATOR ORDER BY trust_score DESC LIMIT 10";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Creator creator = new Creator();
                creator.setCreatorId(rs.getInt("creator_id"));
                creator.setDisplayName(rs.getString("display_name"));
                creator.setNiche(rs.getString("niche"));
                creator.setAudienceCategory(rs.getString("audience_category"));
                creator.setBio(rs.getString("bio"));
                creator.setTrustScore(rs.getDouble("trust_score"));
                creators.add(creator);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return creators;
    }

    public boolean updateCreatorProfile(Creator creator) {
        String query = "UPDATE CREATOR SET display_name = ?, niche = ?, audience_category = ?, bio = ? WHERE creator_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, creator.getDisplayName());
            stmt.setString(2, creator.getNiche());
            stmt.setString(3, creator.getAudienceCategory());
            stmt.setString(4, creator.getBio());
            stmt.setInt(5, creator.getCreatorId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean delete(int id) throws java.sql.SQLException {
        String query = "DELETE FROM Creators WHERE creator_id = ?";
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
