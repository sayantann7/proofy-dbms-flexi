<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Proofy | Register</title>
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
    <script>
        function toggleFields() {
            var role = document.getElementById("role").value;
            document.getElementById("creator-fields").style.display = (role === 'creator') ? 'block' : 'none';
            document.getElementById("brand-fields").style.display = (role === 'brand') ? 'block' : 'none';
        }
        window.onload = toggleFields;
    </script>
</head>
<body>
    <div class="container">
        <h2>Register for Proofy</h2>
        <% if (request.getParameter("error") != null) { %>
            <div class="error"><%= request.getParameter("error") %></div>
        <% } %>
        
        <form action="register" method="POST">
            <label>Email:</label>
            <input type="email" name="email" required>
            
            <label>Password:</label>
            <input type="password" name="password" required>
            
            <label>Role:</label>
            <select name="role" id="role" onchange="toggleFields()" required>
                <option value="creator">Creator</option>
                <option value="brand">Brand</option>
            </select>
            
            <label>Name (Display Name / Brand Name):</label>
            <input type="text" name="name" required>
            
            <label id="niche-label">Niche / Industry:</label>
            <input type="text" name="nicheOrIndustry" required>
            
            <label id="audience-label">Audience Category / Website:</label>
            <input type="text" name="audienceOrWebsite" required>
            
            <div id="creator-fields" class="role-fields">
                <label>Bio (Creator Only):</label>
                <textarea name="bio" rows="3"></textarea>
            </div>
            
            <button type="submit">Register</button>
        </form>
        <p style="text-align:center; margin-top:1rem;">Already have an account? <a href="login">Login here</a></p>
    </div>
</body>
</html>