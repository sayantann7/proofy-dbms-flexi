# Proofy - Data-Driven Influencer Marketplace

## Introduction
Social media marketing has become one of the most important ways for businesses to promote their products. However, today’s influencer platforms mostly work on assumptions such as follower count, likes, and star ratings. These values can be misleading.

**Proofy** is a full-stack web platform that connects business owners (Brands) and social media creators (Influencers) using **data-driven matching** instead of artificial intelligence or black-box machine learning.

The system uses **only database logic, SQL queries, and backend rules** to decide which creator is best suited for a brand’s campaign. This platform proves that a powerful, fair marketplace can be built using only strong database design and intelligent SQL.

---

## Core Features
*   **Two-Sided Marketplace**: Distinct experiences, dashboards, and capabilities for both **Creators** and **Brands**.
*   **SQL-Based Matching Algorithm**: Creators receive a "Trust Score" based entirely on hard data (Audience relevance, past conversion rates, delivery reliability, and dispute history).
*   **Transparent Analytics View**: Creators can see exactly *how* their score is calculated out of 100 with a detailed metric breakdown.
*   **Campaign Management**: Brands can create campaigns with strict requirements (niche, min engagement, target audience).
*   **Full Application Flow**: Creators can discover active campaigns and apply. Brands can review applicants and strictly Accept or Reject them.
*   **Profile Management**: Both entities can update their profiles, niches, and platform statistics seamlessly.

---

## Technology Stack
*   **Backend Paradigm**: Pure Core Java Web MVC (No Spring Boot / No Frameworks)
*   **Programming Language**: Java 17
*   **Web API**: Jakarta EE (Servlets, JSP, JSTL) - *Compatible with Tomcat 11*
*   **Database**: MySQL 8.0 (utilizing advanced SQL Views, Triggers, and Stored Procedures)
*   **Build Tool**: Apache Maven
*   **Server**: Apache Tomcat 11
*   **Frontend**: HTML, CSS, JSP Expression Language (EL)

---

## Architecture & Directory Structure

The application strictly follows the **Model-DAO-Service-Controller** layered MVC architecture pattern.

```text
proofy-dbms-flexi-main/
│
├── db/
│   └── db.sql                  # The core database schema, seed data, and Triggers.
│
├── pom.xml                     # Maven configuration, handles packaging to .war and dependencies.
│
└── src/main/
    ├── java/com/proofy/
    │   ├── model/              # POJOs (Plain Old Java Objects). Map exactly to DB entities.
    │   │   ├── Brand.java, Campaign.java, Creator.java, User.java, etc.
    │   │
    │   ├── dao/                # Data Access Objects. Pure JDBC PreparedStatement logic.
    │   │   ├── BrandDAO.java, CampaignDAO.java, CreatorDAO.java, UserDAO.java, etc.
    │   │
    │   ├── service/            # Business Logic Layer. Acts as the bridge between DAOs and Controllers.
    │   │   ├── AuthService.java, BrandService.java, CampaignService.java, etc.
    │   │
    │   ├── controller/         # Jakarta Servlets acting as HTTP endpoints. Handles session/routing.
    │   │   ├── BrandDashboardServlet.java, EditProfileServlet.java, LoginServlet.java, etc.
    │   │
    │   └── util/
    │       └── DatabaseConnection.java  # Singleton JDBC Connection Manager.
    │
    └── webapp/                 # The Frontend / View layer
        ├── WEB-INF/
        │   └── web.xml         # Deployment Descriptor configuring the Servlet mapping rules.
        ├── brand-dashboard.jsp
        ├── create-campaign.jsp
        ├── creator-dashboard.jsp
        ├── creator-details.jsp
        ├── edit-profile.jsp
        ├── login.jsp
        └── register.jsp
```

---

## Database Schema

The system uses a robust relational database design to handle users, matching, campaigns, and algorithmic scoring natively within MySQL.

### Core Tables & Relationships
*   **Users & Roles**
    *   `USER`: The base entity for authentication (Email, Password, Role).
    *   `CREATOR`: A specialized user containing creator-specific details. **(1:1 Relationship with USER)**.
    *   `BRAND`: A specialized user containing brand-specific details. **(1:1 Relationship with USER)**.
*   **Creator Statistics**
    *   `PLATFORM`: Master list of platforms (Instagram, YouTube, etc.).
    *   `CREATOR_PLATFORM_STATS`: Stores a creator's metrics for specific platforms. **(M:N Relationship between CREATOR and PLATFORM)**.
*   **Campaigns & Discovery**
    *   `CAMPAIGN`: Created by Brands. **(1:N Relationship from BRAND to CAMPAIGN)**.
    *   `CAMPAIGN_REQUIREMENT`: Stores the strict data requirements for a campaign. **(1:1 or 1:N Relationship from CAMPAIGN to CAMPAIGN_REQUIREMENT)**.
    *   `APPLICATION`: The bridge where a Creator applies to a Campaign. **(M:N Relationship between CREATOR and CAMPAIGN)**.
*   **Deliverables & Analytics**
    *   `DELIVERABLE`: Content submitted by a creator after an application is accepted. **(1:N Relationship from APPLICATION to DELIVERABLE)**.
    *   `ENGAGEMENT_REPORT`: Tracks raw performance metrics for a delivered asset. **(1:N Relationship from DELIVERABLE to ENGAGEMENT_REPORT)**.
*   **Trust & Arbitration**
    *   `DISPUTE`: Tracks conflicts raised by users regarding a campaign. **(1:N Relationship from CAMPAIGN to DISPUTE / 1:N from USER to DISPUTE)**.
    *   `PENALTY`: Stores details of score deductions applied to a Creator. **(1:N Relationship from DISPUTE to PENALTY / 1:N from CREATOR to PENALTY)**.
    *   `CREDIBILITY_SCORE`: A historical ledger tracking a creator's score over time. **(1:N Relationship from CREATOR to CREDIBILITY_SCORE)**.

---

## How It Works (Data Flow)
When a user interacts with the app (e.g., viewing their dashboard):
1. **View (JSP/HTML)**: A localized link action directs the browser to a specific route (`/creator/dashboard`).
2. **Controller (Servlet)**: The `CreatorDashboardServlet` intercepts the `GET` request. It validates the user's Session and checks their Role constraint.
3. **Service Layer**: The Servlet invokes `CreatorService.getCreatorProfile()`.
4. **DAO Layer**: The Service calls `CreatorDAO.getCreatorById()`.
5. **Database**: The DAO establishes a raw JDBC Connection and fires standard SQL logic to MySQL.
6. **Return Route**: The `ResultSet` payload maps back upward into a POJO (`Creator.java`), gets bound to the HTTP request attributes by the Servlet, and forwarded to the JSP view to seamlessly render HTML.

### The Algorithm (Trust Score)
Calculated natively via SQL triggers and formulas stored centrally:
`FinalScore = (0.4 × Audience Match) + (0.3 × Past Conversion) + (0.2 × Delivery) - (0.1 × Dispute Penalty)`
Updating a Dispute record automatically offsets this score using active MySQL triggers, ensuring platform integrity.

---

## How to Run the Application Locally

### Prerequisites
*   Java Development Kit (JDK 17+)
*   Apache Maven
*   MySQL Server
*   Apache Tomcat 11

### Step 1: Database Setup
1. Open your MySQL client.
2. Execute the entire `db/db.sql` script to create the `proofy` database, tables, triggers, and insert the initial seed data.
3. Open `src/main/java/com/proofy/util/DatabaseConnection.java`.
4. Verify that the `USER` and `PASSWORD` constants correspond to your local MySQL instance.

### Step 2: Build the WAR Executable
1. Open up a terminal in the root directory (`proofy-dbms-flexi-main`).
2. Run the Maven packaging command:
   ```sh
   mvn clean package
   ```
3. Verify that a `proofy.war` file has been generated inside the `target/` directory.

### Step 3: Deploy to Apache Tomcat
1. Copy the `target/proofy.war` file.
2. Navigate to your Tomcat installation's `webapps/` directory and paste the file.
3. Start Tomcat by executing `startup.bat` (Windows) or `startup.sh` (Mac/Linux) located inside Tomcat's `bin/` folder.
4. Tomcat will automatically extract the `.war` archive.

### Step 4: Login
*   Open your browser and navigate to `http://localhost:8080/proofy/login.jsp`.
*   **Sample Creator Login:** `sayantan@gmail.com` / `pass001`
*   **Sample Brand Login:** `contact@boostbrew.in` / `brand001`
*   Or simply register a new account through the UI!