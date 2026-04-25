package utils;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Protected Admin Resources
        boolean isAdminPath = path.equals("/dashboard.jsp") || 
                            path.equals("/manageHostels") || 
                            path.equals("/adminProfile");

        // Protected Student Resources
        boolean isStudentPath = path.equals("/student_dashboard.jsp") || 
                               path.equals("/submitComplaint") || 
                               path.equals("/studentProfile");

        if (isAdminPath) {
            if (session == null || session.getAttribute("adminId") == null) {
                res.sendRedirect("admin_login.jsp?error=Access Denied. Please login.");
                return;
            }
        } else if (isStudentPath) {
            if (session == null || session.getAttribute("studentId") == null) {
                res.sendRedirect("student_login.jsp?error=Access Denied. Please login.");
                return;
            }
        }

        // Prevent Browser Caching of Protected Pages (Security Best Practice)
        if (isAdminPath || isStudentPath) {
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
