<div align="center">

# 🏢 FacilityFix

### Maintenance & Service Ticketing System

A comprehensive web-based maintenance ticketing system built with Spring Boot and JSP. FacilityFix streamlines facility maintenance operations by providing an intuitive interface for submitting, tracking, and managing maintenance requests.

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1.6-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![Spring Security](https://img.shields.io/badge/Spring%20Security-6.1-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white)
![Hibernate](https://img.shields.io/badge/Hibernate-6.2-59666C?style=for-the-badge&logo=hibernate&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

[Features](#-features) •
[Tech Stack](#-tech-stack) •
[Quick Start](#-quick-start) •
[Demo](#-demo-accounts) •
[API](#-rest-api-endpoints)

</div>

---

## ✨ Features

### 👥 Role-Based Access Control
| Role | Capabilities |
|------|-------------|
| **Admin** | Full system access, user management, reports, settings, assign tickets |
| **Staff** | View and manage assigned tickets, update status, add notes |
| **User** | Create tickets, track personal requests, verify resolutions |

### 🎫 Ticket Management
- ✅ Create, view, and track maintenance tickets
- 🏷️ **Categories**: Electrical, Plumbing, HVAC, Cleaning, Other
- 🚨 **Priority Levels**: Low, Medium, High, Critical
- 🔄 **Status Workflow**: `OPEN` → `IN_PROGRESS` → `RESOLVED` → `VERIFIED`
- 💬 Comment system for ticket communication
- 👷 Staff assignment functionality

### 📊 Dashboard & Analytics
- 📈 Real-time statistics overview
- 📉 Ticket distribution by status
- 🕐 Recent activity feed
- ⚡ Quick actions for common tasks

### 👨‍💼 Admin Panel
- 👤 User management (Create, Read, Update, Delete)
- 🎭 Role and department assignment
- 📋 System reports and analytics
- ⚙️ Application settings

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Language** | Java 17 |
| **Framework** | Spring Boot 3.1.6 (Spring MVC) |
| **Security** | Spring Security 6.1.5 (Session-based) |
| **ORM** | Spring Data JPA (Hibernate 6.2) |
| **Views** | JSP + JSTL + Custom CSS |
| **Icons** | Bootstrap Icons |
| **Database** | H2 (Development) / MySQL (Production) |
| **Build Tool** | Maven |

---

## 🚀 Quick Start

### Prerequisites
- ☕ Java 17 or higher
- 📦 Maven 3.8+ (optional - wrapper included)

### Installation

1️⃣ **Clone the repository**
```bash
git clone https://github.com/shashwatlaloriya/FacilityFix.git
cd FacilityFix
```

2️⃣ **Run the application**

**Option A – With Maven installed:**
```bash
mvn spring-boot:run
```

**Option B – Using Maven Wrapper (no Maven required):**
```powershell
# Windows PowerShell
java "-Dmaven.multiModuleProjectDirectory=$PWD" -classpath ".mvn\wrapper\maven-wrapper.jar" org.apache.maven.wrapper.MavenWrapperMain spring-boot:run
```

3️⃣ **Access the application**
```
🌐 Application: http://localhost:8080
🗄️ H2 Console:  http://localhost:8080/h2-console
   JDBC URL:    jdbc:h2:mem:facilitydb
```

---

## 👤 Demo Accounts

| Role | Email | Password |
|:----:|-------|----------|
| 🔴 **Admin** | admin@facilityfix.com | admin123 |
| 🔵 **Staff** | john@facilityfix.com | staff123 |
| 🔵 **Staff** | jane@facilityfix.com | staff123 |
| 🟢 **User** | alice@example.com | user123 |
| 🟢 **User** | bob@example.com | user123 |

---

## 📁 Project Structure

```
📦 FacilityFix
├── 📂 src/main/java/com/facilityfix/
│   ├── 📄 Application.java          # Entry point
│   ├── 📂 config/                    # Security & app configuration
│   ├── 📂 controller/                # MVC controllers
│   │   └── 📂 api/                   # REST API controllers
│   ├── 📂 dto/                       # Data transfer objects
│   ├── 📂 model/                     # JPA entities & enums
│   ├── 📂 repository/                # Spring Data repositories
│   ├── 📂 security/                  # UserDetailsService
│   └── 📂 service/                   # Business logic
├── 📂 src/main/webapp/
│   ├── 📂 WEB-INF/views/             # JSP templates
│   ├── 📂 css/                       # Stylesheets
│   └── 📂 js/                        # JavaScript files
└── 📄 pom.xml                        # Maven configuration
```

---

## 🔌 REST API Endpoints

| Method | Endpoint | Description |
|:------:|----------|-------------|
| `GET` | `/api/tickets` | List tickets (role-based) |
| `GET` | `/api/tickets/{id}` | Get ticket details |
| `POST` | `/api/tickets` | Create a new ticket |
| `PATCH` | `/api/tickets/{id}/status` | Change ticket status |
| `PATCH` | `/api/tickets/{id}/assign` | Assign ticket to staff |
| `GET` | `/api/dashboard/summary` | Dashboard statistics |

---

## 🔐 Security Features

- 🔒 BCrypt password encryption
- 🛡️ CSRF protection enabled
- 🚫 Role-based URL authorization
- 🍪 Secure session management
- ✅ Form validation & sanitization

---

## 🗄️ Database Configuration

### Switching to MySQL (Production)

Update `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/facilitydb?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.jpa.hibernate.ddl-auto=update
```

---

## 🔮 Future Enhancements

- [ ] 📧 Email notifications on status change
- [ ] 📎 File attachments for tickets
- [ ] 📊 Advanced analytics/reports
- [ ] 📱 Mobile app (React Native)
- [ ] 🔔 Push notifications via WebSockets
- [ ] 🌙 Dark mode support

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### 👨‍💻 Author

**Shashwat Laloriya**

[![GitHub](https://img.shields.io/badge/GitHub-shashwatlaloriya-181717?style=for-the-badge&logo=github)](https://github.com/shashwatlaloriya)

---

<p>Made with ❤️ using Spring Boot</p>

⭐ Star this repo if you find it helpful!

</div>
