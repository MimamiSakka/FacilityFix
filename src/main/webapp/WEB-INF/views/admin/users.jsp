<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="users" scope="request"/>
        <%@ include file="../includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="Manage Users" scope="request"/>
            <%@ include file="../includes/header.jsp" %>

            <div class="page-content">
                <!-- Toast Messages -->
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
                <c:if test="${not empty error}">
                    <div class="toast-container">
                        <div class="toast show" style="border-left-color: var(--danger);" data-autohide="true">
                            <div class="toast-icon" style="color: var(--danger);">
                                <i class="bi bi-exclamation-circle-fill"></i>
                            </div>
                            <div class="toast-content">
                                <div class="toast-title">Error</div>
                                <div class="toast-message">${error}</div>
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
                        <h1 class="page-title">Manage Users</h1>
                        <p class="page-subtitle">View and manage system users and their roles</p>
                    </div>
                    <button class="btn btn-primary" onclick="openAddUserModal()">
                        <i class="bi bi-plus-lg"></i>
                        Add User
                    </button>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid" style="margin-bottom: var(--spacing-6);">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary), var(--primary-dark));">
                            <i class="bi bi-people"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${users.size()}</div>
                            <div class="stat-label">Total Users</div>
                        </div>
                    </div>
                    <c:set var="adminCount" value="0"/>
                    <c:set var="staffCount" value="0"/>
                    <c:set var="userCount" value="0"/>
                    <c:forEach items="${users}" var="u">
                        <c:if test="${u.role == 'ADMIN'}"><c:set var="adminCount" value="${adminCount + 1}"/></c:if>
                        <c:if test="${u.role == 'STAFF'}"><c:set var="staffCount" value="${staffCount + 1}"/></c:if>
                        <c:if test="${u.role == 'USER'}"><c:set var="userCount" value="${userCount + 1}"/></c:if>
                    </c:forEach>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #dc2626, #b91c1c);">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${adminCount}</div>
                            <div class="stat-label">Admins</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #2563eb, #1d4ed8);">
                            <i class="bi bi-person-gear"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${staffCount}</div>
                            <div class="stat-label">Staff</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #059669, #047857);">
                            <i class="bi bi-person"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${userCount}</div>
                            <div class="stat-label">Users</div>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">All Users</h3>
                    </div>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="width: 5%;">#</th>
                                    <th style="width: 20%;">Name</th>
                                    <th style="width: 20%;">Email</th>
                                    <th style="width: 12%;">Role</th>
                                    <th style="width: 18%;">Department</th>
                                    <th style="width: 25%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="u" varStatus="status">
                                    <tr>
                                        <td style="color: var(--gray-500);">${status.index + 1}</td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: var(--spacing-3);">
                                                <div class="avatar avatar-sm" style="
                                                    background: ${u.role == 'ADMIN' ? 'linear-gradient(135deg, #dc2626, #b91c1c)' : 
                                                                  u.role == 'STAFF' ? 'linear-gradient(135deg, #2563eb, #1d4ed8)' : 
                                                                  'linear-gradient(135deg, #059669, #047857)'};">
                                                    ${u.fullName.substring(0,1)}
                                                </div>
                                                <span style="font-weight: 500; color: var(--gray-900);">${u.fullName}</span>
                                            </div>
                                        </td>
                                        <td style="color: var(--gray-600);">${u.email}</td>
                                        <td>
                                            <span class="badge ${u.role == 'ADMIN' ? 'badge-danger' : u.role == 'STAFF' ? 'badge-primary' : 'badge-success'}">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td style="color: var(--gray-600);">${u.department != null ? u.department : '-'}</td>
                                        <td>
                                            <div style="display: flex; gap: var(--spacing-2); flex-wrap: wrap;">
                                                <c:if test="${u.id != user.id}">
                                                    <!-- Role Dropdown -->
                                                    <form method="post" action="/admin/users/${u.id}/role" style="display: inline;">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <select name="role" class="form-select" style="min-width: 90px; padding: var(--spacing-1) var(--spacing-2); font-size: var(--font-size-sm);" onchange="this.form.submit()">
                                                            <c:forEach items="${roles}" var="r">
                                                                <option value="${r}" ${u.role == r ? 'selected' : ''}>${r}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </form>
                                                    <!-- Department Dropdown (for STAFF only) -->
                                                    <c:if test="${u.role == 'STAFF'}">
                                                        <form method="post" action="/admin/users/${u.id}/department" style="display: inline;">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                            <select name="department" class="form-select" style="min-width: 110px; padding: var(--spacing-1) var(--spacing-2); font-size: var(--font-size-sm);" onchange="this.form.submit()">
                                                                <option value="" ${u.department == null ? 'selected' : ''}>No Dept</option>
                                                                <option value="Electrical" ${u.department == 'Electrical' ? 'selected' : ''}>Electrical</option>
                                                                <option value="Plumbing" ${u.department == 'Plumbing' ? 'selected' : ''}>Plumbing</option>
                                                                <option value="HVAC" ${u.department == 'HVAC' ? 'selected' : ''}>HVAC</option>
                                                                <option value="Cleaning" ${u.department == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                                <option value="General" ${u.department == 'General' ? 'selected' : ''}>General</option>
                                                            </select>
                                                        </form>
                                                    </c:if>
                                                    <!-- Delete Button -->
                                                    <form method="post" action="/admin/users/${u.id}/delete" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit" class="btn btn-ghost" style="color: var(--danger); padding: var(--spacing-1) var(--spacing-2);">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${u.id == user.id}">
                                                    <span style="font-size: var(--font-size-sm); color: var(--gray-400); font-style: italic;">Current user</span>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Add User Modal -->
    <div id="addUserModal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h3 class="modal-title">Add New User</h3>
                <button type="button" class="modal-close" onclick="closeAddUserModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <div class="modal-body">
                <form method="post" action="${pageContext.request.contextPath}/admin/users" id="addUserForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    
                    <div class="form-group">
                        <label class="form-label">Full Name <span style="color: #ef4444;">*</span></label>
                        <input type="text" name="fullName" class="form-input" required placeholder="Enter full name">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email <span style="color: #ef4444;">*</span></label>
                        <input type="email" name="email" class="form-input" required placeholder="Enter email address">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Password <span style="color: #ef4444;">*</span></label>
                        <input type="password" name="password" class="form-input" required placeholder="Enter password" minlength="6">
                        <small style="color: #6b7280; font-size: 12px; margin-top: 4px; display: block;">Minimum 6 characters</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Role <span style="color: #ef4444;">*</span></label>
                        <select name="role" class="form-select" required id="addUserRole" onchange="toggleDepartmentField()">
                            <option value="USER">User</option>
                            <option value="STAFF">Staff</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    
                    <div class="form-group" id="departmentField" style="margin-bottom: 0;">
                        <label class="form-label">Department</label>
                        <select name="department" class="form-select">
                            <option value="">-- Select Department --</option>
                            <option value="Electrical">Electrical</option>
                            <option value="Plumbing">Plumbing</option>
                            <option value="HVAC">HVAC</option>
                            <option value="Cleaning">Cleaning</option>
                            <option value="General">General</option>
                        </select>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeAddUserModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i>
                            Add User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <style>
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-overlay.show {
            display: flex;
        }
        .modal-container {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25), 0 0 0 1px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 480px;
            max-height: 90vh;
            overflow-y: auto;
            animation: modalSlideIn 0.2s ease-out;
        }
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-20px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
            background: #f9fafb;
            border-radius: 16px 16px 0 0;
        }
        .modal-title {
            font-size: 18px;
            font-weight: 600;
            color: #111827;
            margin: 0;
        }
        .modal-close {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            padding: 8px;
            cursor: pointer;
            color: #6b7280;
            border-radius: 8px;
            transition: all 0.15s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-close:hover {
            background: #f3f4f6;
            color: #111827;
            border-color: #d1d5db;
        }
        .modal-body {
            padding: 24px;
            background: #ffffff;
        }
        .modal-body .form-group {
            margin-bottom: 20px;
        }
        .modal-body .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
            font-size: 14px;
        }
        .modal-body .form-input,
        .modal-body .form-select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            background: #ffffff;
            color: #111827;
            transition: border-color 0.15s ease, box-shadow 0.15s ease;
        }
        .modal-body .form-input:focus,
        .modal-body .form-select:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        .modal-body .form-input::placeholder {
            color: #9ca3af;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 20px 24px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
            border-radius: 0 0 16px 16px;
        }
    </style>

    <script>
        function openAddUserModal() {
            document.getElementById('addUserModal').classList.add('show');
            document.body.style.overflow = 'hidden';
            toggleDepartmentField();
        }
        
        function closeAddUserModal() {
            document.getElementById('addUserModal').classList.remove('show');
            document.body.style.overflow = '';
            document.getElementById('addUserForm').reset();
        }
        
        function toggleDepartmentField() {
            const role = document.getElementById('addUserRole').value;
            const deptField = document.getElementById('departmentField');
            if (role === 'STAFF') {
                deptField.style.display = 'block';
            } else {
                deptField.style.display = 'none';
            }
        }
        
        // Close modal on backdrop click
        document.getElementById('addUserModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeAddUserModal();
            }
        });
        
        // Close modal on Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeAddUserModal();
            }
        });
    </script>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
