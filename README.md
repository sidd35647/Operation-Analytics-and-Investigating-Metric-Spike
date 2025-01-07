# Operational Analytics: Investigating Metric Spikes and Analyzing Company Operations

This repository contains a comprehensive project on Operational Analytics, focusing on analyzing business operations, investigating metric anomalies, and providing actionable insights to improve company performance. The project is centered around two key case studies that involve advanced SQL queries to extract, transform, and analyze data from multiple datasets.

- Project Overview
Operational Analytics involves systematically analyzing a company's end-to-end operations to uncover inefficiencies, understand user behavior, and identify opportunities for improvement. This project mimics a real-world scenario where a Lead Data Analyst at a company like Microsoft works with diverse datasets to:

- Address sudden metric spikes and anomalies.
Provide data-driven recommendations to operational, support, and marketing teams.
Track and evaluate critical performance indicators.
The project highlights the power of data-driven decision-making by solving challenging analytical problems using advanced SQL queries.

- Objectives
Analyze operational data to uncover trends, patterns, and insights.
Investigate and explain anomalies in key business metrics.
Measure engagement, growth, and retention metrics over time.
Identify areas for process improvement and operational optimization.
Demonstrate advanced SQL techniques for solving real-world business problems.

- Case Studies
- Case Study 1: Job Data Analysis
This case study focuses on a table named job_data, which contains logs of job-related events. The tasks involve:

Jobs Reviewed Over Time: Calculating the number of jobs reviewed per hour for each day in November 2020 to understand the review activity pattern.
Throughput Analysis: Computing a 7-day rolling average of throughput (events per second) and comparing it with daily metrics to identify trends.
Language Share Analysis: Determining the percentage share of each language in job events over the last 30 days.
Duplicate Rows Detection: Identifying duplicate records in the dataset to maintain data integrity.

- Case Study 2: Investigating Metric Spike
This case study involves analyzing user activity data across multiple tables to investigate metric spikes and derive insights for engagement and growth. Key tasks include:

Weekly User Engagement: Calculating weekly activeness of users to measure engagement trends.
User Growth Analysis: Analyzing user growth trends over time for the product.
Weekly Retention Analysis: Computing retention metrics on a weekly basis, segmented by user sign-up cohorts.
Weekly Engagement Per Device: Measuring weekly user engagement across different device types.
Email Engagement Analysis: Analyzing user interaction and engagement with the email service.

- Key Skills and Tools
  
Skills:
Advanced SQL techniques:
Rolling averages
Time-series analysis
Cohort analysis
Data aggregation and filtering
Metric anomaly detection and investigation
Operational and user behavior analytics
Data cleaning and deduplication

Tools:
SQL-based RDBMS MySQL

- Data Description
Tables Used:
job_data:

Columns: job_id, actor_id, event, language, time_spent, org, ds (date stored as text).
Use case: Analysis of job review processes and event logs.
users:

Contains user account information.
Use case: User growth and retention analysis.
events:

Captures user actions (e.g., login, messaging, search).
Use case: Weekly engagement metrics and device-level analysis.
email_events:

Tracks email interaction events.
Use case: Email engagement metrics.
Insights and Outcomes
Operational Trends: Clear visualization of job review patterns and throughput efficiency.
Language Analysis: Identified dominant languages and their shares over time.
User Behavior: Detailed engagement and growth metrics by cohorts and devices.
Retention Insights: Highlighted areas to improve user retention and re-engagement.
Data Quality: Addressed duplicate data issues for accurate reporting.
