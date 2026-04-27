<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Send Notification — JustLeave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .sidebar { min-height: 100vh; background: #1a1a2e; color: white; width: 240px; position: fixed; top: 0; left: 0; padding: 24px 0; }
        .sidebar .brand { padding: 0 24px 24px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar .nav-link { color: rgba(255,255,255,0.75); padding: 12px 24px; display: flex; align-items: center; gap: 10px; transition: all 0.2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.1); color: white; }
        .main-content { margin-left: 240px; padding: 32px; }
        .form-card { border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 600px; }
        .form-card .card-header { background: #1a1a2e; color: white; border-radius: 16px 16px 0 0; padding: 24px; }
        .form-control:focus, .form-select:focus { border-color: #1a73e8; box-shadow: 0 0 0 0.2rem rgba(26,115,232,0.15); }
        .quick-btn { cursor: pointer; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">
        <i class="bi bi-calendar-check fs-4"></i>
        <span class="fw-bold ms-2 fs-5">JustLeave</span>
        <div><small class="opacity-50">Admin Panel</small></div>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/create-user" class="nav-link">
            <i class="bi bi-person-plus"></i> Create User
        </a>
        <a href="${pageContext.request.contextPath}/admin/publish-notification" class="nav-link active">
            <i class="bi bi-megaphone"></i> Send Notification
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link mt-4">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="card form-card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-megaphone me-2"></i>Send Notification</h5>
            <small class="opacity-75">Send announcements or alerts to users</small>
        </div>
        <div class="card-body p-4">

            <c:if test="${param.msg == 'sent'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i>Notification sent successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'error'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-triangle me-2"></i>Failed to send notification.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/publish-notification" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Send To <span class="text-danger">*</span></label>
                    <select name="target" class="form-select" required>
                        <option value="all">-- All Users --</option>
                        <c:forEach var="user" items="${users}">
                            <option value="${user.userId}">${user.name} (${user.email})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Quick Templates</label>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="badge bg-light text-dark border quick-btn px-3 py-2"
                              onclick="setMsg('Office will remain closed tomorrow due to a public holiday.')">
                            Holiday Notice
                        </span>
                        <span class="badge bg-light text-dark border quick-btn px-3 py-2"
                              onclick="setMsg('Reminder: Please submit your pending leave applications.')">
                            Leave Reminder
                        </span>
                        <span class="badge bg-light text-dark border quick-btn px-3 py-2"
                              onclick="setMsg('Today\'s scheduled lecture/meeting has been cancelled.')">
                            Session Cancelled
                        </span>
                        <span class="badge bg-light text-dark border quick-btn px-3 py-2"
                              onclick="setMsg('Please complete your attendance for this month.')">
                            Attendance Alert
                        </span>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Message <span class="text-danger">*</span></label>
                    <textarea name="message" id="msgBox" class="form-control" rows="4"
                              placeholder="Type your notification message here..." required></textarea>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-send me-2"></i>Send Notification
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="btn btn-outline-secondary px-4">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function setMsg(text) {
        document.getElementById('msgBox').value = text;
    }
</script>
</body>
</html>