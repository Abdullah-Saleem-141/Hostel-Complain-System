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
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        boolean success = false;
        if (complaintIdStr != null && !complaintIdStr.isEmpty()) {
            int complaintId = Integer.parseInt(complaintIdStr);
            
            if ("admin_fix".equals(action)) {
                success = complaintDAO.markAsFixedByAdmin(complaintId);
                if (!isAjax) response.sendRedirect("dashboard.jsp?msg=Complaint marked as resolved");
            } else if ("admin_unresolve".equals(action)) {
                success = complaintDAO.markAsUnresolvedByAdmin(complaintId);
                if (!isAjax) response.sendRedirect("dashboard.jsp?msg=Complaint marked as unresolved");
            } else if ("student_confirm".equals(action)) {
                success = complaintDAO.confirmFixByStudent(complaintId);
                if (!isAjax) response.sendRedirect("student_dashboard.jsp?msg=Thank you for confirming the resolution");
            } else if ("admin_delete".equals(action)) {
                String adminUsername = (String) request.getSession().getAttribute("adminUsername");
                success = complaintDAO.deleteComplaint(complaintId, adminUsername != null ? adminUsername : "Unknown Admin");
                if (!isAjax) response.sendRedirect("dashboard.jsp?msg=Complaint deleted successfully");
            } else if ("admin_comment".equals(action)) {
                String comment = request.getParameter("comment");
                success = complaintDAO.updateAdminComment(complaintId, comment);
                if (!isAjax) response.sendRedirect("dashboard.jsp?msg=Comment updated successfully");
            }
        }

        if (isAjax) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": " + success + "}");
        } else if (complaintIdStr == null) {
            response.sendRedirect("index.jsp");
        }
    }
}
