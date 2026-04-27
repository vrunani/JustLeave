package com.leavemanagement.servlet;

import com.leavemanagement.dao.LeaveDAO;
import com.leavemanagement.dao.UserDAO;
import com.leavemanagement.model.Leave;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private LeaveDAO leaveDAO = new LeaveDAO();
    private UserDAO  userDAO  = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Leave> allLeaves = leaveDAO.getAllLeaves();
        List<User>  allUsers  = userDAO.getAllUsers();

        long pending  = allLeaves.stream().filter(l -> "pending".equals(l.getStatus())).count();
        long approved = allLeaves.stream().filter(l -> "approved".equals(l.getStatus())).count();
        long rejected = allLeaves.stream().filter(l -> "rejected".equals(l.getStatus())).count();

        req.setAttribute("allLeaves", allLeaves);
        req.setAttribute("allUsers",  allUsers);
        req.setAttribute("pendingCount",  pending);
        req.setAttribute("approvedCount", approved);
        req.setAttribute("rejectedCount", rejected);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}