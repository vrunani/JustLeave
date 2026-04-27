package com.leavemanagement.servlet;

import com.leavemanagement.dao.UserDAO;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/create-user")
public class CreateUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/create-user.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");
        int totalLeaves = role.equals("admin") ? 0 :
                          Integer.parseInt(req.getParameter("totalLeaves"));

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);
        user.setTotalLeaves(totalLeaves);

        boolean success = userDAO.createUser(user);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/create-user?msg=success");
        } else {
            req.setAttribute("error", "Failed to create user. Email may already exist.");
            req.getRequestDispatcher("/WEB-INF/views/admin/create-user.jsp").forward(req, resp);
        }
    }
}