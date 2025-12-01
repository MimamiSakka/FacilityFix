<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="settings" scope="request"/>
        <%@ include file="../includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="Settings" scope="request"/>
            <%@ include file="../includes/header.jsp" %>

            <div class="page-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">System Settings</h1>
                        <p class="page-subtitle">Configure system options and preferences</p>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: var(--spacing-6);">
                    <!-- Categories -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-tag" style="margin-right: var(--spacing-2);"></i>
                                Ticket Categories
                            </h3>
                        </div>
                        <div class="card-body">
                            <p style="color: var(--gray-600); margin-bottom: var(--spacing-4);">
                                Available categories for classifying tickets.
                            </p>
                            <div style="display: flex; flex-wrap: wrap; gap: var(--spacing-2);">
                                <c:forEach items="${categories}" var="cat">
                                    <span class="badge badge-secondary" style="padding: var(--spacing-2) var(--spacing-3);">
                                        <i class="bi ${cat == 'ELECTRICAL' ? 'bi-lightning' : 
                                                       cat == 'PLUMBING' ? 'bi-droplet' : 
                                                       cat == 'CLEANING' ? 'bi-stars' : 
                                                       cat == 'HVAC' ? 'bi-thermometer-half' : 'bi-three-dots'}" 
                                           style="margin-right: var(--spacing-1);"></i>
                                        ${cat}
                                    </span>
                                </c:forEach>
                            </div>
                            <p style="color: var(--gray-400); font-size: var(--font-size-sm); margin-top: var(--spacing-4);">
                                <i class="bi bi-info-circle"></i>
                                Categories are predefined in the system.
                            </p>
                        </div>
                    </div>

                    <!-- Priorities -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-exclamation-triangle" style="margin-right: var(--spacing-2);"></i>
                                Priority Levels
                            </h3>
                        </div>
                        <div class="card-body">
                            <p style="color: var(--gray-600); margin-bottom: var(--spacing-4);">
                                Available priority levels for tickets.
                            </p>
                            <div style="display: flex; flex-direction: column; gap: var(--spacing-2);">
                                <c:forEach items="${priorities}" var="pri">
                                    <div style="display: flex; align-items: center; gap: var(--spacing-3); padding: var(--spacing-2);">
                                        <span class="badge priority-${pri.toString().toLowerCase()}" style="min-width: 80px; justify-content: center;">${pri}</span>
                                        <span style="color: var(--gray-600); font-size: var(--font-size-sm);">
                                            <c:choose>
                                                <c:when test="${pri == 'CRITICAL'}">Urgent issues requiring immediate attention</c:when>
                                                <c:when test="${pri == 'HIGH'}">Important issues to be addressed soon</c:when>
                                                <c:when test="${pri == 'MEDIUM'}">Standard priority issues</c:when>
                                                <c:when test="${pri == 'LOW'}">Minor issues with flexible timing</c:when>
                                            </c:choose>
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- System Info -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-info-circle" style="margin-right: var(--spacing-2);"></i>
                                System Information
                            </h3>
                        </div>
                        <div class="card-body">
                            <div style="display: flex; flex-direction: column; gap: var(--spacing-3);">
                                <div style="display: flex; justify-content: space-between; padding: var(--spacing-2) 0; border-bottom: 1px solid var(--gray-100);">
                                    <span style="color: var(--gray-600);">Application</span>
                                    <span style="font-weight: 500;">FacilityFix</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; padding: var(--spacing-2) 0; border-bottom: 1px solid var(--gray-100);">
                                    <span style="color: var(--gray-600);">Version</span>
                                    <span style="font-weight: 500;">1.0.0</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; padding: var(--spacing-2) 0; border-bottom: 1px solid var(--gray-100);">
                                    <span style="color: var(--gray-600);">Framework</span>
                                    <span style="font-weight: 500;">Spring Boot 3.1</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; padding: var(--spacing-2) 0;">
                                    <span style="color: var(--gray-600);">Database</span>
                                    <span style="font-weight: 500;">H2 (Development)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Workflow Info -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-diagram-3" style="margin-right: var(--spacing-2);"></i>
                                Ticket Workflow
                            </h3>
                        </div>
                        <div class="card-body">
                            <p style="color: var(--gray-600); margin-bottom: var(--spacing-4);">
                                Ticket status progression flow.
                            </p>
                            <div style="display: flex; align-items: center; justify-content: center; gap: var(--spacing-2); flex-wrap: wrap;">
                                <span class="status-badge status-open">OPEN</span>
                                <i class="bi bi-arrow-right" style="color: var(--gray-400);"></i>
                                <span class="status-badge status-in-progress">IN PROGRESS</span>
                                <i class="bi bi-arrow-right" style="color: var(--gray-400);"></i>
                                <span class="status-badge status-resolved">RESOLVED</span>
                                <i class="bi bi-arrow-right" style="color: var(--gray-400);"></i>
                                <span class="status-badge status-verified">VERIFIED</span>
                            </div>
                            <div style="margin-top: var(--spacing-4); padding: var(--spacing-3); background: var(--gray-50); border-radius: var(--radius-md);">
                                <p style="font-size: var(--font-size-sm); color: var(--gray-600); margin: 0;">
                                    <strong>Note:</strong> Tickets move through this workflow. Staff can update status as work progresses. Admins and the ticket creator can verify resolved tickets.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
