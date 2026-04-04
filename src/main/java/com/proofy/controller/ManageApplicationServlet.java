package com.proofy.controller;

import com.proofy.service.ApplicationService;
import com.proofy.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/brand/manage-application")
public class ManageApplicationServlet extends HttpServlet {
    private ApplicationService applicationService;

    @Override
    public void init() throws ServletException {
        applicationService = new ApplicationService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String action = request.getParameter("action"); // "accept" or "reject"
        
        String newStatus = "accepted".equals(action) ? "accepted" : "rejected";
        boolean success = applicationService.manageApplication(applicationId, newStatus);

        if (success) {
            response.sendRedirect("dashboard?success=Application+" + newStatus);
        } else {
            response.sendRedirect("dashboard?error=Action+failed");
        }
    }
}