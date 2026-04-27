package com.leavemanagement.servlet;

import com.leavemanagement.dao.LeaveDAO;
import com.leavemanagement.dao.NotificationDAO;
import com.leavemanagement.model.Leave;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/user/apply-leave")
public class ApplyLeaveServlet extends HttpServlet {

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
        req.getRequestDispatcher("/WEB-INF/views/user/apply-leave.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        String reason      = req.getParameter("reason");
        String description = req.getParameter("description");
        String startStr    = req.getParameter("startDate");
        String endStr      = req.getParameter("endDate");

        Leave leave = new Leave();
        leave.setUserId(user.getUserId());
        leave.setReason(reason);
        leave.setDescription(description);
        leave.setStartDate(Date.valueOf(startStr));
        leave.setEndDate(Date.valueOf(endStr));

        boolean success = leaveDAO.applyLeave(leave);

        if (success) {
            notifDAO.sendNotification(user.getUserId(),
                "Your leave request for " + startStr + " to " + endStr + " has been submitted.");
            resp.sendRedirect(req.getContextPath() + "/user/dashboard?msg=applied");
        } else {
            req.setAttribute("error", "Failed to apply leave. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/user/apply-leave.jsp").forward(req, resp);
        }
    }
}