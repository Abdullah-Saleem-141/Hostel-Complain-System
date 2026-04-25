<%@ page import="dao.ComplaintDAO" %>
<%@ page import="models.Complaint" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    if (studentId == null) {
        response.sendRedirect("student_login.jsp");
        return;
    }
    String studentName = (String) session.getAttribute("studentName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Noor Enterprises</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
        <div class="container">
            <a class="navbar-brand brand-logo" href="#">
                <i class="bi bi-building"></i> Noor Enterprises - Student Panel
            </a>
            <div class="d-flex align-items-center">
                <span class="text-white me-3">Welcome, <%= studentName %>!</span>
                <a href="logout" class="btn btn-sm btn-light">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        
        <% 
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) { 
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= msg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <ul class="nav nav-tabs mb-4" id="studentTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-bold" id="complaints-tab" data-bs-toggle="tab" data-bs-target="#complaints" type="button" role="tab">My Complaints</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab">Profile Settings</button>
            </li>
        </ul>

        <div class="tab-content" id="studentTabsContent">
            <!-- COMPLAINTS TAB -->
            <div class="tab-pane fade show active" id="complaints" role="tabpanel">
                <div class="row">
                    <!-- Submit Complaint Form -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                                <h5 class="fw-bold text-primary"><i class="bi bi-plus-circle me-2"></i>New Complaint</h5>
                            </div>
                            <div class="card-body">
                                <form action="submitComplaint" method="POST">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Description of Issue</label>
                                        <textarea class="form-control" name="description" rows="3" placeholder="Describe the problem..." required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Urgency Level</label>
                                        <select class="form-select" name="urgency">
                                            <option value="Low">Low - Normal issue</option>
                                            <option value="Medium" selected>Medium - Needs attention</option>
                                            <option value="High">High - Emergency / Urgent</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100 fw-bold">Submit Request</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- My Complaints List -->
                    <div class="col-md-8">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                                <h5 class="fw-bold text-primary"><i class="bi bi-list-task me-2"></i>My Complaints</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Date</th>
                                                <th>Issue</th>
                                                <th>Admin Status</th>
                                                <th>My Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                ComplaintDAO dao = new ComplaintDAO();
                                                List<Complaint> myComplaints = dao.getComplaintsByStudentId(studentId);
                                                if (myComplaints.isEmpty()) {
                                            %>
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-4">No complaints submitted yet.</td>
                                                </tr>
                                            <%
                                                } else {
                                                    for (Complaint c : myComplaints) {
                                            %>
                                                <tr>
                                                    <td>
                                                        <small class="text-muted"><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(c.getCreatedAt()) %></small><br>
                                                        <small class="text-muted"><%= new java.text.SimpleDateFormat("hh:mm a").format(c.getCreatedAt()) %></small>
                                                    </td>
                                                    <td>
                                                        <%= c.getDescription() %><br>
                                                        <% 
                                                            String urgencyClass = "bg-info";
                                                            if ("High".equals(c.getUrgency())) urgencyClass = "bg-danger";
                                                            else if ("Medium".equals(c.getUrgency())) urgencyClass = "bg-warning text-dark";
                                                        %>
                                                        <span class="badge <%= urgencyClass %>" style="font-size: 0.7rem;"><%= c.getUrgency() %></span>
                                                    </td>
                                                    <td>
                                                        <% if (c.isAdminConfirmed()) { %>
                                                            <span class="badge bg-success">Resolved by Admin</span>
                                                        <% } else { %>
                                                            <span class="badge bg-warning text-dark">Pending</span>
                                                        <% } %>
                                                    </td>
                                                    <td>
                                                        <% if (c.isAdminConfirmed() && !c.isStudentConfirmed()) { %>
                                                            <form action="updateComplaint" method="POST" class="d-inline">
                                                                <input type="hidden" name="action" value="student_confirm">
                                                                <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                                                <button type="submit" class="btn btn-sm btn-outline-success">Confirm Fix</button>
                                                            </form>
                                                        <% } else if (c.isStudentConfirmed()) { %>
                                                            <span class="badge bg-secondary"><i class="bi bi-check-all"></i> Closed</span>
                                                        <% } else { %>
                                                            <span class="text-muted">-</span>
                                                        <% } %>
                                                    </td>
                                                </tr>
                                            <%
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- PROFILE SETTINGS TAB -->
            <div class="tab-pane fade" id="profile" role="tabpanel">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-white pt-4 pb-0 border-bottom-0">
                                <h5 class="fw-bold text-primary">Update Profile</h5>
                            </div>
                            <div class="card-body">
                                <form action="studentProfile" method="POST">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">New Username</label>
                                        <input type="text" class="form-control" name="username" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">New Password</label>
                                        <input type="password" class="form-control" name="password" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Update Profile</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
