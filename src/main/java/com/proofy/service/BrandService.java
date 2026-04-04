package com.proofy.service;

import com.proofy.dao.BrandDAO;
import com.proofy.model.Brand;

public class BrandService {
    private BrandDAO brandDAO;

    public BrandService() {
        this.brandDAO = new BrandDAO();
    }

    public Brand getBrandProfile(int brandId) {
        return brandDAO.getBrandById(brandId);
    }

    public boolean updateBrandProfile(Brand brand) {
        return brandDAO.updateBrandProfile(brand);
    }
}
