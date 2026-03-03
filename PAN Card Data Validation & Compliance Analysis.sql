/* =========================================================
   STEP 1: Create Staging Table
========================================================= */
create database pan_card;

CREATE TABLE pan_numbers (
    pan_number VARCHAR(20)
);

SELECT *
FROM pan_numbers;

-- STEP 1 Data Profiling

-- 1.How many total records were received?

SELECT COUNT(*) AS total_records
FROM pan_card.pan_card_numbers;

-- 2.How many PAN numbers are missing or blank?

SELECT COUNT(*) AS missing_pan_count
FROM pan_card.pan_card_numbers
WHERE pan_numbers IS NULL
   OR TRIM(pan_numbers) = '';

 -- 3.Are there duplicate PAN numbers?
 
SELECT pan_numbers, COUNT(*) AS duplicate_count
FROM pan_card.pan_card_numbers
WHERE pan_numbers IS NOT NULL
GROUP BY pan_numbers
HAVING COUNT(*) > 1;

-- STEP 2: Data Cleaning

-- 4.Are there leading or trailing spaces?
SELECT *
FROM pan_card.pan_card_numbers
WHERE pan_numbers <> TRIM(pan_numbers);

-- 5.Are there lowercase entries? 
SELECT *
FROM pan_card.pan_card_numbers
WHERE pan_numbers <> UPPER(pan_numbers);


-- Create Cleaned Tbale

DROP TABLE IF EXISTS pan_card.pan_card_numbers_cleaned;

CREATE TABLE pan_card.pan_card_numbers_cleaned AS
SELECT DISTINCT UPPER(TRIM(pan_numbers)) AS pan_number
FROM pan_card.pan_card_numbers
WHERE pan_numbers IS NOT NULL
AND TRIM(pan_numbers) <> '';

-- STEP 3: Format Validation

-- Which PAN numbers fail format validation?
SELECT pan_number
FROM pan_card.pan_card_numbers_cleaned
WHERE pan_number NOT REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$';


-- STEP 4: Advanced Logical Validation

-- Function 1: Adjacent Character Repetition
DELIMITER $$

CREATE FUNCTION fn_check_adjacent_repetition(p_str VARCHAR(20))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i < LENGTH(p_str) DO
        IF SUBSTRING(p_str, i, 1) = SUBSTRING(p_str, i+1, 1) THEN
            RETURN TRUE;
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN FALSE;
END $$

DELIMITER ;

-- 🔹 Function 2: Sequential Pattern Check
DELIMITER $$

CREATE FUNCTION fn_check_sequence(p_str VARCHAR(20))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i < LENGTH(p_str) DO
        IF ASCII(SUBSTRING(p_str, i+1, 1)) 
           - ASCII(SUBSTRING(p_str, i, 1)) <> 1 THEN
            RETURN FALSE;
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN TRUE;
END $$

DELIMITER ;


-- STEP 5: Valid / Invalid Classification
CREATE OR REPLACE VIEW pan_card.vw_valid_invalid_pans AS

SELECT 
    cln.pan_number,

    CASE 
        WHEN 
            fn_check_adjacent_repetition(cln.pan_number) = FALSE
            AND fn_check_sequence(SUBSTRING(cln.pan_number,1,5)) = FALSE
            AND fn_check_sequence(SUBSTRING(cln.pan_number,6,4)) = FALSE
            AND cln.pan_number REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$'
        THEN 'Valid PAN'
        ELSE 'Invalid PAN'
    END AS status

FROM pan_card.pan_card_numbers_cleaned cln;

-- STEP 6: Executive Summary
 
 -- Q7: Overall Validation Summary
 
 SELECT 
    (SELECT COUNT(*) FROM pan_card.pan_card_numbers) AS total_records,

    SUM(CASE WHEN status = 'Valid PAN' THEN 1 ELSE 0 END) AS valid_pans,

    SUM(CASE WHEN status = 'Invalid PAN' THEN 1 ELSE 0 END) AS invalid_pans,

    ROUND(
        SUM(CASE WHEN status = 'Valid PAN' THEN 1 ELSE 0 END)
        * 100.0 /
        (SELECT COUNT(*) FROM pan_card.pan_card_numbers)
    ,2) AS valid_percentage

FROM pan_card.vw_valid_invalid_pans;


-- STEP 7: Investigation Queries

-- Q8: Which PANs are sequential (suspicious)?

SELECT *
FROM pan_card.pan_card_numbers_cleaned
WHERE fn_check_sequence(SUBSTRING(pan_number,1,5)) = TRUE
   OR fn_check_sequence(SUBSTRING(pan_number,6,4)) = TRUE;
   
 -- Q9: Which PANs contain repeated adjacent characters?
 
 SELECT *
FROM pan_card.pan_card_numbers_cleaned
WHERE fn_check_adjacent_repetition(pan_number) = TRUE;



 
   
   



















