package dao;

import models.Complaint;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database Operations related to Complaints.
 */
public class ComplaintDAO {

    // 1. Insert a new complaint into the database
    public boolean addComplaint(Complaint complaint) {
        boolean isSuccess = false;
        String sql = "INSERT INTO complaints (student_id, hostel_id, room_no, student_name, description, urgency) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, complaint.getStudentId());
            stmt.setInt(2, complaint.getHostelId());
            stmt.setString(3, complaint.getRoomNo());
            stmt.setString(4, complaint.getStudentName());
            stmt.setString(5, complaint.getDescription());
            stmt.setString(6, complaint.getUrgency());
            
            int rowsAffected = stmt.executeUpdate();
            isSuccess = (rowsAffected > 0);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Complaint> getComplaintsByStudentId(int studentId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c JOIN hostels h ON c.hostel_id = h.id WHERE c.student_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setStudentId(rs.getInt("student_id"));
                c.setHostelId(rs.getInt("hostel_id"));
                c.setHostelName(rs.getString("hostel_name"));
                c.setRoomNo(rs.getString("room_no"));
                c.setStudentName(rs.getString("student_name"));
                c.setDescription(rs.getString("description"));
                c.setUrgency(rs.getString("urgency"));
                c.setAdminConfirmed(rs.getBoolean("admin_confirmed"));
                c.setStudentConfirmed(rs.getBoolean("student_confirmed"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setResolvedAt(rs.getTimestamp("resolved_at"));
                complaints.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // 2. Fetch pending complaints for a specific hostel (For Admin Dashboard)
    public List<Complaint> getPendingComplaintsByHostel(int hostelId) {
        List<Complaint> complaints = new ArrayList<>();
        // Fetch complaints where student hasn't confirmed yet (or maybe admin hasn't)
        // Usually, a complaint is pending if admin hasn't fixed it.
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c " +
                     "JOIN hostels h ON c.hostel_id = h.id " +
                     "WHERE c.hostel_id = ? AND c.student_confirmed = FALSE ORDER BY c.created_at DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, hostelId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setStudentId(rs.getInt("student_id"));
                c.setHostelId(rs.getInt("hostel_id"));
                c.setHostelName(rs.getString("hostel_name"));
                c.setRoomNo(rs.getString("room_no"));
                c.setStudentName(rs.getString("student_name"));
                c.setDescription(rs.getString("description"));
                c.setUrgency(rs.getString("urgency"));
                c.setAdminConfirmed(rs.getBoolean("admin_confirmed"));
                c.setStudentConfirmed(rs.getBoolean("student_confirmed"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setResolvedAt(rs.getTimestamp("resolved_at"));
                complaints.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // 3. Search for a complaint by student name or room number (For Student Tracker)
    public List<Complaint> searchComplaints(String query) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c " +
                     "JOIN hostels h ON c.hostel_id = h.id " +
                     "WHERE c.room_no ILIKE ? OR c.student_name ILIKE ? ORDER BY c.created_at DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            String searchTerm = "%" + query + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setHostelId(rs.getInt("hostel_id"));
                c.setHostelName(rs.getString("hostel_name"));
                c.setRoomNo(rs.getString("room_no"));
                c.setStudentName(rs.getString("student_name"));
                c.setDescription(rs.getString("description"));
                c.setUrgency(rs.getString("urgency"));
                c.setAdminConfirmed(rs.getBoolean("admin_confirmed"));
                c.setStudentConfirmed(rs.getBoolean("student_confirmed"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                complaints.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // 4. Update Admin Confirmation
    public boolean markAsFixedByAdmin(int complaintId) {
        boolean isSuccess = false;
        String sql = "UPDATE complaints SET admin_confirmed = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            isSuccess = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public boolean markAsUnresolvedByAdmin(int complaintId) {
        boolean isSuccess = false;
        String sql = "UPDATE complaints SET admin_confirmed = FALSE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            isSuccess = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // 5. Update Student Confirmation
    public boolean confirmFixByStudent(int complaintId) {
        boolean isSuccess = false;
        String sql = "UPDATE complaints SET student_confirmed = TRUE, resolved_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            isSuccess = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}
