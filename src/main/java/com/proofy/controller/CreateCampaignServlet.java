package com.proofy.controller;

import com.proofy.model.Campaign;
import com.proofy.model.User;
import com.proofy.service.CampaignService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/brand/create-campaign")
public class CreateCampaignServlet extends HttpServlet {
    private CampaignService campaignService;

    @Override
    public void init() throws ServletException {
        this.campaignService = new CampaignService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/create-campaign.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        Campaign c = new Campaign();
        c.setBrandId(user.getUserId());
        c.setTitle(request.getParameter("title"));
        c.setBudget(Double.parseDouble(request.getParameter("budget")));
        c.setStartDate(Date.valueOf(request.getParameter("startDate")));
        c.setEndDate(Date.valueOf(request.getParameter("endDate")));
        c.setStatus("active");
        c.setNiche(request.getParameter("niche"));
        c.setMinEngagement(Double.parseDouble(request.getParameter("minEngagement")));
        c.setTargetAudience(request.getParameter("targetAudience"));

        boolean success = campaignService.createCampaign(c);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/brand/dashboard");
        } else {
            request.setAttribute("errorMessage", "Error creating campaign. Please check inputs.");
            request.getRequestDispatcher("/create-campaign.jsp").forward(request, response);
        }
    }
}
