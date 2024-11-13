DROP TEMPORARY TABLE IF EXISTS Overview;

CREATE TEMPORARY TABLE Overview AS(
	SELECT psp.Ticker, psp.Date, psp.Open, psp.Close, pv.High, pv.Low
    FROM palantir_stock_price psp
    JOIN palantir_volatility pv ON psp.Date = pv.Date);

WITH Daily_ATR AS (
    -- Calculate True Range (TR) for each day
    SELECT
        Date,
        YEAR(Date) AS Year,
        Ticker,
        High - Low AS Range1,
        ABS(High - LAG(Close) OVER (ORDER BY Date)) AS Range2,
        ABS(Low - LAG(Close) OVER (ORDER BY Date)) AS Range3
    FROM Overview
),
True_Range AS (
    -- Calculate the maximum of Range1, Range2, and Range3 for each day
    SELECT
        Date,
        Year,
        Ticker,
        GREATEST(Range1, Range2, Range3) AS TR
    FROM Daily_ATR
),
ATR_Calculation AS (
    -- Calculate ATR using a 14-day average of TR
    SELECT
        Date,
        Year,
        Ticker,
        AVG(TR) OVER (PARTITION BY Year ORDER BY Date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS ATR_14
    FROM True_Range
),
Yearly_ATR AS (
    -- Calculate the yearly average ATR
    SELECT
        Year,
        Ticker,
        AVG(ATR_14) AS Avg_ATR
    FROM ATR_Calculation
    GROUP BY Year, Ticker
),
Yearly_Open_Close AS (
    -- Extract the opening and closing prices for each year
    SELECT
        YEAR(Date) AS Year,
        Ticker,
        FIRST_VALUE(Close) OVER (PARTITION BY YEAR(Date) ORDER BY Date) AS Year_Open_Price,
        -- use unbound preceeding and following to retrieve last-value of each year
        LAST_VALUE(Close) OVER (PARTITION BY YEAR(Date) ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Year_Close_Price
    FROM palantir_stock_price
),
Final_Analysis AS (
    -- Combine ATR and sentiment calculations
    SELECT
        y.Year,
        y.Ticker,
        y.Avg_ATR,
        o.Year_Open_Price,
        o.Year_Close_Price,
        CASE
            WHEN o.Year_Close_Price > o.Year_Open_Price THEN 'Bullish'
            WHEN o.Year_Close_Price < o.Year_Open_Price THEN 'Bearish'
            ELSE 'Neutral'
        END AS Sentiment
    FROM Yearly_ATR y
    JOIN Yearly_Open_Close o ON y.Year = o.Year 
)
-- Output the final table
SELECT DISTINCT * 
FROM Final_Analysis
ORDER BY Year DESC;
