package com.proofy.controller;

import com.proofy.model.Creator;
import com.proofy.model.PlatformStat;
import com.proofy.model.CredibilityScore;
import com.proofy.model.User;
import com.proofy.service.CreatorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/brand/creator-details")
public class CreatorDetailsServlet extends HttpServlet {
    private CreatorService creatorService;

    @Override
    public void init() throws ServletException {
        this.creatorService = new CreatorService();
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

        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int creatorId = Integer.parseInt(idParam);
                Creator creator = creatorService.getCreatorProfile(creatorId);
                List<PlatformStat> stats = creatorService.getCreatorPlatformStats(creatorId);
                CredibilityScore score = creatorService.getCreatorLatestScore(creatorId);

                request.setAttribute("creator", creator);
                request.setAttribute("stats", stats);
                request.setAttribute("score", score);
                
                request.getRequestDispatcher("/creator-details.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/brand/dashboard");
    }
}
