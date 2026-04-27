<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JustLeave — Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-card { width: 100%; max-width: 420px; border-radius: 16px; border: none; box-shadow: 0 8px 32px rgba(0,0,0,0.10); }
        .login-header { background: #1a73e8; color: white; border-radius: 16px 16px 0 0; padding: 32px; text-align: center; }
        .login-header i { font-size: 48px; }
        .login-body { padding: 32px; }
        .btn-login { background: #1a73e8; border: none; width: 100%; padding: 12px; font-size: 16px; border-radius: 8px; }
        .btn-login:hover { background: #1557b0; }
        .form-control:focus { border-color: #1a73e8; box-shadow: 0 0 0 0.2rem rgba(26,115,232,0.15); }
    </style>
</head>
<body>
<div class="login-card card">
    <div class="login-header">
        <i class="bi bi-calendar-check"></i>
        <h3 class="mt-2 mb-0">JustLeave</h3>
        <p class="mb-0 opacity-75">Leave Management System</p>
    </div>
    <div class="login-body">
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i><%= request.getAttribute("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>You have been logged out successfully.
        </div>
        <% } %>
        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="mb-3">
                <label class="form-label fw-semibold">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-login text-white">
                <i class="bi bi-box-arrow-in-right me-2"></i>Login
            </button>
        </form>
        <hr class="my-3">
        <small class="text-muted d-block text-center">
            Admin: admin@leave.com / admin123<br>
            User: john@leave.com / user123
        </small>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>