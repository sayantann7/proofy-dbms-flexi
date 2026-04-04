package com.proofy.model;

public class PlatformStat {
    private String platformName;
    private int followers;
    private double avgEngagement;

    public PlatformStat() {}

    public String getPlatformName() { return platformName; }
    public void setPlatformName(String platformName) { this.platformName = platformName; }

    public int getFollowers() { return followers; }
    public void setFollowers(int followers) { this.followers = followers; }

    public double getAvgEngagement() { return avgEngagement; }
    public void setAvgEngagement(double avgEngagement) { this.avgEngagement = avgEngagement; }
}
