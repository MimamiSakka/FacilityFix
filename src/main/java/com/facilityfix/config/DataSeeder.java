package com.facilityfix.config;

import com.facilityfix.model.*;
import com.facilityfix.repository.TicketRepository;
import com.facilityfix.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataSeeder {

    @Bean
    CommandLineRunner initDatabase(UserRepository userRepo, TicketRepository ticketRepo, PasswordEncoder encoder) {
        return args -> {
            // Skip if data already exists
            if (userRepo.count() > 0) {
                return;
            }

            // Create users
            User admin = new User("Admin User", "admin@facilityfix.com", encoder.encode("admin123"), Role.ADMIN);
            User staff1 = new User("John Electrician", "john@facilityfix.com", encoder.encode("staff123"), Role.STAFF);
            staff1.setDepartment("Electrical");
            User staff2 = new User("Jane Plumber", "jane@facilityfix.com", encoder.encode("staff123"), Role.STAFF);
            staff2.setDepartment("Plumbing");
            User user1 = new User("Alice Resident", "alice@example.com", encoder.encode("user123"), Role.USER);
            User user2 = new User("Bob Employee", "bob@example.com", encoder.encode("user123"), Role.USER);

            userRepo.save(admin);
            userRepo.save(staff1);
            userRepo.save(staff2);
            userRepo.save(user1);
            userRepo.save(user2);

            // Create sample tickets
            Ticket t1 = new Ticket();
            t1.setTitle("AC not cooling in Room 101");
            t1.setDescription("The air conditioner is running but not cooling. Temperature stays at 28C.");
            t1.setCategory(Category.HVAC);
            t1.setPriority(Priority.HIGH);
            t1.setStatus(TicketStatus.OPEN);
            t1.setLocation("Room 101");
            t1.setCreatedBy(user1);
            ticketRepo.save(t1);

            Ticket t2 = new Ticket();
            t2.setTitle("Water leakage in bathroom");
            t2.setDescription("There is a persistent water leak from the faucet.");
            t2.setCategory(Category.PLUMBING);
            t2.setPriority(Priority.MEDIUM);
            t2.setStatus(TicketStatus.IN_PROGRESS);
            t2.setLocation("Block B, Floor 2, Room 205");
            t2.setCreatedBy(user2);
            t2.setAssignedTo(staff2);
            ticketRepo.save(t2);

            Ticket t3 = new Ticket();
            t3.setTitle("Broken light switch");
            t3.setDescription("The light switch in the corridor is broken and sparks occasionally.");
            t3.setCategory(Category.ELECTRICAL);
            t3.setPriority(Priority.CRITICAL);
            t3.setStatus(TicketStatus.OPEN);
            t3.setLocation("Main corridor, Ground Floor");
            t3.setCreatedBy(user1);
            t3.setAssignedTo(staff1);  // Assign to John so he can see it
            ticketRepo.save(t3);

            System.out.println(">>> Sample data seeded successfully!");
        };
    }
}
