<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Noor Hostels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f8faff; }
        .login-card { border-radius: 24px; border: none; box-shadow: 0 10px 40px rgba(0,0,0,0.05); overflow: hidden; }
        .btn-primary { background: #4f46e5; border: none; padding: 12px; border-radius: 12px; font-weight: 600; transition: all 0.3s; }
        .btn-primary:hover { background: #4338ca; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(79, 70, 229, 0.4); }
        .form-control { border-radius: 12px; padding: 12px; border: 1px solid #e2e8f0; }
        .form-control:focus { box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); border-color: #4f46e5; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100 animate__animated animate__fadeIn">

    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand brand-logo text-primary fw-bold" href="index.jsp">
                <i class="bi bi-buildings-fill me-2"></i>Noor Hostels Admin
            </a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="index.jsp">Back to Student Portal</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container flex-grow-1 d-flex align-items-center justify-content-center mt-5">
        <div class="col-md-5">
            
            <% 
                String error = request.getParameter("error");
                if (error != null) { 
            %>
                <div class="alert alert-danger text-center" role="alert">
                    <%= error %>
                </div>
            <% } %>

            <div class="card shadow-lg border-0 rounded-4 login-card">
                <div class="card-body p-5">
                    <div class="text-center mb-4">
                        <h2 class="fw-bold text-primary">Admin Access</h2>
                        <p class="text-muted">Sign in to manage hostel complaints</p>
                    </div>

                    <form action="adminLogin" method="POST">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Username</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="e.g. admin_jinnah" required>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold">Secure Login</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
