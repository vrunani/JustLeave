<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Page Not Found — JustLeave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body>
<div class="text-center">
    <i class="bi bi-exclamation-triangle text-warning" style="font-size: 80px;"></i>
    <h1 class="display-4 fw-bold mt-3">404</h1>
    <p class="text-muted fs-5">Oops! The page you're looking for doesn't exist.</p>
    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary mt-2">
        <i class="bi bi-house me-2"></i>Go to Login
    </a>
</div>
</body>
</html>