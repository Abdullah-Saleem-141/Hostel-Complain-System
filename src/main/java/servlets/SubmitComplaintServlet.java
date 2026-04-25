package servlets;

import dao.ComplaintDAO;
import models.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.http.HttpSession;

@WebServlet("/submitComplaint")
public class SubmitComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("student_login.jsp?error=Please login first.");
            return;
        }

        // Read student data from session
        int studentId = (Integer) session.getAttribute("studentId");
        int hostelId = (Integer) session.getAttribute("hostelId");
        String roomNo = (String) session.getAttribute("roomNo");
        String studentName = (String) session.getAttribute("studentName");
        
        // Description and Urgency from form
        String description = utils.XSSUtils.sanitize(request.getParameter("description"));
        String urgency = request.getParameter("urgency");

        // Create complaint object
        Complaint complaint = new Complaint();
        complaint.setStudentId(studentId);
        complaint.setHostelId(hostelId);
        complaint.setRoomNo(roomNo);
        complaint.setStudentName(studentName);
        complaint.setDescription(description);
        complaint.setUrgency(urgency);

        // Save to database
        boolean success = complaintDAO.addComplaint(complaint);

        // Redirect back with success or error message
        if (success) {
            response.sendRedirect("student_dashboard.jsp?msg=Complaint Submitted Successfully!");
        } else {
            response.sendRedirect("student_dashboard.jsp?error=Failed to submit complaint. Please try again.");
        }
    }
}
