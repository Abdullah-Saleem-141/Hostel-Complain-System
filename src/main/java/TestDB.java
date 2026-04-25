import utils.DBConnection;
import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        System.out.println("Testing DB Connection...");
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                System.out.println("SUCCESS! Database connection established.");
            } else {
                System.out.println("FAILED! Connection is null.");
            }
        } catch (Exception e) {
            System.out.println("FAILED! Error occurred:");
            e.printStackTrace();
        }
    }
}
