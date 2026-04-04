<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Proofy - Edit Profile</title>
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
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
        }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); margin: 0; padding: 30px; color: var(--text-main); }
        h1, h2, h3, h4, h5, h6 { color: var(--text-main); font-weight: 700; margin: 0; margin-bottom: 16px; }
        a { color: var(--primary); text-decoration: none; font-weight: 600; }
        a:hover { color: var(--primary-hover); }
        .header { display: flex; justify-content: space-between; align-items: center; background: var(--surface); padding: 20px 30px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 30px; border: 1px solid rgba(0,0,0,0.05);}
        .header h2 { margin: 0; font-size: 24px; }
        .card { background: var(--surface); padding: 24px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 24px; border: 1px solid rgba(0,0,0,0.05); }
        .card > h3 { margin-top: 0; margin-bottom: 16px; font-weight: 600; color: var(--text-main); font-size: 18px; border-bottom: 1px solid var(--border); padding-bottom: 12px;}
        table { width: 100%; border-collapse: separate; border-spacing: 0; text-align: left; }
        th { background-color: var(--bg); padding: 14px 16px; font-weight: 600; color: var(--text-muted); font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid var(--border); }
        td { padding: 16px; border-bottom: 1px solid var(--border); font-size: 15px; color: var(--text-main); }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: var(--bg); }
        .btn { padding: 10px 16px; background-color: var(--primary); color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; font-family: 'Plus Jakarta Sans', sans-serif; transition: background 0.2s; text-align: center; border: 1px solid transparent;}
        .btn:hover { background-color: var(--primary-hover); }
        .btn-success { background-color: var(--success); }
        .btn-success:hover { background-color: #059669; }
        .btn-danger { background-color: var(--danger); }
        .btn-danger:hover { background-color: #dc2626; }
        .cancel-btn { background-color: white; color: var(--text-main); border: 1px solid var(--border); }
        .cancel-btn:hover { background-color: var(--bg); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; color: var(--text-main); }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 12px 16px; border: 1px solid var(--border); border-radius: 8px; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; font-size: 15px; background: var(--bg); transition: all 0.2s; color: var(--text-main); }
        .form-group input:focus, .form-group textarea:focus, .form-group select:focus { outline: none; border-color: var(--primary); background: #fff; box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }
        .badge { display: inline-block; padding: 6px 12px; border-radius: 9999px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge-active { background-color: #d1fae5; color: #065f46; }
        .badge-pending { background-color: #fef3c7; color: #92400e; }
        .badge-rejected { background-color: #fee2e2; color: #991b1b; }
        p { line-height: 1.6; color: var(--text-muted); }
        strong { color: var(--text-main); }

    </style>
</head>
<body>
    <div class="header">
        <h2>Edit Profile</h2>
    </div>

    <div class="card">
        <c:if test="${not empty errorMessage}">
            <p style="color: red; text-align: center;">${errorMessage}</p>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/edit-profile" method="post">
            
            <c:choose>
                <c:when test="${userRole == 'creator'}">
                    <h3>Update Creator Profile</h3>
                    <div class="form-group">
                        <label>Display Name</label>
                        <input type="text" name="displayName" value="${creator.displayName}" required>
                    </div>
                    <div class="form-group">
                        <label>Niche</label>
                        <input type="text" name="niche" value="${creator.niche}" required placeholder="e.g. Fitness">
                    </div>
                    <div class="form-group">
                        <label>Audience Category</label>
                        <input type="text" name="audienceCategory" value="${creator.audienceCategory}" required placeholder="e.g. Men 18-35">
                    </div>
                    <div class="form-group">
                        <label>Bio</label>
                        <textarea name="bio" rows="4">${creator.bio}</textarea>
                    </div>
                    <button type="submit" class="btn">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/creator/dashboard" class="btn cancel-btn">Cancel</a>
                </c:when>
                
                <c:when test="${userRole == 'brand'}">
                    <h3>Update Brand Profile</h3>
                    <div class="form-group">
                        <label>Brand Name</label>
                        <input type="text" name="brandName" value="${brand.brandName}" required>
                    </div>
                    <div class="form-group">
                        <label>Industry</label>
                        <input type="text" name="industry" value="${brand.industry}" required>
                    </div>
                    <div class="form-group">
                        <label>Website</label>
                        <input type="url" name="website" value="${brand.website}" required>
                    </div>
                    <button type="submit" class="btn">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/brand/dashboard" class="btn cancel-btn">Cancel</a>
                </c:when>
            </c:choose>

        </form>
    </div>
</body>
</html>