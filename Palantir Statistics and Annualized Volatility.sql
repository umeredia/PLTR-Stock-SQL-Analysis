DROP TEMPORARY TABLE IF EXISTS temp_daily_returns;
DROP TEMPORARY TABLE IF EXISTS temp_calculated_returns;
DROP TEMPORARY TABLE IF EXISTS temp_statistics;

-- Step 1: Create a temporary table to store daily midpoints
CREATE TEMPORARY TABLE temp_daily_returns AS
SELECT 
    YEAR(date) AS year,
    date,
    (High + Low) / 2 AS midpoint, 
    LAG((High + Low) / 2) OVER (PARTITION BY YEAR(date) ORDER BY date) AS previous_midpoint
FROM palantir_volatility;

-- Step 2: Create a temporary table to store calculated daily returns
CREATE TEMPORARY TABLE temp_calculated_returns AS
SELECT 
    year,
    date,
    (midpoint - previous_midpoint) / previous_midpoint AS daily_return
FROM temp_daily_returns
WHERE previous_midpoint IS NOT NULL;

-- Step 3: Calculate average daily return, variance, and standard deviation for each year
CREATE TEMPORARY TABLE temp_statistics AS
SELECT 
    year,
    ROUND(AVG(daily_return * 100),2) AS percent_avg_daily_return,
   ROUND(VARIANCE(daily_return * 100),2) AS percent_variance,
    ROUND(STDDEV(daily_return * 100),2) AS percent_stdev
FROM temp_calculated_returns
GROUP BY year;

-- Step 4: Calculate annual volatility for each year (annualized standard deviation)
SELECT 
    year,
    percent_avg_daily_return,
    percent_variance,
    percent_stdev,
    Round(percent_stdev * SQRT(252),2) AS Percent_annual_volatility
FROM temp_statistics
ORDER BY year DESC;
