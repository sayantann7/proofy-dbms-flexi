<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proofy - The Trusted Influencer Marketing Platform</title>
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
            --secondary: #eff6ff;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg);
            margin: 0;
            padding: 0;
            color: var(--text-main);
            overflow-x: hidden;
        }

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--surface);
            padding: 20px 50px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-brand {
            font-size: 28px;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            letter-spacing: -0.5px;
        }

        .navbar-nav {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .navbar-nav a {
            text-decoration: none;
            color: var(--text-main);
            font-weight: 600;
            transition: color 0.2s;
        }

        .navbar-nav a:hover {
            color: var(--primary);
        }

        .btn {
            padding: 12px 24px;
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s ease;
        }

        .btn:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
            padding: 10px 22px;
        }

        .btn-outline:hover {
            background-color: var(--secondary);
            color: var(--primary-hover);
        }

        /* Hero Section */
        .hero {
            padding: 100px 20px;
            text-align: center;
            background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);
        }

        .hero h1 {
            font-size: 56px;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 24px;
            letter-spacing: -1px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.2;
        }

        .hero .highlight {
            color: var(--primary);
        }

        .hero p {
            font-size: 20px;
            color: var(--text-muted);
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .hero-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
        }

        /* Features Section */
        .features {
            padding: 80px 50px;
            background-color: var(--surface);
            text-align: center;
        }

        .section-title {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .section-subtitle {
            font-size: 18px;
            color: var(--text-muted);
            margin-bottom: 60px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .feature-card {
            background: var(--bg);
            padding: 40px 30px;
            border-radius: 16px;
            border: 1px solid var(--border);
            text-align: left;
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05);
        }

        .feature-icon {
            font-size: 32px;
            color: var(--primary);
            margin-bottom: 20px;
        }

        .feature-card h3 {
            font-size: 22px;
            margin-bottom: 12px;
            color: var(--text-main);
        }

        .feature-card p {
            color: var(--text-muted);
            line-height: 1.6;
            margin: 0;
        }

        /* Two Column Section */
        .split-section {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 60px;
            padding: 80px 50px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .split-content {
            flex: 1;
        }

        .split-content h2 {
            font-size: 36px;
            margin-bottom: 20px;
        }

        .split-content p {
            font-size: 18px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .split-image {
            flex: 1;
            background: var(--surface);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
            border: 1px solid var(--border);
            text-align: center;
        }
        
        .mockup-item {
            background: var(--bg);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 1px solid var(--border);
        }

        /* Footer */
        .footer {
            background-color: var(--surface);
            padding: 40px 50px;
            text-align: center;
            border-top: 1px solid var(--border);
            color: var(--text-muted);
            margin-top: 40px;
        }

        @media (max-width: 768px) {
            .hero h1 { font-size: 40px; }
            .split-section { flex-direction: column; }
            .navbar { padding: 20px; flex-direction: column; gap: 15px; }
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/" class="navbar-brand">Proofy</a>
        <div class="navbar-nav">
            <a href="#features">Features</a>
            <a href="#how-it-works">How it Works</a>
            <a href="<%= request.getContextPath() %>/login" class="btn btn-outline" style="color: var(--primary);">Login</a>
            <a href="<%= request.getContextPath() %>/register" class="btn">Get Started</a>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero">
        <h1>Connecting Brands with Creators</h1>
        <p>Proofy leverages data-backed algorithms to calculate authentic credibility scores, ensuring brands partner with real influencers, not manipulated metrics.</p>
        <div class="hero-buttons">
            <a href="<%= request.getContextPath() %>/register" class="btn" style="padding: 16px 32px; font-size: 18px;">Join as a Brand</a>
            <a href="<%= request.getContextPath() %>/register" class="btn btn-outline" style="padding: 14px 30px; font-size: 18px;">I'm a Creator</a>
        </div>
    </header>

    <!-- Features Section -->
    <section id="features" class="features">
        <h2 class="section-title">Why Choose Proofy?</h2>
        <p class="section-subtitle">A database-managed solution built for transparency and performance.</p>
        
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🔍</div>
                <h3>SQL-Based Trust Scores</h3>
                <p>We analyze platform statistics using complex SQL functions and triggers to calculate a dynamic trust score for every creator, filtering out fake engagement.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🤝</div>
                <h3>Smart Matchmaking</h3>
                <p>Advanced querying recommends the most suitable creators to brands based on industry niche, budget constraints, and verified audience demographics.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Seamless Campaign Management</h3>
                <p>Track application statuses natively. Brands can review, approve, or reject creator proposals in real-time through an intuitive dashboard.</p>
            </div>
        </div>
    </section>

    <!-- Split Section (How it Works) -->
    <section id="how-it-works" class="split-section">
        <div class="split-image">
            <h3 style="margin-top:0; color:var(--text-main); font-size: 20px; margin-bottom: 20px;">Creator Match Engine</h3>
            <div class="mockup-item" style="display: flex; justify-content: space-between; align-items: center;">
                <div style="text-align: left;">
                    <div style="font-weight: 700; color: var(--text-main);">Alex TechReviews</div>
                    <div style="font-size: 13px; color: var(--text-muted);">Niche: Technology</div>
                </div>
                <div style="background: #d1fae5; color: #065f46; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700;">Score: 92/100</div>
            </div>
            <div class="mockup-item" style="display: flex; justify-content: space-between; align-items: center;">
                <div style="text-align: left;">
                    <div style="font-weight: 700; color: var(--text-main);">FitLife Sarah</div>
                    <div style="font-size: 13px; color: var(--text-muted);">Niche: Fitness & Health</div>
                </div>
                <div style="background: #d1fae5; color: #065f46; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700;">Score: 88/100</div>
            </div>
            <div class="mockup-item" style="display: flex; justify-content: space-between; align-items: center; opacity: 0.6;">
                <div style="text-align: left;">
                    <div style="font-weight: 700; color: var(--text-main);">Unknown User</div>
                    <div style="font-size: 13px; color: var(--text-muted);">Niche: Gaming</div>
                </div>
                <div style="background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700;">Flagged Risk</div>
            </div>
        </div>
        
        <div class="split-content">
            <h2>Powered by Robust Data Management</h2>
            <p>Proofy isn't just a UI; it's heavily backed by a strict relational database architecture. Data integrity is maintained through sophisticated constraints and triggers.</p>
            <p>When a creator updates their platform statistics, our backend automatically recalculates their credibility index. Brands only see what is verified, ensuring high ROI on marketing campaigns.</p>
            <a href="<%= request.getContextPath() %>/register" class="btn" style="margin-top: 10px;">Create an Account Today</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 Proofy Influencer Marketing Platform</p>
    </footer>

</body>
</html>