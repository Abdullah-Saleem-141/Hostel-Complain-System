import utils.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class DatabasePatch {
    public static void main(String[] args) {
        System.out.println("Applying Database Patch...");
        String sql = "ALTER TABLE complaints ADD COLUMN IF NOT EXISTS admin_comment TEXT;";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("SUCCESS! 'admin_comment' column added (or already exists).");
        } catch (Exception e) {
            System.out.println("FAILED! Error applying patch:");
            e.printStackTrace();
            
            // Fallback for older Postgres versions that don't support IF NOT EXISTS in ADD COLUMN
            System.out.println("Trying fallback...");
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                stmt.execute("ALTER TABLE complaints ADD COLUMN admin_comment TEXT;");
                System.out.println("SUCCESS! 'admin_comment' column added via fallback.");
            } catch (Exception ex) {
                System.out.println("Fallback also failed (likely column already exists).");
            }
        }
    }
}
