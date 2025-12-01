package com.facilityfix.repository;

import com.facilityfix.model.Ticket;
import com.facilityfix.model.TicketStatus;
import com.facilityfix.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    List<Ticket> findByCreatedBy(User user);

    List<Ticket> findByAssignedTo(User staff);

    List<Ticket> findByStatus(TicketStatus status);

    @Query("SELECT t FROM Ticket t ORDER BY t.createdAt DESC")
    List<Ticket> findAllOrderByCreatedAtDesc();

    // Dashboard counts
    long countByStatus(TicketStatus status);
}
