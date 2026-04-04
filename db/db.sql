DROP DATABASE IF EXISTS proofy;
CREATE DATABASE proofy;
USE proofy;

-- ============================================================
-- TABLES
-- ============================================================

-- Base table for all users (Generalization)
-- CREATOR and BRAND are specializations of USER
CREATE TABLE USER (
    user_id    INT          PRIMARY KEY AUTO_INCREMENT,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(100) NOT NULL,
    role       VARCHAR(20)  NOT NULL,   -- 'creator', 'brand', 'admin'
    created_at DATE         NOT NULL
);

-- Specialization of USER: Creator
CREATE TABLE CREATOR (
    creator_id        INT          PRIMARY KEY,
    display_name      VARCHAR(100) NOT NULL,
    niche             VARCHAR(100) NOT NULL,
    audience_category VARCHAR(100) NOT NULL,
    bio               TEXT,
    trust_score       DECIMAL(5,2) DEFAULT 50.00,
    FOREIGN KEY (creator_id) REFERENCES USER(user_id)
);

-- Specialization of USER: Brand
CREATE TABLE BRAND (
    brand_id    INT          PRIMARY KEY,
    brand_name  VARCHAR(100) NOT NULL,
    industry    VARCHAR(100) NOT NULL,
    website     VARCHAR(200),
    FOREIGN KEY (brand_id) REFERENCES USER(user_id)
);

-- Social media platforms (Instagram, YouTube, etc.)
CREATE TABLE PLATFORM (
    platform_id   INT         PRIMARY KEY AUTO_INCREMENT,
    platform_name VARCHAR(50) NOT NULL UNIQUE
);

-- Tracks a creator's stats on each platform (M:N between CREATOR and PLATFORM)
CREATE TABLE CREATOR_PLATFORM_STATS (
    creator_id     INT            NOT NULL,
    platform_id    INT            NOT NULL,
    followers      INT            DEFAULT 0,
    avg_engagement DECIMAL(5,2)   DEFAULT 0.00,
    PRIMARY KEY (creator_id, platform_id),
    FOREIGN KEY (creator_id)  REFERENCES CREATOR(creator_id),
    FOREIGN KEY (platform_id) REFERENCES PLATFORM(platform_id)
);

-- Campaigns created by brands
CREATE TABLE CAMPAIGN (
    campaign_id INT          PRIMARY KEY AUTO_INCREMENT,
    brand_id    INT          NOT NULL,
    title       VARCHAR(200) NOT NULL,
    budget      DECIMAL(10,2) DEFAULT 0.00,
    start_date  DATE         NOT NULL,
    end_date    DATE         NOT NULL,
    status      VARCHAR(20)  DEFAULT 'active',   -- 'active', 'completed', 'cancelled'
    FOREIGN KEY (brand_id) REFERENCES BRAND(brand_id)
);

-- What a campaign needs (niche, platform, audience)
CREATE TABLE CAMPAIGN_REQUIREMENT (
    requirement_id  INT          PRIMARY KEY AUTO_INCREMENT,
    campaign_id     INT          NOT NULL,
    niche           VARCHAR(100) NOT NULL,
    min_engagement  DECIMAL(5,2) DEFAULT 0.00,
    target_audience VARCHAR(100) NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES CAMPAIGN(campaign_id)
);

-- Creator applies to a campaign
CREATE TABLE APPLICATION (
    application_id INT  PRIMARY KEY AUTO_INCREMENT,
    creator_id     INT  NOT NULL,
    campaign_id    INT  NOT NULL,
    applied_at     DATE NOT NULL,
    status         VARCHAR(20) DEFAULT 'pending',  -- 'pending', 'accepted', 'rejected'
    FOREIGN KEY (creator_id)  REFERENCES CREATOR(creator_id),
    FOREIGN KEY (campaign_id) REFERENCES CAMPAIGN(campaign_id)
);

-- Content submitted by creator after getting accepted
CREATE TABLE DELIVERABLE (
    deliverable_id  INT          PRIMARY KEY AUTO_INCREMENT,
    application_id  INT          NOT NULL,
    submission_url  VARCHAR(300) NOT NULL,
    submitted_at    DATE         NOT NULL,
    deadline        DATE         NOT NULL,
    approved        TINYINT(1)   DEFAULT 0,   -- 0 = not approved, 1 = approved
    FOREIGN KEY (application_id) REFERENCES APPLICATION(application_id)
);

-- Engagement numbers for each deliverable
CREATE TABLE ENGAGEMENT_REPORT (
    report_id       INT          PRIMARY KEY AUTO_INCREMENT,
    deliverable_id  INT          NOT NULL,
    impressions     INT          DEFAULT 0,
    clicks          INT          DEFAULT 0,
    conversions     INT          DEFAULT 0,
    engagement_rate DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (deliverable_id) REFERENCES DELIVERABLE(deliverable_id)
);

-- Disputes raised between creators and brands
CREATE TABLE DISPUTE (
    dispute_id  INT         PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT         NOT NULL,
    raised_by   INT         NOT NULL,   -- user_id of person who raised it
    against     INT         NOT NULL,   -- user_id of person it's against
    reason      TEXT        NOT NULL,
    status      VARCHAR(20) DEFAULT 'open',  -- 'open', 'resolved', 'dismissed'
    created_at  DATE        NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES CAMPAIGN(campaign_id),
    FOREIGN KEY (raised_by)   REFERENCES USER(user_id),
    FOREIGN KEY (against)     REFERENCES USER(user_id)
);

-- Penalty applied to a creator after a dispute
CREATE TABLE PENALTY (
    penalty_id    INT          PRIMARY KEY AUTO_INCREMENT,
    dispute_id    INT          NOT NULL,
    creator_id    INT          NOT NULL,
    penalty_score DECIMAL(5,2) NOT NULL,
    reason        TEXT         NOT NULL,
    applied_at    DATE         NOT NULL,
    FOREIGN KEY (dispute_id)  REFERENCES DISPUTE(dispute_id),
    FOREIGN KEY (creator_id)  REFERENCES CREATOR(creator_id)
);

-- Credibility score history for each creator
CREATE TABLE CREDIBILITY_SCORE (
    score_id             INT          PRIMARY KEY AUTO_INCREMENT,
    creator_id           INT          NOT NULL,
    audience_match       DECIMAL(5,2) DEFAULT 0.00,
    past_conversion_rate DECIMAL(5,2) DEFAULT 0.00,
    delivery_reliability DECIMAL(5,2) DEFAULT 0.00,
    dispute_penalty      DECIMAL(5,2) DEFAULT 0.00,
    final_score          DECIMAL(5,2) DEFAULT 0.00,
    calculated_at        DATE         NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES CREATOR(creator_id)
);

-- ============================================================
-- TRIGGERS
-- ============================================================

-- TRIGGER 1:
-- When a penalty is inserted, reduce the creator's trust_score
DELIMITER $$
CREATE TRIGGER trg_apply_penalty
AFTER INSERT ON PENALTY
FOR EACH ROW
BEGIN
    UPDATE CREATOR
    SET trust_score = trust_score - NEW.penalty_score
    WHERE creator_id = NEW.creator_id;
END$$
DELIMITER ;


-- TRIGGER 2:
-- When a new credibility score is added, update the creator's trust_score
DELIMITER $$
CREATE TRIGGER trg_update_trust_score
AFTER INSERT ON CREDIBILITY_SCORE
FOR EACH ROW
BEGIN
    UPDATE CREATOR
    SET trust_score = NEW.final_score
    WHERE creator_id = NEW.creator_id;
END$$
DELIMITER ;

-- ============================================================
-- FUNCTIONS
-- ============================================================
-- Function : Returns total budget of completed campaigns where the creator was accepted
DELIMITER $$

CREATE FUNCTION get_creator_revenue(p_creator_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10,2);

    SELECT IFNULL(SUM(c.budget), 0)
    INTO total_revenue
    FROM APPLICATION a
    JOIN CAMPAIGN c ON a.campaign_id = c.campaign_id
    WHERE a.creator_id = p_creator_id
      AND a.status = 'accepted'
      AND c.status = 'completed';

    RETURN total_revenue;
END$$

DELIMITER ;

-- Function : Returns the average engagement rate across all deliverables of a creator (from accepted applications)
DELIMITER $$

CREATE FUNCTION get_creator_avg_engagement(p_creator_id INT)
RETURNS DECIMAL(5,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE avg_engagement DECIMAL(5,2);

    SELECT IFNULL(AVG(er.engagement_rate), 0)
    INTO avg_engagement
    FROM APPLICATION a
    JOIN DELIVERABLE d ON a.application_id = d.application_id
    JOIN ENGAGEMENT_REPORT er ON d.deliverable_id = er.deliverable_id
    WHERE a.creator_id = p_creator_id
      AND a.status = 'accepted';

    RETURN avg_engagement;
END$$

DELIMITER ;


-- ============================================================
-- DATA
-- ============================================================

-- USERS
INSERT INTO USER (email, password, role, created_at) VALUES
('admin@proofy.io',       'admin123',   'admin',   '2025-01-01'),
('sayantan@gmail.com',          'pass001',    'creator', '2025-01-05'),
('sankeerth@gmail.com',          'pass002',    'creator', '2025-01-06'),
('roshan@gmail.com',         'pass003',    'creator', '2025-01-07'),
('shashank@gmail.com',           'pass004',    'creator', '2025-01-08'),
('shayontan@gmail.com',          'pass005',    'creator', '2025-01-09'),
('contact@boostbrew.in',     'brand001',   'brand',   '2025-01-10'),
('hello@glowskin.in',        'brand002',   'brand',   '2025-01-11'),
('info@techstride.io',       'brand003',   'brand',   '2025-01-12');

-- CREATORS (user_id 2 to 6)
INSERT INTO CREATOR VALUES
(2, 'Sankeerth Kumar',  'Beauty & Skincare',  'Men 18-35',   'Honest skincare reviews.',  72.50),
(3, 'Sayantan Nandi',   'Tech & Gadgets',     'Men 20-40',     'Deep-dive tech reviews.',   65.00),
(4, 'Roshan Sah',   'Food & Travel',      'All 22-45',     'Food and travel stories.',  80.00),
(5, 'Shashank Rai',     'Fashion & Lifestyle','Men 16-30',   'Affordable style tips.',    58.00),
(6, 'Shayontan Laha',  'Fitness & Wellness', 'Men/Women 18-40','Fitness and wellness.',    88.00);

-- BRANDS (user_id 7 to 9)
INSERT INTO BRAND VALUES
(7, 'BoostBrew',    'Food & Beverage', 'https://boostbrew.in'),
(8, 'GlowSkin Co.', 'Beauty',          'https://glowskin.in'),
(9, 'TechStride',   'Consumer Tech',   'https://techstride.io');

-- PLATFORMS
INSERT INTO PLATFORM (platform_name) VALUES
('Instagram'),
('YouTube'),
('TikTok'),
('Twitter');

-- CREATOR PLATFORM STATS
INSERT INTO CREATOR_PLATFORM_STATS VALUES
(2, 1, 145000, 6.80),
(2, 2, 38000,  4.20),
(3, 2, 210000, 5.50),
(4, 1, 95000,  7.30),
(5, 1, 320000, 4.90),
(5, 3, 180000, 5.80),
(6, 1, 260000, 8.10),
(6, 2, 115000, 7.40);

-- CAMPAIGNS
INSERT INTO CAMPAIGN (brand_id, title, budget, start_date, end_date, status) VALUES
(7, 'BoostBrew Summer Launch',  150000, '2025-06-01', '2025-06-30', 'completed'),
(8, 'GlowSkin Monsoon Glow',    120000, '2025-07-01', '2025-07-31', 'completed'),
(9, 'TechStride SmartBand X1',  200000, '2025-08-01', '2025-08-31', 'completed'),
(7, 'BoostBrew Campus Campaign', 80000, '2025-09-01', '2025-09-30', 'active'),
(8, 'GlowSkin Winter Kit',       90000, '2025-11-01', '2025-11-30', 'active');

-- CAMPAIGN REQUIREMENTS
INSERT INTO CAMPAIGN_REQUIREMENT (campaign_id, niche, min_engagement, target_audience) VALUES
(1, 'Fitness & Wellness',  5.00, 'Men/Women 18-35'),
(2, 'Beauty & Skincare',   4.50, 'Men 18-40'),
(3, 'Fitness & Wellness',  5.50, 'Men/Women 20-40'),
(4, 'Food & Beverage',     3.50, 'All 18-28'),
(5, 'Beauty & Skincare',   4.00, 'Women 18-45');

-- APPLICATIONS
INSERT INTO APPLICATION (creator_id, campaign_id, applied_at, status) VALUES
(6, 1, '2025-05-20', 'accepted'),
(2, 2, '2025-06-15', 'accepted'),
(5, 2, '2025-06-16', 'accepted'),
(6, 3, '2025-07-20', 'accepted'),
(3, 3, '2025-07-21', 'accepted'),
(4, 4, '2025-08-25', 'pending'),
(2, 5, '2025-10-10', 'accepted');

-- DELIVERABLES
INSERT INTO DELIVERABLE (application_id, submission_url, submitted_at, deadline, approved) VALUES
(1, 'https://instagram.com', '2025-06-10', '2025-06-15', 1),
(2, 'https://instagram.com',  '2025-07-10', '2025-07-15', 1),
(3, 'https://instagram.com',   '2025-07-18', '2025-07-15', 0),
(4, 'https://instagram.com',  '2025-08-10', '2025-08-15', 1),
(5, 'https://youtube.com',       '2025-08-12', '2025-08-18', 1),
(7, 'https://instagram.com','2025-10-20', '2025-10-25', 1);

-- ENGAGEMENT REPORTS
INSERT INTO ENGAGEMENT_REPORT (deliverable_id, impressions, clicks, conversions, engagement_rate) VALUES
(1, 98000,  4200, 310, 8.20),
(2, 74000,  3100, 280, 6.80),
(3, 81000,  2200, 140, 4.90),
(4, 130000, 6500, 590, 9.50),
(5, 95000,  4800, 370, 7.20),
(6, 68000,  2900, 230, 6.50);

-- DISPUTES
INSERT INTO DISPUTE (campaign_id, raised_by, against, reason, status, created_at) VALUES
(2, 8, 5, 'Deliverable was late and off-brief.', 'resolved', '2025-07-20'),
(3, 3, 9, 'Payment was delayed beyond agreed date.', 'open',  '2025-08-25');

-- PENALTIES  (this will also fire trg_apply_penalty → reduces Zara trust_score by 8)
INSERT INTO PENALTY (dispute_id, creator_id, penalty_score, reason, applied_at) VALUES
(1, 5, 8.00, 'Late and off-brief deliverable on GlowSkin campaign.', '2025-07-22');

-- CREDIBILITY SCORES  (this will also fire trg_update_trust_score → updates trust_score)
-- final_score = (0.4 * audience_match) + (0.3 * conversion) + (0.2 * delivery) - (0.1 * penalty)
INSERT INTO CREDIBILITY_SCORE (creator_id, audience_match, past_conversion_rate, delivery_reliability, dispute_penalty, final_score, calculated_at) VALUES
(2, 72.00, 42.00, 100.00, 0.00, 75.40, '2025-09-01'),
(3, 55.00, 39.50, 100.00, 0.00, 63.85, '2025-09-01'),
(4, 73.00, 30.00, 100.00, 0.00, 70.20, '2025-09-01'),
(5, 49.00, 14.00,   0.00, 8.00, 23.80, '2025-09-01'),
(6, 85.00, 49.50, 100.00, 0.00, 83.85, '2025-09-01');
