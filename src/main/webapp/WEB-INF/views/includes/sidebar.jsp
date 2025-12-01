<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Sidebar Navigation -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="/dashboard" class="sidebar-brand">
            <i class="bi bi-tools"></i>
            <span>FacilityFix</span>
        </a>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-section-title">Main Menu</div>
            <a href="/dashboard" class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2"></i>
                <span>Dashboard</span>
            </a>
            <a href="/tickets" class="nav-item ${activePage == 'tickets' ? 'active' : ''}">
                <i class="bi bi-ticket-detailed"></i>
                <span>All Tickets</span>
                <c:if test="${openTicketsCount != null && openTicketsCount > 0}">
                    <span class="nav-badge">${openTicketsCount}</span>
                </c:if>
            </a>
            <!-- Only Admin and User can create tickets, not Staff -->
            <sec:authorize access="hasRole('ADMIN') or hasRole('USER')">
                <a href="/tickets/new" class="nav-item ${activePage == 'new-ticket' ? 'active' : ''}">
                    <i class="bi bi-plus-circle"></i>
                    <span>Create Ticket</span>
                </a>
            </sec:authorize>
        </div>

        <sec:authorize access="hasAnyRole('STAFF', 'ADMIN')">
            <div class="nav-section">
                <div class="nav-section-title">Staff</div>
                <a href="/tickets?assigned=me" class="nav-item ${activePage == 'my-tickets' ? 'active' : ''}">
                    <i class="bi bi-person-badge"></i>
                    <span>My Assigned</span>
                </a>
                <a href="/tickets?status=OPEN" class="nav-item">
                    <i class="bi bi-inbox"></i>
                    <span>Open Tickets</span>
                </a>
            </div>
        </sec:authorize>

        <sec:authorize access="hasRole('ADMIN')">
            <div class="nav-section">
                <div class="nav-section-title">Admin</div>
                <a href="/admin/users" class="nav-item ${activePage == 'users' ? 'active' : ''}">
                    <i class="bi bi-people"></i>
                    <span>Manage Users</span>
                </a>
                <a href="/admin/reports" class="nav-item ${activePage == 'reports' ? 'active' : ''}">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports</span>
                </a>
                <a href="/admin/settings" class="nav-item ${activePage == 'settings' ? 'active' : ''}">
                    <i class="bi bi-gear"></i>
                    <span>Settings</span>
                </a>
            </div>
        </sec:authorize>
    </nav>

    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="sidebar-user-avatar">
                <sec:authentication property="principal.username" var="userEmail"/>
                ${userEmail.substring(0,1).toUpperCase()}
            </div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${userEmail}</div>
                <div class="sidebar-user-role">
                    <sec:authorize access="hasRole('ADMIN')">Administrator</sec:authorize>
                    <sec:authorize access="hasRole('STAFF') and !hasRole('ADMIN')">Staff</sec:authorize>
                    <sec:authorize access="hasRole('USER') and !hasRole('STAFF') and !hasRole('ADMIN')">User</sec:authorize>
                </div>
            </div>
        </div>
    </div>
</aside>
