package dao;

import models.Student;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StudentDAO {

    public Student authenticate(String username, String password) {
        if (username == null || password == null) return null;
        
        username = username.trim();
        password = password.trim();
        
        Student student = null;
        // Use LEFT JOIN and LOWER() for case-insensitive username matching
        String sql = "SELECT s.id, s.username, s.password, s.name, s.room_no, s.hostel_id, h.name as hostel_name " +
                     "FROM students s " +
                     "LEFT JOIN hostels h ON s.hostel_id = h.id " +
                     "WHERE LOWER(s.username) = LOWER(?) AND s.password = ?";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                student = new Student();
                student.setId(rs.getInt("id"));
                student.setUsername(rs.getString("username"));
                student.setPassword(rs.getString("password"));
                student.setName(rs.getString("name"));
                student.setRoomNo(rs.getString("room_no"));
                student.setHostelId(rs.getInt("hostel_id"));
                student.setHostelName(rs.getString("hostel_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public boolean register(Student student) {
        String sql = "INSERT INTO students (username, password, name, room_no, hostel_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, student.getUsername().trim());
            stmt.setString(2, student.getPassword().trim());
            stmt.setString(3, student.getName().trim());
            stmt.setString(4, student.getRoomNo().trim());
            stmt.setInt(5, student.getHostelId());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStudentProfile(int studentId, String newUsername, String newPassword) {
        String sql = "UPDATE students SET username = ?, password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newUsername.trim());
            stmt.setString(2, newPassword.trim());
            stmt.setInt(3, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
