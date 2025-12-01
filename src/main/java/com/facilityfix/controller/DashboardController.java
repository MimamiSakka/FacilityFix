package com.facilityfix.controller;

import com.facilityfix.model.Role;
import com.facilityfix.model.TicketStatus;
import com.facilityfix.model.User;
import com.facilityfix.service.TicketService;
import com.facilityfix.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    private final TicketService ticketService;
    private final UserService userService;

    public DashboardController(TicketService ticketService, UserService userService) {
        this.ticketService = ticketService;
        this.userService = userService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        model.addAttribute("user", user);
        model.addAttribute("totalTickets", ticketService.countAll());
        model.addAttribute("openCount", ticketService.countByStatus(TicketStatus.OPEN));
        model.addAttribute("inProgressCount", ticketService.countByStatus(TicketStatus.IN_PROGRESS));
        model.addAttribute("resolvedCount", ticketService.countByStatus(TicketStatus.RESOLVED));
        model.addAttribute("verifiedCount", ticketService.countByStatus(TicketStatus.VERIFIED));

        // Role-based tickets
        if (user.getRole() == Role.ADMIN) {
            model.addAttribute("tickets", ticketService.findAll());
        } else if (user.getRole() == Role.STAFF) {
            model.addAttribute("tickets", ticketService.findByStaff(user));
        } else {
            model.addAttribute("tickets", ticketService.findByUser(user));
        }

        return "dashboard";
    }
}
