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

    // Timezone Formatting for Pakistan (PKT)
    java.util.TimeZone tz = java.util.TimeZone.getTimeZone("Asia/Karachi");
    java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("MMM dd, yyyy");
    java.text.SimpleDateFormat sdfTime = new java.text.SimpleDateFormat("hh:mm a");
    sdfDate.setTimeZone(tz);
    sdfTime.setTimeZone(tz);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Noor Hostels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f8faff; }
        .navbar { background: #4f46e5 !important; }
        .glass-card { 
            background: rgba(255, 255, 255, 0.8); 
            backdrop-filter: blur(10px); 
            border: 1px solid rgba(255, 255, 255, 0.3); 
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.07);
        }
        .status-timeline { display: flex; justify-content: space-between; margin-top: 10px; position: relative; }
        .status-step { flex: 1; text-align: center; font-size: 0.65rem; position: relative; color: #cbd5e1; }
        .status-step.active { color: #4f46e5; font-weight: 600; }
        .status-step.completed { color: #10b981; }
        .status-step::after { 
            content: ''; height: 2px; width: 100%; background: #e2e8f0; 
            position: absolute; top: -10px; left: 50%; z-index: 1;
        }
        .status-step:last-child::after { display: none; }
        .status-step .dot { 
            width: 10px; height: 10px; background: #e2e8f0; border-radius: 50%; 
            margin: 0 auto 5px; position: relative; z-index: 2; top: -14px;
        }
        .status-step.active .dot { background: #4f46e5; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2); }
        .status-step.completed .dot { background: #10b981; }
        .nav-tabs { border: none; gap: 10px; }
        .nav-link { border: none !important; border-radius: 12px !important; padding: 10px 20px !important; color: #64748b !important; }
        .nav-link.active { background: #4f46e5 !important; color: white !important; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2); }
        .form-control, .form-select { border-radius: 12px; padding: 12px; }
        .btn-primary { background: #4f46e5; border: none; border-radius: 12px; padding: 12px; }
    </style>
</head>
<body class="bg-light animate__animated animate__fadeIn">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand brand-logo fw-bold" href="#">
                <i class="bi bi-building-fill me-2"></i>Noor Hostels - Student Panel
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
                        <div class="card glass-card border-0">
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
                        <div class="card glass-card border-0">
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
                                                        <small class="text-muted"><%= sdfDate.format(c.getCreatedAt()) %></small><br>
                                                        <small class="text-muted"><%= sdfTime.format(c.getCreatedAt()) %></small>
                                                    </td>
                                                    <td>
                                                        <%= c.getDescription() %><br>
                                                        <% 
                                                            String urgencyClass = "bg-info";
                                                            if ("High".equals(c.getUrgency())) urgencyClass = "bg-danger";
                                                            else if ("Medium".equals(c.getUrgency())) urgencyClass = "bg-warning text-dark";
                                                        %>
                                                        <span class="badge <%= urgencyClass %>" style="font-size: 0.7rem;"><%= c.getUrgency() %></span>
                                                        <% if (c.getAdminComment() != null && !c.getAdminComment().isEmpty()) { %>
                                                            <div class="mt-2 p-2 rounded bg-light border-start border-primary border-4" style="font-size: 0.85rem;">
                                                                <strong class="text-primary"><i class="bi bi-info-circle me-1"></i>Admin Note:</strong> 
                                                                <span class="text-dark"><%= c.getAdminComment() %></span>
                                                            </div>
                                                        <% } %>
                                                    </td>
                                                    <td>
                                                        <% if (c.isStudentConfirmed()) { %>
                                                            <span class="badge bg-secondary">Closed</span>
                                                        <% } else if (c.isAdminConfirmed()) { %>
                                                            <span class="badge bg-success animate__animated animate__pulse animate__infinite">Resolved by Admin</span>
                                                        <% } else { %>
                                                            <span class="badge bg-warning text-dark">Pending</span>
                                                        <% } %>
                                                        
                                                        <!-- Status Timeline -->
                                                        <div class="status-timeline mt-3">
                                                            <div class="status-step completed">
                                                                <div class="dot"></div>
                                                                Sent
                                                            </div>
                                                            <div class="status-step <%= c.isAdminConfirmed() ? "completed" : "active" %>">
                                                                <div class="dot"></div>
                                                                In Progress
                                                            </div>
                                                            <div class="status-step <%= c.isStudentConfirmed() ? "completed" : (c.isAdminConfirmed() ? "active" : "") %>">
                                                                <div class="dot"></div>
                                                                Finished
                                                            </div>
                                                        </div>
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
    <script src="js/complaintActions.js"></script>
</body>
</html>
