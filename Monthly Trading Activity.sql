DROP TEMPORARY TABLE IF EXISTS Avg_Trading_Volume;

CREATE TEMPORARY TABLE Avg_Trading_Volume AS(
	SELECT 
    year(Date) as 'Year', 
    month(Date) as 'Month', 
    AVG(volume) as Avg_Mnthly_Trading_Volume
FROM 
    palantir_stock_price psp 
WHERE 
	year(date) in (2023,2024)
GROUP BY 
	Year(Date), MONTH(Date)
ORDER BY 
	Year DESC,
    Month DESC);
    
SELECT *,
((Avg_Mnthly_Trading_Volume - (LAG(Avg_Mnthly_Trading_Volume) OVER (PARTITION BY Year ORDER BY Month)))/LAG(Avg_Mnthly_Trading_Volume) OVER (PARTITION BY Year ORDER BY Month) * 100) AS Percent_Change
FROM Avg_Trading_Volume
ORDER BY Year DESC, Month DESC

   -- Stock activity is higher in 2024 months when compared to 2023 months on average
   -- Sharp increase from 10/2024 to 11/2024 maybe tied to external factors such as election
   		-- note that Palantir supports government sectors for data analysis and foreign intelligence
   -- Stock price increase from 2023-2024 + increased activity suggests a growing positive sentiment 
