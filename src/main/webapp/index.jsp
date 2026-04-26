<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Noor Hostels - Hostel Complaint Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f8faff; }
        .hero-section {
            background: linear-gradient(135deg, #4f46e5 0%, #0ea5e9 100%);
            color: white;
            padding: 120px 0;
            border-bottom-left-radius: 60px;
            border-bottom-right-radius: 60px;
            margin-bottom: 60px;
            box-shadow: 0 10px 30px rgba(79, 70, 229, 0.2);
        }
        .portal-card {
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.8);
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            cursor: pointer;
            overflow: hidden;
        }
        .portal-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            background: #fff;
        }
        .portal-card .icon-wrapper {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            background: rgba(79, 70, 229, 0.1);
            color: #4f46e5;
            transition: all 0.3s ease;
        }
        .portal-card:hover .icon-wrapper {
            background: #4f46e5;
            color: #fff;
            transform: rotate(10deg);
        }
        .brand-logo { font-weight: 700; font-size: 1.5rem; letter-spacing: -0.5px; }
    </style>
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand brand-logo text-primary" href="index.jsp">
                <i class="bi bi-buildings-fill me-2"></i>Noor Hostels
            </a>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section text-center animate__animated animate__fadeInDown">
        <div class="container">
            <h1 class="display-3 fw-bold mb-3">Hostel Complaint Portal</h1>
            <p class="lead mb-4 opacity-75">Fast, reliable, and trackable maintenance for your hostel room.</p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mb-5">
        <div class="row justify-content-center g-4">
            
            <!-- Student Portal -->
            <div class="col-md-5 animate__animated animate__fadeInLeft">
                <div class="card h-100 shadow-sm portal-card" onclick="location.href='student_login.jsp'">
                    <div class="card-body text-center p-5">
                        <div class="icon-wrapper">
                            <i class="bi bi-mortarboard" style="font-size: 2.5rem;"></i>
                        </div>
                        <h3 class="fw-bold mt-3">Student Portal</h3>
                        <p class="text-muted">Login to submit new complaints, track existing issues, and confirm maintenance fixes.</p>
                        <a href="student_login.jsp" class="btn btn-primary mt-3 px-5 rounded-pill fw-bold shadow-sm">Login as Student</a>
                    </div>
                </div>
            </div>

            <!-- Admin Portal -->
            <div class="col-md-5 animate__animated animate__fadeInRight">
                <div class="card h-100 shadow-sm portal-card" onclick="location.href='admin_login.jsp'">
                    <div class="card-body text-center p-5">
                        <div class="icon-wrapper">
                            <i class="bi bi-shield-lock" style="font-size: 2.5rem;"></i>
                        </div>
                        <h3 class="fw-bold mt-3">Admin Portal</h3>
                        <p class="text-muted">Login to manage hostel maintenance requests, update status, and track history.</p>
                        <a href="admin_login.jsp" class="btn btn-outline-primary mt-3 px-5 rounded-pill fw-bold">Login as Admin</a>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Footer -->
    <footer class="footer-custom text-center py-5 bg-white mt-auto border-top">
        <div class="container">
            <p class="mb-0 text-muted">&copy; 2026 Noor Hostels - Smart Hostel Management. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
