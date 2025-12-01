package com.facilityfix.dto;

import java.util.Map;

public class DashboardSummaryDTO {
    private long total;
    private long open;
    private long inProgress;
    private long resolved;
    private long verified;

    public DashboardSummaryDTO() {}

    public DashboardSummaryDTO(long total, long open, long inProgress, long resolved, long verified) {
        this.total = total;
        this.open = open;
        this.inProgress = inProgress;
        this.resolved = resolved;
        this.verified = verified;
    }

    // Getters and setters
    public long getTotal() { return total; }
    public void setTotal(long total) { this.total = total; }

    public long getOpen() { return open; }
    public void setOpen(long open) { this.open = open; }

    public long getInProgress() { return inProgress; }
    public void setInProgress(long inProgress) { this.inProgress = inProgress; }

    public long getResolved() { return resolved; }
    public void setResolved(long resolved) { this.resolved = resolved; }

    public long getVerified() { return verified; }
    public void setVerified(long verified) { this.verified = verified; }
}
