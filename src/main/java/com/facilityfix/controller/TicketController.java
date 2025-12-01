package com.facilityfix.controller;

import com.facilityfix.model.*;
import com.facilityfix.service.TicketService;
import com.facilityfix.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/tickets")
public class TicketController {

    private final TicketService ticketService;
    private final UserService userService;

    public TicketController(TicketService ticketService, UserService userService) {
        this.ticketService = ticketService;
        this.userService = userService;
    }

    @GetMapping
    public String listTickets(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String priority,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String assigned,
            Authentication auth, 
            Model model) {
        
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        List<Ticket> tickets;
        
        // Base query based on user role
        if (user.getRole() == Role.ADMIN) {
            tickets = ticketService.findAll();
        } else if (user.getRole() == Role.STAFF) {
            // If "assigned=me" filter, show only tickets assigned to this staff
            if ("me".equals(assigned)) {
                tickets = ticketService.findByStaff(user);
            } else {
                // Staff can see all tickets by default
                tickets = ticketService.findAll();
            }
        } else {
            // Regular users see only their own tickets
            tickets = ticketService.findByUser(user);
        }

        // Apply filters
        if (status != null && !status.isEmpty()) {
            try {
                TicketStatus filterStatus = TicketStatus.valueOf(status);
                tickets = tickets.stream()
                        .filter(t -> t.getStatus() == filterStatus)
                        .collect(Collectors.toList());
            } catch (IllegalArgumentException ignored) {}
        }

        if (priority != null && !priority.isEmpty()) {
            try {
                Priority filterPriority = Priority.valueOf(priority);
                tickets = tickets.stream()
                        .filter(t -> t.getPriority() == filterPriority)
                        .collect(Collectors.toList());
            } catch (IllegalArgumentException ignored) {}
        }

        if (category != null && !category.isEmpty()) {
            try {
                Category filterCategory = Category.valueOf(category);
                tickets = tickets.stream()
                        .filter(t -> t.getCategory() == filterCategory)
                        .collect(Collectors.toList());
            } catch (IllegalArgumentException ignored) {}
        }

        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase().trim();
            tickets = tickets.stream()
                    .filter(t -> t.getTitle().toLowerCase().contains(searchLower) ||
                            (t.getDescription() != null && t.getDescription().toLowerCase().contains(searchLower)) ||
                            (t.getLocation() != null && t.getLocation().toLowerCase().contains(searchLower)))
                    .collect(Collectors.toList());
        }

        model.addAttribute("tickets", tickets);
        model.addAttribute("user", user);
        model.addAttribute("isMyAssigned", "me".equals(assigned));
        return "tickets_list";
    }

    @GetMapping("/new")
    public String newTicketForm(Authentication auth, Model model, RedirectAttributes redirectAttributes) {
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();
        
        // Only Admin and User can create tickets, not Staff
        if (user.getRole() == Role.STAFF) {
            redirectAttributes.addFlashAttribute("error", "Staff members cannot create tickets. You can only work on assigned tickets.");
            return "redirect:/tickets";
        }
        
        model.addAttribute("user", user);
        model.addAttribute("categories", Category.values());
        model.addAttribute("priorities", Priority.values());
        return "new_ticket";
    }

    @PostMapping
    public String createTicket(@RequestParam String title,
                               @RequestParam String description,
                               @RequestParam Category category,
                               @RequestParam Priority priority,
                               @RequestParam(required = false) String location,
                               Authentication auth,
                               RedirectAttributes redirectAttributes) {
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        // Only Admin and User can create tickets, not Staff
        if (user.getRole() == Role.STAFF) {
            redirectAttributes.addFlashAttribute("error", "Staff members cannot create tickets.");
            return "redirect:/tickets";
        }

        ticketService.createTicket(title, description, category, priority, location, user);
        redirectAttributes.addFlashAttribute("success", "Ticket created successfully!");
        return "redirect:/tickets";
    }

    @GetMapping("/{id}")
    public String ticketDetail(@PathVariable Long id, Authentication auth, Model model) {
        Ticket ticket = ticketService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));

        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        model.addAttribute("ticket", ticket);
        model.addAttribute("user", user);
        model.addAttribute("comments", ticketService.getComments(ticket));
        model.addAttribute("statuses", TicketStatus.values());
        model.addAttribute("priorities", Priority.values());
        model.addAttribute("staffList", userService.findAllStaff());

        return "ticket_detail";
    }

    @PostMapping("/{id}/comment")
    public String addComment(@PathVariable Long id,
                             @RequestParam String body,
                             Authentication auth,
                             RedirectAttributes redirectAttributes) {
        String email = auth.getName();
        User user = userService.findByEmail(email).orElseThrow();

        ticketService.addComment(id, user, body);
        redirectAttributes.addFlashAttribute("success", "Comment added.");
        return "redirect:/tickets/" + id;
    }

    @PostMapping("/{id}/status")
    public String changeStatus(@PathVariable Long id,
                               @RequestParam TicketStatus status,
                               RedirectAttributes redirectAttributes) {
        ticketService.changeStatus(id, status);
        redirectAttributes.addFlashAttribute("success", "Status updated to " + status);
        return "redirect:/tickets/" + id;
    }

    @PostMapping("/{id}/assign")
    public String assignTicket(@PathVariable Long id,
                               @RequestParam Long staffId,
                               RedirectAttributes redirectAttributes) {
        ticketService.assignTicket(id, staffId);
        redirectAttributes.addFlashAttribute("success", "Ticket assigned.");
        return "redirect:/tickets/" + id;
    }

    @PostMapping("/{id}/priority")
    public String changePriority(@PathVariable Long id,
                                 @RequestParam Priority priority,
                                 RedirectAttributes redirectAttributes) {
        ticketService.changePriority(id, priority);
        redirectAttributes.addFlashAttribute("success", "Priority updated.");
        return "redirect:/tickets/" + id;
    }
}
