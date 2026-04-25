<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Complaint" %>
<%@ page import="dao.ComplaintDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Status - Hostel Complaint Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
        <div class="container">
            <a class="navbar-brand brand-logo" href="index.jsp">HostelCare</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="index.jsp">Submit Complaint</a></li>
                    <li class="nav-item"><a class="nav-link active" href="status.jsp">Track Status</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-outline-primary ms-lg-3 px-3" href="admin_login.jsp">Admin Login</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                
                <% 
                    String msg = request.getParameter("msg");
                    if (msg != null) { 
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Success!</strong> <%= msg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <div class="card mb-4">
                    <div class="card-body p-4">
                        <h4 class="fw-bold text-center mb-4">Track Your Complaint</h4>
                        <form action="status.jsp" method="GET" class="d-flex">
                            <input class="form-control me-2" type="search" name="search" placeholder="Search by Room No (e.g. 101A) or Name" required>
                            <button class="btn btn-primary" type="submit">Search</button>
                        </form>
                    </div>
                </div>

                <% 
                    String query = request.getParameter("search");
                    if (query != null && !query.trim().isEmpty()) {
                        ComplaintDAO dao = new ComplaintDAO();
                        List<Complaint> results = dao.searchComplaints(query);
                %>
                    <h5 class="mb-3">Search Results for: "<%= query %>"</h5>
                    
                    <% if (results.isEmpty()) { %>
                        <div class="alert alert-warning">No complaints found matching your search.</div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover table-custom align-middle">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Hostel & Room</th>
                                        <th>Description</th>
                                        <th>Admin Status</th>
                                        <th>Your Confirmation</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Complaint c : results) { %>
                                        <tr>
                                            <td><%= c.getCreatedAt().toString().substring(0, 10) %></td>
                                            <td>
                                                <strong><%= c.getHostelName() %></strong><br>
                                                Room: <%= c.getRoomNo() %>
                                            </td>
                                            <td><%= c.getDescription() %></td>
                                            <td>
                                                <% if (c.isAdminConfirmed()) { %>
                                                    <span class="badge bg-success status-badge">Fixed by Admin</span>
                                                <% } else { %>
                                                    <span class="badge bg-warning text-dark status-badge">Pending</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (c.isStudentConfirmed()) { %>
                                                    <span class="badge bg-success status-badge">Resolved</span>
                                                <% } else if (c.isAdminConfirmed()) { %>
                                                    <!-- Show confirm button only if admin has fixed it -->
                                                    <form action="updateComplaint" method="POST">
                                                        <input type="hidden" name="action" value="student_confirm">
                                                        <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                                        <button type="submit" class="btn btn-sm btn-outline-success fw-bold">Confirm Fix</button>
                                                    </form>
                                                <% } else { %>
                                                    <span class="text-muted small">Awaiting admin</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
