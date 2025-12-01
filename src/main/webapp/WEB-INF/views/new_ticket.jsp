<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Ticket - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <div class="app-wrapper">
        <c:set var="activePage" value="new-ticket" scope="request"/>
        <%@ include file="includes/sidebar.jsp" %>

        <main class="main-content">
            <c:set var="pageTitle" value="New Ticket" scope="request"/>
            <%@ include file="includes/header.jsp" %>

            <div class="page-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div style="display: flex; align-items: center; gap: var(--spacing-4);">
                        <a href="/tickets" class="btn btn-ghost" style="padding: var(--spacing-2);">
                            <i class="bi bi-arrow-left" style="font-size: 1.25rem;"></i>
                        </a>
                        <div>
                            <h1 class="page-title">Create New Ticket</h1>
                            <p class="page-subtitle">Submit a new maintenance request</p>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: var(--spacing-6);">
                    <!-- Main Form -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="bi bi-clipboard-plus"></i>
                                Ticket Details
                            </h3>
                        </div>
                        <div class="card-body">
                            <form action="/tickets" method="post" id="ticketForm">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <!-- Title -->
                                <div class="form-group">
                                    <label for="title" class="form-label">
                                        Title <span style="color: var(--danger-500);">*</span>
                                    </label>
                                    <input type="text" class="form-input" id="title" name="title" 
                                           placeholder="Brief summary of the issue (e.g., 'Broken AC in Room 301')" 
                                           required maxlength="200">
                                    <div class="form-hint">Keep it short and descriptive</div>
                                </div>

                                <!-- Description -->
                                <div class="form-group">
                                    <label for="description" class="form-label">
                                        Description <span style="color: var(--danger-500);">*</span>
                                    </label>
                                    <textarea class="form-textarea" id="description" name="description" 
                                              rows="5" placeholder="Please provide a detailed description of the problem. Include:
• What is the issue?
• When did it start?
• How does it affect you?
• Any other relevant details..." 
                                              required minlength="20"></textarea>
                                    <div class="form-hint">Minimum 20 characters. The more detail, the faster we can help!</div>
                                </div>

                                <!-- Category & Priority Row -->
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-4);">
                                    <div class="form-group">
                                        <label for="category" class="form-label">
                                            Category <span style="color: var(--danger-500);">*</span>
                                        </label>
                                        <select class="form-select" id="category" name="category" required>
                                            <option value="">Select a category...</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat}" data-icon="${cat == 'ELECTRICAL' ? 'lightning' : (cat == 'PLUMBING' ? 'droplet' : (cat == 'HVAC' ? 'thermometer-half' : (cat == 'CLEANING' ? 'stars' : 'tools')))}">${cat}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="priority" class="form-label">
                                            Priority <span style="color: var(--danger-500);">*</span>
                                        </label>
                                        <select class="form-select" id="priority" name="priority" required>
                                            <option value="">Select priority level...</option>
                                            <c:forEach var="p" items="${priorities}">
                                                <option value="${p}">${p}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="form-hint" id="priorityHint"></div>
                                    </div>
                                </div>

                                <!-- Location -->
                                <div class="form-group">
                                    <label for="location" class="form-label">
                                        Location
                                        <span style="color: var(--gray-400); font-weight: normal;">(Optional)</span>
                                    </label>
                                    <div style="position: relative;">
                                        <i class="bi bi-geo-alt" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--gray-400);"></i>
                                        <input type="text" class="form-input" id="location" name="location" 
                                               placeholder="e.g., Building A, Room 301, Floor 2"
                                               style="padding-left: 36px;">
                                    </div>
                                    <div class="form-hint">Help us find the issue faster by providing the exact location</div>
                                </div>

                                <!-- Action Buttons -->
                                <div style="display: flex; justify-content: space-between; align-items: center; padding-top: var(--spacing-4); border-top: 1px solid var(--gray-200); margin-top: var(--spacing-6);">
                                    <a href="/tickets" class="btn btn-ghost">
                                        <i class="bi bi-x"></i>
                                        Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="bi bi-send"></i>
                                        Submit Ticket
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Sidebar Tips -->
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-4);">
                        <!-- Priority Guide -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Priority Guide</h3>
                            </div>
                            <div class="card-body" style="padding: var(--spacing-4);">
                                <div style="display: flex; flex-direction: column; gap: var(--spacing-3);">
                                    <div style="display: flex; align-items: flex-start; gap: var(--spacing-3); padding: var(--spacing-3); background: var(--danger-50); border-radius: var(--radius-md); border-left: 3px solid var(--danger-500);">
                                        <i class="bi bi-exclamation-triangle-fill" style="color: var(--danger-500);"></i>
                                        <div>
                                            <div style="font-weight: 600; color: var(--gray-900);">Critical</div>
                                            <div style="font-size: var(--font-size-xs); color: var(--gray-600);">Safety hazard, flooding, fire risk</div>
                                        </div>
                                    </div>
                                    <div style="display: flex; align-items: flex-start; gap: var(--spacing-3); padding: var(--spacing-3); background: var(--warning-50); border-radius: var(--radius-md); border-left: 3px solid var(--warning-500);">
                                        <i class="bi bi-exclamation-circle-fill" style="color: var(--warning-600);"></i>
                                        <div>
                                            <div style="font-weight: 600; color: var(--gray-900);">High</div>
                                            <div style="font-size: var(--font-size-xs); color: var(--gray-600);">Major disruption, needs quick attention</div>
                                        </div>
                                    </div>
                                    <div style="display: flex; align-items: flex-start; gap: var(--spacing-3); padding: var(--spacing-3); background: var(--info-50); border-radius: var(--radius-md); border-left: 3px solid var(--info-500);">
                                        <i class="bi bi-info-circle-fill" style="color: var(--info-500);"></i>
                                        <div>
                                            <div style="font-weight: 600; color: var(--gray-900);">Medium</div>
                                            <div style="font-size: var(--font-size-xs); color: var(--gray-600);">Moderate inconvenience, standard timeline</div>
                                        </div>
                                    </div>
                                    <div style="display: flex; align-items: flex-start; gap: var(--spacing-3); padding: var(--spacing-3); background: var(--gray-100); border-radius: var(--radius-md); border-left: 3px solid var(--gray-400);">
                                        <i class="bi bi-dash-circle" style="color: var(--gray-500);"></i>
                                        <div>
                                            <div style="font-weight: 600; color: var(--gray-900);">Low</div>
                                            <div style="font-size: var(--font-size-xs); color: var(--gray-600);">Minor issue, can be scheduled</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tips Card -->
                        <div class="card" style="background: linear-gradient(135deg, var(--primary-50) 0%, var(--primary-100) 100%); border: 1px solid var(--primary-200);">
                            <div class="card-header" style="background: transparent; border: none;">
                                <h3 class="card-title">
                                    <i class="bi bi-lightbulb" style="color: var(--primary-500);"></i>
                                    Tips for Faster Resolution
                                </h3>
                            </div>
                            <div class="card-body" style="padding-top: 0;">
                                <ul style="margin: 0; padding-left: var(--spacing-5); color: var(--gray-700); font-size: var(--font-size-sm);">
                                    <li style="margin-bottom: var(--spacing-2);">Be specific about the problem location</li>
                                    <li style="margin-bottom: var(--spacing-2);">Include photos if possible (in comments)</li>
                                    <li style="margin-bottom: var(--spacing-2);">Mention any workarounds you've tried</li>
                                    <li style="margin-bottom: var(--spacing-2);">Note the best time to access the area</li>
                                    <li>Provide contact info for follow-up</li>
                                </ul>
                            </div>
                        </div>

                        <!-- Need Help Card -->
                        <div class="card">
                            <div class="card-body" style="text-align: center; padding: var(--spacing-6);">
                                <i class="bi bi-question-circle" style="font-size: 2rem; color: var(--gray-400); margin-bottom: var(--spacing-2);"></i>
                                <h4 style="font-size: var(--font-size-sm); font-weight: 600; color: var(--gray-900); margin-bottom: var(--spacing-1);">Need Help?</h4>
                                <p style="font-size: var(--font-size-sm); color: var(--gray-500); margin-bottom: var(--spacing-3);">For emergencies, call the maintenance hotline</p>
                                <a href="tel:+1234567890" class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-telephone"></i>
                                    (123) 456-7890
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        // Priority hint updater
        document.getElementById('priority').addEventListener('change', function() {
            const hints = {
                'CRITICAL': 'Response within 1 hour',
                'HIGH': 'Response within 4 hours',
                'MEDIUM': 'Response within 24 hours',
                'LOW': 'Response within 3 days'
            };
            const hint = document.getElementById('priorityHint');
            hint.textContent = hints[this.value] || '';
            hint.style.color = this.value === 'CRITICAL' ? 'var(--danger-500)' : 'var(--gray-500)';
        });

        // Form validation feedback
        document.getElementById('ticketForm').addEventListener('submit', function(e) {
            const btn = this.querySelector('button[type="submit"]');
            btn.innerHTML = '<i class="bi bi-hourglass-split"></i> Submitting...';
            btn.disabled = true;
        });

        // Character counter for description
        const desc = document.getElementById('description');
        desc.addEventListener('input', function() {
            const minLength = 20;
            const current = this.value.length;
            const hint = this.nextElementSibling;
            if (current < minLength) {
                hint.style.color = 'var(--danger-500)';
                hint.textContent = `${minLength - current} more characters needed`;
            } else {
                hint.style.color = 'var(--success-500)';
                hint.textContent = '✓ Good description length';
            }
        });
    </script>
</body>
</html>
