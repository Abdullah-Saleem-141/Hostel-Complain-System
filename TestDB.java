import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDB {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.bynfhjqtomxixgeadfdt";
        String password = "noorenterprise839";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("Connected!");
            
            String sql = "INSERT INTO students (username, password, name, room_no, hostel_id) VALUES ('testuser', 'testpass', 'Test Name', '101', 1)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            int rows = stmt.executeUpdate();
            System.out.println("Rows inserted: " + rows);
            
            stmt.close();
            
            sql = "DELETE FROM students WHERE username = 'testuser'";
            conn.createStatement().executeUpdate(sql);
            System.out.println("Test user deleted.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
