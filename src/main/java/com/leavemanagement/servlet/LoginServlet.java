package com.leavemanagement.servlet;

import com.leavemanagement.dao.UserDAO;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        System.out.println("✅ LoginServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("➡ GET /login called");
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("===== LOGIN REQUEST START =====");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        System.out.println("Raw Email: " + email);
        System.out.println("Raw Password: " + password);

        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        System.out.println("Trimmed Email: " + email);
        System.out.println("Trimmed Password: " + password);

        // STEP 1: validation
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            System.out.println("❌ VALIDATION FAILED: Empty fields");

            req.setAttribute("error", "Email and Password are required!");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        System.out.println("➡ Calling DAO.login()...");

        // STEP 2: DB check
        String result = userDAO.loginDebug(email, password);
        System.out.println("DEBUG RESULT: " + result);

        User user = null;

        if ("SUCCESS".equals(result)) {
            user = userDAO.login(email, password); // fetch full user object
        }

        // STEP 3: result handling
        if (user != null) {

            System.out.println("✅ LOGIN SUCCESS");
            System.out.println("User found: " + user.getEmail());
            System.out.println("Role: " + user.getRole());

            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());

            System.out.println("➡ Session created");

            if ("admin".equalsIgnoreCase(user.getRole())) {
                System.out.println("➡ Redirecting to ADMIN dashboard");
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                System.out.println("➡ Redirecting to USER dashboard");
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
            }

        } else {

            System.out.println("❌ LOGIN FAILED: User not found or wrong credentials");

            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }

        System.out.println("===== LOGIN REQUEST END =====");
    }
}