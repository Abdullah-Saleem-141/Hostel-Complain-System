package models;

import java.sql.Timestamp;

/**
 * Data model for a Complaint.
 * Maps to the 'complaints' table in the database.
 */
public class Complaint {
    private int id;
    private int studentId;
    private int hostelId;
    private String hostelName; // Useful for displaying in dashboard
    private String roomNo;
    private String studentName;
    private String description;
    private boolean adminConfirmed;
    private boolean studentConfirmed;
    private String urgency;
    private Timestamp createdAt;
    private Timestamp resolvedAt;
    private String adminComment;

    // Getters and Setters

    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getHostelId() { return hostelId; }
    public void setHostelId(int hostelId) { this.hostelId = hostelId; }

    public String getHostelName() { return hostelName; }
    public void setHostelName(String hostelName) { this.hostelName = hostelName; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isAdminConfirmed() { return adminConfirmed; }
    public void setAdminConfirmed(boolean adminConfirmed) { this.adminConfirmed = adminConfirmed; }

    public boolean isStudentConfirmed() { return studentConfirmed; }
    public void setStudentConfirmed(boolean studentConfirmed) { this.studentConfirmed = studentConfirmed; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    public String getAdminComment() { return adminComment; }
    public void setAdminComment(String adminComment) { this.adminComment = adminComment; }
}
