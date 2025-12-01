# Implementation Plan (extracted from Maintenance_Ticketing_Specification.md

## Summary
Project: FacilityFix — Maintenance & Service Ticketing System
Stack (per spec): Java 17, Spring Boot 3.x, JSP (JSTL), Spring Data JPA (Hibernate), MySQL (dev: H2 supported), Spring Security, Maven

## Key Requirements (MVP)
- Roles: USER (Resident/Employee), STAFF (Maintenance), ADMIN
- Ticket lifecycle: OPEN → IN_PROGRESS → RESOLVED → VERIFIED
- Ticket fields: title, description, category, priority, location, createdBy, assignedTo
- Comments: threaded "TicketComment" with author and timestamp
- Admin capabilities: assign/reassign, change priority, view dashboard
- Staff capabilities: view assigned, change status, add notes
- Dashboard: counts by status, category; simple chart (Chart.js optional)

## Data Model (entities)
- User: id, fullName, email (unique), passwordHash, role (USER/STAFF/ADMIN), department, createdAt, updatedAt
- Ticket: id, title, description, category, priority, status, location, createdBy (FK), assignedTo (FK), createdAt, updatedAt, resolvedAt, verifiedAt
- TicketComment: id, ticket (FK), author (FK), body, createdAt

## Minimal REST API (for future clients)
- POST /api/auth/login
- GET /api/tickets
- GET /api/tickets/{id}
- POST /api/tickets
- PATCH /api/tickets/{id}/status
- PATCH /api/tickets/{id}/assign
- GET /api/dashboard/summary

## Dev Decision
- Use embedded H2 for initial developer setup (zero config). Provide instructions to switch to MySQL in `README.md`.
- Use session-based authentication with Spring Security and BCrypt password encoder.
- Package layout: `com.facilityfix` with `config`, `controller`, `service`, `repository`, `model`, `dto`, `security`.

## Next Immediate Steps
1. Scaffold Maven Spring Boot project skeleton (pom.xml, main class, properties) — target: `mvn spring-boot:run` works with H2.
2. Implement domain entities and repositories.
3. Implement basic auth (UserDetailsService) and seed users.
4. Implement ticket services and controllers + JSP views iteratively (list, create, detail).


-- End of Implementation Plan
