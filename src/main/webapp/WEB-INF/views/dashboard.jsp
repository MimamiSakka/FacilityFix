<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="dashboard" scope="request"/>
        <%@ include file="includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="Dashboard" scope="request"/>
            <%@ include file="includes/header.jsp" %>

            <div class="page-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Dashboard</h1>
                        <p class="page-subtitle">Welcome back, ${user.fullName}! Here's what's happening today.</p>
                    </div>
                    <!-- Only Admin and User can create tickets, not Staff -->
                    <c:if test="${user.role != 'STAFF'}">
                        <a href="/tickets/new" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i>
                            New Ticket
                        </a>
                    </c:if>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon info">
                            <i class="bi bi-inbox"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value" data-count="${openCount}">${openCount}</div>
                            <div class="stat-label">Open Tickets</div>
                            <div class="stat-change positive">
                                <i class="bi bi-arrow-up"></i> Active
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon warning">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value" data-count="${inProgressCount}">${inProgressCount}</div>
                            <div class="stat-label">In Progress</div>
                            <div class="stat-change positive">
                                <i class="bi bi-arrow-up"></i> Being worked on
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon success">
                            <i class="bi bi-check-circle"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value" data-count="${resolvedCount}">${resolvedCount}</div>
                            <div class="stat-label">Resolved</div>
                            <div class="stat-change positive">
                                <i class="bi bi-check2"></i> Completed
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon primary">
                            <i class="bi bi-patch-check"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value" data-count="${verifiedCount}">${verifiedCount}</div>
                            <div class="stat-label">Verified</div>
                            <div class="stat-change positive">
                                <i class="bi bi-shield-check"></i> Confirmed
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Grid -->
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: var(--spacing-6);">
                    <!-- Tickets Table -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">All Tickets</c:when>
                                    <c:when test="${user.role == 'STAFF'}">My Assigned Tickets</c:when>
                                    <c:otherwise>My Tickets</c:otherwise>
                                </c:choose>
                            </h3>
                            <a href="/tickets" class="btn btn-ghost btn-sm">View All</a>
                        </div>
                        <div class="card-body" style="padding: 0;">
                            <c:choose>
                                <c:when test="${not empty tickets}">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Ticket</th>
                                                <th>Category</th>
                                                <th>Priority</th>
                                                <th>Status</th>
                                                <th>Created</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${tickets}" var="ticket" end="6">
                                                <tr onclick="window.location='/tickets/${ticket.id}'" style="cursor: pointer;">
                                                    <td>
                                                        <div style="font-weight: 500; color: var(--gray-900);">${ticket.title}</div>
                                                        <div style="font-size: var(--font-size-xs); color: var(--gray-500);">#${ticket.id}</div>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-secondary">${ticket.category}</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge priority-${ticket.priority.toString().toLowerCase()}">${ticket.priority}</span>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-${ticket.status.toString().toLowerCase().replace('_', '-')}">${ticket.status.toString().replace('_', ' ')}</span>
                                                    </td>
                                                    <td style="color: var(--gray-500); font-size: var(--font-size-sm);">
                                                        ${ticket.createdAt.monthValue}/${ticket.createdAt.dayOfMonth} ${ticket.createdAt.hour}:${ticket.createdAt.minute < 10 ? '0' : ''}${ticket.createdAt.minute}
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state" style="padding: var(--spacing-12);">
                                        <div class="empty-state-icon">
                                            <i class="bi bi-ticket"></i>
                                        </div>
                                        <div class="empty-state-title">No tickets yet</div>
                                        <div class="empty-state-text">Create your first maintenance ticket to get started.</div>
                                        <a href="/tickets/new" class="btn btn-primary">
                                            <i class="bi bi-plus-lg"></i>
                                            Create Ticket
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-6);">
                        <!-- Status Distribution Chart -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Status Overview</h3>
                            </div>
                            <div class="card-body">
                                <canvas id="statusChart" height="200"></canvas>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Quick Actions</h3>
                            </div>
                            <div class="card-body" style="display: flex; flex-direction: column; gap: var(--spacing-3);">
                                <!-- Only Admin and User can create tickets, not Staff -->
                                <c:if test="${user.role != 'STAFF'}">
                                    <a href="/tickets/new" class="btn btn-outline-primary" style="justify-content: flex-start;">
                                        <i class="bi bi-plus-circle"></i>
                                        Create New Ticket
                                    </a>
                                </c:if>
                                <a href="/tickets?status=OPEN" class="btn btn-outline-primary" style="justify-content: flex-start;">
                                    <i class="bi bi-inbox"></i>
                                    View Open Tickets
                                </a>
                                <c:if test="${user.role == 'STAFF' || user.role == 'ADMIN'}">
                                    <a href="/tickets?assigned=me" class="btn btn-outline-primary" style="justify-content: flex-start;">
                                        <i class="bi bi-person-badge"></i>
                                        My Assigned Tickets
                                    </a>
                                    <a href="/tickets?status=IN_PROGRESS" class="btn btn-outline-primary" style="justify-content: flex-start;">
                                        <i class="bi bi-clock-history"></i>
                                        In Progress Tickets
                                    </a>
                                </c:if>
                                <c:if test="${user.role == 'ADMIN'}">
                                    <a href="/admin/users" class="btn btn-outline-primary" style="justify-content: flex-start;">
                                        <i class="bi bi-people"></i>
                                        Manage Users
                                    </a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Tips Card -->
                        <div class="card" style="background: linear-gradient(135deg, var(--primary-50) 0%, var(--primary-100) 100%); border: 1px solid var(--primary-200);">
                            <div class="card-body">
                                <div style="display: flex; align-items: flex-start; gap: var(--spacing-3);">
                                    <div style="width: 40px; height: 40px; background: var(--primary-500); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center; color: white; flex-shrink: 0;">
                                        <i class="bi bi-lightbulb"></i>
                                    </div>
                                    <div>
                                        <h4 style="font-size: var(--font-size-sm); font-weight: 600; color: var(--gray-900); margin-bottom: var(--spacing-1);">Pro Tip</h4>
                                        <p style="font-size: var(--font-size-sm); color: var(--gray-600); margin: 0;">Add detailed descriptions and location info to your tickets for faster resolution times.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        // Status Distribution Chart
        const ctx = document.getElementById('statusChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Open', 'In Progress', 'Resolved', 'Verified'],
                datasets: [{
                    data: [${openCount}, ${inProgressCount}, ${resolvedCount}, ${verifiedCount}],
                    backgroundColor: [
                        '#3B82F6',
                        '#F59E0B',
                        '#10B981',
                        '#6B7280'
                    ],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 16,
                            usePointStyle: true,
                            font: {
                                size: 12,
                                family: "'Inter', sans-serif"
                            }
                        }
                    }
                },
                cutout: '65%'
            }
        });
    </script>
</body>
</html>
