package com.proofy.controller;

import com.proofy.model.Brand;
import com.proofy.model.Campaign;
import com.proofy.model.Application;
import com.proofy.model.Creator;
import com.proofy.model.User;
import com.proofy.service.BrandService;
import com.proofy.service.CampaignService;
import com.proofy.service.CreatorService;
import com.proofy.service.ApplicationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/brand/dashboard")
public class BrandDashboardServlet extends HttpServlet {
    private BrandService brandService;
    private CreatorService creatorService;
    private CampaignService campaignService;
    private ApplicationService applicationService;

    @Override
    public void init() throws ServletException {
        this.brandService = new BrandService();
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
        if (!"brand".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch Brand profile
        Brand brand = brandService.getBrandProfile(user.getUserId());
        request.setAttribute("brand", brand);

        // Fetch Brand's Campaigns
        List<Campaign> campaigns = campaignService.getBrandCampaigns(user.getUserId());
        request.setAttribute("campaigns", campaigns);

        // Fetch Top Creators for recommendations
        List<Creator> topCreators = creatorService.getTopRankedCreators();      
        request.setAttribute("topCreators", topCreators);

        // Fetch Applications
        List<Application> applications = applicationService.getBrandApplications(user.getUserId());
        request.setAttribute("applications", applications);

        request.getRequestDispatcher("/brand-dashboard.jsp").forward(request, response);
    }
}