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
    <title>User Dashboard — JustLeave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .sidebar { min-height: 100vh; background: #1a73e8; color: white; width: 240px; position: fixed; top: 0; left: 0; padding: 24px 0; }
        .sidebar .brand { padding: 0 24px 24px; border-bottom: 1px solid rgba(255,255,255,0.15); }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 24px; display: flex; align-items: center; gap: 10px; border-radius: 0; transition: all 0.2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.15); color: white; }
        .main-content { margin-left: 240px; padding: 32px; }
        .stat-card { border-radius: 12px; border: none; padding: 24px; color: white; }
        .stat-card.available { background: #1a73e8; }
        .stat-card.approved  { background: #0f9d58; }
        .stat-card.pending   { background: #f4b400; }
        .stat-card.rejected  { background: #db4437; }
        .stat-card i { font-size: 36px; opacity: 0.8; }
        .stat-card .number { font-size: 36px; font-weight: 700; }
        .table-card { border-radius: 12px; border: none; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        .badge-pending  { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d1e7dd; color: #0a3622; }
        .badge-rejected { background: #f8d7da; color: #58151c; }
        .badge-cancelled{ background: #e2e3e5; color: #41464b; }
        .topbar { background: white; border-radius: 12px; padding: 16px 24px; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="brand">
        <i class="bi bi-calendar-check fs-4"></i>
        <span class="fw-bold ms-2 fs-5">JustLeave</span>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link active">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/user/apply-leave" class="nav-link">
            <i class="bi bi-plus-circle"></i> Apply Leave
        </a>
        <a href="${pageContext.request.contextPath}/user/notifications" class="nav-link">
            <i class="bi bi-bell"></i> Notifications
            <c:if test="${unreadNotif > 0}">
                <span class="badge bg-danger ms-auto">${unreadNotif}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link mt-4">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </nav>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="topbar">
        <div>
            <h5 class="mb-0 fw-bold">Welcome, ${sessionScope.loggedUser.name}</h5>
            <small class="text-muted">Employee Dashboard</small>
        </div>
        <a href="${pageContext.request.contextPath}/user/apply-leave" class="btn btn-primary">
            <i class="bi bi-plus-circle me-2"></i>Apply Leave
        </a>
    </div>

    <c:if test="${param.msg == 'applied'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle me-2"></i>Leave applied successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card available">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="number">${availableLeaves}</div>
                        <div>Available Leaves</div>
                    </div>
                    <i class="bi bi-calendar-heart"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card approved">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="number">${approved}</div>
                        <div>Approved</div>
                    </div>
                    <i class="bi bi-check-circle"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card pending">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="number">${pending}</div>
                        <div>Pending</div>
                    </div>
                    <i class="bi bi-clock"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card rejected">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="number">${rejected}</div>
                        <div>Rejected</div>
                    </div>
                    <i class="bi bi-x-circle"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Leave History Table -->
    <div class="card table-card">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h6 class="mb-0 fw-bold">My Leave History</h6>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">#</th>
                        <th>Reason</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Applied On</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty leaves}">
                        <tr><td colspan="7" class="text-center py-4 text-muted">No leave requests found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="leave" items="${leaves}" varStatus="i">
                        <tr>
                            <td class="ps-4">${i.count}</td>
                            <td>${leave.reason}</td>
                            <td><fmt:formatDate value="${leave.startDate}" pattern="dd MMM yyyy"/></td>
                            <td><fmt:formatDate value="${leave.endDate}" pattern="dd MMM yyyy"/></td>
                            <td><fmt:formatDate value="${leave.appliedAt}" pattern="dd MMM yyyy"/></td>
                            <td>
                                <span class="badge badge-${leave.status} px-3 py-2 rounded-pill">
                                    ${leave.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${leave.status == 'pending'}">
                                    <form action="${pageContext.request.contextPath}/user/cancel-leave" method="post" style="display:inline">
                                        <input type="hidden" name="leaveId" value="${leave.leaveId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                            onclick="return confirm('Cancel this leave request?')">
                                            Cancel
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${leave.status != 'pending'}">
                                    <span class="text-muted small">—</span>
                                </c:if>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>