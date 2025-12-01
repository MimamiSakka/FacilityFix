<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FacilityFix</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <div class="login-page">
        <!-- Left Side - Branding -->
        <div class="login-left">
            <div class="login-brand">
                <div class="login-brand-icon">
                    <i class="bi bi-tools"></i>
                </div>
                <div class="login-brand-text">FacilityFix</div>
            </div>
            
            <p class="login-tagline">
                Streamline your facility maintenance with our powerful ticketing system
            </p>

            <div class="login-features">
                <div class="login-feature">
                    <div class="login-feature-icon">
                        <i class="bi bi-lightning-charge"></i>
                    </div>
                    <span class="login-feature-text">Quick ticket submission</span>
                </div>
                <div class="login-feature">
                    <div class="login-feature-icon">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <span class="login-feature-text">Real-time status tracking</span>
                </div>
                <div class="login-feature">
                    <div class="login-feature-icon">
                        <i class="bi bi-people"></i>
                    </div>
                    <span class="login-feature-text">Team collaboration</span>
                </div>
                <div class="login-feature">
                    <div class="login-feature-icon">
                        <i class="bi bi-graph-up"></i>
                    </div>
                    <span class="login-feature-text">Analytics & reporting</span>
                </div>
            </div>
        </div>

        <!-- Right Side - Login Form -->
        <div class="login-right">
            <div class="login-form-container">
                <h1 class="login-form-title">Welcome back</h1>
                <p class="login-form-subtitle">Enter your credentials to access your account</p>

                <c:if test="${param.error != null}">
                    <div class="alert alert-danger" data-auto-hide="5000">
                        <i class="bi bi-exclamation-circle alert-icon"></i>
                        <div class="alert-content">
                            <div class="alert-text">Invalid email or password. Please try again.</div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${param.logout != null}">
                    <div class="alert alert-success" data-auto-hide="5000">
                        <i class="bi bi-check-circle alert-icon"></i>
                        <div class="alert-content">
                            <div class="alert-text">You have been logged out successfully.</div>
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="login-form" data-validate>
                    <div class="form-group">
                        <label for="username" class="form-label required">Email Address</label>
                        <div class="input-group">
                            <i class="bi bi-envelope input-group-icon"></i>
                            <input type="email" 
                                   class="form-control has-icon" 
                                   id="username" 
                                   name="username" 
                                   placeholder="Enter your email"
                                   required 
                                   autofocus>
                        </div>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label required">Password</label>
                        <div class="input-group" style="position: relative;">
                            <i class="bi bi-lock input-group-icon"></i>
                            <input type="password" 
                                   class="form-control has-icon" 
                                   id="password" 
                                   name="password" 
                                   placeholder="Enter your password"
                                   required
                                   style="padding-right: 45px;">
                            <button type="button" class="password-toggle" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--gray-400);">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback"></div>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    
                    <button type="submit" class="btn btn-primary btn-lg w-full" style="width: 100%; margin-top: var(--spacing-4);">
                        <i class="bi bi-box-arrow-in-right"></i>
                        Sign In
                    </button>
                </form>

                <div class="login-demo">
                    <div class="login-demo-title">
                        <i class="bi bi-info-circle"></i> Demo Credentials
                    </div>
                    <div class="login-demo-creds">
                        <div><strong>Admin:</strong> admin@facilityfix.com / admin123</div>
                        <div><strong>Staff:</strong> john@facilityfix.com / staff123</div>
                        <div><strong>User:</strong> alice@example.com / user123</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
