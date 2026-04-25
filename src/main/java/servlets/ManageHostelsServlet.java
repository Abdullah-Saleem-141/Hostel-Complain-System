package servlets;

import dao.HostelDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/manageHostels")
public class ManageHostelsServlet extends HttpServlet {
    private HostelDAO hostelDAO = new HostelDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("hostelName");
            if (hostelDAO.addHostel(name)) {
                response.sendRedirect("dashboard.jsp?msg=Hostel added successfully.");
            } else {
                response.sendRedirect("dashboard.jsp?error=Failed to add hostel.");
            }
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("hostelId"));
            String name = request.getParameter("hostelName");
            if (hostelDAO.updateHostel(id, name)) {
                response.sendRedirect("dashboard.jsp?msg=Hostel renamed successfully.");
            } else {
                response.sendRedirect("dashboard.jsp?error=Failed to rename hostel.");
            }
        }
    }
}
