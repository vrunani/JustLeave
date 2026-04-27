package com.leavemanagement.servlet;

import com.leavemanagement.dao.NotificationDAO;
import com.leavemanagement.model.Notification;
import com.leavemanagement.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/notifications")
public class NotificationServlet extends HttpServlet {

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

        List<Notification> notifications = notifDAO.getNotificationsByUser(userId);
        notifDAO.markAllRead(userId);

        req.setAttribute("notifications", notifications);
        req.getRequestDispatcher("/WEB-INF/views/user/notifications.jsp").forward(req, resp);
    }
}