create database bank_analytics_project;
use bank_analytics_project;
select * from finance_1;
select * from finance_2;

----------- KPI-1 Year wise loan amount Stats  --------------
select Right(last_pymnt_d,2) as lastpymnt_Year, concat(round(sum(loan_amnt) /100000,1),"M") as loan_amount from finance_1
join
finance_2
on 
finance_2.id = finance_1.id
group by right(last_pymnt_d,2)
order by right(last_pymnt_d,2);

-----------   KPI-2  Grade and sub grade wise revol_bal --------------

SELECT grade, sub_grade, concat(round(sum(revol_bal)/1000000,1),"M") AS revol_balance
FROM finance_1
JOIN finance_2
ON finance_1.id = finance_2.id
GROUP BY grade, sub_grade
ORDER BY grade;

----------- KPI-3 --------------
 ----- This for verified and source verified and not verified in NUmbers ---------
select verification_status,concat(round(sum(total_pymnt)/1000000,1),"M") as total_payment
FROM finance_1
JOIN finance_2
ON finance_1.id = finance_2.id
group by verification_status;

 ----- This for verified and not verified in percentage format ---------
SELECT verification_status,
CONCAT(ROUND(SUM(total_pymnt) * 100.0 / (SELECT SUM(total_pymnt) FROM finance_1 JOIN finance_2 ON finance_1.id = finance_2.id), 1), '%') AS total_payment_percentage
FROM finance_1
JOIN finance_2
ON finance_1.id = finance_2.id
WHERE verification_status IN ('Verified', 'Not Verified')
GROUP BY verification_status;

----------- KPI-4  Home ownership Vs last payment date stats --------------
SELECT home_ownership, COUNT(last_pymnt_d) AS payment_count,MAX(last_pymnt_d) AS last_payment_date
FROM finance_1
JOIN finance_2 ON finance_1.id = finance_2.id
GROUP BY home_ownership
ORDER BY home_ownership;
----------- KPI-5 --------------
-- State wise and month wise loan status -----------
SELECT f1.ADDR_STATE AS STATE,
SUBSTRING(f2.LAST_PYMNT_D, 1, 3) AS MONTH,  -- Extracts the first three characters for the month
COUNT(CASE WHEN f1.LOAN_STATUS = 'FULLY PAID' THEN 1 END) AS FULLY_PAID_COUNT,
COUNT(CASE WHEN f1.LOAN_STATUS = 'CHARGE OFF' THEN 1 END) AS CHARGE_OFF_COUNT,
COUNT(CASE WHEN f1.LOAN_STATUS = 'CURRENT' THEN 1 END) AS CURRENT_COUNT,
COUNT(f1.LOAN_STATUS) AS TOTAL_LOAN_COUNT  -- Total loan count
FROM finance_1 f1
JOIN finance_2 f2 ON f1.ID = f2.ID
WHERE f2.LAST_PYMNT_D IS NOT NULL  -- Ensure we are not counting NULL values
GROUP BY f1.ADDR_STATE, MONTH
ORDER BY f1.ADDR_STATE, MONTH;


-- State wise loan status -----------
SELECT f1.ADDR_STATE AS STATE,
    COUNT(CASE WHEN f1.LOAN_STATUS = 'FULLY PAID' THEN 1 END) AS FULLY_PAID_COUNT,
    COUNT(CASE WHEN f1.LOAN_STATUS = 'CHARGE OFF' THEN 1 END) AS CHARGE_OFF_COUNT,
    COUNT(CASE WHEN f1.LOAN_STATUS = 'CURRENT' THEN 1 END) AS CURRENT_COUNT,
    COUNT(f1.LOAN_STATUS) AS TOTAL_LOAN_COUNT  -- Total loan count
FROM finance_1 f1
JOIN finance_2 f2 ON f1.ID = f2.ID
WHERE f2.LAST_PYMNT_D IS NOT NULL  -- Ensure we are not counting NULL values
GROUP BY f1.ADDR_STATE
ORDER BY f1.ADDR_STATE;

-------- month wise loan status -----------
SELECT
SUBSTRING(f2.LAST_PYMNT_D, 1, 3) AS MONTH,  -- Extracts the first three characters for the month
COUNT(CASE WHEN f1.LOAN_STATUS = 'FULLY PAID' THEN 1 END) AS FULLY_PAID_COUNT,
COUNT(CASE WHEN f1.LOAN_STATUS = 'CHARGE OFF' THEN 1 END) AS CHARGE_OFF_COUNT,
COUNT(CASE WHEN f1.LOAN_STATUS = 'CURRENT' THEN 1 END) AS CURRENT_COUNT,
COUNT(f1.LOAN_STATUS) AS TOTAL_LOAN_COUNT  -- Total loan count
FROM finance_1 f1
JOIN finance_2 f2 ON f1.ID = f2.ID
WHERE f2.LAST_PYMNT_D IS NOT NULL  -- Ensure we are not counting NULL values
GROUP BY  MONTH
ORDER BY  MONTH;




