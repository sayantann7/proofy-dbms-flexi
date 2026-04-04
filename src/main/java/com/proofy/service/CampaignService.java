package com.proofy.service;

import com.proofy.dao.CampaignDAO;
import com.proofy.model.Campaign;
import java.util.List;

public class CampaignService {
    private CampaignDAO campaignDAO;

    public CampaignService() {
        this.campaignDAO = new CampaignDAO();
    }

    public List<Campaign> getBrandCampaigns(int brandId) {
        return campaignDAO.getCampaignsByBrand(brandId);
    }

    public List<Campaign> getAllActiveCampaigns() {
        return campaignDAO.getAllActiveCampaigns();
    }

    public boolean createCampaign(Campaign campaign) {
        return campaignDAO.createCampaignWithRequirements(campaign);
    }
}
