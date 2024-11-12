# PLTR-Stock-SQL-Analysis
Palantir Historical Stock Price and Volatility Analysis using MySQL

The data used for this analysis is sourced from Yahoo Finance data using python to export .csv for use in MySQL. This project aims to analyze risks and advantages for long-term and short-term share holders

SQL script files are broken down into the following substructure:

1. YoY Percent growth = Price analaysis from date of IPO to 2024
  
2. Monthly trading acivity = Query for trading volume focused on 2024 due to relevancy based on the time period of analysis
  
3. Yearly ATR and Sentiment = Query to calculate Yearly Average True Range (ATR)) of stock price, yearly open and close prices, and sentiment analysis based on changes over each year

4. Annualized volatility = Query to return the following Statistics:
   - Average Daily Returns (%)
   - Price Variance (%)
   - Price standard deviation (%)
   - Annualized volatility (%)
                                        

6. Top 5 Off-Market Increases = Query to highlight the top 5 off market prices increases (Gap-Up) to focus research on stock sensitivity


