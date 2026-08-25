/*Regional Analysis*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Regional Product Preference*/
select
region,
category,
cast(round(SUM(sales),1)as decimal(18,2)) total_sales,
cast(round(SUM(profit),1)as decimal(18,2)) total_profit,
cast(round(AVG(Discount)*100,1)as decimal(18,2)) avg_discount,
cast(round((SUM(profit)/SUM(sales))*100,1)as decimal(18,2)) profit_margin
from Superstore
group by 
region,
category
order by
region,
cast(round(SUM(sales),1)as decimal(18,2)) desc;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Operational Efficiency & Shipping*/
select
region,
Ship_Mode,
avg(DATEDIFF(day,Order_Date,Ship_Date))as Shipping_Days
from Superstore
group by
region,
Ship_Mode
/*Late Shipping Rate %*/
SELECT 
    Region,
    cast(round(SUM(sales),1)as decimal(18,2)) total_sales,
    cast(round(SUM(profit),1)as decimal(18,2)) total_profit,
    COUNT(DISTINCT Order_ID) AS total_orders,
    SUM(CASE WHEN DATEDIFF(day, Order_Date, Ship_Date) > 4 THEN 1 ELSE 0 END) AS delayed_orders,
    CAST(ROUND((SUM(CASE WHEN DATEDIFF(day, Order_Date, Ship_Date) > 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT Order_ID)), 2) AS DECIMAL(18,2)) AS delay_rate_pct
FROM Superstore
GROUP BY region
ORDER BY delay_rate_pct DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Profitability vs Revenue & Profitability vs Revenue by region*/
select
Region,
cast(round(SUM(sales),1)as decimal(18,2)) total_sales,
cast(round(SUM(profit),1)as decimal(18,2)) total_profit,
cast(round(AVG(Discount)*100,1)as decimal(18,2)) avg_discount,
cast(round((SUM(profit)/SUM(sales))*100,1)as decimal(18,2)) profit_margin
from Superstore
group by Region
order by cast(round(SUM(sales),1)as decimal(18,2));
/*Profitability vs Revenue & Profitability vs Revenue by state*/
select
State,
cast(round(SUM(sales),1)as decimal(18,2)) total_sales,
cast(round(SUM(profit),1)as decimal(18,2)) total_profit,
cast(round(AVG(Discount)*100,1)as decimal(18,2)) avg_discount,
cast(round((SUM(profit)/SUM(sales))*100,1)as decimal(18,2)) profit_margin
from Superstore
group by State
order by cast(round(SUM(sales),1)as decimal(18,2));
/*Profitability vs Revenue & Profitability vs Revenue by city*/
select
City,
cast(round(SUM(sales),1)as decimal(18,2)) total_sales,
cast(round(SUM(profit),1)as decimal(18,2)) total_profit,
cast(round(AVG(Discount)*100,1)as decimal(18,2)) avg_discount,
cast(round((SUM(profit)/SUM(sales))*100,1)as decimal(18,2)) profit_margin
from Superstore
group by City
order by cast(round(SUM(sales),1)as decimal(18,2));