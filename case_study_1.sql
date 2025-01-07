# Case Study 01: Operational Analytics
# Database: project03

USE project03;

# Table: job_data
# Creating the `job_data` table with necessary columns
CREATE TABLE job_data (
    ds VARCHAR(50),
    job_id INT NOT NULL,
    actor_id INT NOT NULL,	
    event VARCHAR(50) NOT NULL,	
    language VARCHAR(50) NOT NULL,
    time_spent INT NOT NULL,
    org CHAR(5)
);

# Inserting data into the `job_data` table
INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES 
    ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
    ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
    ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
    ('2020-11-28', 23, 1005, 'transfer', 'Persian', 22, 'D'),
    ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
    ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
    ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
    ('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');

# Verify the data in the `job_data` table
SELECT * FROM job_data;

# Task 01: Jobs Reviewed Over Time
# Calculate the number of jobs reviewed per hour for each day in November 2020
SELECT 
    ds AS Dates,
    ROUND((COUNT(job_id)/SUM(time_spent)) * 3600, 2) AS `Jobs Reviewed Per Hour`
FROM 
    job_data 
WHERE 
    ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY 
    ds
ORDER BY 
    Dates ASC;

# Task 02: Throughput Analysis
# Weekly throughput: Number of events per second for all records
SELECT 
    ROUND(COUNT(event)/SUM(time_spent), 2) AS `Weekly Throughput`
FROM 
    job_data;

# Daily throughput: Number of events per second for each day
SELECT 
    ds AS Dates,
    ROUND((COUNT(event)/SUM(time_spent)), 2) AS `Daily Throughput`
FROM 
    job_data 
GROUP BY 
    ds
ORDER BY 
    Dates ASC;

# Task 03: Language Share Analysis
# Calculate the percentage share of each language
SELECT 
    language AS `Languages`,
    ROUND((COUNT(language) / total) * 100, 3) AS `Percentage Share`
FROM 
    job_data
CROSS JOIN 
    (SELECT COUNT(*) AS total FROM job_data) sub
GROUP BY 
    language, total;

# Task 04: Duplicate Rows Detection
# Identify actor IDs that appear more than once
SELECT 
    actor_id, 
    COUNT(actor_id) AS duplicates
FROM 
    job_data
GROUP BY 
    actor_id 
HAVING 
    duplicates > 1;

# Verify the data again (optional)
SELECT * FROM job_data;
