package com.proofy.dao;

import com.proofy.model.Brand;
import com.proofy.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BrandDAO implements BaseDAO {

    public Brand getBrandById(int brandId) {
        String query = "SELECT * FROM BRAND WHERE brand_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, brandId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Brand brand = new Brand();
                    brand.setBrandId(rs.getInt("brand_id"));
                    brand.setBrandName(rs.getString("brand_name"));
                    brand.setIndustry(rs.getString("industry"));
                    brand.setWebsite(rs.getString("website"));
                    return brand;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateBrandProfile(Brand brand) {
        String query = "UPDATE BRAND SET brand_name = ?, industry = ?, website = ? WHERE brand_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, brand.getBrandName());
            stmt.setString(2, brand.getIndustry());
            stmt.setString(3, brand.getWebsite());
            stmt.setInt(4, brand.getBrandId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Implementation of BaseDAO (Polymorphism)
    @Override
    public boolean delete(int id) throws java.sql.SQLException {
        String query = "DELETE FROM Brands WHERE brand_id = ?";
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
