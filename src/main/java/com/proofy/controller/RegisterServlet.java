package com.proofy.controller;

import java.io.IOException;

import com.proofy.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String nicheOrIndustry = request.getParameter("nicheOrIndustry");
        String audienceOrWebsite = request.getParameter("audienceOrWebsite");
        String bio = request.getParameter("bio");

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            response.sendRedirect("register.jsp?error=Invalid+email+format.");
            return;
        }

        boolean success = authService.register(email, password, role, name, nicheOrIndustry, audienceOrWebsite, bio);

        if (success) {
            response.sendRedirect("login.jsp?success=Registration+successful.+Please+log+in.");
        } else {
            response.sendRedirect("register.jsp?error=Registration+failed.");
        }
    }
}