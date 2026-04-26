package dao;

import models.Complaint;
import models.DeletionLog;
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
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // 2. Fetch pending complaints for a specific hostel (For Admin Dashboard)
    public List<Complaint> getPendingComplaintsByHostel(int hostelId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c " +
                     "JOIN hostels h ON c.hostel_id = h.id " +
                     "WHERE c.hostel_id = ? AND c.student_confirmed = FALSE ORDER BY c.created_at DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, hostelId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Complaint c = mapResultSetToComplaint(rs);
                complaints.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // 2b. Fetch ALL pending complaints (For Super Admin)
    public List<Complaint> getAllPendingComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c " +
                     "JOIN hostels h ON c.hostel_id = h.id " +
                     "WHERE c.student_confirmed = FALSE ORDER BY c.created_at DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Complaint c = mapResultSetToComplaint(rs);
                complaints.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // Helper method to map ResultSet to Complaint object
    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
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
        return c;
    }

    // 3. Search for a complaint by student name or room number
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
                complaints.add(mapResultSetToComplaint(rs));
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

    // 6. Delete a complaint and log it
    public boolean deleteComplaint(int complaintId, String adminUsername) {
        boolean isSuccess = false;
        String fetchSql = "SELECT * FROM complaints WHERE id = ?";
        String logSql = "INSERT INTO deletion_logs (complaint_id, admin_name, student_name, room_no, description) VALUES (?, ?, ?, ?, ?)";
        String deleteSql = "DELETE FROM complaints WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String studentName = "";
                String roomNo = "";
                String description = "";
                try (PreparedStatement fStmt = conn.prepareStatement(fetchSql)) {
                    fStmt.setInt(1, complaintId);
                    ResultSet rs = fStmt.executeQuery();
                    if (rs.next()) {
                        studentName = rs.getString("student_name");
                        roomNo = rs.getString("room_no");
                        description = rs.getString("description");
                    }
                }
                
                try (PreparedStatement lStmt = conn.prepareStatement(logSql)) {
                    lStmt.setInt(1, complaintId);
                    lStmt.setString(2, adminUsername);
                    lStmt.setString(3, studentName);
                    lStmt.setString(4, roomNo);
                    lStmt.setString(5, description);
                    lStmt.executeUpdate();
                }
                
                try (PreparedStatement dStmt = conn.prepareStatement(deleteSql)) {
                    dStmt.setInt(1, complaintId);
                    isSuccess = dStmt.executeUpdate() > 0;
                }
                
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // 7. Fetch deletion history
    public List<DeletionLog> getDeletionHistory() {
        List<DeletionLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM deletion_logs ORDER BY deleted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DeletionLog log = new DeletionLog();
                log.setId(rs.getInt("id"));
                log.setComplaintId(rs.getInt("complaint_id"));
                log.setAdminName(rs.getString("admin_name"));
                log.setStudentName(rs.getString("student_name"));
                log.setRoomNo(rs.getString("room_no"));
                log.setDescription(rs.getString("description"));
                log.setDeletedAt(rs.getTimestamp("deleted_at"));
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    // 8. Fetch Resolved History
    public List<Complaint> getResolvedHistoryByHostel(int hostelId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c " +
                     "JOIN hostels h ON c.hostel_id = h.id " +
                     "WHERE c.hostel_id = ? AND c.student_confirmed = TRUE ORDER BY c.resolved_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hostelId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public List<Complaint> getAllResolvedHistory() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.*, h.name as hostel_name FROM complaints c " +
                     "JOIN hostels h ON c.hostel_id = h.id " +
                     "WHERE c.student_confirmed = TRUE ORDER BY c.resolved_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }
}
