package com.proofy.model;

public class Creator {
    private int creatorId;
    private String displayName;
    private String niche;
    private String audienceCategory;
    private String bio;
    private double trustScore;

    public Creator() {}

    public int getCreatorId() { return creatorId; }
    public void setCreatorId(int creatorId) { this.creatorId = creatorId; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getNiche() { return niche; }
    public void setNiche(String niche) { this.niche = niche; }

    public String getAudienceCategory() { return audienceCategory; }
    public void setAudienceCategory(String audienceCategory) { this.audienceCategory = audienceCategory; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public double getTrustScore() { return trustScore; }
    public void setTrustScore(double trustScore) { this.trustScore = trustScore; }
}
