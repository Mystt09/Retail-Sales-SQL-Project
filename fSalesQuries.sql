
-- finalized queries from rSalesQueries

-- Q1: Do discounts increase sales volume?

SELECT category,
SUM(units_sold) AS units_without_discount
FROM cdata
WHERE discount_percent = 0
GROUP BY category;

SELECT category,
SUM(units_sold) AS units_with_discount
FROM cdata
WHERE discount_percent > 0
GROUP BY category;

SELECT category, day_of_week,
SUM(units_sold) AS units_with_discount
FROM cdata
WHERE discount_percent > 0
GROUP BY category, day_of_week;

SELECT category, day_of_week,
SUM(units_sold) AS units_without_discount
FROM cdata
WHERE discount_percent = 0
GROUP BY category, day_of_week;

-- Q2 : Which categories rely most on discounts?

-- ** disc: discounted sales
-- ** ndisc: no discount

SELECT 
disc.category, disc.units_with_discount, ndisc.units_without_discount, 
disc.units_with_discount + ndisc.units_without_discount 
AS total_units,
    
ROUND(

	disc.units_with_discount * 100.0 /
	(disc.units_with_discount + ndisc.units_without_discount), 2)
    AS discounted_sales_percentage
FROM
(
    SELECT category, SUM(units_sold) AS units_with_discount
    FROM cdata
    WHERE discount_percent > 0
    GROUP BY category
) disc
JOIN
(
    SELECT category, SUM(units_sold) AS units_without_discount
    FROM cdata
    WHERE discount_percent = 0
    GROUP BY category
) ndisc

ON disc.category = ndisc.category;

-- Q3 : Which stores performed the best overall? 

SELECT store_id,
-- ROUND(SUM(price * units_sold), 2) AS total_rev,
SUM(units_sold) AS total_units,
COUNT(*) AS total_transactions,
ROUND(SUM(price * units_sold), 2) AS total_rev
FROM cdata
GROUP BY store_id
ORDER BY total_rev DESC;

-- Q4 Which stores benefits the most with discounts? 



