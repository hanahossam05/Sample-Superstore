/*Product Analysis*/
--------------------------
/*category Analysis*/
select 
Category,
round(cast(SUM(sales) as DECIMAL(18,2)),1) total_sales,
round(cast(SUM(Profit)as DECIMAL(18,2)),1) total_profit,
round(cast((SUM(Profit)/SUM(sales))*100  as DECIMAL(18,2)),1) as profit_margin,
round(cast((SUM(Sales)/SUM(Quantity))  as DECIMAL(18,2)),1) as sales_per_unit,
round(cast((SUM(Profit)/SUM(Quantity)) as DECIMAL(18,2)),1) as profit_per_unit,
round(cast((SUM(Profit)/(select sum(profit) from Superstore))*100  as DECIMAL(18,2)),1)  Category_profit_contribution,
SUM(quantity) total_quantity,
round(cast(AVG(discount)*100 as DECIMAL(18,2)),1) avg_discount
from Superstore
group by Category;
-----------------------------------------------------------------------------------------------------------------------------------------
/*Sup_category Analysis*/
select
Sub_Category,
round(cast(SUM(sales) as DECIMAL(18,2)),1) total_sales,
round(cast(SUM(Profit) as DECIMAL(18,2)),1) total_profit,
round(cast((SUM(Profit)/SUM(sales))*100 as DECIMAL(18,2)),1) as profit_margin,
round(cast((SUM(Sales)/SUM(Quantity))  as DECIMAL(18,2)),1) as sales_per_unit,
round(cast((SUM(Profit)/SUM(Quantity)) as DECIMAL(18,2)),1) as profit_per_unit,
round(cast((SUM(Profit)/(select sum(profit) from Superstore))*100  as DECIMAL(18,2)),1) profit_contribution,
SUM(quantity) total_quantity,
round(cast(AVG(discount)*100 as DECIMAL(18,2)),1) avg_discount
from Superstore
group by
Sub_Category;
-----------------------------------------------------------------------------------------------------------------------------------------