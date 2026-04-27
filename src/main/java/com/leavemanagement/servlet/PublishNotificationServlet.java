package com.leavemanagement.servlet;

import com.leavemanagement.dao.NotificationDAO;
import com.leavemanagement.dao.UserDAO;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/publish-notification")
public class PublishNotificationServlet extends HttpServlet {

    private NotificationDAO notifDAO = new NotificationDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        List<User> users = userDAO.getAllUsers();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/WEB-INF/views/admin/publish-notification.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String   target  = req.getParameter("target");
        String   message = req.getParameter("message");
        boolean  success = false;

        if ("all".equals(target)) {
            List<User> users = userDAO.getAllUsers();
            for (User u : users) {
                notifDAO.sendNotification(u.getUserId(), message);
            }
            success = true;
        } else {
            int userId = Integer.parseInt(target);
            success = notifDAO.sendNotification(userId, message);
        }

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/publish-notification?msg=sent");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/publish-notification?msg=error");
        }
    }
}