<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isMyAssigned ? 'My Assigned Tickets' : 'Tickets'} - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="${isMyAssigned ? 'my-tickets' : 'tickets'}" scope="request"/>
        <%@ include file="includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="${isMyAssigned ? 'My Assigned Tickets' : 'Tickets'}" scope="request"/>
            <%@ include file="includes/header.jsp" %>

            <div class="page-content">
                <!-- Success Message Toast -->
                <c:if test="${not empty success}">
                    <div class="toast-container">
                        <div class="toast show" data-autohide="true">
                            <div class="toast-icon success">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                            <div class="toast-content">
                                <div class="toast-title">Success</div>
                                <div class="toast-message">${success}</div>
                            </div>
                            <button class="toast-close" onclick="this.closest('.toast').remove()">
                                <i class="bi bi-x"></i>
                            </button>
                        </div>
                    </div>
                </c:if>

                <!-- Page Header -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">
                            <c:choose>
                                <c:when test="${isMyAssigned}">My Assigned Tickets</c:when>
                                <c:otherwise>Tickets</c:otherwise>
                            </c:choose>
                        </h1>
                        <p class="page-subtitle">
                            <c:choose>
                                <c:when test="${isMyAssigned}">Tickets assigned to you for resolution</c:when>
                                <c:otherwise>Manage and track all maintenance requests</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <!-- Only Admin and User can create tickets, not Staff -->
                    <c:if test="${user.role != 'STAFF'}">
                        <a href="/tickets/new" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i>
                            New Ticket
                        </a>
                    </c:if>
                </div>

                <!-- Filters & Search Bar -->
                <div class="card" style="margin-bottom: var(--spacing-6);">
                    <div class="card-body" style="padding: var(--spacing-4);">
                        <form method="get" action="/tickets" style="display: flex; gap: var(--spacing-4); flex-wrap: wrap; align-items: center;">
                            <!-- Preserve assigned=me if set -->
                            <c:if test="${isMyAssigned}">
                                <input type="hidden" name="assigned" value="me"/>
                            </c:if>
                            
                            <!-- Search -->
                            <div class="search-box" style="flex: 1; min-width: 200px;">
                                <i class="bi bi-search"></i>
                                <input type="text" name="search" placeholder="Search tickets..." value="${param.search}" 
                                       style="border: none; padding: var(--spacing-2) var(--spacing-2) var(--spacing-2) var(--spacing-8); width: 100%;">
                            </div>
                            
                            <!-- Status Filter -->
                            <div class="form-group" style="margin: 0; min-width: 150px;">
                                <select name="status" class="form-select" onchange="this.form.submit()">
                                    <option value="">All Statuses</option>
                                    <option value="OPEN" ${param.status == 'OPEN' ? 'selected' : ''}>Open</option>
                                    <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                    <option value="RESOLVED" ${param.status == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                                    <option value="VERIFIED" ${param.status == 'VERIFIED' ? 'selected' : ''}>Verified</option>
                                </select>
                            </div>
                            
                            <!-- Priority Filter -->
                            <div class="form-group" style="margin: 0; min-width: 150px;">
                                <select name="priority" class="form-select" onchange="this.form.submit()">
                                    <option value="">All Priorities</option>
                                    <option value="CRITICAL" ${param.priority == 'CRITICAL' ? 'selected' : ''}>Critical</option>
                                    <option value="HIGH" ${param.priority == 'HIGH' ? 'selected' : ''}>High</option>
                                    <option value="MEDIUM" ${param.priority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                                    <option value="LOW" ${param.priority == 'LOW' ? 'selected' : ''}>Low</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn btn-secondary">
                                <i class="bi bi-funnel"></i>
                                Filter
                            </button>
                            
                            <c:if test="${not empty param.status || not empty param.priority || not empty param.search}">
                                <a href="/tickets${isMyAssigned ? '?assigned=me' : ''}" class="btn btn-ghost">
                                    <i class="bi bi-x-circle"></i>
                                    Clear
                                </a>
                            </c:if>
                        </form>
                    </div>
                </div>

                <!-- Tickets Table -->
                <div class="card">
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty tickets}">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%;">#</th>
                                            <th style="width: 25%;">Ticket</th>
                                            <th style="width: 12%;">Category</th>
                                            <th style="width: 10%;">Priority</th>
                                            <th style="width: 12%;">Status</th>
                                            <th style="width: 12%;">Location</th>
                                            <th style="width: 12%;">Assigned To</th>
                                            <th style="width: 12%;">Created</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ticket" items="${tickets}">
                                            <tr onclick="window.location='/tickets/${ticket.id}'" style="cursor: pointer;">
                                                <td>
                                                    <span style="color: var(--gray-400);">${ticket.id}</span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 500; color: var(--gray-900); margin-bottom: 2px;">${ticket.title}</div>
                                                    <div style="font-size: var(--font-size-xs); color: var(--gray-500); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 250px;">
                                                        ${ticket.description}
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge badge-secondary">
                                                        <c:choose>
                                                            <c:when test="${ticket.category == 'ELECTRICAL'}"><i class="bi bi-lightning"></i></c:when>
                                                            <c:when test="${ticket.category == 'PLUMBING'}"><i class="bi bi-droplet"></i></c:when>
                                                            <c:when test="${ticket.category == 'HVAC'}"><i class="bi bi-thermometer-half"></i></c:when>
                                                            <c:when test="${ticket.category == 'CLEANING'}"><i class="bi bi-stars"></i></c:when>
                                                            <c:otherwise><i class="bi bi-tools"></i></c:otherwise>
                                                        </c:choose>
                                                        ${ticket.category}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge priority-${ticket.priority.toString().toLowerCase()}">${ticket.priority}</span>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${ticket.status.toString().toLowerCase().replace('_', '-')}">${ticket.status.toString().replace('_', ' ')}</span>
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: var(--spacing-1);">
                                                        <i class="bi bi-geo-alt" style="color: var(--gray-400);"></i>
                                                        <span style="color: var(--gray-600); font-size: var(--font-size-sm);">${ticket.location}</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ticket.assignedTo != null}">
                                                            <div style="display: flex; align-items: center; gap: var(--spacing-2);">
                                                                <div class="avatar avatar-sm" style="width: 24px; height: 24px; font-size: 10px;">
                                                                    ${ticket.assignedTo.fullName.substring(0,1)}
                                                                </div>
                                                                <span style="color: var(--gray-700); font-size: var(--font-size-sm);">${ticket.assignedTo.fullName}</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--gray-400); font-size: var(--font-size-sm); font-style: italic;">Unassigned</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="color: var(--gray-500); font-size: var(--font-size-sm);">
                                                    ${ticket.createdAt.monthValue}/${ticket.createdAt.dayOfMonth}/${ticket.createdAt.year}
                                                    <div style="font-size: var(--font-size-xs); color: var(--gray-400);">
                                                        ${ticket.createdAt.hour}:${ticket.createdAt.minute < 10 ? '0' : ''}${ticket.createdAt.minute}
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: var(--spacing-16);">
                                    <div class="empty-state-icon">
                                        <i class="bi bi-inbox"></i>
                                    </div>
                                    <div class="empty-state-title">No tickets found</div>
                                    <div class="empty-state-text">
                                        <c:choose>
                                            <c:when test="${not empty param.status || not empty param.priority || not empty param.search}">
                                                No tickets match your current filters. Try adjusting your search criteria.
                                            </c:when>
                                            <c:otherwise>
                                                No maintenance tickets have been created yet. Get started by creating your first ticket.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="display: flex; gap: var(--spacing-3); margin-top: var(--spacing-4);">
                                        <c:if test="${not empty param.status || not empty param.priority || not empty param.search}">
                                            <a href="/tickets" class="btn btn-secondary">Clear Filters</a>
                                        </c:if>
                                        <a href="/tickets/new" class="btn btn-primary">
                                            <i class="bi bi-plus-lg"></i>
                                            Create Ticket
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Results Count -->
                <c:if test="${not empty tickets}">
                    <div style="margin-top: var(--spacing-4); text-align: center; color: var(--gray-500); font-size: var(--font-size-sm);">
                        Showing <strong>${tickets.size()}</strong> ticket<c:if test="${tickets.size() != 1}">s</c:if>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        // Auto-hide success toast after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const toasts = document.querySelectorAll('.toast[data-autohide="true"]');
            toasts.forEach(toast => {
                setTimeout(() => {
                    toast.style.animation = 'slideOut 0.3s ease forwards';
                    setTimeout(() => toast.remove(), 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>
