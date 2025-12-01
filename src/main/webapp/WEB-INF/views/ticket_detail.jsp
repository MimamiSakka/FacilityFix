<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket #${ticket.id} - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="tickets" scope="request"/>
        <%@ include file="includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="Ticket Details" scope="request"/>
            <%@ include file="includes/header.jsp" %>

            <div class="page-content">
                <!-- Success Toast -->
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

                <!-- Page Header with Back Button -->
                <div class="page-header">
                    <div style="display: flex; align-items: center; gap: var(--spacing-4);">
                        <a href="/tickets" class="btn btn-ghost" style="padding: var(--spacing-2);">
                            <i class="bi bi-arrow-left" style="font-size: 1.25rem;"></i>
                        </a>
                        <div>
                            <div style="display: flex; align-items: center; gap: var(--spacing-3);">
                                <h1 class="page-title" style="margin: 0;">Ticket #${ticket.id}</h1>
                                <span class="status-badge status-${ticket.status.toString().toLowerCase().replace('_', '-')}">${ticket.status.toString().replace('_', ' ')}</span>
                            </div>
                            <p class="page-subtitle" style="margin: var(--spacing-1) 0 0 0;">${ticket.title}</p>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 380px; gap: var(--spacing-6);">
                    <!-- Main Content -->
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-6);">
                        <!-- Ticket Info Card -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Ticket Information</h3>
                                <span class="badge priority-${ticket.priority.toString().toLowerCase()}">${ticket.priority}</span>
                            </div>
                            <div class="card-body">
                                <!-- Meta Information -->
                                <div style="display: flex; gap: var(--spacing-6); margin-bottom: var(--spacing-6); padding-bottom: var(--spacing-6); border-bottom: 1px solid var(--gray-200);">
                                    <div style="display: flex; align-items: center; gap: var(--spacing-3);">
                                        <div class="avatar avatar-sm">${ticket.createdBy.fullName.substring(0,1)}</div>
                                        <div>
                                            <div style="font-size: var(--font-size-xs); color: var(--gray-500);">Created by</div>
                                            <div style="font-weight: 500; color: var(--gray-900);">${ticket.createdBy.fullName}</div>
                                        </div>
                                    </div>
                                    <div>
                                        <div style="font-size: var(--font-size-xs); color: var(--gray-500);">Created</div>
                                        <div style="font-weight: 500; color: var(--gray-900);">
                                            ${ticket.createdAt.monthValue}/${ticket.createdAt.dayOfMonth}/${ticket.createdAt.year} at ${ticket.createdAt.hour}:${ticket.createdAt.minute < 10 ? '0' : ''}${ticket.createdAt.minute}
                                        </div>
                                    </div>
                                    <c:if test="${ticket.updatedAt != null}">
                                        <div>
                                            <div style="font-size: var(--font-size-xs); color: var(--gray-500);">Last Updated</div>
                                            <div style="font-weight: 500; color: var(--gray-900);">
                                                ${ticket.updatedAt.monthValue}/${ticket.updatedAt.dayOfMonth}/${ticket.updatedAt.year} at ${ticket.updatedAt.hour}:${ticket.updatedAt.minute < 10 ? '0' : ''}${ticket.updatedAt.minute}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Description -->
                                <div style="margin-bottom: var(--spacing-6);">
                                    <h4 style="font-size: var(--font-size-sm); font-weight: 600; color: var(--gray-700); margin-bottom: var(--spacing-2);">Description</h4>
                                    <p style="color: var(--gray-600); line-height: 1.6; white-space: pre-wrap;">${ticket.description}</p>
                                </div>

                                <!-- Details Grid -->
                                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--spacing-4);">
                                    <div class="card" style="background: var(--gray-50); border: none;">
                                        <div class="card-body" style="padding: var(--spacing-4);">
                                            <div style="display: flex; align-items: center; gap: var(--spacing-2); margin-bottom: var(--spacing-2);">
                                                <i class="bi bi-tag" style="color: var(--gray-400);"></i>
                                                <span style="font-size: var(--font-size-xs); color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Category</span>
                                            </div>
                                            <div style="font-weight: 600; color: var(--gray-900);">${ticket.category}</div>
                                        </div>
                                    </div>
                                    <div class="card" style="background: var(--gray-50); border: none;">
                                        <div class="card-body" style="padding: var(--spacing-4);">
                                            <div style="display: flex; align-items: center; gap: var(--spacing-2); margin-bottom: var(--spacing-2);">
                                                <i class="bi bi-geo-alt" style="color: var(--gray-400);"></i>
                                                <span style="font-size: var(--font-size-xs); color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Location</span>
                                            </div>
                                            <div style="font-weight: 600; color: var(--gray-900);">${ticket.location != null && ticket.location != '' ? ticket.location : 'Not specified'}</div>
                                        </div>
                                    </div>
                                    <div class="card" style="background: var(--gray-50); border: none;">
                                        <div class="card-body" style="padding: var(--spacing-4);">
                                            <div style="display: flex; align-items: center; gap: var(--spacing-2); margin-bottom: var(--spacing-2);">
                                                <i class="bi bi-person-badge" style="color: var(--gray-400);"></i>
                                                <span style="font-size: var(--font-size-xs); color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Assigned To</span>
                                            </div>
                                            <c:choose>
                                                <c:when test="${ticket.assignedTo != null}">
                                                    <div style="display: flex; align-items: center; gap: var(--spacing-2);">
                                                        <div class="avatar avatar-xs">${ticket.assignedTo.fullName.substring(0,1)}</div>
                                                        <span style="font-weight: 600; color: var(--gray-900);">${ticket.assignedTo.fullName}</span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--gray-400); font-style: italic;">Unassigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Comments Section -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <i class="bi bi-chat-dots"></i>
                                    Comments
                                    <c:if test="${not empty comments}">
                                        <span class="badge badge-secondary" style="margin-left: var(--spacing-2);">${comments.size()}</span>
                                    </c:if>
                                </h3>
                            </div>
                            <div class="card-body">
                                <!-- Comment List -->
                                <c:choose>
                                    <c:when test="${not empty comments}">
                                        <div class="comment-list" style="display: flex; flex-direction: column; gap: var(--spacing-4); margin-bottom: var(--spacing-6);">
                                            <c:forEach var="comment" items="${comments}">
                                                <div class="comment-item" style="display: flex; gap: var(--spacing-3); padding: var(--spacing-4); background: var(--gray-50); border-radius: var(--radius-lg);">
                                                    <div class="avatar avatar-sm">${comment.author.fullName.substring(0,1)}</div>
                                                    <div style="flex: 1;">
                                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-2);">
                                                            <div>
                                                                <span style="font-weight: 600; color: var(--gray-900);">${comment.author.fullName}</span>
                                                                <span class="badge badge-secondary" style="margin-left: var(--spacing-2); font-size: 10px;">${comment.author.role}</span>
                                                            </div>
                                                            <span style="font-size: var(--font-size-xs); color: var(--gray-500);">
                                                                ${comment.createdAt.monthValue}/${comment.createdAt.dayOfMonth} ${comment.createdAt.hour}:${comment.createdAt.minute < 10 ? '0' : ''}${comment.createdAt.minute}
                                                            </span>
                                                        </div>
                                                        <p style="color: var(--gray-700); margin: 0; line-height: 1.5; white-space: pre-wrap;">${comment.body}</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="text-align: center; padding: var(--spacing-8); color: var(--gray-500);">
                                            <i class="bi bi-chat" style="font-size: 2rem; margin-bottom: var(--spacing-2); opacity: 0.5;"></i>
                                            <p style="margin: 0;">No comments yet. Be the first to comment!</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Add Comment Form -->
                                <form action="/tickets/${ticket.id}/comment" method="post" style="border-top: 1px solid var(--gray-200); padding-top: var(--spacing-4);">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <div class="form-group" style="margin-bottom: var(--spacing-3);">
                                        <label for="commentBody" class="form-label" style="font-weight: 500;">Add a Comment</label>
                                        <textarea id="commentBody" class="form-textarea" name="body" rows="3" 
                                                  placeholder="Write your comment here..." required
                                                  style="resize: vertical;"></textarea>
                                    </div>
                                    <div style="display: flex; justify-content: flex-end;">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-send"></i>
                                            Post Comment
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar Actions -->
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-4);">
                        <!-- Status Timeline -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Status Timeline</h3>
                            </div>
                            <div class="card-body" style="padding: var(--spacing-4);">
                                <div class="timeline">
                                    <div class="timeline-item">
                                        <div class="timeline-marker ${ticket.status == 'OPEN' || ticket.status == 'IN_PROGRESS' || ticket.status == 'RESOLVED' || ticket.status == 'VERIFIED' ? 'success' : ''}">
                                            <i class="bi bi-check"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">Open</div>
                                            <div class="timeline-text">Ticket created</div>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-marker ${ticket.status == 'IN_PROGRESS' || ticket.status == 'RESOLVED' || ticket.status == 'VERIFIED' ? 'success' : (ticket.status == 'OPEN' ? 'primary' : '')}">
                                            <i class="bi bi-${ticket.status == 'IN_PROGRESS' || ticket.status == 'RESOLVED' || ticket.status == 'VERIFIED' ? 'check' : 'hourglass'}"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">In Progress</div>
                                            <div class="timeline-text">Being worked on</div>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-marker ${ticket.status == 'RESOLVED' || ticket.status == 'VERIFIED' ? 'success' : ''}">
                                            <i class="bi bi-${ticket.status == 'RESOLVED' || ticket.status == 'VERIFIED' ? 'check' : 'clipboard-check'}"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">Resolved</div>
                                            <div class="timeline-text">Issue fixed</div>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-marker ${ticket.status == 'VERIFIED' ? 'success' : ''}">
                                            <i class="bi bi-${ticket.status == 'VERIFIED' ? 'check' : 'patch-check'}"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">Verified</div>
                                            <div class="timeline-text">Confirmed complete</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Change Status (STAFF or ADMIN) -->
                        <c:if test="${user.role == 'STAFF' || user.role == 'ADMIN'}">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Update Status</h3>
                                </div>
                                <div class="card-body">
                                    <form action="/tickets/${ticket.id}/status" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <div class="form-group" style="margin-bottom: var(--spacing-3);">
                                            <select name="status" class="form-select">
                                                <c:forEach var="s" items="${statuses}">
                                                    <option value="${s}" ${ticket.status == s ? 'selected' : ''}>${s.toString().replace('_', ' ')}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                                            <i class="bi bi-arrow-repeat"></i>
                                            Update Status
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:if>

                        <!-- User Verify Button -->
                        <c:if test="${user.role == 'USER' && ticket.status == 'RESOLVED' && ticket.createdBy.id == user.id}">
                            <div class="card" style="background: linear-gradient(135deg, var(--success-50) 0%, var(--success-100) 100%); border: 1px solid var(--success-200);">
                                <div class="card-body">
                                    <div style="text-align: center; margin-bottom: var(--spacing-3);">
                                        <div style="width: 48px; height: 48px; background: var(--success-500); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; color: white; margin-bottom: var(--spacing-2);">
                                            <i class="bi bi-check-circle" style="font-size: 1.5rem;"></i>
                                        </div>
                                        <h4 style="font-size: var(--font-size-base); font-weight: 600; color: var(--gray-900); margin-bottom: var(--spacing-1);">Issue Resolved!</h4>
                                        <p style="font-size: var(--font-size-sm); color: var(--gray-600); margin: 0;">Please verify if the issue has been fixed.</p>
                                    </div>
                                    <form action="/tickets/${ticket.id}/status" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="status" value="VERIFIED"/>
                                        <button type="submit" class="btn btn-success" style="width: 100%;">
                                            <i class="bi bi-patch-check"></i>
                                            Verify Resolution
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:if>

                        <!-- Assign Staff (ADMIN only) -->
                        <c:if test="${user.role == 'ADMIN'}">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Assign Staff</h3>
                                </div>
                                <div class="card-body">
                                    <form action="/tickets/${ticket.id}/assign" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <div class="form-group" style="margin-bottom: var(--spacing-3);">
                                            <select name="staffId" class="form-select">
                                                <option value="">Select staff member...</option>
                                                <c:forEach var="staff" items="${staffList}">
                                                    <option value="${staff.id}" 
                                                        ${ticket.assignedTo != null && ticket.assignedTo.id == staff.id ? 'selected' : ''}>
                                                        ${staff.fullName}
                                                        <c:if test="${staff.department != null}"> (${staff.department})</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-secondary" style="width: 100%;">
                                            <i class="bi bi-person-plus"></i>
                                            Assign Staff
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <!-- Change Priority (ADMIN only) -->
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Change Priority</h3>
                                </div>
                                <div class="card-body">
                                    <form action="/tickets/${ticket.id}/priority" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <div class="form-group" style="margin-bottom: var(--spacing-3);">
                                            <select name="priority" class="form-select">
                                                <c:forEach var="p" items="${priorities}">
                                                    <option value="${p}" ${ticket.priority == p ? 'selected' : ''}>${p}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-warning" style="width: 100%;">
                                            <i class="bi bi-flag"></i>
                                            Update Priority
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        // Auto-hide toast
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
