package com.proofy.controller;

import com.proofy.model.Brand;
import com.proofy.model.Creator;
import com.proofy.model.User;
import com.proofy.service.BrandService;
import com.proofy.service.CreatorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/edit-profile")
public class EditProfileServlet extends HttpServlet {
    private CreatorService creatorService;
    private BrandService brandService;

    @Override
    public void init() throws ServletException {
        this.creatorService = new CreatorService();
        this.brandService = new BrandService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if ("creator".equals(user.getRole())) {
            Creator creator = creatorService.getCreatorProfile(user.getUserId());
            request.setAttribute("creator", creator);
        } else if ("brand".equals(user.getRole())) {
            Brand brand = brandService.getBrandProfile(user.getUserId());
            request.setAttribute("brand", brand);
        }
        
        request.setAttribute("userRole", user.getRole());
        request.getRequestDispatcher("/edit-profile.jsp").forward(request, response);
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
                Creator creator = new Creator();
                creator.setCreatorId(user.getUserId());
                creator.setDisplayName(request.getParameter("displayName"));
                creator.setNiche(request.getParameter("niche"));
                creator.setAudienceCategory(request.getParameter("audienceCategory"));
                creator.setBio(request.getParameter("bio"));
                
                creatorService.updateCreatorProfile(creator);
                response.sendRedirect(request.getContextPath() + "/creator/dashboard");

            } else if ("brand".equals(user.getRole())) {
                Brand brand = new Brand();
                brand.setBrandId(user.getUserId());
                brand.setBrandName(request.getParameter("brandName"));
                brand.setIndustry(request.getParameter("industry"));
                brand.setWebsite(request.getParameter("website"));
                
                brandService.updateBrandProfile(brand);
                response.sendRedirect(request.getContextPath() + "/brand/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to update profile.");
            doGet(request, response);
        }
    }
}
