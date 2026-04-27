package com.leavemanagement.servlet;

import com.leavemanagement.dao.LeaveDAO;
import com.leavemanagement.dao.NotificationDAO;
import com.leavemanagement.model.Leave;
import com.leavemanagement.model.Notification;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {

    private LeaveDAO leaveDAO = new LeaveDAO();
    private NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        int userId = user.getUserId();

        List<Leave> leaves = leaveDAO.getLeavesByUser(userId);
        int approved  = leaveDAO.countByStatus(userId, "approved");
        int pending   = leaveDAO.countByStatus(userId, "pending");
        int rejected  = leaveDAO.countByStatus(userId, "rejected");
        int cancelled = leaveDAO.countByStatus(userId, "cancelled");
        int unreadNotif = notifDAO.countUnread(userId);

        req.setAttribute("leaves", leaves);
        req.setAttribute("approved", approved);
        req.setAttribute("pending", pending);
        req.setAttribute("rejected", rejected);
        req.setAttribute("cancelled", cancelled);
        req.setAttribute("availableLeaves", user.getTotalLeaves() - approved);
        req.setAttribute("unreadNotif", unreadNotif);

        req.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp")
           .forward(req, resp);
    }
}