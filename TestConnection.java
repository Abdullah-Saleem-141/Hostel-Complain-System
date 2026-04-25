import java.sql.Connection;
import java.sql.DriverManager;

public class TestConnection {
    public static void main(String[] args) {
        String URL = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String USER = "postgres.bynfhjqtomxixgeadfdt";
        String PASSWORD = "noorenterprise839";
        
        System.out.println("Testing connection to: " + URL);
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            if (conn != null) {
                System.out.println("SUCCESS! Connection established.");
                conn.close();
            } else {
                System.out.println("FAILED: Connection is null.");
            }
        } catch (Exception e) {
            System.out.println("FAILED with exception:");
            e.printStackTrace();
        }
    }
}
