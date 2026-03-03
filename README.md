🏢 PAN Card Data Validation & Compliance Analysis (MySQL)

This project demonstrates a real-world Data Quality & Validation Framework built using MySQL to validate PAN (Permanent Account Number) data.

The goal of this project is to simulate enterprise-level data validation practices used in banking, fintech, and compliance-driven industries.

📌 Project Objective

Organizations handling financial transactions must ensure PAN numbers are:

Structurally valid

Free from duplicates

Properly formatted

Not suspicious (sequential or repeated patterns)

This project performs:

✔ Data Profiling
✔ Data Cleaning
✔ Regex Validation
✔ Logical Pattern Detection
✔ Executive Summary Reporting

🛠️ Tech Stack

MySQL

String Functions (SUBSTRING, ASCII, TRIM, UPPER)

REGEXP (Pattern Validation)

Custom SQL Functions

Views & Reporting Queries

🗂️ Database Details

Database Name: pan_card

Table Name: pan_card_numbers

🔎 Project Workflow
🔹 Step 1: Data Profiling

Count total records

Identify missing PAN values

Detect duplicate entries

Identify formatting inconsistencies

🔹 Step 2: Data Cleaning

Remove leading/trailing spaces

Convert lowercase to uppercase

Remove blank values

Create cleaned dataset

🔹 Step 3: Format Validation

Official PAN Format Rule:

5 Letters + 4 Digits + 1 Letter
Example: ABCDE1234F

Regex Used:

^[A-Z]{5}[0-9]{4}[A-Z]$
🔹 Step 4: Advanced Logical Validation
1️⃣ Adjacent Character Repetition Check

Example: AABCD → Suspicious

2️⃣ Sequential Pattern Detection

Example: ABCDE or 1234 → Suspicious

Custom MySQL functions were created to detect:

Repeated characters

Sequential character patterns

🔹 Step 5: Valid vs Invalid Classification

A view was created to classify each PAN number as:

✅ Valid PAN

❌ Invalid PAN

Based on:

Format compliance

No sequential pattern

No repeated adjacent characters

📊 Executive Summary Report

The project generates a summary including:

Total Records Processed

Total Valid PANs

Total Invalid PANs

Validation Success Percentage

This simulates a real compliance reporting system.

📈 Business Insights Generated

Percentage of valid PAN numbers

Frequency of format violations

Duplicate record detection

Suspicious sequential patterns

Data quality improvement opportunities

🚀 Key Learnings

This project demonstrates:

Advanced SQL string manipulation

Regex pattern validation

Data quality analysis

Logical rule-based validation

Enterprise-style compliance checks

💼 Resume Value

This project showcases:

✔ Real-world compliance validation
✔ SQL procedural logic
✔ Regex implementation
✔ Data quality framework development
✔ Fraud pattern detection logic

📌 Future Enhancements

Validate 4th character entity type rule

Add audit logging table

Build Power BI dashboard for validation insights

Automate validation pipeline using Python

👨🏻‍💻 About This Project

This project is part of my Data Analytics portfolio to demonstrate strong SQL skills and practical data validation logic relevant to financial and regulatory environments.
