/*Customers Analysis*/
--------------------------
/*Customer Loyalty & Order Recency Analysis: Ranking Customers by Average Days Between Purchases*/
-- step 1: Removing duplicate rows per Order ID
with distict_orders as
(
	select
		Order_ID,
		Customer_ID,
		Customer_Name,
		Order_Date
	from Superstore
	group by 
		Order_ID,
		Customer_ID,
		Customer_Name,
		Order_Date
),
-- step 2: Calculating days difference between successive orders
order_differences as
(
select 
customer_id ,
Customer_Name,
DATEDIFF(day,order_date,lead(order_date)over (partition by customer_id order by order_date,order_id)) as DaysUntilNextOrder
from distict_orders
)
-- step 3:Computing Average Metrics and Customer Ranking
select 
customer_id,
Customer_Name,
avg (DaysUntilNextOrder) as avg_days,
rank()over(order by case when avg(DaysUntilNextOrder)is null then 1 else 0 end,avg(DaysUntilNextOrder) asc ) as rank_avg
from order_differences
group by 
customer_id  ,
Customer_Name;
---------------------------------------------------------------------------------------------------------------------------
/*RFM*/
select 
Customer_ID,
Customer_Name,
Last_Order_Date,
max_dataset_date,
DATEDIFF(day,Last_Order_Date,max_dataset_date) AS Recency_Days,
total_orders_by_customers,
total_sales_by_customers
from
(
	SELECT 
		Customer_ID,
		Customer_Name,
		MIN(Order_Date) AS first_Order_Date,
		MAX(Order_Date) AS Last_Order_Date,
		MAX(MAX(Order_Date) ) over() as max_dataset_date,
		count(distinct Order_ID) total_orders_by_customers,
		cast(round(sum(sales),1) as decimal(18,2)) total_sales_by_customers
	FROM Superstore
	GROUP BY 
		Customer_ID,
		Customer_Name
	) t
ORDER BY Recency_Days ASC;


with RFM_Base as 
(
select 
Customer_ID,
Customer_Name,
DATEDIFF(day,MAX(Order_Date),MAX(MAX(Order_Date) ) over()) AS Recency,
count(distinct Order_ID) Frequency,
cast(round(sum(sales),1) as decimal(18,2)) Monetary
from Superstore
group by
Customer_ID,
Customer_Name
),
RFM_Score as
(
select 
*,
NTILE(5)over(order by Recency desc) as R_score,
NTILE(5)over(order by Frequency asc) as F_score,
NTILE(5)over(order by Monetary asc) as M_score
from RFM_Base
)
select 
*,
CASE 
        -- Champions: √ÕœÀ ⁄„·«¡ Ê√ﬂÀ—Â„  ﬂ—«—« ·‘—«¡
        WHEN R_Score >= 4 AND F_Score >= 4 THEN 'Champions'
        
        -- Potential Loyalists: «‘ —Ê« „ƒŒ—« Ê„⁄œ·  ﬂ—«—Â„ „ Ê”ÿ √Ê Ê«⁄œ
        WHEN R_Score >= 3 AND F_Score < 4 THEN 'Potential Loyalists'
        
        -- At Risk: ⁄„·«¡ ﬁœ«„Ï » ﬂ—«— ‘—«¡ ⁄«·Ì ·ﬂ‰ «‰ﬁÿ⁄Ê«
        WHEN R_Score < 3 AND F_Score >= 3 THEN 'At Risk'
        
        -- Hibernating: «‰ﬁÿ⁄Ê« „‰ › —… ÿÊÌ·… Ê ﬂ—«—Â„ ÷⁄Ì› (»«ﬁÌ «·Õ«·« )
        ELSE 'Hibernating'
    END AS Customer_Segment
from RFM_Score
ORDER BY R_Score DESC, F_Score DESC, M_Score DESC;
--------------------------------------------------------------------------------------------------------------------------- 
/*count customers RFM cegments*/
WITH RFM_Base AS 
(
    SELECT 
        Customer_ID,
        Customer_Name,
        DATEDIFF(day, MAX(Order_Date), MAX(MAX(Order_Date)) OVER()) AS Recency,
        COUNT(DISTINCT Order_ID) AS Frequency,
        CAST(ROUND(SUM(Sales), 1) AS DECIMAL(18,2)) AS Monetary
    FROM Superstore
    GROUP BY
        Customer_ID,
        Customer_Name
),
RFM_Score AS
(
    SELECT 
        *,
        NTILE(5) OVER(ORDER BY Recency DESC) AS R_score,
        NTILE(5) OVER(ORDER BY Frequency ASC) AS F_score,
        NTILE(5) OVER(ORDER BY Monetary ASC) AS M_score
    FROM RFM_Base
),
RFM_Segmented AS
(
    SELECT 
        Customer_ID,
        CASE 
            -- Champions: √ÕœÀ ⁄„·«¡ Ê√ﬂÀ—Â„  ﬂ—«—« ··‘—«¡
            WHEN R_Score >= 4 AND F_Score >= 4 THEN 'Champions'
            
            -- Potential Loyalists: «‘ —Ê« „ƒŒ—« Ê„⁄œ·  ﬂ—«—Â„ „ Ê”ÿ √Ê Ê«⁄œ
            WHEN R_Score >= 3 AND F_Score < 4 THEN 'Potential Loyalists'
            
            -- At Risk: ⁄„·«¡ ﬁœ«„Ï » ﬂ—«— ‘—«¡ ⁄«·Ì ·ﬂ‰ «‰ﬁÿ⁄Ê«
            WHEN R_Score < 3 AND F_Score >= 3 THEN 'At Risk'
            
            -- Hibernating: «‰ﬁÿ⁄Ê« „‰ › —… ÿÊÌ·… Ê ﬂ—«—Â„ ÷⁄Ì› (»«ﬁÌ «·Õ«·« )
            ELSE 'Hibernating'
        END AS Customer_Segment
    FROM RFM_Score
)
SELECT 
    Customer_Segment,
    COUNT(Customer_ID) AS Total_Customers,
    -- ‰”»… «·⁄„·«¡ ›Ì ﬂ· ‘—ÌÕ… „‰ ≈Ã„«·Ì «·⁄„·«¡
    CAST(ROUND((COUNT(Customer_ID) * 100.0) / SUM(COUNT(Customer_ID)) OVER(), 2) AS DECIMAL(5,2)) AS [Customer_Percentage%]
FROM RFM_Segmented
GROUP BY 
    Customer_Segment
ORDER BY 
    Total_Customers DESC;
--------------------------------------------------------------------------------------------------------------------------- 
/*Customer Lifetime Value & Profitability*/
select
Customer_ID,
Customer_Name,
cast(round((sum(sales)/count(distinct Order_ID)),1)as decimal(18,2)) as AOV,
cast(round(sum(sales),1)as decimal(18,2)) as total_sales,
cast(round(sum(profit),1)as decimal(18,2)) as total_profit,
cast(round((sum(profit)/SUM(sales))*100,1)as decimal(18,2)) as profit_margin_by_customer,
cast(round(avg(Discount)*100,2)as decimal(18,2)) as avg_discounts
from Superstore
group by 
Customer_ID,
Customer_Name

ORDER BY total_sales DESC;
---------------------------------------------------------------------------------------------------------------------------
/*Segment Analysis*/
select 
Customer_ID,
Customer_Name,
Segment,
count(distinct Customer_ID) as total_customers,
count(distinct order_id) as total_orders,
sum(Quantity) as total_quantity,
cast(round((sum(sales)/count(distinct Order_ID)),1)as decimal(18,2)) as AOV,
cast(round(sum(sales),1)as decimal(18,2)) as total_sales,
cast(round(sum(profit),1)as decimal(18,2)) as total_profit,
cast(round((sum(profit)/SUM(sales))*100,1)as decimal(18,2)) as profit_margin_by_segmant
from Superstore
group by
Customer_ID,
Customer_Name,
Segment
order by 
Segment ;
---------------------------------------------------------------------------------------------------------------------------