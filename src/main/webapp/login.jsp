<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Proofy - Login</title>
    <style>

        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --bg: #f8fafc;
            --surface: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --error: #ef4444;
            --success: #10b981;
        }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; color: var(--text-main); }
        .login-container, .container { background: var(--surface); padding: 40px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05), 0 4px 6px -4px rgba(0,0,0,0.05); width: 100%; max-width: 400px; border: 1px solid rgba(0,0,0,0.05); }
        h2 { text-align: center; color: var(--text-main); font-weight: 700; margin-bottom: 24px; font-size: 24px; }
        .form-group, label { display: block; margin-bottom: 8px; color: var(--text-main); font-weight: 500; font-size: 14px; }
        input, select, textarea { width: 100%; padding: 12px 16px; margin-bottom: 16px; border: 1px solid var(--border); border-radius: 8px; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; font-size: 15px; transition: all 0.2s ease; background-color: #f8fafc; color: var(--text-main); }
        input:focus, select:focus, textarea:focus { outline: none; border-color: var(--primary); background-color: #fff; box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }
        button, .btn { width: 100%; padding: 14px; background-color: var(--primary); color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: 600; font-family: 'Plus Jakarta Sans', sans-serif; transition: background-color 0.2s ease; }
        button:hover, .btn:hover { background-color: var(--primary-hover); }
        .error { color: var(--error); text-align: center; margin-bottom: 16px; font-size: 14px; font-weight: 500; background: #fef2f2; padding: 10px; border-radius: 6px;}
        a { color: var(--primary); text-decoration: none; font-weight: 600; }
        a:hover { text-decoration: underline; }

    </style>
</head>
<body>
    <div class="login-container">
        <h2>Proofy Login</h2>
        <% if (request.getParameter("success") != null) { %>
            <div style="color: green; text-align: center; margin-bottom: 10px;"><%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/login" method="post">     
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>  
            </div>
            <button type="submit" class="btn">Login</button>
        </form>
        <p style="text-align: center; margin-top: 15px;">
            Don't have an account? <a href="<%= request.getContextPath() %>/register">Register here</a>
        </p>
    </div>
</body>
</html>
