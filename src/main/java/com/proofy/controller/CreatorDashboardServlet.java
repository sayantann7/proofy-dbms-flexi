package com.proofy.controller;

import com.proofy.model.Creator;
import com.proofy.model.Campaign;
import com.proofy.model.Application;
import com.proofy.model.PlatformStat;
import com.proofy.model.CredibilityScore;
import com.proofy.model.User;
import com.proofy.service.CreatorService;
import com.proofy.service.CampaignService;
import com.proofy.service.ApplicationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/creator/dashboard")
public class CreatorDashboardServlet extends HttpServlet {
    private CreatorService creatorService;
    private CampaignService campaignService;
    private ApplicationService applicationService;

    @Override
    public void init() throws ServletException {
        this.creatorService = new CreatorService();
        this.campaignService = new CampaignService();
        this.applicationService = new ApplicationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {  
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"creator".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int creatorId = user.getUserId();

        // Fetch Profile, Stats, and Score
        Creator creator = creatorService.getCreatorProfile(creatorId);
        List<PlatformStat> stats = creatorService.getCreatorPlatformStats(creatorId);
        CredibilityScore score = creatorService.getCreatorLatestScore(creatorId);

        // Fetch active campaigns and applications
        List<Campaign> activeCampaigns = campaignService.getAllActiveCampaigns();
        List<Application> myApplications = applicationService.getCreatorApplications(creatorId);

        request.setAttribute("creator", creator);
        request.setAttribute("stats", stats);
        request.setAttribute("score", score);
        request.setAttribute("activeCampaigns", activeCampaigns);
        request.setAttribute("myApplications", myApplications);

        request.getRequestDispatcher("/creator-dashboard.jsp").forward(request, response);
    }
}