package com.facilityfix.controller;

import com.facilityfix.model.*;
import com.facilityfix.service.TicketService;
import com.facilityfix.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;
    private final TicketService ticketService;
    private final PasswordEncoder passwordEncoder;

    public AdminController(UserService userService, TicketService ticketService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.ticketService = ticketService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/users")
    public String listUsers(Authentication auth, Model model) {
        User currentUser = userService.findByEmail(auth.getName()).orElseThrow();
        List<User> users = userService.findAll();
        
        model.addAttribute("user", currentUser);
        model.addAttribute("users", users);
        model.addAttribute("roles", Role.values());
        return "admin/users";
    }

    @PostMapping("/users")
    public String createUser(@RequestParam String fullName,
                            @RequestParam String email,
                            @RequestParam String password,
                            @RequestParam Role role,
                            @RequestParam(required = false) String department,
                            RedirectAttributes redirectAttributes) {
        
        if (userService.findByEmail(email).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "A user with this email already exists.");
            return "redirect:/admin/users";
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setRole(role);
        user.setDepartment(department);
        
        userService.save(user);
        redirectAttributes.addFlashAttribute("success", "User created successfully!");
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/role")
    public String updateUserRole(@PathVariable Long id,
                                 @RequestParam Role role,
                                 RedirectAttributes redirectAttributes) {
        userService.findById(id).ifPresent(user -> {
            user.setRole(role);
            userService.save(user);
        });
        redirectAttributes.addFlashAttribute("success", "User role updated.");
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/department")
    public String updateUserDepartment(@PathVariable Long id,
                                       @RequestParam(required = false) String department,
                                       RedirectAttributes redirectAttributes) {
        userService.findById(id).ifPresent(user -> {
            user.setDepartment(department != null && !department.trim().isEmpty() ? department.trim() : null);
            userService.save(user);
        });
        redirectAttributes.addFlashAttribute("success", "User department updated.");
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id, 
                            Authentication auth,
                            RedirectAttributes redirectAttributes) {
        User currentUser = userService.findByEmail(auth.getName()).orElseThrow();
        
        if (currentUser.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("error", "You cannot delete your own account.");
            return "redirect:/admin/users";
        }
        
        userService.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "User deleted.");
        return "redirect:/admin/users";
    }

    @GetMapping("/reports")
    public String reports(Authentication auth, Model model) {
        User currentUser = userService.findByEmail(auth.getName()).orElseThrow();
        List<Ticket> allTickets = ticketService.findAll();
        
        // Calculate stats
        long totalTickets = allTickets.size();
        long openTickets = allTickets.stream().filter(t -> t.getStatus() == TicketStatus.OPEN).count();
        long inProgressTickets = allTickets.stream().filter(t -> t.getStatus() == TicketStatus.IN_PROGRESS).count();
        long resolvedTickets = allTickets.stream().filter(t -> t.getStatus() == TicketStatus.RESOLVED).count();
        long verifiedTickets = allTickets.stream().filter(t -> t.getStatus() == TicketStatus.VERIFIED).count();
        
        // By category
        Map<Category, Long> byCategory = allTickets.stream()
                .collect(Collectors.groupingBy(Ticket::getCategory, Collectors.counting()));
        
        // By priority
        Map<Priority, Long> byPriority = allTickets.stream()
                .collect(Collectors.groupingBy(Ticket::getPriority, Collectors.counting()));
        
        // Staff performance
        List<User> staff = userService.findAllStaff();
        
        model.addAttribute("user", currentUser);
        model.addAttribute("totalTickets", totalTickets);
        model.addAttribute("openTickets", openTickets);
        model.addAttribute("inProgressTickets", inProgressTickets);
        model.addAttribute("resolvedTickets", resolvedTickets);
        model.addAttribute("verifiedTickets", verifiedTickets);
        model.addAttribute("byCategory", byCategory);
        model.addAttribute("byPriority", byPriority);
        model.addAttribute("staff", staff);
        model.addAttribute("allTickets", allTickets);
        
        return "admin/reports";
    }

    @GetMapping("/settings")
    public String settings(Authentication auth, Model model) {
        User currentUser = userService.findByEmail(auth.getName()).orElseThrow();
        model.addAttribute("user", currentUser);
        model.addAttribute("categories", Category.values());
        model.addAttribute("priorities", Priority.values());
        return "admin/settings";
    }
}
