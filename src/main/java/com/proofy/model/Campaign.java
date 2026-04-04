package com.proofy.model;

import java.sql.Date;

public class Campaign {
    private int campaignId;
    private int brandId;
    private String title;
    private double budget;
    private Date startDate;
    private Date endDate;
    private String status;
    
    // Requirements joined for UI convenience
    private String niche;
    private double minEngagement;
    private String targetAudience;
    private String brandName;

    public Campaign() {}

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public int getCampaignId() { return campaignId; }
    public void setCampaignId(int campaignId) { this.campaignId = campaignId; }

    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getBudget() { return budget; }
    public void setBudget(double budget) { this.budget = budget; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNiche() { return niche; }
    public void setNiche(String niche) { this.niche = niche; }

    public double getMinEngagement() { return minEngagement; }
    public void setMinEngagement(double minEngagement) { this.minEngagement = minEngagement; }

    public String getTargetAudience() { return targetAudience; }
    public void setTargetAudience(String targetAudience) { this.targetAudience = targetAudience; }
}
