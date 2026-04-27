package com.leavemanagement.servlet;

import com.leavemanagement.dao.LeaveDAO;
import com.leavemanagement.dao.NotificationDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/update-leave")
public class UpdateLeaveServlet extends HttpServlet {

    private LeaveDAO leaveDAO = new LeaveDAO();
    private NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int    leaveId = Integer.parseInt(req.getParameter("leaveId"));
        int    userId  = Integer.parseInt(req.getParameter("userId"));
        String status  = req.getParameter("status");

        leaveDAO.updateLeaveStatus(leaveId, status);

        String msg = "approved".equals(status)
            ? "Your leave request has been approved by admin."
            : "Your leave request has been rejected by admin.";
        notifDAO.sendNotification(userId, msg);

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=updated");
    }
}