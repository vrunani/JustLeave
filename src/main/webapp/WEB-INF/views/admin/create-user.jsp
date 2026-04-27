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
    <title>Create User — JustLeave</title>
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
        <a href="${pageContext.request.contextPath}/admin/create-user" class="nav-link active">
            <i class="bi bi-person-plus"></i> Create User
        </a>
        <a href="${pageContext.request.contextPath}/admin/publish-notification" class="nav-link">
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
            <h5 class="mb-0"><i class="bi bi-person-plus me-2"></i>Create New User</h5>
            <small class="opacity-75">Add a new employee or admin to the system</small>
        </div>
        <div class="card-body p-4">

            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i>User created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i><%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/create-user" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" name="name" class="form-control"
                               placeholder="Enter full name" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" name="email" class="form-control"
                               placeholder="Enter email address" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" name="password" class="form-control"
                               placeholder="Set password" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
                    <select name="role" class="form-select" id="roleSelect" required
                            onchange="toggleLeaves(this.value)">
                        <option value="">-- Select Role --</option>
                        <option value="user">Employee (User)</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div class="mb-4" id="leavesField">
                    <label class="form-label fw-semibold">Total Annual Leaves</label>
                    <input type="number" name="totalLeaves" class="form-control"
                           value="20" min="0" max="365">
                    <div class="form-text">Default is 20 days per year.</div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-person-plus me-2"></i>Create User
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
    function toggleLeaves(role) {
        document.getElementById('leavesField').style.display =
            role === 'admin' ? 'none' : 'block';
    }
</script>
</body>
</html>