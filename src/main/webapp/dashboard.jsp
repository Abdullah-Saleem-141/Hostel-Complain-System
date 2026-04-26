<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Complaint" %>
<%@ page import="models.DeletionLog" %>
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
        return; 
    }
    
    // Super Admin check: If hostelId is 1, they are the Master Admin (Noor Hostels)
    boolean isSuperAdmin = (hostelId == 1);

    // Timezone Formatting for Pakistan (PKT)
    java.util.TimeZone tz = java.util.TimeZone.getTimeZone("Asia/Karachi");
    java.text.SimpleDateFormat sdfDateTime = new java.text.SimpleDateFormat("MMM dd, hh:mm a");
    java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("MMM dd, yyyy");
    sdfDateTime.setTimeZone(tz);
    sdfDate.setTimeZone(tz);
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
        .complaint-card { transition: all 0.3s ease; }
        .complaint-card:hover { transform: translateY(-5px); }
        .btn-success { background: #10b981; border: none; border-radius: 12px; padding: 10px; }
        .btn-warning { background: #f59e0b; border: none; border-radius: 12px; padding: 10px; }
        .btn-danger-soft { background: #fee2e2; color: #dc2626; border: none; border-radius: 12px; padding: 10px; transition: all 0.2s; }
        .btn-danger-soft:hover { background: #dc2626; color: white; }
        .history-row { background: white; border-radius: 15px; margin-bottom: 10px; border: 1px solid #e2e8f0; transition: all 0.2s; }
        .history-row:hover { border-color: #4f46e5; background: #f8fafc; }
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
                <a href="logout" class="btn btn-outline-light btn-sm rounded-pill px-3">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        
        <% 
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) { 
        %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <%= msg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-bold" id="complaints-tab" data-bs-toggle="tab" data-bs-target="#complaints" type="button" role="tab"><i class="bi bi-grid-fill me-2"></i>Active Feed</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button" role="tab"><i class="bi bi-clock-history me-2"></i>History</button>
            </li>
            <% if (isSuperAdmin) { %>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="hostels-tab" data-bs-toggle="tab" data-bs-target="#hostels" type="button" role="tab"><i class="bi bi-gear-fill me-2"></i>Manage Hostels</button>
            </li>
            <% } %>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab"><i class="bi bi-person-badge-fill me-2"></i>Profile</button>
            </li>
        </ul>

        <div class="tab-content" id="adminTabsContent">
            
            <!-- COMPLAINTS TAB -->
            <div class="tab-pane fade show active" id="complaints" role="tabpanel">
                <%
                    ComplaintDAO dao = new ComplaintDAO();
                    List<Complaint> allComplaints = isSuperAdmin ? dao.getAllPendingComplaints() : dao.getPendingComplaintsByHostel(hostelId);
                    
                    int total = allComplaints.size();
                    int highUrgency = 0;
                    for(Complaint c : allComplaints) {
                        if("High".equals(c.getUrgency())) highUrgency++;
                    }
                %>

                <!-- Summary Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-md-6">
                        <div class="card glass-card shadow-sm border-0 animate__animated animate__zoomIn">
                            <div class="card-body d-flex align-items-center p-4">
                                <div class="stats-icon bg-primary bg-opacity-10 me-3">
                                    <i class="bi bi-list-task text-primary fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="text-muted mb-0">Total Active Complaints</h6>
                                    <h3 class="fw-bold mb-0"><%= total %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card glass-card shadow-sm border-0 animate__animated animate__zoomIn" style="animation-delay: 0.1s;">
                            <div class="card-body d-flex align-items-center p-4">
                                <div class="stats-icon bg-danger bg-opacity-10 me-3">
                                    <i class="bi bi-exclamation-octagon text-danger fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="text-muted mb-0">High Urgency Tasks</h6>
                                    <h3 class="fw-bold mb-0 text-danger"><%= highUrgency %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold text-dark">
                        <%= isSuperAdmin ? "Master Activity Feed (All Hostels)" : "Recent Activity" %>
                    </h4>
                    <div class="d-flex">
                        <input type="text" id="searchInput" class="form-control me-2 rounded-pill px-3" style="width: 250px;" placeholder="Search Room or Name...">
                        <span class="badge bg-primary fs-6 py-2 px-3 d-flex align-items-center rounded-pill animate__animated animate__pulse animate__infinite">Live Feed</span>
                    </div>
                </div>

                <% if (allComplaints.isEmpty()) { %>
                    <div class="card text-center py-5 shadow-sm border-0 rounded-4 glass-card">
                        <div class="card-body">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
                            <h4 class="text-success fw-bold mt-3">All caught up!</h4>
                            <p class="text-muted">There are no pending complaints to display.</p>
                        </div>
                    </div>
                <% } else { %>
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="complaintContainer">
                        <% for (Complaint c : allComplaints) { %>
                            <div class="col complaint-card" data-room="<%= c.getRoomNo() %>" data-name="<%= c.getStudentName().toLowerCase() %>">
                                <div class="card h-100 shadow-sm border-0 rounded-4 position-relative overflow-hidden glass-card">
                                    <% 
                                        String urgencyClass = "bg-info";
                                        if ("High".equals(c.getUrgency())) urgencyClass = "bg-danger";
                                        else if ("Medium".equals(c.getUrgency())) urgencyClass = "bg-warning text-dark";
                                    %>
                                    <div class="position-absolute top-0 end-0 p-2">
                                        <span class="badge <%= urgencyClass %> px-2 py-1 rounded-pill"><%= c.getUrgency() %></span>
                                    </div>

                                    <div class="card-header bg-transparent border-bottom-0 pt-4 pb-0">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <h5 class="fw-bold mb-0 text-primary">Room <%= c.getRoomNo() %></h5>
                                            <div class="text-end me-5">
                                                <small class="text-muted d-block" style="font-size: 0.7rem;"><%= sdfDateTime.format(c.getCreatedAt()) %></small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <h6 class="card-subtitle mb-3 text-muted fw-bold"><i class="bi bi-person me-1"></i><%= c.getStudentName() %></h6>
                                        <p class="card-text text-dark"><%= c.getDescription() %></p>
                                        <% if(isSuperAdmin) { %>
                                            <div class="mb-2"><span class="badge bg-secondary rounded-pill"><i class="bi bi-buildings me-1"></i><%= c.getHostelName() %></span></div>
                                        <% } %>
                                    </div>
                                    <div class="card-footer bg-transparent border-top-0 pb-4">
                                        <div class="d-grid gap-2">
                                            <% if (!c.isAdminConfirmed()) { %>
                                                <form action="updateComplaint" method="POST">
                                                    <input type="hidden" name="action" value="admin_fix">
                                                    <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                                    <button type="submit" class="btn btn-success w-100 fw-bold"><i class="bi bi-check-circle me-1"></i> Mark as Resolved</button>
                                                </form>
                                            <% } else { %>
                                                <form action="updateComplaint" method="POST">
                                                    <input type="hidden" name="action" value="admin_unresolve">
                                                    <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                                    <button type="submit" class="btn btn-warning w-100 fw-bold text-dark"><i class="bi bi-arrow-counterclockwise me-1"></i> Undo Fix</button>
                                                </form>
                                            <% } %>
                                            
                                            <!-- DELETE OPTION -->
                                            <button type="button" class="btn btn-danger-soft fw-bold" onclick="confirmDelete(<%= c.getId() %>)">
                                                <i class="bi bi-trash3 me-1"></i> Delete Permanent
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- HISTORY TAB -->
            <div class="tab-pane fade" id="history" role="tabpanel">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 glass-card p-4">
                            <h4 class="fw-bold mb-4"><i class="bi bi-patch-check-fill text-success me-2"></i>Resolved History</h4>
                            <%
                                List<Complaint> history = isSuperAdmin ? dao.getAllResolvedHistory() : dao.getResolvedHistoryByHostel(hostelId);
                                if(history.isEmpty()) {
                            %>
                                <p class="text-muted text-center py-4">No resolved complaints yet.</p>
                            <% } else { %>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>Room</th>
                                                <th>Student</th>
                                                <th>Issue</th>
                                                <th>Resolved At</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for(Complaint h : history) { %>
                                                <tr>
                                                    <td class="fw-bold">R-<%= h.getRoomNo() %></td>
                                                    <td><%= h.getStudentName() %></td>
                                                    <td><small><%= h.getDescription() %></small></td>
                                                    <td><span class="badge bg-light text-dark"><%= sdfDate.format(h.getResolvedAt()) %></span></td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 glass-card p-4">
                            <h4 class="fw-bold mb-4"><i class="bi bi-trash3-fill text-danger me-2"></i>Delete History</h4>
                            <%
                                List<DeletionLog> deleteLogs = dao.getDeletionHistory();
                                if(deleteLogs.isEmpty()) {
                            %>
                                <p class="text-muted text-center py-4">No deletion records.</p>
                            <% } else { %>
                                <% for(DeletionLog log : deleteLogs) { %>
                                    <div class="p-3 border-bottom mb-2 history-row">
                                        <div class="d-flex justify-content-between">
                                            <span class="fw-bold text-danger">Deleted Request #<%= log.getComplaintId() %></span>
                                            <small class="text-muted"><%= sdfDateTime.format(log.getDeletedAt()) %></small>
                                        </div>
                                        <div class="mt-1"><small><strong>By:</strong> <%= log.getAdminName() %></small></div>
                                        <div class="mt-1"><small><strong>From:</strong> <%= log.getStudentName() %> (Room <%= log.getRoomNo() %>)</small></div>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- MANAGE HOSTELS TAB (Super Admin Only) -->
            <% if(isSuperAdmin) { %>
            <div class="tab-pane fade" id="hostels" role="tabpanel">
                <div class="row">
                    <div class="col-md-6">
                        <div class="card glass-card shadow-sm border-0 mb-4 p-4">
                            <h5 class="fw-bold text-primary mb-3">Add New Hostel</h5>
                            <form action="manageHostels" method="POST">
                                <input type="hidden" name="action" value="add">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Hostel Name</label>
                                    <input type="text" class="form-control rounded-3" name="hostelName" required placeholder="e.g., Sir Syed Hall">
                                </div>
                                <button type="submit" class="btn btn-primary px-4 rounded-pill">Create Hostel</button>
                            </form>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card glass-card shadow-sm border-0 mb-4 p-4">
                            <h5 class="fw-bold text-warning mb-3">Rename Existing Hostel</h5>
                            <form action="manageHostels" method="POST">
                                <input type="hidden" name="action" value="update">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Select Hostel</label>
                                    <select class="form-select rounded-3" name="hostelId" required>
                                        <%
                                            HostelDAO hDAO = new HostelDAO();
                                            for (Hostel h : hDAO.getAllHostels()) {
                                        %>
                                            <option value="<%= h.getId() %>"><%= h.getName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">New Name</label>
                                    <input type="text" class="form-control rounded-3" name="hostelName" required>
                                </div>
                                <button type="submit" class="btn btn-warning text-dark fw-bold px-4 rounded-pill">Save Changes</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- PROFILE SETTINGS TAB -->
            <div class="tab-pane fade" id="profile" role="tabpanel">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card glass-card shadow-sm border-0 p-4">
                            <h5 class="fw-bold text-primary mb-3">Admin Profile Information</h5>
                            <form action="adminProfile" method="POST">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Dashboard Username</label>
                                    <input type="text" class="form-control rounded-3" name="username" value="<%= adminUsername %>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Security Password</label>
                                    <input type="password" class="form-control rounded-3" name="password" required placeholder="Update your password">
                                </div>
                                <button type="submit" class="btn btn-primary px-4 rounded-pill fw-bold">Apply Profile Updates</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

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
                card.style.display = (room.includes(filter) || name.includes(filter)) ? "" : "none";
            });
        });

        // SweetAlert Delete Confirmation
        function confirmDelete(id) {
            Swal.fire({
                title: 'Are you sure?',
                text: "This complaint will be permanently removed from the active list and logged in deletion history.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc2626',
                cancelButtonColor: '#64748b',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'updateComplaint';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'admin_delete';
                    form.appendChild(actionInput);
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'complaintId';
                    idInput.value = id;
                    form.appendChild(idInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    </script>
</body>
</html>
