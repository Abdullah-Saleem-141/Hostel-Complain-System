package servlets;

import dao.ComplaintDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/updateComplaint")
public class UpdateComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String complaintIdStr = request.getParameter("complaintId");
        
        if (complaintIdStr != null && !complaintIdStr.isEmpty()) {
            int complaintId = Integer.parseInt(complaintIdStr);
            
            if ("admin_fix".equals(action)) {
                // Admin marks as fixed
                complaintDAO.markAsFixedByAdmin(complaintId);
                response.sendRedirect("dashboard.jsp?msg=Complaint marked as resolved");
            } else if ("admin_unresolve".equals(action)) {
                // Admin marks as unresolved
                complaintDAO.markAsUnresolvedByAdmin(complaintId);
                response.sendRedirect("dashboard.jsp?msg=Complaint marked as unresolved");
            } else if ("student_confirm".equals(action)) {
                // Student confirms fix
                complaintDAO.confirmFixByStudent(complaintId);
                response.sendRedirect("student_dashboard.jsp?msg=Thank you for confirming the resolution");
            }
        } else {
            response.sendRedirect("index.jsp"); // Fallback
        }
    }
}
