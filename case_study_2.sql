# Case Study 02: Investigating Metric Spikes
# Database: project03

USE project03;

# Table 01: Users
# Creating the `users` table with necessary columns
CREATE TABLE users (
    user_id INT NOT NULL,
    created_at VARCHAR(20),	
    company_id INT NOT NULL,
    language VARCHAR(20),	
    activated_at VARCHAR(20),
    state VARCHAR(20)
);

# Show the secure file path for loading data
SHOW VARIABLES LIKE 'secure_file_priv';

# Load data into the `users` table from a CSV file
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Verify data in the `users` table
SELECT * FROM users;

# Add a temporary column to transform the `created_at` column into DATETIME format
ALTER TABLE users ADD COLUMN temp_created_at DATETIME;

# Update `temp_created_at` with transformed values from `created_at`
SET SQL_SAFE_UPDATES = 0;
UPDATE users SET temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
SET SQL_SAFE_UPDATES = 1;

# Replace `created_at` with the new DATETIME column
ALTER TABLE users DROP created_at;
ALTER TABLE users CHANGE COLUMN temp_created_at created_at DATETIME;

# Add a temporary column to transform the `activated_at` column into DATETIME format
ALTER TABLE users ADD COLUMN temp_activated_at DATETIME;

# Update `temp_activated_at` with transformed values from `activated_at`
SET SQL_SAFE_UPDATES = 0;
UPDATE users SET temp_activated_at = STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i');
SET SQL_SAFE_UPDATES = 1;

# Replace `activated_at` with the new DATETIME column
ALTER TABLE users DROP activated_at;
ALTER TABLE users CHANGE COLUMN temp_activated_at activated_at DATETIME;

# Table 02: Events
# Creating the `events` table with necessary columns
CREATE TABLE events (
    user_id INT NOT NULL,
    occurred_at VARCHAR(20),	
    event_type VARCHAR(50),
    event_name VARCHAR(50),	
    location VARCHAR(50),
    device VARCHAR(50),
    user_type INT
);

# Load data into the `events` table from a CSV file
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Verify data in the `events` table
SELECT * FROM events;

# Add a temporary column to transform the `occurred_at` column into DATETIME format
ALTER TABLE events ADD COLUMN temp_occured_at DATETIME;

# Update `temp_occured_at` with transformed values from `occurred_at`
SET SQL_SAFE_UPDATES = 0;
UPDATE events SET temp_occured_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
SET SQL_SAFE_UPDATES = 1;

# Replace `occurred_at` with the new DATETIME column
ALTER TABLE events DROP occurred_at;
ALTER TABLE events CHANGE COLUMN temp_occured_at occurred_at DATETIME;

# Table 03: Email Events
# Creating the `email_events` table with necessary columns
CREATE TABLE email_events (
    user_id INT NOT NULL,
    occurred_at VARCHAR(20),	
    `action` VARCHAR(50),
    user_type INT
);

# Load data into the `email_events` table from a CSV file
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE email_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Verify data in the `email_events` table
SELECT * FROM email_events;

# Add a temporary column to transform the `occurred_at` column into DATETIME format
ALTER TABLE email_events ADD COLUMN temp_occured_at DATETIME;

# Update `temp_occured_at` with transformed values from `occurred_at`
SET SQL_SAFE_UPDATES = 0;
UPDATE email_events SET temp_occured_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
SET SQL_SAFE_UPDATES = 1;

# Replace `occurred_at` with the new DATETIME column
ALTER TABLE email_events DROP occurred_at;
ALTER TABLE email_events CHANGE COLUMN temp_occured_at occurred_at DATETIME;

# Task 01: Weekly Engagement
# Calculate the number of active users per week based on engagement events
SELECT 
    WEEK(occurred_at) AS week,
    COUNT(DISTINCT user_id) AS active_users
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY week
ORDER BY week;

# Task 02: User Growth Analysis
# Calculate monthly user growth and growth rate
WITH Monthly_Users AS (
    SELECT 
        EXTRACT(MONTH FROM created_at) AS Month,
        COUNT(activated_at) AS Users
    FROM 
        users
    WHERE 
        activated_at IS NOT NULL
    GROUP BY 
        EXTRACT(MONTH FROM created_at)
)
SELECT
    Month, Users,
    ROUND((Users - LAG(Users, 1) OVER (ORDER BY Month)) * 100.0 / 
    LAG(Users, 1) OVER (ORDER BY Month), 2) AS "Growth in %"
FROM
    Monthly_Users
ORDER BY 
    Month;

# Task 03: Weekly Retention Analysis
# Analyze user retention over weeks based on their signup cohort
SELECT 
    first AS "Week Numbers", 
    SUM(CASE WHEN week_number = 0 THEN 1 ELSE 0 END) AS "Week 0", 
    SUM(CASE WHEN week_number = 1 THEN 1 ELSE 0 END) AS "Week 1", 
    ...
    SUM(CASE WHEN week_number = 18 THEN 1 ELSE 0 END) AS "Week 18"
FROM (
    SELECT 
        m.user_id, m.login_week, n.first, 
        (m.login_week - first) AS week_number 
    FROM (
        SELECT 
            user_id, 
            EXTRACT(WEEK FROM occurred_at) AS login_week 
        FROM 
            events 
        GROUP BY 1, 2
    ) m
    JOIN (
        SELECT 
            user_id, 
            MIN(EXTRACT(WEEK FROM occurred_at)) AS first 
        FROM 
            events 
        GROUP BY 1
    ) n
    ON m.user_id = n.user_id
) sub 
GROUP BY first 
ORDER BY first;

# Task 04: Weekly Engagement Per Device
# Measure engagement metrics per device type on a weekly basis
SELECT 
    CONCAT(YEAR(occurred_at),
           '-',
           LPAD(WEEK(occurred_at, 0), 2, '0')) AS `Year - week no.`,
    device,
    COUNT(DISTINCT user_id) AS active_users
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY CONCAT(YEAR(occurred_at),
         '-',
         LPAD(WEEK(occurred_at, 0), 2, '0')) , device
ORDER BY `Year - week no.` , device;

# Task 05: Email Engagement Analysis
# Analyze email engagement rates for weekly digests, opens, and clickthroughs
SELECT 
    Week,
    ROUND((weekly_digest / total * 100), 2) AS 'Weekly Digest Rate',
    ROUND((email_opens / total * 100), 2) AS 'Email Open Rate',
    ROUND((email_clickthroughs / total * 100), 2) AS 'Email Clickthrough Rate',
    ROUND((reengagement_emails / total * 100), 2) AS 'Reengagement Email Rate'
FROM
    (SELECT 
        EXTRACT(WEEK FROM occurred_at) AS Week,
        COUNT(CASE WHEN action = 'sent_weekly_digest' THEN user_id ELSE NULL END) AS weekly_digest,
        COUNT(CASE WHEN action = 'email_open' THEN user_id ELSE NULL END) AS email_opens,
        COUNT(CASE WHEN action = 'email_clickthrough' THEN user_id ELSE NULL END) AS email_clickthroughs,
        COUNT(CASE WHEN action = 'sent_reengagement_email' THEN user_id ELSE NULL END) AS reengagement_emails,
        COUNT(user_id) AS total
    FROM
        email_events
    GROUP BY week) sub
GROUP BY week
ORDER BY week;
