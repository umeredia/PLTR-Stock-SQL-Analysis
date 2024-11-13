-- Calculate Avg Year Price for each Year
-- Determine YoY Percent Growth

select YEAR(Date) as Year, 
		-- Yearly avg shows each years average price
		AVG(close) as Yearly_AVG,
		-- equation below calculates YoY growth with using a lag function
		-- values are multiplied by 100 to get percent and rounded to 2 decimals
		ROUND(((avg(close)-lag(avg(close)) OVER(order by 'Year' desc))/lag(avg(close)) OVER(order by 'Year' desc)) * 100,2) as YoY_Percent_Growth
from palantir_stock_price psp 
group by Year 
-- Order by year descending to show a timeline from most relevant year at the top
order by Year desc

-- Stock price declines in 2022 match S&P 500 trends of overall stock market decline post-covid
-- steady growth in 2023 and 2024 suggests positive outlook for holding shares
-- over 100% growth in price in 2024 indicates further reaseach is required into company news (product release, earnings reports, sector growth, etc.)
