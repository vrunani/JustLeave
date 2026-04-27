<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    <title>Admin Dashboard — JustLeave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .sidebar { min-height: 100vh; background: #1a1a2e; color: white; width: 240px; position: fixed; top: 0; left: 0; padding: 24px 0; }
        .sidebar .brand { padding: 0 24px 24px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar .nav-link { color: rgba(255,255,255,0.75); padding: 12px 24px; display: flex; align-items: center; gap: 10px; transition: all 0.2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.1); color: white; }
        .main-content { margin-left: 240px; padding: 32px; }
        .stat-card { border-radius: 12px; border: none; padding: 24px; color: white; }
        .stat-card.pending  { background: #f4b400; }
        .stat-card.approved { background: #0f9d58; }
        .stat-card.rejected { background: #db4437; }
        .stat-card.users    { background: #1a73e8; }
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

<!-- Admin Sidebar -->
<div class="sidebar">
    <div class="brand">
        <i class="bi bi-calendar-check fs-4"></i>
        <span class="fw-bold ms-2 fs-5">JustLeave</span>
        <div><small class="opacity-50">Admin Panel</small></div>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/create-user" class="nav-link">
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

<!-- Main Content -->
<div class="main-content">
    <div class="topbar">
        <div>
            <h5 class="mb-0 fw-bold">Admin Dashboard</h5>
            <small class="text-muted">Manage all leave requests</small>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/create-user" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-person-plus me-1"></i>Create User
            </a>
            <a href="${pageContext.request.contextPath}/admin/publish-notification" class="btn btn-primary btn-sm">
                <i class="bi bi-megaphone me-1"></i>Send Notification
            </a>
        </div>
    </div>

    <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle me-2"></i>Leave status updated and user notified!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card pending">
                <div class="d-flex justify-content-between align-items-center">
                    <div><div class="number">${pendingCount}</div><div>Pending</div></div>
                    <i class="bi bi-clock"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card approved">
                <div class="d-flex justify-content-between align-items-center">
                    <div><div class="number">${approvedCount}</div><div>Approved</div></div>
                    <i class="bi bi-check-circle"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card rejected">
                <div class="d-flex justify-content-between align-items-center">
                    <div><div class="number">${rejectedCount}</div><div>Rejected</div></div>
                    <i class="bi bi-x-circle"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card users">
                <div class="d-flex justify-content-between align-items-center">
                    <div><div class="number">${allUsers.size()}</div><div>Total Users</div></div>
                    <i class="bi bi-people"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- All Leave Requests -->
    <div class="card table-card">
        <div class="card-header bg-white py-3">
            <h6 class="mb-0 fw-bold">All Leave Requests</h6>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">#</th>
                        <th>Employee</th>
                        <th>Reason</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty allLeaves}">
                        <tr><td colspan="7" class="text-center py-4 text-muted">No leave requests found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="leave" items="${allLeaves}" varStatus="i">
                        <tr>
                            <td class="ps-4">${i.count}</td>
                            <td><i class="bi bi-person-circle me-1 text-muted"></i>${leave.userName}</td>
                            <td>${leave.reason}</td>
                            <td><fmt:formatDate value="${leave.startDate}" pattern="dd MMM yyyy"/></td>
                            <td><fmt:formatDate value="${leave.endDate}" pattern="dd MMM yyyy"/></td>
                            <td>
                                <span class="badge badge-${leave.status} px-3 py-2 rounded-pill">
                                    ${leave.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${leave.status == 'pending'}">
                                    <form action="${pageContext.request.contextPath}/admin/update-leave" method="post" style="display:inline">
                                        <input type="hidden" name="leaveId" value="${leave.leaveId}">
                                        <input type="hidden" name="userId"  value="${leave.userId}">
                                        <input type="hidden" name="status"  value="approved">
                                        <button type="submit" class="btn btn-sm btn-success me-1"
                                            onclick="return confirm('Approve this leave?')">
                                            <i class="bi bi-check"></i> Approve
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/update-leave" method="post" style="display:inline">
                                        <input type="hidden" name="leaveId" value="${leave.leaveId}">
                                        <input type="hidden" name="userId"  value="${leave.userId}">
                                        <input type="hidden" name="status"  value="rejected">
                                        <button type="submit" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Reject this leave?')">
                                            <i class="bi bi-x"></i> Reject
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