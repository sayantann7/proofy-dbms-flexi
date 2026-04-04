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
    <title>Proofy - Creator Dashboard</title>
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
        <h2>Creator Dashboard</h2>
        <div>
            <a href="${pageContext.request.contextPath}/edit-profile" style="color: #007bff; text-decoration: none; font-weight: bold; margin-right: 15px;">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/login.jsp" style="color: #dc3545; text-decoration: none; font-weight: bold;">Logout</a>
        </div>
    </div>
    
    <div class="card">
        <h3>Welcome, ${creator != null ? creator.displayName : 'Creator'}!</h3>
        <p><strong>Niche:</strong> ${creator.niche}</p>
        <p><strong>Audience Category:</strong> ${creator.audienceCategory}</p>
        <p><strong>Bio:</strong> ${creator.bio != null ? creator.bio : 'No bio provided.'}</p>
    </div>

    <div class="stats-grid">
        <div class="stat-box">
            <div>Credibility Trust Score</div>
            <div class="stat-value score-value">${creator.trustScore} / 100</div>
        </div>
        <div class="stat-box">
            <div>Completed Campaigns</div>
            <div class="stat-value">0</div>
        </div>
        <div class="stat-box">
            <div>Active Disputes</div>
            <div class="stat-value" style="color: #dc3545;">0</div>
        </div>
    </div>

    <div style="display: flex; gap: 20px; margin-top: 20px;">
        <div class="card" style="flex: 1;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h3>My Linked Platforms</h3>
                <a href="${pageContext.request.contextPath}/edit-stats.jsp" style="background-color: #28a745; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 14px;">Update Stats</a>
            </div>
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <tr style="background-color: #f4f4f4;">
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Platform</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Followers</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Engagement</th>
                </tr>
                <c:forEach var="stat" items="${stats}">
                    <tr>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${stat.platformName}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${stat.followers}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${stat.avgEngagement}%</td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div class="card" style="flex: 1;">
            <h3>Trust Score Details</h3>
            <p style="font-size: 14px; color: #555; background: #eef2f5; padding: 10px; border-radius: 4px; border-left: 4px solid #007bff;">
                <strong>How is this calculated?</strong><br>
                We use an unbiased, strictly data-driven SQL algorithm that updates daily without AI assumptions.<br>
                <em>Formula: final_score = (0.4 × Audience Match) + (0.3 × Past Conversion) + (0.2 × Delivery) - (0.1 × Disputes)</em>
            </p>
            <c:if test="${not empty score}">
                <p><strong>Audience Match (40%):</strong> <span style="float: right;">${score.audienceMatch}</span></p>
                <div style="font-size: 12px; color: #666; margin-bottom: 5px;">Based on how well your follower demographics align with brand requirements.</div>
                <div style="background-color: #e9ecef; height: 8px; border-radius: 4px; margin-bottom: 15px;"><div style="background-color: #28a745; width: ${score.audienceMatch}%; height: 100%; border-radius: 4px;"></div></div>

                <p><strong>Past Conversion (30%):</strong> <span style="float: right;">${score.pastConversionRate}</span></p>
                <div style="font-size: 12px; color: #666; margin-bottom: 5px;">Calculated from the click-through and purchase percentages of your past deliverables.</div>
                <div style="background-color: #e9ecef; height: 8px; border-radius: 4px; margin-bottom: 15px;"><div style="background-color: #28a745; width: ${score.pastConversionRate}%; height: 100%; border-radius: 4px;"></div></div>

                <p><strong>Delivery Reliability (20%):</strong> <span style="float: right;">${score.deliveryReliability}</span></p>
                <div style="font-size: 12px; color: #666; margin-bottom: 5px;">Tracks your history of submitting deliverables before deadlines.</div>
                <div style="background-color: #e9ecef; height: 8px; border-radius: 4px; margin-bottom: 15px;"><div style="background-color: #28a745; width: ${score.deliveryReliability}%; height: 100%; border-radius: 4px;"></div></div>

                <p><strong>Dispute Penalty (10%):</strong> <span style="float: right; color: #dc3545;">-${score.disputePenalty}</span></p>
                <div style="font-size: 12px; color: #666; margin-bottom: 5px;">Negative points applied automatically by admin rulings or unfulfilled campaigns.</div>
            </c:if>
            <c:if test="${empty score}">
                <p>No score calculation history found.</p>
            </c:if>
        </div>
    <div style="display: flex; gap: 20px; margin-top: 20px;">
        <div class="card" style="flex: 1;">
            <h3>Active Campaigns</h3>
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <tr style="background-color: #f4f4f4;">
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Brand</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Title</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Niche</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Budget</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Action</th>
                </tr>
                <c:forEach var="camp" items="${activeCampaigns}">
                    <tr>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${camp.brandName}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${camp.title}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${camp.niche}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">$${camp.budget}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">
                            <form action="${pageContext.request.contextPath}/creator/apply-campaign" method="post" style="margin:0;">
                                <input type="hidden" name="campaignId" value="${camp.campaignId}">
                                <button type="submit" style="background-color: #28a745; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">Apply</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <div class="card" style="flex: 1;">
            <h3>My Applications</h3>
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <tr style="background-color: #f4f4f4;">
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Campaign</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Applied At</th>
                    <th style="padding: 10px; border-bottom: 1px solid #ddd;">Status</th>
                </tr>
                <c:forEach var="app" items="${myApplications}">
                    <tr>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${app.campaignTitle}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">${app.appliedAt}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #ddd;">
                            <span style="color: ${app.status == 'accepted' ? 'green' : (app.status == 'rejected' ? 'red' : 'orange')}; font-weight: bold;">
                                ${app.status}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
</body>
</html>
