package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class to manage database connection.
 * Connects to PostgreSQL database (Supabase).
 */
public class DBConnection {
    // Database credentials and URL
    // TODO: Replace these with your actual Supabase credentials
    private static final String URL = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
    private static final String USER = "postgres.bynfhjqtomxixgeadfdt";
    private static final String PASSWORD = "noorenterprise839";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load the PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");
            // Establish the connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL JDBC Driver not found. Include it in your library path.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
        }
        return conn;
    }
}
