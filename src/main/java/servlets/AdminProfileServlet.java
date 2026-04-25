package servlets;

import dao.AdminDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/adminProfile")
public class AdminProfileServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");

        if (adminDAO.updateAdminProfile(adminId, newUsername, newPassword)) {
            session.setAttribute("adminUsername", newUsername);
            response.sendRedirect("dashboard.jsp?msg=Profile updated successfully.");
        } else {
            response.sendRedirect("dashboard.jsp?error=Failed to update profile.");
        }
    }
}
