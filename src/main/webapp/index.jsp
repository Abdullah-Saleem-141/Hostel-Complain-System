<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Noor Enterprises - Hostel Complaint Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            color: white;
            padding: 100px 0;
            border-bottom-left-radius: 50px;
            border-bottom-right-radius: 50px;
            margin-bottom: 50px;
        }
        .portal-card {
            transition: transform 0.3s;
            cursor: pointer;
        }
        .portal-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand brand-logo fw-bold text-primary" href="index.jsp">
                <i class="bi bi-buildings"></i> Noor Enterprises
            </a>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-3">Hostel Complaint Portal</h1>
            <p class="lead mb-4">Fast, reliable, and trackable maintenance for your hostel room.</p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mb-5">
        <div class="row justify-content-center g-4">
            
            <!-- Student Portal -->
            <div class="col-md-5">
                <div class="card h-100 shadow-sm border-0 portal-card" onclick="location.href='student_login.jsp'">
                    <div class="card-body text-center p-5">
                        <i class="bi bi-mortarboard text-primary" style="font-size: 4rem;"></i>
                        <h3 class="fw-bold mt-3">Student Portal</h3>
                        <p class="text-muted">Login to submit new complaints, track existing issues, and confirm maintenance fixes.</p>
                        <a href="student_login.jsp" class="btn btn-outline-primary mt-3 px-4 rounded-pill">Login as Student</a>
                    </div>
                </div>
            </div>

            <!-- Admin Portal -->
            <div class="col-md-5">
                <div class="card h-100 shadow-sm border-0 portal-card" onclick="location.href='admin_login.jsp'">
                    <div class="card-body text-center p-5">
                        <i class="bi bi-person-badge text-primary" style="font-size: 4rem;"></i>
                        <h3 class="fw-bold mt-3">Admin Portal</h3>
                        <p class="text-muted">Login to manage hostel maintenance requests, update status, and track history.</p>
                        <a href="admin_login.jsp" class="btn btn-outline-primary mt-3 px-4 rounded-pill">Login as Admin</a>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Footer -->
    <footer class="footer-custom text-center py-4 bg-white mt-auto border-top">
        <div class="container">
            <p class="mb-0 text-muted">&copy; 2026 Noor Enterprises - Hostel Management. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
