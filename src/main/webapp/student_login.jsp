<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login - Noor Hostels</title>
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
<body class="bg-light animate__animated animate__fadeIn">

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="text-center mb-4">
                    <h2 class="fw-bold text-primary">Noor Hostels</h2>
                    <p class="text-muted">Student Login</p>
                </div>
                
                <% 
                    String msg = request.getParameter("msg");
                    String error = request.getParameter("error");
                    if (msg != null) { 
                %>
                    <div class="alert alert-success"><%= msg %></div>
                <% } else if (error != null) { %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>

                <div class="card shadow-sm border-0 login-card">
                    <div class="card-body p-4">
                        <form action="studentAuth" method="POST">
                            <input type="hidden" name="action" value="login">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Username</label>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Password</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>
                        </form>
                        <div class="text-center">
                            <p class="mb-0">Don't have an account? <a href="student_register.jsp">Register here</a></p>
                            <p class="mt-2"><a href="index.jsp" class="text-muted">Back to Home</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
