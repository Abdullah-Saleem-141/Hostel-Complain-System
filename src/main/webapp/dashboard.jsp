<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Complaint" %>
<%@ page import="dao.ComplaintDAO" %>
<%@ page import="dao.HostelDAO" %>
<%@ page import="models.Hostel" %>
<%
    // Session Check: Ensure user is logged in
    String adminUsername = (String) session.getAttribute("adminUsername");
    Integer adminId = (Integer) session.getAttribute("adminId");
    Integer hostelId = (Integer) session.getAttribute("hostelId");

    if (adminUsername == null || adminId == null || hostelId == null) {
        response.sendRedirect("admin_login.jsp?error=Please login first.");
        return; // Stop rendering
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Noor Hostels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f0f2f5; }
        .navbar { background: rgba(33, 37, 41, 0.9) !important; backdrop-filter: blur(10px); }
        .glass-card { 
            background: rgba(255, 255, 255, 0.7); 
            backdrop-filter: blur(15px); 
            border: 1px solid rgba(255, 255, 255, 0.3); 
            border-radius: 20px;
            transition: all 0.3s ease;
        }
        .glass-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .nav-tabs { border: none; gap: 10px; }
        .nav-link { 
            border: none !important; 
            border-radius: 12px !important; 
            padding: 12px 24px !important;
            color: #64748b !important;
            transition: all 0.3s;
        }
        .nav-link.active { 
            background: #4f46e5 !important; 
            color: white !important; 
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
        }
        .stats-icon { width: 48px; height: 48px; display: flex; align-items: center; justify-content: center; border-radius: 14px; }
        .complaint-card { border-radius: 20px; overflow: hidden; border: none; }
        .btn-success { background: #10b981; border: none; border-radius: 12px; padding: 10px; }
        .btn-warning { background: #f59e0b; border: none; border-radius: 12px; padding: 10px; }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark sticky-top shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-buildings-fill me-2"></i>Noor Hostels Admin
            </a>
            <div class="d-flex align-items-center">
                <span class="text-light me-3">Welcome, <strong><%= adminUsername %></strong></span>
                <a href="logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        
        <% 
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) { 
        %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <%= msg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-bold" id="complaints-tab" data-bs-toggle="tab" data-bs-target="#complaints" type="button" role="tab">Complaints</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="hostels-tab" data-bs-toggle="tab" data-bs-target="#hostels" type="button" role="tab">Manage Hostels</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab">Profile Settings</button>
            </li>
        </ul>

        <div class="tab-content" id="adminTabsContent">
            <!-- COMPLAINTS TAB -->
            <div class="tab-pane fade show active" id="complaints" role="tabpanel">
                
                <%
                    ComplaintDAO dao = new ComplaintDAO();
                    List<Complaint> allComplaints;
                    if ("Noor Hostels".equals(adminUsername)) {
                        allComplaints = dao.getAllPendingComplaints();
                    } else {
                        allComplaints = dao.getPendingComplaintsByHostel(hostelId);
                    }
                    
                    int total = allComplaints.size();
                    int highUrgency = 0;
                    int resolvedCount = 0;
                    for(Complaint c : allComplaints) {
                        if("High".equals(c.getUrgency())) highUrgency++;
                        if(c.isAdminConfirmed()) resolvedCount++;
                    }
                %>

                <!-- Summary Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card glass-card shadow-sm border-0 animate__animated animate__zoomIn">
                            <div class="card-body d-flex align-items-center p-4">
                                <div class="stats-icon bg-primary bg-opacity-10 me-3">
                                    <i class="bi bi-list-task text-primary fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="text-muted mb-0">Total Complaints</h6>
                                    <h3 class="fw-bold mb-0"><%= total %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card glass-card shadow-sm border-0 animate__animated animate__zoomIn" style="animation-delay: 0.1s;">
                            <div class="card-body d-flex align-items-center p-4">
                                <div class="stats-icon bg-danger bg-opacity-10 me-3">
                                    <i class="bi bi-exclamation-octagon text-danger fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="text-muted mb-0">High Urgency</h6>
                                    <h3 class="fw-bold mb-0 text-danger"><%= highUrgency %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card glass-card shadow-sm border-0 animate__animated animate__zoomIn" style="animation-delay: 0.2s;">
                            <div class="card-body d-flex align-items-center p-4">
                                <div class="stats-icon bg-success bg-opacity-10 me-3">
                                    <i class="bi bi-check-all text-success fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="text-muted mb-0">Fixed (Pending)</h6>
                                    <h3 class="fw-bold mb-0 text-success"><%= resolvedCount %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <%
                        HostelDAO hDao = new HostelDAO();
                        String currentHostelName = "Your Hostel";
                        for(Hostel h : hDao.getAllHostels()) {
                            if(h.getId() == hostelId) {
                                currentHostelName = h.getName();
                                break;
                            }
                        }
                    %>
                    <h4 class="fw-bold text-dark">
                        <% if ("Noor Hostels".equals(adminUsername)) { %>
                            Master Feed (All Hostels)
                        <% } else { %>
                            Recent Activity for <%= currentHostelName %>
                        <% } %>
                    </h4>
                    
                    <div class="d-flex">
                        <input type="text" id="searchInput" class="form-control form-control-sm me-2" style="width: 250px;" placeholder="Search Room or Name...">
                        <span class="badge bg-primary fs-6 py-2 px-3 d-flex align-items-center">Live Feed</span>
                    </div>
                </div>

                <%
                    if (allComplaints.isEmpty()) {
                %>
                    <div class="card text-center py-5 shadow-sm border-0 rounded-4">
                        <div class="card-body">
                            <h4 class="text-success fw-bold">All caught up!</h4>
                            <p class="text-muted">There are no pending complaints for your hostel.</p>
                        </div>
                    </div>
                <% } else { %>
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="complaintContainer">
                        <% for (Complaint c : allComplaints) { %>
                            <div class="col complaint-card" data-room="<%= c.getRoomNo() %>" data-name="<%= c.getStudentName().toLowerCase() %>">
                                <div class="card h-100 shadow-sm border-0 rounded-4 position-relative overflow-hidden">
                                    <% 
                                        String urgencyClass = "bg-info";
                                        boolean isHigh = "High".equals(c.getUrgency());
                                        if (isHigh) urgencyClass = "bg-danger pulse-warning";
                                        else if ("Medium".equals(c.getUrgency())) urgencyClass = "bg-warning text-dark";
                                    %>
                                    <div class="position-absolute top-0 end-0 p-2">
                                        <span class="badge <%= urgencyClass %> px-2 py-1"><%= c.getUrgency() %></span>
                                    </div>

                                    <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <h5 class="fw-bold mb-0 text-primary"><i class="bi bi-door-closed me-1"></i> Room <%= c.getRoomNo() %></h5>
                                            <div class="text-end me-5"> <!-- me-5 to avoid badge overlap -->
                                                <small class="text-muted d-block"><%= new java.text.SimpleDateFormat("MMM dd").format(c.getCreatedAt()) %></small>
                                                <small class="text-muted" style="font-size: 0.75rem;"><%= new java.text.SimpleDateFormat("hh:mm a").format(c.getCreatedAt()) %></small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <h6 class="card-subtitle mb-3 text-muted"><i class="bi bi-person me-1"></i><%= c.getStudentName() %></h6>
                                        <p class="card-text text-dark"><%= c.getDescription() %></p>
                                    </div>
                                    <div class="card-footer bg-white border-top-0 pb-4">
                                        <% if (!c.isAdminConfirmed()) { %>
                                            <form action="updateComplaint" method="POST">
                                                <input type="hidden" name="action" value="admin_fix">
                                                <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                                <button type="submit" class="btn btn-success w-100 fw-bold"><i class="bi bi-check-circle me-1"></i> Mark as Resolved</button>
                                            </form>
                                        <% } else { %>
                                            <form action="updateComplaint" method="POST" class="mb-2">
                                                <input type="hidden" name="action" value="admin_unresolve">
                                                <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                                <button type="submit" class="btn btn-warning w-100 fw-bold"><i class="bi bi-arrow-counterclockwise me-1"></i> Mark as Unresolved</button>
                                            </form>
                                            <button class="btn btn-secondary w-100 fw-bold" disabled>Awaiting Student Confirmation</button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- MANAGE HOSTELS TAB -->
            <div class="tab-pane fade" id="hostels" role="tabpanel">
                <div class="row">
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0 mb-4">
                            <div class="card-header bg-white pt-4 pb-0 border-bottom-0">
                                <h5 class="fw-bold text-primary">Add New Hostel</h5>
                            </div>
                            <div class="card-body">
                                <form action="manageHostels" method="POST">
                                    <input type="hidden" name="action" value="add">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Hostel Name</label>
                                        <input type="text" class="form-control" name="hostelName" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Add Hostel</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0 mb-4">
                            <div class="card-header bg-white pt-4 pb-0 border-bottom-0">
                                <h5 class="fw-bold text-primary">Rename Hostel</h5>
                            </div>
                            <div class="card-body">
                                <form action="manageHostels" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Select Hostel</label>
                                        <select class="form-select" name="hostelId" required>
                                            <%
                                                HostelDAO hostelDAO = new HostelDAO();
                                                List<Hostel> allHostels = hostelDAO.getAllHostels();
                                                for (Hostel h : allHostels) {
                                            %>
                                                <option value="<%= h.getId() %>"><%= h.getName() %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">New Name</label>
                                        <input type="text" class="form-control" name="hostelName" required>
                                    </div>
                                    <button type="submit" class="btn btn-warning text-dark fw-bold">Update Name</button>
                                </form>
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
                                <h5 class="fw-bold text-primary">Update Admin Profile</h5>
                            </div>
                            <div class="card-body">
                                <form action="adminProfile" method="POST">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">New Username</label>
                                        <input type="text" class="form-control" name="username" value="<%= adminUsername %>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">New Password</label>
                                        <input type="password" class="form-control" name="password" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Update Profile</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <style>
        .pulse-warning {
            animation: pulse-red 2s infinite;
            box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7);
        }
        @keyframes pulse-red {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 10px rgba(220, 53, 69, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(220, 53, 69, 0); }
        }
        .complaint-card { transition: all 0.3s ease; }
        .complaint-card:hover { transform: translateY(-5px); }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/complaintActions.js"></script>
    <script>
        // Live Search Filter
        document.getElementById('searchInput').addEventListener('keyup', function() {
            let filter = this.value.toLowerCase();
            let cards = document.querySelectorAll('.complaint-card');
            
            cards.forEach(card => {
                let room = card.getAttribute('data-room').toLowerCase();
                let name = card.getAttribute('data-name').toLowerCase();
                if (room.includes(filter) || name.includes(filter)) {
                    card.style.display = "";
                } else {
                    card.style.display = "none";
                }
            });
        });
    </script>
</body>
</html>
