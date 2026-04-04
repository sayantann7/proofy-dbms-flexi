package com.proofy.controller;

import com.proofy.model.User;
import com.proofy.service.CreatorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/edit-stats")
public class EditStatsServlet extends HttpServlet {
    private CreatorService creatorService;

    @Override
    public void init() throws ServletException {
        this.creatorService = new CreatorService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        
        try {
            if ("creator".equals(user.getRole())) {
                String platformName = request.getParameter("platformName");
                int followers = Integer.parseInt(request.getParameter("followers"));
                double avgEngagement = Double.parseDouble(request.getParameter("avgEngagement"));

                creatorService.upsertPlatformStat(user.getUserId(), platformName, followers, avgEngagement);
            }
            response.sendRedirect(request.getContextPath() + "/creator/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/creator/dashboard");
        }
    }
}