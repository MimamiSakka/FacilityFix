package com.facilityfix.service;

import com.facilityfix.model.*;
import com.facilityfix.repository.TicketCommentRepository;
import com.facilityfix.repository.TicketRepository;
import com.facilityfix.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class TicketService {

    private final TicketRepository ticketRepository;
    private final TicketCommentRepository commentRepository;
    private final UserRepository userRepository;

    public TicketService(TicketRepository ticketRepository,
                         TicketCommentRepository commentRepository,
                         UserRepository userRepository) {
        this.ticketRepository = ticketRepository;
        this.commentRepository = commentRepository;
        this.userRepository = userRepository;
    }

    public Ticket createTicket(String title, String description, Category category,
                               Priority priority, String location, User createdBy) {
        Ticket ticket = new Ticket();
        ticket.setTitle(title);
        ticket.setDescription(description);
        ticket.setCategory(category);
        ticket.setPriority(priority);
        ticket.setLocation(location);
        ticket.setCreatedBy(createdBy);
        ticket.setStatus(TicketStatus.OPEN);
        return ticketRepository.save(ticket);
    }

    public Optional<Ticket> findById(Long id) {
        return ticketRepository.findById(id);
    }

    public List<Ticket> findAll() {
        return ticketRepository.findAllOrderByCreatedAtDesc();
    }

    public List<Ticket> findByUser(User user) {
        return ticketRepository.findByCreatedBy(user);
    }

    public List<Ticket> findByStaff(User staff) {
        return ticketRepository.findByAssignedTo(staff);
    }

    public Ticket assignTicket(Long ticketId, Long staffId) {
        Ticket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));
        User staff = userRepository.findById(staffId)
                .orElseThrow(() -> new IllegalArgumentException("Staff not found"));

        ticket.setAssignedTo(staff);
        return ticketRepository.save(ticket);
    }

    public Ticket changeStatus(Long ticketId, TicketStatus newStatus) {
        Ticket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));

        ticket.setStatus(newStatus);

        if (newStatus == TicketStatus.RESOLVED) {
            ticket.setResolvedAt(LocalDateTime.now());
        } else if (newStatus == TicketStatus.VERIFIED) {
            ticket.setVerifiedAt(LocalDateTime.now());
        }

        return ticketRepository.save(ticket);
    }

    public Ticket changePriority(Long ticketId, Priority priority) {
        Ticket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));
        ticket.setPriority(priority);
        return ticketRepository.save(ticket);
    }

    public TicketComment addComment(Long ticketId, User author, String body) {
        Ticket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));

        TicketComment comment = new TicketComment(ticket, author, body);
        return commentRepository.save(comment);
    }

    public List<TicketComment> getComments(Ticket ticket) {
        return commentRepository.findByTicketOrderByCreatedAtAsc(ticket);
    }

    // Dashboard counts
    public long countByStatus(TicketStatus status) {
        return ticketRepository.countByStatus(status);
    }

    public long countAll() {
        return ticketRepository.count();
    }
}
