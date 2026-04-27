<%@ page contentType="text/html;charset=UTF-8" %>
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
    <title>Apply Leave — JustLeave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .sidebar { min-height: 100vh; background: #1a73e8; color: white; width: 240px; position: fixed; top: 0; left: 0; padding: 24px 0; }
        .sidebar .brand { padding: 0 24px 24px; border-bottom: 1px solid rgba(255,255,255,0.15); }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 24px; display: flex; align-items: center; gap: 10px; transition: all 0.2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.15); color: white; }
        .main-content { margin-left: 240px; padding: 32px; }
        .form-card { border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 640px; }
        .form-card .card-header { background: #1a73e8; color: white; border-radius: 16px 16px 0 0; padding: 24px; }
        .form-control:focus { border-color: #1a73e8; box-shadow: 0 0 0 0.2rem rgba(26,115,232,0.15); }
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
        <a href="${pageContext.request.contextPath}/user/apply-leave" class="nav-link active">
            <i class="bi bi-plus-circle"></i> Apply Leave
        </a>
        <a href="${pageContext.request.contextPath}/user/notifications" class="nav-link">
            <i class="bi bi-bell"></i> Notifications
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link mt-4">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="card form-card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Apply for Leave</h5>
            <small class="opacity-75">Fill in the details below to submit your leave request</small>
        </div>
        <div class="card-body p-4">
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i><%= request.getAttribute("error") %>
            </div>
            <% } %>
            <form action="${pageContext.request.contextPath}/user/apply-leave" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Reason for Leave <span class="text-danger">*</span></label>
                    <select name="reason" class="form-select" required>
                        <option value="">-- Select Reason --</option>
                        <option value="Medical">Medical / Health</option>
                        <option value="Personal">Personal</option>
                        <option value="Sick">Sick Leave</option>
                        <option value="Vacation">Vacation</option>
                        <option value="Emergency">Family Emergency</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Start Date <span class="text-danger">*</span></label>
                        <input type="date" name="startDate" class="form-control" required
                               min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">End Date <span class="text-danger">*</span></label>
                        <input type="date" name="endDate" class="form-control" required
                               min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-semibold">Description</label>
                    <textarea name="description" class="form-control" rows="4"
                              placeholder="Provide additional details about your leave request..."></textarea>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-send me-2"></i>Submit Request
                    </button>
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-outline-secondary px-4">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const start = document.querySelector('[name="startDate"]');
    const end   = document.querySelector('[name="endDate"]');
    start.addEventListener('change', () => { end.min = start.value; });
</script>
</body>
</html>