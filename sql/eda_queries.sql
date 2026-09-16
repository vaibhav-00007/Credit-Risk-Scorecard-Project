-- ============================================================
-- Credit Risk Scorecard — Exploratory SQL Queries
-- Run against: data/credit_data.db, table: credit_data
-- These are the same queries used in Stage 2 of notebooks/credit_scorecard.ipynb
-- ============================================================

-- 1. Table schema — confirms every column and its inferred type
PRAGMA table_info(credit_data);

-- 2. Row count
SELECT COUNT(*) as total_rows FROM credit_data;

-- 3. Overall default rate
SELECT
    SeriousDlqin2yrs,
    COUNT(*) as count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_data), 2) as percent
FROM credit_data
GROUP BY SeriousDlqin2yrs;

-- 4. Top 5 customers by utilization — flags the outliers we cap in Stage 3
SELECT ID, RevolvingUtilizationOfUnsecuredLines, age
FROM credit_data
ORDER BY RevolvingUtilizationOfUnsecuredLines DESC
LIMIT 5;

-- 5. Age sanity check
SELECT MIN(age) as min_age, MAX(age) as max_age, AVG(age) as avg_age
FROM credit_data;

-- 6. Missing value counts
SELECT
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) as missing_income,
    SUM(CASE WHEN NumberOfDependents IS NULL THEN 1 ELSE 0 END) as missing_dependents
FROM credit_data;

-- 7. Delinquency count distributions (run once per column: 30-59, 60-89, 90+ days late)
SELECT "NumberOfTime30-59DaysPastDueNotWorse" AS bucket, COUNT(*) as count
FROM credit_data
GROUP BY "NumberOfTime30-59DaysPastDueNotWorse"
ORDER BY bucket;

SELECT "NumberOfTime60-89DaysPastDueNotWorse" AS bucket, COUNT(*) as count
FROM credit_data
GROUP BY "NumberOfTime60-89DaysPastDueNotWorse"
ORDER BY bucket;

SELECT NumberOfTimes90DaysLate AS bucket, COUNT(*) as count
FROM credit_data
GROUP BY NumberOfTimes90DaysLate
ORDER BY bucket;

-- 8. Dependents distribution
SELECT NumberOfDependents as dependents, COUNT(*) as count
FROM credit_data
GROUP BY NumberOfDependents
ORDER BY dependents;
