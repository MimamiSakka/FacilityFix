<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="reports" scope="request"/>
        <%@ include file="../includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="Reports" scope="request"/>
            <%@ include file="../includes/header.jsp" %>

            <div class="page-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Reports & Analytics</h1>
                        <p class="page-subtitle">Overview of system performance and ticket statistics</p>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid" style="margin-bottom: var(--spacing-6);">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary), var(--primary-dark));">
                            <i class="bi bi-ticket"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${totalTickets}</div>
                            <div class="stat-label">Total Tickets</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <i class="bi bi-exclamation-circle"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${openTickets}</div>
                            <div class="stat-label">Open</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${inProgressTickets}</div>
                            <div class="stat-label">In Progress</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                            <i class="bi bi-check-circle"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${resolvedTickets + verifiedTickets}</div>
                            <div class="stat-label">Completed</div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: var(--spacing-6); margin-bottom: var(--spacing-6);">
                    <!-- Status Distribution -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Ticket Status Distribution</h3>
                        </div>
                        <div class="card-body" style="display: flex; justify-content: center; padding: var(--spacing-6);">
                            <div style="width: 280px; height: 280px;">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Priority Distribution -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Ticket Priority Distribution</h3>
                        </div>
                        <div class="card-body" style="display: flex; justify-content: center; padding: var(--spacing-6);">
                            <div style="width: 280px; height: 280px;">
                                <canvas id="priorityChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Category Breakdown -->
                <div class="card" style="margin-bottom: var(--spacing-6);">
                    <div class="card-header">
                        <h3 class="card-title">Tickets by Category</h3>
                    </div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: var(--spacing-4);">
                            <c:forEach items="${byCategory}" var="entry">
                                <div style="padding: var(--spacing-4); background: var(--gray-50); border-radius: var(--radius-lg); text-align: center;">
                                    <div style="font-size: var(--font-size-2xl); font-weight: 700; color: var(--primary);">${entry.value}</div>
                                    <div style="font-size: var(--font-size-sm); color: var(--gray-600); text-transform: capitalize;">${entry.key.toString().toLowerCase().replace('_', ' ')}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Staff Performance -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Staff Overview</h3>
                    </div>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Staff Member</th>
                                    <th>Department</th>
                                    <th>Assigned Tickets</th>
                                    <th>Open</th>
                                    <th>In Progress</th>
                                    <th>Resolved</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${staff}" var="s">
                                    <c:set var="assignedCount" value="0"/>
                                    <c:set var="staffOpen" value="0"/>
                                    <c:set var="staffProgress" value="0"/>
                                    <c:set var="staffResolved" value="0"/>
                                    <c:forEach items="${allTickets}" var="t">
                                        <c:if test="${t.assignedTo != null && t.assignedTo.id == s.id}">
                                            <c:set var="assignedCount" value="${assignedCount + 1}"/>
                                            <c:if test="${t.status == 'OPEN'}"><c:set var="staffOpen" value="${staffOpen + 1}"/></c:if>
                                            <c:if test="${t.status == 'IN_PROGRESS'}"><c:set var="staffProgress" value="${staffProgress + 1}"/></c:if>
                                            <c:if test="${t.status == 'RESOLVED' || t.status == 'VERIFIED'}"><c:set var="staffResolved" value="${staffResolved + 1}"/></c:if>
                                        </c:if>
                                    </c:forEach>
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: var(--spacing-3);">
                                                <div class="avatar avatar-sm">${s.fullName.substring(0,1)}</div>
                                                <span style="font-weight: 500;">${s.fullName}</span>
                                            </div>
                                        </td>
                                        <td style="color: var(--gray-600);">${s.department != null ? s.department : '-'}</td>
                                        <td><span class="badge badge-secondary">${assignedCount}</span></td>
                                        <td><span class="badge" style="background: #fef3c7; color: #92400e;">${staffOpen}</span></td>
                                        <td><span class="badge" style="background: #dbeafe; color: #1e40af;">${staffProgress}</span></td>
                                        <td><span class="badge" style="background: #d1fae5; color: #065f46;">${staffResolved}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty staff}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--gray-500); padding: var(--spacing-8);">
                                            No staff members found.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Status Chart
        new Chart(document.getElementById('statusChart'), {
            type: 'doughnut',
            data: {
                labels: ['Open', 'In Progress', 'Resolved', 'Verified'],
                datasets: [{
                    data: [${openTickets}, ${inProgressTickets}, ${resolvedTickets}, ${verifiedTickets}],
                    backgroundColor: ['#f59e0b', '#3b82f6', '#10b981', '#6366f1'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true }
                    }
                },
                cutout: '60%'
            }
        });

        // Priority Chart
        new Chart(document.getElementById('priorityChart'), {
            type: 'doughnut',
            data: {
                labels: ['Critical', 'High', 'Medium', 'Low'],
                datasets: [{
                    data: [
                        ${byPriority.getOrDefault('CRITICAL', 0)},
                        ${byPriority.getOrDefault('HIGH', 0)},
                        ${byPriority.getOrDefault('MEDIUM', 0)},
                        ${byPriority.getOrDefault('LOW', 0)}
                    ],
                    backgroundColor: ['#dc2626', '#f97316', '#eab308', '#22c55e'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true }
                    }
                },
                cutout: '60%'
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
