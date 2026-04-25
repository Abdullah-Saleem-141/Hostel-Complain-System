<%@ page import="dao.HostelDAO" %>
<%@ page import="models.Hostel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Noor Enterprises</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="text-center mb-4">
                    <h2 class="fw-bold text-primary">Noor Enterprises</h2>
                    <p class="text-muted">Student Registration</p>
                </div>
                
                <% 
                    String error = request.getParameter("error");
                    if (error != null) { 
                %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>

                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <form action="studentAuth" method="POST">
                            <input type="hidden" name="action" value="register">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Username</label>
                                    <input type="text" class="form-control" name="username" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Password</label>
                                    <input type="password" class="form-control" name="password" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Hostel</label>
                                    <select class="form-select" name="hostelId" required>
                                        <option value="" disabled selected>Select Hostel...</option>
                                        <%
                                            HostelDAO hostelDAO = new HostelDAO();
                                            List<Hostel> hostels = hostelDAO.getAllHostels();
                                            for (Hostel h : hostels) {
                                        %>
                                            <option value="<%= h.getId() %>"><%= h.getName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Room Number</label>
                                    <input type="text" class="form-control" name="roomNo" placeholder="e.g. 101A" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100 mb-3">Register</button>
                        </form>
                        <div class="text-center">
                            <p class="mb-0">Already have an account? <a href="student_login.jsp">Login here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
