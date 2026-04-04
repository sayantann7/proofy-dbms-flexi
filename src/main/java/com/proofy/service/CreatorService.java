package com.proofy.service;

import com.proofy.dao.CreatorDAO;
import com.proofy.dao.StatsDAO;
import com.proofy.model.Creator;
import com.proofy.model.CredibilityScore;
import com.proofy.model.PlatformStat;
import java.util.List;

public class CreatorService {
    private CreatorDAO creatorDAO;
    private StatsDAO statsDAO;

    public CreatorService() {
        this.creatorDAO = new CreatorDAO();
        this.statsDAO = new StatsDAO();
    }

    public Creator getCreatorProfile(int creatorId) {
        return creatorDAO.getCreatorById(creatorId);
    }

    public List<Creator> getTopRankedCreators() {
        return creatorDAO.getTopCreators();
    }

    public List<PlatformStat> getCreatorPlatformStats(int creatorId) {
        return statsDAO.getPlatformStats(creatorId);
    }

    public CredibilityScore getCreatorLatestScore(int creatorId) {
        return statsDAO.getLatestCredibilityScore(creatorId);
    }

    public boolean updateCreatorProfile(Creator creator) {
        return creatorDAO.updateCreatorProfile(creator);
    }

    public void upsertPlatformStat(int creatorId, String platformName, int followers, double avgEngagement) {
        statsDAO.upsertPlatformStat(creatorId, platformName, followers, avgEngagement);
    }
}

