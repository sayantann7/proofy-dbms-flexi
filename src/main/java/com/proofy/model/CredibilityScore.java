package com.proofy.model;

import java.sql.Date;

public class CredibilityScore {
    private double audienceMatch;
    private double pastConversionRate;
    private double deliveryReliability;
    private double disputePenalty;
    private double finalScore;
    private Date calculatedAt;

    public CredibilityScore() {}

    public double getAudienceMatch() { return audienceMatch; }
    public void setAudienceMatch(double audienceMatch) { this.audienceMatch = audienceMatch; }

    public double getPastConversionRate() { return pastConversionRate; }
    public void setPastConversionRate(double pastConversionRate) { this.pastConversionRate = pastConversionRate; }

    public double getDeliveryReliability() { return deliveryReliability; }
    public void setDeliveryReliability(double deliveryReliability) { this.deliveryReliability = deliveryReliability; }

    public double getDisputePenalty() { return disputePenalty; }
    public void setDisputePenalty(double disputePenalty) { this.disputePenalty = disputePenalty; }

    public double getFinalScore() { return finalScore; }
    public void setFinalScore(double finalScore) { this.finalScore = finalScore; }

    public Date getCalculatedAt() { return calculatedAt; }
    public void setCalculatedAt(Date calculatedAt) { this.calculatedAt = calculatedAt; }
}
