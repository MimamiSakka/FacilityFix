<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Top Header Bar -->
<header class="top-header">
    <div class="header-left">
        <button class="header-icon-btn" id="sidebar-toggle" title="Toggle Sidebar">
            <i class="bi bi-list" style="font-size: 1.25rem;"></i>
        </button>
        
        <div class="breadcrumb">
            <a href="/dashboard">Home</a>
            <span class="breadcrumb-separator">/</span>
            <span>${pageTitle != null ? pageTitle : 'Dashboard'}</span>
        </div>
    </div>

    <div class="header-right">
        <div class="header-search">
            <i class="bi bi-search"></i>
            <input type="text" placeholder="Search tickets..." id="global-search">
        </div>

        <button class="header-icon-btn" title="Notifications">
            <i class="bi bi-bell"></i>
            <span class="badge">3</span>
        </button>

        <div class="dropdown">
            <div class="header-user dropdown-trigger">
                <div class="header-user-avatar">
                    <sec:authentication property="principal.username" var="userEmail"/>
                    ${userEmail.substring(0,1).toUpperCase()}
                </div>
                <i class="bi bi-chevron-down" style="font-size: 0.75rem; color: var(--gray-400);"></i>
            </div>
            <div class="dropdown-menu">
                <a href="/profile" class="dropdown-item">
                    <i class="bi bi-person"></i>
                    <span>My Profile</span>
                </a>
                <a href="/tickets?createdBy=me" class="dropdown-item">
                    <i class="bi bi-ticket"></i>
                    <span>My Tickets</span>
                </a>
                <div class="dropdown-divider"></div>
                <form action="/logout" method="post" style="margin: 0;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="dropdown-item" style="width: 100%; border: none; background: none; text-align: left; cursor: pointer;">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Logout</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</header>
