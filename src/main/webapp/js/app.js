/**
 * FacilityFix - Application JavaScript
 * Production-Ready UI Interactions
 */

(function() {
    'use strict';

    // ============================================
    // Toast Notifications
    // ============================================
    const Toast = {
        container: null,

        init() {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        },

        show(message, type = 'info', duration = 4000) {
            const toast = document.createElement('div');
            toast.className = `toast toast-${type}`;
            
            const icons = {
                success: 'bi-check-circle-fill',
                error: 'bi-x-circle-fill',
                warning: 'bi-exclamation-triangle-fill',
                info: 'bi-info-circle-fill'
            };

            toast.innerHTML = `
                <i class="bi ${icons[type] || icons.info}" style="font-size: 1.25rem; color: var(--${type === 'error' ? 'danger' : type}-500);"></i>
                <div class="toast-content">
                    <div class="toast-message">${message}</div>
                </div>
                <button class="toast-close" onclick="this.parentElement.remove()">
                    <i class="bi bi-x"></i>
                </button>
            `;

            this.container.appendChild(toast);

            // Auto remove
            setTimeout(() => {
                toast.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }, duration);
        },

        success(message) { this.show(message, 'success'); },
        error(message) { this.show(message, 'error'); },
        warning(message) { this.show(message, 'warning'); },
        info(message) { this.show(message, 'info'); }
    };

    // ============================================
    // Sidebar Toggle
    // ============================================
    const Sidebar = {
        init() {
            const toggleBtn = document.getElementById('sidebar-toggle');
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('.main-content');

            if (toggleBtn && sidebar) {
                toggleBtn.addEventListener('click', () => {
                    sidebar.classList.toggle('open');
                });

                // Close sidebar when clicking outside on mobile
                document.addEventListener('click', (e) => {
                    if (window.innerWidth <= 1024) {
                        if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
                            sidebar.classList.remove('open');
                        }
                    }
                });
            }
        }
    };

    // ============================================
    // Dropdown Menus
    // ============================================
    const Dropdown = {
        init() {
            document.querySelectorAll('.dropdown').forEach(dropdown => {
                const trigger = dropdown.querySelector('.dropdown-trigger');
                
                if (trigger) {
                    trigger.addEventListener('click', (e) => {
                        e.stopPropagation();
                        
                        // Close other dropdowns
                        document.querySelectorAll('.dropdown.show').forEach(d => {
                            if (d !== dropdown) d.classList.remove('show');
                        });
                        
                        dropdown.classList.toggle('show');
                    });
                }
            });

            // Close dropdowns when clicking outside
            document.addEventListener('click', () => {
                document.querySelectorAll('.dropdown.show').forEach(d => {
                    d.classList.remove('show');
                });
            });
        }
    };

    // ============================================
    // Modal
    // ============================================
    const Modal = {
        open(modalId) {
            const backdrop = document.getElementById('modal-backdrop');
            const modal = document.getElementById(modalId);
            
            if (backdrop && modal) {
                backdrop.classList.add('show');
                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
            }
        },

        close(modalId) {
            const backdrop = document.getElementById('modal-backdrop');
            const modal = document.getElementById(modalId);
            
            if (backdrop && modal) {
                backdrop.classList.remove('show');
                modal.classList.remove('show');
                document.body.style.overflow = '';
            }
        },

        init() {
            // Close modal on backdrop click
            const backdrop = document.getElementById('modal-backdrop');
            if (backdrop) {
                backdrop.addEventListener('click', () => {
                    document.querySelectorAll('.modal.show').forEach(modal => {
                        this.close(modal.id);
                    });
                });
            }

            // Close modal on escape key
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    document.querySelectorAll('.modal.show').forEach(modal => {
                        this.close(modal.id);
                    });
                }
            });
        }
    };

    // ============================================
    // Form Validation
    // ============================================
    const FormValidation = {
        init() {
            document.querySelectorAll('form[data-validate]').forEach(form => {
                form.addEventListener('submit', (e) => {
                    if (!this.validateForm(form)) {
                        e.preventDefault();
                    }
                });

                // Real-time validation
                form.querySelectorAll('input, textarea, select').forEach(field => {
                    field.addEventListener('blur', () => {
                        this.validateField(field);
                    });

                    field.addEventListener('input', () => {
                        if (field.classList.contains('is-invalid')) {
                            this.validateField(field);
                        }
                    });
                });
            });
        },

        validateForm(form) {
            let isValid = true;
            form.querySelectorAll('[required]').forEach(field => {
                if (!this.validateField(field)) {
                    isValid = false;
                }
            });
            return isValid;
        },

        validateField(field) {
            const value = field.value.trim();
            let isValid = true;
            let message = '';

            // Required validation
            if (field.hasAttribute('required') && !value) {
                isValid = false;
                message = 'This field is required';
            }

            // Email validation
            if (field.type === 'email' && value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(value)) {
                    isValid = false;
                    message = 'Please enter a valid email address';
                }
            }

            // Min length validation
            if (field.minLength > 0 && value.length < field.minLength) {
                isValid = false;
                message = `Minimum ${field.minLength} characters required`;
            }

            // Update UI
            const feedback = field.parentElement.querySelector('.invalid-feedback');
            if (isValid) {
                field.classList.remove('is-invalid');
                if (feedback) feedback.textContent = '';
            } else {
                field.classList.add('is-invalid');
                if (feedback) feedback.textContent = message;
            }

            return isValid;
        }
    };

    // ============================================
    // Password Toggle
    // ============================================
    const PasswordToggle = {
        init() {
            document.querySelectorAll('.password-toggle').forEach(toggle => {
                toggle.addEventListener('click', () => {
                    const input = toggle.parentElement.querySelector('input');
                    const icon = toggle.querySelector('i');
                    
                    if (input.type === 'password') {
                        input.type = 'text';
                        icon.classList.replace('bi-eye', 'bi-eye-slash');
                    } else {
                        input.type = 'password';
                        icon.classList.replace('bi-eye-slash', 'bi-eye');
                    }
                });
            });
        }
    };

    // ============================================
    // Loading Button
    // ============================================
    const LoadingButton = {
        start(button) {
            button.disabled = true;
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = '<span class="spinner"></span> Loading...';
        },

        stop(button) {
            button.disabled = false;
            button.innerHTML = button.dataset.originalText;
        }
    };

    // ============================================
    // Data Tables
    // ============================================
    const DataTable = {
        init() {
            document.querySelectorAll('.table-search input').forEach(input => {
                input.addEventListener('input', (e) => {
                    const searchTerm = e.target.value.toLowerCase();
                    const table = input.closest('.table-container').querySelector('.data-table');
                    const rows = table.querySelectorAll('tbody tr');

                    rows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        row.style.display = text.includes(searchTerm) ? '' : 'none';
                    });
                });
            });
        }
    };

    // ============================================
    // Animated Counter
    // ============================================
    const AnimatedCounter = {
        init() {
            document.querySelectorAll('[data-count]').forEach(counter => {
                const target = parseInt(counter.dataset.count);
                const duration = 1000;
                const step = target / (duration / 16);
                let current = 0;

                const updateCounter = () => {
                    current += step;
                    if (current < target) {
                        counter.textContent = Math.floor(current);
                        requestAnimationFrame(updateCounter);
                    } else {
                        counter.textContent = target;
                    }
                };

                // Start animation when element is visible
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            updateCounter();
                            observer.unobserve(entry.target);
                        }
                    });
                });

                observer.observe(counter);
            });
        }
    };

    // ============================================
    // Confirm Delete
    // ============================================
    const ConfirmDelete = {
        init() {
            document.querySelectorAll('[data-confirm]').forEach(element => {
                element.addEventListener('click', (e) => {
                    const message = element.dataset.confirm || 'Are you sure you want to delete this item?';
                    if (!confirm(message)) {
                        e.preventDefault();
                    }
                });
            });
        }
    };

    // ============================================
    // Auto-hide Alerts
    // ============================================
    const AutoHideAlerts = {
        init() {
            document.querySelectorAll('.alert[data-auto-hide]').forEach(alert => {
                const duration = parseInt(alert.dataset.autoHide) || 5000;
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(() => alert.remove(), 300);
                }, duration);
            });
        }
    };

    // ============================================
    // Ticket Status Update
    // ============================================
    const TicketStatusUpdate = {
        init() {
            document.querySelectorAll('.status-select').forEach(select => {
                select.addEventListener('change', async (e) => {
                    const ticketId = select.dataset.ticketId;
                    const newStatus = select.value;
                    
                    try {
                        const response = await fetch(`/api/tickets/${ticketId}/status`, {
                            method: 'PATCH',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({ status: newStatus })
                        });
                        
                        if (response.ok) {
                            Toast.success('Status updated successfully');
                        } else {
                            Toast.error('Failed to update status');
                        }
                    } catch (error) {
                        Toast.error('An error occurred');
                    }
                });
            });
        }
    };

    // ============================================
    // Character Counter
    // ============================================
    const CharacterCounter = {
        init() {
            document.querySelectorAll('[data-char-count]').forEach(textarea => {
                const maxLength = parseInt(textarea.dataset.charCount);
                const counter = document.createElement('div');
                counter.className = 'char-counter text-muted';
                counter.style.fontSize = '0.75rem';
                counter.style.textAlign = 'right';
                counter.style.marginTop = '4px';
                textarea.parentElement.appendChild(counter);

                const updateCounter = () => {
                    const remaining = maxLength - textarea.value.length;
                    counter.textContent = `${textarea.value.length}/${maxLength}`;
                    counter.style.color = remaining < 20 ? 'var(--danger-500)' : '';
                };

                textarea.addEventListener('input', updateCounter);
                updateCounter();
            });
        }
    };

    // ============================================
    // Theme (Future: Dark Mode)
    // ============================================
    const Theme = {
        init() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
        },

        toggle() {
            const current = document.documentElement.getAttribute('data-theme');
            const next = current === 'light' ? 'dark' : 'light';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
        }
    };

    // ============================================
    // Smooth Scroll
    // ============================================
    const SmoothScroll = {
        init() {
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', (e) => {
                    const target = document.querySelector(anchor.getAttribute('href'));
                    if (target) {
                        e.preventDefault();
                        target.scrollIntoView({ behavior: 'smooth' });
                    }
                });
            });
        }
    };

    // ============================================
    // Initialize All Modules
    // ============================================
    document.addEventListener('DOMContentLoaded', () => {
        Toast.init();
        Sidebar.init();
        Dropdown.init();
        Modal.init();
        FormValidation.init();
        PasswordToggle.init();
        DataTable.init();
        AnimatedCounter.init();
        ConfirmDelete.init();
        AutoHideAlerts.init();
        TicketStatusUpdate.init();
        CharacterCounter.init();
        Theme.init();
        SmoothScroll.init();
    });

    // Expose globally for use in templates
    window.FacilityFix = {
        Toast,
        Modal,
        LoadingButton,
        Theme
    };

})();

// Add slideOut animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
    .toast-close {
        background: none;
        border: none;
        cursor: pointer;
        padding: 4px;
        color: var(--gray-400);
        transition: color 0.2s;
    }
    .toast-close:hover {
        color: var(--gray-600);
    }
    .char-counter {
        font-size: 0.75rem;
        text-align: right;
        margin-top: 4px;
        color: var(--gray-500);
    }
`;
document.head.appendChild(style);
