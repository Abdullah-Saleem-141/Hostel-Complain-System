package servlets;

import dao.StudentDAO;
import models.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/studentAuth")
public class StudentAuthServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String username = request.getParameter("username") != null ? request.getParameter("username").trim() : null;
            String password = request.getParameter("password") != null ? request.getParameter("password").trim() : null;
            
            Student student = studentDAO.authenticate(username, password);
            if (student != null) {
                // Prevent Session Fixation
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }
                HttpSession session = request.getSession(true);
                session.setAttribute("studentId", student.getId());
                session.setAttribute("studentName", student.getName());
                session.setAttribute("roomNo", student.getRoomNo());
                session.setAttribute("hostelId", student.getHostelId());
                response.sendRedirect("student_dashboard.jsp");
            } else {
                response.sendRedirect("student_login.jsp?error=Invalid username or password");
            }
        } else if ("register".equals(action)) {
            Student student = new Student();
            student.setUsername(request.getParameter("username") != null ? request.getParameter("username").trim() : null);
            student.setPassword(request.getParameter("password") != null ? request.getParameter("password").trim() : null);
            student.setName(request.getParameter("name") != null ? request.getParameter("name").trim() : null);
            student.setRoomNo(request.getParameter("roomNo") != null ? request.getParameter("roomNo").trim() : null);
            student.setHostelId(Integer.parseInt(request.getParameter("hostelId")));

            if (studentDAO.register(student)) {
                response.sendRedirect("student_login.jsp?msg=Registration successful. Please login.");
            } else {
                response.sendRedirect("student_register.jsp?error=Registration failed. Username might be taken.");
            }
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
        }
    }
}
