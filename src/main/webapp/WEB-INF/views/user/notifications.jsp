<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Notifications — JustLeave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .sidebar { min-height: 100vh; background: #1a73e8; color: white; width: 240px; position: fixed; top: 0; left: 0; padding: 24px 0; }
        .sidebar .brand { padding: 0 24px 24px; border-bottom: 1px solid rgba(255,255,255,0.15); }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 24px; display: flex; align-items: center; gap: 10px; transition: all 0.2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.15); color: white; }
        .main-content { margin-left: 240px; padding: 32px; }
        .notif-card { border-radius: 12px; border: none; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        .notif-item { padding: 16px 20px; border-bottom: 1px solid #f0f0f0; display: flex; align-items: flex-start; gap: 14px; }
        .notif-item:last-child { border-bottom: none; }
        .notif-icon { width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 18px; }
        .notif-icon.approved  { background: #d1e7dd; color: #0a3622; }
        .notif-icon.rejected  { background: #f8d7da; color: #58151c; }
        .notif-icon.info      { background: #cfe2ff; color: #084298; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">
        <i class="bi bi-calendar-check fs-4"></i>
        <span class="fw-bold ms-2 fs-5">JustLeave</span>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/user/apply-leave" class="nav-link">
            <i class="bi bi-plus-circle"></i> Apply Leave
        </a>
        <a href="${pageContext.request.contextPath}/user/notifications" class="nav-link active">
            <i class="bi bi-bell"></i> Notifications
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link mt-4">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <h5 class="fw-bold mb-4"><i class="bi bi-bell me-2"></i>Notifications</h5>
    <div class="card notif-card">
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="text-center py-5 text-muted">
                    <i class="bi bi-bell-slash fs-1"></i>
                    <p class="mt-3">No notifications yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${notifications}">
                <div class="notif-item">
                    <div class="notif-icon
                        <c:choose>
                            <c:when test="${n.message.contains('approved')}">approved</c:when>
                            <c:when test="${n.message.contains('rejected')}">rejected</c:when>
                            <c:otherwise>info</c:otherwise>
                        </c:choose>">
                        <c:choose>
                            <c:when test="${n.message.contains('approved')}"><i class="bi bi-check-circle"></i></c:when>
                            <c:when test="${n.message.contains('rejected')}"><i class="bi bi-x-circle"></i></c:when>
                            <c:otherwise><i class="bi bi-info-circle"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="flex-grow-1">
                        <p class="mb-1">${n.message}</p>
                        <small class="text-muted">
                            <fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                        </small>
                    </div>
                </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>