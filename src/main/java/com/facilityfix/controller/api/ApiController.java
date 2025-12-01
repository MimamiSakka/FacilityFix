package com.facilityfix.controller.api;

import com.facilityfix.dto.DashboardSummaryDTO;
import com.facilityfix.dto.TicketDTO;
import com.facilityfix.model.*;
import com.facilityfix.service.TicketService;
import com.facilityfix.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class ApiController {

    private final TicketService ticketService;
    private final UserService userService;

    public ApiController(TicketService ticketService, UserService userService) {
        this.ticketService = ticketService;
        this.userService = userService;
    }

    @GetMapping("/tickets")
    public ResponseEntity<List<TicketDTO>> getTickets(Authentication auth) {
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        List<Ticket> tickets;
        if (user.getRole() == Role.ADMIN) {
            tickets = ticketService.findAll();
        } else if (user.getRole() == Role.STAFF) {
            tickets = ticketService.findByStaff(user);
        } else {
            tickets = ticketService.findByUser(user);
        }

        List<TicketDTO> dtos = tickets.stream()
                .map(TicketDTO::fromEntity)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/tickets/{id}")
    public ResponseEntity<TicketDTO> getTicket(@PathVariable Long id) {
        return ticketService.findById(id)
                .map(ticket -> ResponseEntity.ok(TicketDTO.fromEntity(ticket)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/tickets")
    public ResponseEntity<TicketDTO> createTicket(@RequestBody Map<String, String> body, Authentication auth) {
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        String title = body.get("title");
        String description = body.get("description");
        Category category = Category.valueOf(body.get("category"));
        Priority priority = Priority.valueOf(body.get("priority"));
        String location = body.get("location");

        Ticket ticket = ticketService.createTicket(title, description, category, priority, location, user);
        return ResponseEntity.ok(TicketDTO.fromEntity(ticket));
    }

    @PatchMapping("/tickets/{id}/status")
    public ResponseEntity<TicketDTO> changeStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        TicketStatus status = TicketStatus.valueOf(body.get("status"));
        Ticket ticket = ticketService.changeStatus(id, status);
        return ResponseEntity.ok(TicketDTO.fromEntity(ticket));
    }

    @PatchMapping("/tickets/{id}/assign")
    public ResponseEntity<TicketDTO> assignTicket(@PathVariable Long id, @RequestBody Map<String, Long> body) {
        Long staffId = body.get("staffId");
        Ticket ticket = ticketService.assignTicket(id, staffId);
        return ResponseEntity.ok(TicketDTO.fromEntity(ticket));
    }

    @GetMapping("/dashboard/summary")
    public ResponseEntity<DashboardSummaryDTO> dashboardSummary() {
        DashboardSummaryDTO summary = new DashboardSummaryDTO(
            ticketService.countAll(),
            ticketService.countByStatus(TicketStatus.OPEN),
            ticketService.countByStatus(TicketStatus.IN_PROGRESS),
            ticketService.countByStatus(TicketStatus.RESOLVED),
            ticketService.countByStatus(TicketStatus.VERIFIED)
        );
        return ResponseEntity.ok(summary);
    }
}
