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
    <title>Proofy - Brand Dashboard</title>
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
        <h2>Brand Dashboard</h2>
        <div>
            <a href="${pageContext.request.contextPath}/edit-profile" style="color: #007bff; text-decoration: none; font-weight: bold; margin-right: 15px;">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/login.jsp" style="color: #dc3545; text-decoration: none; font-weight: bold;">Logout</a>
        </div>
    </div>
    
    <div class="card">
        <h3>Welcome, ${brand != null ? brand.brandName : 'Brand Owner'}!</h3>
        <p><strong>Industry:</strong> ${brand.industry}</p>
        <p><strong>Website:</strong> <a href="${brand.website}" target="_blank">${brand.website}</a></p>
    </div>

    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h3>Top Recommended Creators (Ranked by SQL-Based Trust Score)</h3>
            <a href="${pageContext.request.contextPath}/brand/create-campaign" style="background-color: #28a745; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px; font-weight: bold;">+ New Campaign</a>
        </div>
        <p>Find the best creators matched exclusively by raw data and our advanced logic.</p>
        <table>
            <thead>
                <tr>
                    <th>Creator Name</th>
                    <th>Niche</th>
                    <th>Audience Category</th>
                    <th>Trust Score</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="cr" items="${topCreators}">
                    <tr>
                        <td>${cr.displayName}</td>
                        <td>${cr.niche}</td>
                        <td>${cr.audienceCategory}</td>
                        <td><span class="score-badge">${cr.trustScore}</span></td>
                        <td><a style="color: #007bff; text-decoration: none; font-weight: bold;" href="${pageContext.request.contextPath}/brand/creator-details?id=${cr.creatorId}">View Details</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="card">
        <h3>My Active Campaigns</h3>
        <table>
            <tr>
                <th>Title</th>
                <th>Dates</th>
                <th>Budget</th>
                <th>Niche Required</th>
                <th>Status</th>
            </tr>
            <c:forEach var="camp" items="${campaigns}">
                <tr>
                    <td><strong>${camp.title}</strong></td>
                    <td>${camp.startDate} to ${camp.endDate}</td>
                    <td>$${camp.budget}</td>
                    <td>${camp.niche}</td>
                    <td><span style="color: ${camp.status == 'active' ? '#28a745' : '#dc3545'};">${camp.status}</span></td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <div class="card">
        <h3>Campaign Applications</h3>
        <table>
            <tr>
                <th>Creator Name</th>
                <th>Campaign</th>
                <th>Applied At</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            <c:forEach var="app" items="${applications}">
                <tr>
                    <td>${app.creatorName}</td>
                    <td>${app.campaignTitle}</td>
                    <td>${app.appliedAt}</td>
                    <td>
                        <span style="color: ${app.status == 'accepted' ? 'green' : (app.status == 'rejected' ? 'red' : 'orange')}; font-weight: bold;">
                            ${app.status}
                        </span>
                    </td>
                    <td>
                        <c:if test="${app.status == 'pending'}">
                            <form action="${pageContext.request.contextPath}/brand/manage-application" method="post" style="display:inline;">
                                <input type="hidden" name="applicationId" value="${app.applicationId}">
                                <input type="hidden" name="action" value="accept">
                                <button type="submit" style="background-color: #28a745; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">Accept</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/brand/manage-application" method="post" style="display:inline;">
                                <input type="hidden" name="applicationId" value="${app.applicationId}">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">Reject</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</body>
</html>
