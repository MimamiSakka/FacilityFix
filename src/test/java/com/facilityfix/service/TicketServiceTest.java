package com.facilityfix.service;

import com.facilityfix.model.*;
import com.facilityfix.repository.TicketRepository;
import com.facilityfix.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
class TicketServiceTest {

    @Autowired
    private TicketService ticketService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TicketRepository ticketRepository;

    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = userRepository.findByEmail("alice@example.com").orElseThrow();
    }

    @Test
    void createTicket_shouldPersistTicket() {
        Ticket ticket = ticketService.createTicket(
            "Test Ticket",
            "Test description",
            Category.ELECTRICAL,
            Priority.HIGH,
            "Room 999",
            testUser
        );

        assertNotNull(ticket.getId());
        assertEquals("Test Ticket", ticket.getTitle());
        assertEquals(TicketStatus.OPEN, ticket.getStatus());
        assertEquals(testUser.getId(), ticket.getCreatedBy().getId());
    }

    @Test
    void changeStatus_shouldUpdateStatus() {
        Ticket ticket = ticketService.createTicket(
            "Status Test",
            "Description",
            Category.PLUMBING,
            Priority.MEDIUM,
            null,
            testUser
        );

        ticketService.changeStatus(ticket.getId(), TicketStatus.IN_PROGRESS);

        Ticket updated = ticketRepository.findById(ticket.getId()).orElseThrow();
        assertEquals(TicketStatus.IN_PROGRESS, updated.getStatus());
    }

    @Test
    void assignTicket_shouldSetAssignedTo() {
        User staff = userRepository.findByEmail("john@facilityfix.com").orElseThrow();
        Ticket ticket = ticketService.createTicket(
            "Assignment Test",
            "Description",
            Category.HVAC,
            Priority.LOW,
            null,
            testUser
        );

        ticketService.assignTicket(ticket.getId(), staff.getId());

        Ticket updated = ticketRepository.findById(ticket.getId()).orElseThrow();
        assertNotNull(updated.getAssignedTo());
        assertEquals(staff.getId(), updated.getAssignedTo().getId());
    }
}
