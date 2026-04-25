package servlets;

import dao.StudentDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/studentProfile")
public class StudentProfileServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");

        if (studentDAO.updateStudentProfile(studentId, newUsername, newPassword)) {
            session.setAttribute("studentUsername", newUsername); // Optional: if you use this in session
            response.sendRedirect("student_dashboard.jsp?msg=Profile updated successfully.");
        } else {
            response.sendRedirect("student_dashboard.jsp?error=Failed to update profile. Username might be taken.");
        }
    }
}
