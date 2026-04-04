package com.proofy.service;

import com.proofy.dao.ApplicationDAO;
import com.proofy.model.Application;

import java.util.List;

public class ApplicationService {
    private ApplicationDAO applicationDAO;

    public ApplicationService() {
        this.applicationDAO = new ApplicationDAO();
    }

    public boolean applyToCampaign(int creatorId, int campaignId) {
        return applicationDAO.applyToCampaign(creatorId, campaignId);
    }

    public List<Application> getCreatorApplications(int creatorId) {
        return applicationDAO.getApplicationsByCreator(creatorId);
    }

    public List<Application> getBrandApplications(int brandId) {
        return applicationDAO.getApplicationsByBrand(brandId);
    }

    public boolean manageApplication(int applicationId, String status) {
        return applicationDAO.updateApplicationStatus(applicationId, status);
    }
}