SELECT Date,
	Open,
    Close,
    LAG(Close) OVER (Order BY Date) Previous_Day_Close,
    Open -  LAG(Close) OVER (Order BY Date) Off_Hr_Changes
FROM palantir_stock_price
Order By Off_Hr_Changes DESC
LIMIT 5