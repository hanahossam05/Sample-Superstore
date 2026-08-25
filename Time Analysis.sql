/*Time Anlysis*/
-----------------------------------------------------------------------------------------------------------------------------------------
/*MOM sales analysis*/
select
month_order,
current_month_sales,
coalesce(previous_month_sales,0) as previous_month_sales ,
coalesce(round(cast(current_month_sales - previous_month_sales as float ),1),0) as mom_change,
coalesce(round(cast(current_month_sales - previous_month_sales as float )/previous_month_sales*100,1),0) as  mom_change_percentage
from
(
	select 
	month(order_date)as month_order,
	round(cast(sum(sales)as float),1) as current_month_sales ,
	round(cast(lag(sum(sales))over(order by month(order_date))as float ),1)as previous_month_sales
	from Superstore
	group by month(order_date)
)t;
-----------------------------------------------------------------------------------------------------------------------------------------
/*YOY sales analysis*/
select
 year_order,
 current_year_sales,
 coalesce(previous_year_sales,0) previous_year_sales,
 coalesce((current_year_sales - previous_year_sales),0) year_change,
 coalesce(round(cast(current_year_sales - previous_year_sales as float )/previous_year_sales*100,1),0) as  year_change_percentage
from(
	select 
	year(Order_Date) year_order,
	round(cast(sum(Sales)as float),1) current_year_sales,
	lag(round(cast(sum(Sales)as float),1))over(order by year(Order_Date)) previous_year_sales
	from Superstore
	group by year(Order_Date)
)t;
-----------------------------------------------------------------------------------------------------------------------------------------
/*MOM profit analysis*/
select
month_order,
current_month_profit,
coalesce(previous_month_profit,0) as previous_month_profit ,
coalesce(round(cast(current_month_profit - previous_month_profit as float ),1),0) as mom_change,
coalesce(round(cast(current_month_profit - previous_month_profit as float )/previous_month_profit*100,1),0) as  mom_change_percentage
from
(
	select 
	month(order_date)as month_order,
	round(cast(sum(Profit)as float),1) as current_month_profit ,
	round(cast(lag(sum(profit))over(order by month(order_date))as float ),1)as previous_month_profit
	from Superstore
	group by month(order_date)
)t;
-----------------------------------------------------------------------------------------------------------------------------------------
/*YOY profit analysis*/
select
 year_order,
 current_year_profit,
 coalesce(previous_year_profit,0) previous_year_profit,
 coalesce((current_year_profit - previous_year_profit),0) year_change,
 coalesce(round(cast(current_year_profit - previous_year_profit as float )/previous_year_profit*100,1),0) as  year_change_percentage
from(
	select 
	year(Order_Date) year_order,
	round(cast(sum(profit)as float),1) current_year_profit,
	lag(round(cast(sum(profit)as float),1))over(order by year(Order_Date)) previous_year_profit
	from Superstore
	group by year(Order_Date)
)t;
-----------------------------------------------------------------------------------------------------------------------------------------
/*Shipping_Days*/
select
Order_ID,
order_date,
ship_date,
Ship_Mode,
DATEDIFF(day,Order_Date,Ship_Date)as Shipping_Days
from Superstore
group by
order_id,
order_date,
ship_date,
Ship_Mode
order by order_date;
-----------------------------------------------------------------------------------------------------------------------------------------
/*Seasonality sales analysis*/
select 
	YEAR(order_date) year_date,
	'Q'+DATENAME(quarter,order_date) quarter,
	round(cast(SUM(sales)as float),1) total_sales
	from Superstore
	group by 
	YEAR(order_date) ,
	DATENAME(quarter,order_date)
    order by 
    YEAR(order_date) ,
    round(cast(SUM(sales)as float),1)
;
-----------------------------------------------------------------------------------------------------------------------------------------
/*peak sales analysis*/
select distinct
year_date,
first_value (month_name) over(partition by  year_date order by total_sales desc) as prak_month,
first_value (total_sales) over(partition by  year_date order by total_sales desc) as max_sales
from
(
	select 
	YEAR(order_date) year_date,
	MONTH(order_date) month_date,
	DATENAME(month,order_date) month_name,
	round(cast(SUM(sales)as float),1) total_sales
	from Superstore
	group by 
	YEAR(order_date) ,
	MONTH(order_date),
	DATENAME(month,order_date) 
) t 
order by year_date;
-----------------------------------------------------------------------------------------------------------------------------------------