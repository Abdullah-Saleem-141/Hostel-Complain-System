<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login - Noor Enterprises</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="text-center mb-4">
                    <h2 class="fw-bold text-primary">Noor Enterprises</h2>
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

                <div class="card shadow-sm border-0">
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
