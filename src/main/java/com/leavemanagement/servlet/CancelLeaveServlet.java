package com.leavemanagement.servlet;

import com.leavemanagement.dao.LeaveDAO;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/cancel-leave")
public class CancelLeaveServlet extends HttpServlet {

    private LeaveDAO leaveDAO = new LeaveDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user   = (User) session.getAttribute("loggedUser");
        int leaveId = Integer.parseInt(req.getParameter("leaveId"));
        leaveDAO.cancelLeave(leaveId, user.getUserId());
        resp.sendRedirect(req.getContextPath() + "/user/dashboard");
    }
}