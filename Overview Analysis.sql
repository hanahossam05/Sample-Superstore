/* Executive Summary & Overall KPIs */
select 
/*Financial KPIs*/
cast(round(SUM(sales),1)as decimal(18,2)) total_sales,
cast(round(SUM(profit),1)as decimal(18,2)) total_profit,
cast(round(AVG(Discount)*100,1)as decimal(18,2)) avg_discount,
cast(round((SUM(profit)/SUM(sales))*100,1)as decimal(18,2)) profit_margin,
/*Operational & Volume KPIs*/
count(distinct order_id) total_orders,
sum(quantity) total_quantity,
cast(round((SUM(sales)/count(distinct order_id)),1)as decimal(18,2)) AOV,
avg(DATEDIFF(day,Order_Date,Ship_Date)) as Overall_Avg_Shipping_Days,
/*Customer & Product Level Overview*/
count(distinct customer_id) total_customers,
cast(round((SUM(sales)/count(distinct Customer_ID)),1)as decimal(18,2)) ARPU,
count(distinct Product_ID) total_Product
from Superstore;
------------------------------------------------------------------------------------------------------
/*Overall YoY Growth %*/
select
 year_order,
 coalesce(round(cast(current_year_sales - previous_year_sales as float )/previous_year_sales*100,1),0) as  sales_year_change_percentage,
 cast(round(coalesce(((current_year_profit - previous_year_profit )/previous_year_profit*100),0),1) as decimal(18,2))as  profit_year_change_percentage
from(
	select 
	year(Order_Date) year_order,
	round(cast(sum(Sales)as float),1) current_year_sales,
	lag(round(cast(sum(Sales)as float),1))over(order by year(Order_Date)) previous_year_sales,
	round(cast(sum(profit)as float),1) current_year_profit,
	lag(round(cast(sum(profit)as float),1))over(order by year(Order_Date)) previous_year_profit
	from Superstore
	group by year(Order_Date)
)t
order by year_order desc;
----------------------------------------------------------------------------------------------------------------------------------------------------------