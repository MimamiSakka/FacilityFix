# Digital Maintenance & Service Ticketing System – Technical Specification & AI Build Guide

## 1. Tech Stack Confirmation

This design is **intentionally aligned** with the company’s expected technologies:

> Project to be focused on **Angular / React Native, Node.js, C#, Core Java, JSP**

For this implementation we will primarily use **Core Java + JSP**, which fits directly in the allowed list.

### 1.1 Backend

- **Language:** Java 17 (Core Java)
- **Framework:** Spring Boot 3.x (Spring MVC)
- **Build Tool:** Maven
- **Web Layer:** Spring MVC controllers returning JSP views + REST controllers for APIs
- **Database:** MySQL (or compatible relational DB)
- **ORM:** Spring Data JPA (Hibernate)
- **Security:** Spring Security (session-based login or JWT-based authentication)
- **Validation:** Jakarta Bean Validation (e.g., `@NotNull`, `@Size`)
- **Testing:** JUnit + Spring Boot Test
- **Logging:** SLF4J + Logback

### 1.2 Frontend

- **View Technology:** JSP (Java Server Pages) using JSTL
- **Styling:** Bootstrap 5 + basic CSS
- **Behavior:** Vanilla JavaScript + a little AJAX (Fetch API) where needed
- **View Engine:** JSP under Spring MVC’s `InternalResourceViewResolver`

> Optional future extension: A separate Angular/React Native client consuming the REST APIs. For now, the **submitted project** will be: **Spring Boot + JSP**.

---

## 2. High-Level Project Overview

**Project Name (placeholder):** _“FacilityFix – Maintenance & Service Ticketing System”_

### 2.1 Problem Statement

In hostels, corporate offices, colleges, and libraries, residents and employees regularly face infrastructure issues (broken AC, water leakage, electrical faults, cleaning requests). The current reporting process is often informal (phone, WhatsApp, manual registers), leading to:

- Lost or ignored complaints
- No visibility on status or priority
- No data for management to analyze performance of maintenance teams

### 2.2 Solution Summary

Build a **web-based helpdesk system** where:

- Users can log issues as **tickets**
- Tickets have **priority**, **category**, **assigned staff**, and **status workflow**:
  - `OPEN → IN_PROGRESS → RESOLVED → VERIFIED`
- Admins can:
  - Assign tickets to maintenance staff
  - View dashboards (pending vs resolved, per-category metrics)
- Maintenance staff can:
  - See tickets assigned to them
  - Update status and leave resolution comments

The system is designed as a **single Spring Boot application** with clear layering and REST endpoints, plus JSP pages for direct interaction.

---

## 3. Feasibility Study for an AI Coding Agent

The goal is for a coding agent (Claude, Sonnet, etc.) to **implement this project end-to-end** within realistic constraints (single developer, short time frame).

### 3.1 Scope Feasibility

**In Scope (MVP):**

1. Authentication / authorization:
   - User roles: `RESIDENT/EMPLOYEE`, `STAFF`, `ADMIN`
   - Simple signup (optional) or pre-seeded users
   - Login with email + password (hashed)
2. Ticket management:
   - Create ticket (title, description, category, priority, optional location)
   - View ticket list (filters by status, priority, category)
   - Status transitions with rules
3. Assignment:
   - Admin can assign tickets to staff
   - Staff can see “My Tickets”
4. Comments / activity log:
   - Users and staff can comment on tickets
   - Basic timeline visible on ticket detail page
5. Dashboard:
   - Card-style summary:
     - Total tickets
     - Open / In-Progress / Resolved / Verified count
     - Simple chart (e.g., pending vs resolved)
6. Basic notification:
   - On status change / assignment, reflect visually on UI (page refresh or AJAX)
   - Optional: email notification (out of core MVP if time is tight)

**Out of Scope for MVP (may be stretch goals):**

- Push notifications / complex real-time WebSockets
- Multitenancy (multiple organizations)
- Mobile app (React Native) in first iteration
- Very advanced analytics dashboards

**Conclusion:**  
The MVP is **highly feasible** for an AI coding agent with clear instructions, given that Spring Boot + JSP are mature and well-supported.

---

### 3.2 Complexity & Risk Analysis

**Complexity Areas:**

- Getting Spring Security correctly configured (roles, login, access rules)
- Maintaining consistent status workflow transitions
- Designing a clean, normalized database schema

**Risk Mitigation Strategy for AI Agent:**

1. **Start with domain model & DB schema**, then generate JPA entities and repositories.
2. Implement **simple form-based login** first (session-based) before trying JWT.
3. Implement controllers + JSP views iteratively:
   - Tickets list → ticket create → ticket detail → assignment → dashboard.
4. Add validation and error handling as a second pass, not in the first draft.

---

### 3.3 Non-Functional Requirements

- **Performance:** Designed for up to a few thousand tickets; simple indexes on primary keys and foreign keys suffice.
- **Security:** 
  - Passwords hashed (BCrypt)
  - Role-based access control
- **Maintainability:** 
  - Layered architecture (Controller → Service → Repository)
  - DTOs where appropriate for view/API separation
- **Extensibility:** 
  - REST APIs ready for future Angular/React Native client
  - Clean service interfaces

---

## 4. System Design

### 4.1 User Roles

1. **Resident/Employee (USER)**  
   - Raise tickets  
   - View their own tickets  
   - Comment on tickets  
   - Mark ticket as “Verified” after resolution

2. **Maintenance Staff (STAFF)**  
   - View tickets assigned to them  
   - Change status (`IN_PROGRESS`, `RESOLVED`)  
   - Add internal notes  

3. **Admin (ADMIN)**  
   - View all tickets  
   - Assign / reassign tickets  
   - Change priority  
   - Close tickets  
   - Manage categories, users, and staff  

---

### 4.2 Core Entities (Initial Proposal)

The AI is allowed to adjust field names, indexes, and optional columns if it improves design.

1. **User**
   - `id` (Long, PK)
   - `fullName` (String)
   - `email` (String, unique)
   - `passwordHash` (String)
   - `role` (enum: USER, STAFF, ADMIN)
   - `department` (optional, e.g., Electrical, Plumbing, Housekeeping)
   - `createdAt`, `updatedAt`

2. **Ticket**
   - `id` (Long, PK)
   - `title` (String)
   - `description` (Text)
   - `category` (enum/string: ELECTRICAL, PLUMBING, CLEANING, OTHER)
   - `priority` (enum: LOW, MEDIUM, HIGH, CRITICAL)
   - `status` (enum: OPEN, IN_PROGRESS, RESOLVED, VERIFIED)
   - `location` (String – room/office no)
   - `createdBy` (User FK)
   - `assignedTo` (User FK – staff, nullable)
   - `createdAt`, `updatedAt`, `resolvedAt`, `verifiedAt`

3. **TicketComment**
   - `id` (Long, PK)
   - `ticket` (Ticket FK)
   - `author` (User FK)
   - `body` (Text)
   - `createdAt`

4. **Category** (optional table if not using enum)
   - `id`
   - `name`
   - `description`

5. **Attachment** (optional stretch)
   - `id`
   - `ticket` (Ticket FK)
   - `filePath` or `url`
   - `uploadedBy`
   - `uploadedAt`

The AI can decide whether to normalize categories as a separate table or use enums, depending on repository complexity and time.

---

### 4.3 Modules / Packages

Recommended package structure (AI may adjust if it preserves clarity):

- `com.facilityfix`
  - `config` (security, MVC, DB config)
  - `controller`
  - `service`
  - `repository`
  - `model` (entities)
  - `dto`
  - `security` (if separated)
  - `view` (if you want to explicitly group JSPs, though they are usually in `/WEB-INF/views/`)

---

### 4.4 Key Use Cases & Flow

1. **Login**
   - User enters credentials
   - Spring Security authenticates via `UserDetailsService`
   - Role-specific redirection:
     - USER → My Tickets page
     - STAFF → My Assigned Tickets
     - ADMIN → Admin Dashboard

2. **Create Ticket**
   - USER opens “New Ticket” page
   - Fills form: title, description, category, priority, location
   - Form posts to `/tickets`
   - Service validates, saves Ticket with status = `OPEN`, createdBy = current user

3. **Assign Ticket (Admin)**
   - From ticket detail or list, admin selects staff
   - POST to `/tickets/{id}/assign`
   - Ticket is updated: `assignedTo` = selected staff, status remains `OPEN` or `IN_PROGRESS`

4. **Staff Work on Ticket**
   - STAFF sees “My Tickets” page
   - When starting, they change status → `IN_PROGRESS`
   - After fixing, they set `status = RESOLVED` and add resolution comment

5. **User Verification**
   - USER sees that ticket is resolved
   - If satisfied, they click “Verify” → `status = VERIFIED`
   - If not, they can reopen (optional stretch: `REOPENED` status)

6. **Dashboard Analytics**
   - Controller aggregates counts by:
     - Status
     - Category
     - Staff performance (tickets resolved per staff – stretch goal)
   - JSP shows counts with Bootstrap cards and maybe a simple chart (e.g., using Chart.js)

---

## 5. Frontend (JSP) Design

The AI has freedom to improve the UI, but should at least provide these pages:

1. **`login.jsp`**
   - Email + password form
   - Error message section

2. **`dashboard.jsp`**
   - Role-based:
     - For ADMIN: summary cards + filters for tickets
     - For STAFF: assigned tickets + metrics
     - For USER: summary of their tickets

3. **`tickets_list.jsp`**
   - Table of tickets with:
     - ID, Title, Category, Priority, Status, Assigned To, Created At
   - Filter + sort controls

4. **`ticket_detail.jsp`**
   - Ticket fields
   - Comment thread
   - Buttons based on role:
     - USER: Verify / Reopen
     - STAFF: Change status
     - ADMIN: Assign staff, change priority

5. **`new_ticket.jsp`**
   - Form to create ticket

6. **`admin_users.jsp`** (stretch goal)
   - Manage users and roles

The AI should use **Bootstrap layout** (navbar, responsive container, cards, modals where useful).

---

## 6. API Design (for Future Clients like Angular/React Native)

Even though the immediate UI is JSP-based, the AI should expose a minimal REST layer (if time permits):

- `POST /api/auth/login`
- `GET /api/tickets`
- `GET /api/tickets/{id}`
- `POST /api/tickets`
- `PATCH /api/tickets/{id}/status`
- `PATCH /api/tickets/{id}/assign`
- `GET /api/dashboard/summary`

These endpoints will mirror the core operations and make the backend future-proof.

---

## 7. Implementation Plan for the Coding AI

The AI has freedom to optimize, but this is a recommended step-by-step plan.

### Step 1 – Project Setup

- Generate Spring Boot project:
  - Dependencies: Web, Thymeleaf or JSP support, Spring Data JPA, MySQL Driver, Spring Security, Validation, Lombok (optional)
- Configure:
  - `application.properties` for DB connection, JPA settings, view resolver for JSP
  - Logging pattern

### Step 2 – Domain & Persistence

- Implement entities: `User`, `Ticket`, `TicketComment`, (optional) `Category`
- Create repositories: `UserRepository`, `TicketRepository`, `TicketCommentRepository`
- Initialize sample data via `data.sql` or a CommandLineRunner.

### Step 3 – Security

- Implement `UserDetailsService` using `UserRepository`
- Configure Spring Security:
  - Login page
  - Role-based access rules
  - Password encoding with BCrypt

### Step 4 – Ticket Services

- Implement `TicketService` with methods:
  - `createTicket`
  - `assignTicket`
  - `changeStatus`
  - `addComment`
  - `findTicketsForUser`
  - `findTicketsForStaff`
  - `findAllTickets` (admin)

### Step 5 – Controllers + JSP Views

- Implement controllers for:
  - Auth
  - Ticket views
  - Admin actions
- Create JSPs corresponding to the flows described above.
- Integrate error/success messages using model attributes.

### Step 6 – Dashboard & Analytics

- Implement aggregation queries in `TicketRepository` or a custom DAO.
- Render counts and simple charts in JSP.

### Step 7 – Testing & Polishing

- Add basic unit tests / integration tests.
- Test key flows manually:
  - Login
  - Create ticket
  - Assign ticket
  - Status transitions
  - Verification

The AI should **prioritize working end-to-end flows** over perfection in visual design.

---

## 8. Guidelines & Freedom for the AI Agent

The AI is **allowed and encouraged** to:

- Simplify or expand the domain model if it improves consistency.
- Use Thymeleaf instead of JSP *only if absolutely necessary*; however, JSP is strongly preferred for alignment with the requirement.
- Introduce helper abstractions (DTOs, mappers, base controllers) if they keep the code clean.
- Adjust the status workflow slightly (e.g., add `REOPENED`) if implemented cleanly and documented.

The AI must:

- Stay within **Core Java + Spring Boot + JSP + MySQL** stack.
- Keep the architecture layered.
- Ensure the project builds and runs with `mvn spring-boot:run`.

---

## 9. Prompt Template for the Coding Agent

You can paste the following prompt directly to a coding agent (Claude, Sonnet, etc.) along with this document:

> **Role:** You are a senior Java backend engineer experienced with Spring Boot, JSP, and enterprise web applications.  
> **Goal:** Build a complete, working prototype of a “Digital Maintenance & Service Ticketing System” using the specification I provide.  
>   
> **Tech Stack Constraints:**  
> - Language: Java 17 (Core Java)  
> - Framework: Spring Boot 3.x (Spring MVC)  
> - View: JSP + JSTL + Bootstrap 5  
> - ORM: Spring Data JPA (Hibernate)  
> - DB: MySQL  
> - Security: Spring Security (role-based auth, session login)  
>   
> **Key Requirements:**  
> - Implement roles: USER, STAFF, ADMIN  
> - Users can create maintenance tickets (title, description, category, priority, location)  
> - Admin can assign tickets to staff  
> - Staff can update ticket statuses (`OPEN`, `IN_PROGRESS`, `RESOLVED`, `VERIFIED`) and add comments  
> - Users can verify the resolution  
> - Dashboard shows counts of tickets by status, category, and basic metrics  
> - Clean layered architecture (controllers, services, repositories, entities)  
> - JSP pages for login, dashboard, ticket list, ticket detail, new ticket, and (optionally) user management  
> - Keep the codebase ready for future REST APIs for Angular/React Native clients  
>   
> **Your Approach:**  
> 1. Start by designing the database schema and entities.  
> 2. Set up the Spring Boot project with necessary dependencies.  
> 3. Implement security and basic authentication.  
> 4. Implement the core ticket lifecycle and views end-to-end.  
> 5. Only after core flows work, add dashboard analytics and any nice-to-have features.  
>   
> You may introduce small improvements or additional fields if they improve clarity or UX, but **do not change the core problem statement or tech stack**. Explain major design choices briefly as comments in the code where necessary.

---

This document should give the coding agent a **clear roadmap** while still allowing it enough freedom to architect and implement details intelligently.
