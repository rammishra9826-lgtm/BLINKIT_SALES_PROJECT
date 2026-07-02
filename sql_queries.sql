SELECT * FROM blinkit_sales ;

-- FINDING 1
--HOW MANY TOTAL ORDERS ,CUSTOMERS AND ROWS DO WE HAVE IN OUR DATABASE--


SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT order_id) AS total_orders,
COUNT(DISTINCT customer_id) AS total_customers
FROM blinkit_sales; 


--Give me a complete business summary
-- total revenue, average order value, total discounts given and average customer rating.--
SELECT
    COUNT(DISTINCT order_id)                AS total_orders,
    COUNT(DISTINCT customer_id)             AS total_customers,
    ROUND(SUM(revenue)::numeric, 2)         AS total_revenue,
    ROUND(AVG(revenue)::numeric, 2)         AS avg_order_value,
    ROUND(SUM(discount_amount)::numeric, 2) AS total_discount_given,
    ROUND(AVG(rating)::numeric, 2)          AS avg_customer_rating
FROM blinkit_sales;

/*Which product category is making us the most money? 
Also show me each category's percentage share of total revenue*/
SELECT
    category,
    COUNT(order_id)                        AS total_orders,
    ROUND(SUM(revenue)::numeric, 2)        AS total_revenue,
    ROUND(AVG(revenue)::numeric, 2)        AS avg_order_value,
    ROUND((SUM(revenue) * 100.0 /
	SUM(SUM(revenue)) OVER())::numeric,2)
                                       AS revenue_share_pct
FROM blinkit_sales
GROUP BY category
ORDER BY total_revenue DESC;

/*
"Which city is our best performing market?
Show total orders, unique customers and average rating per city."
*/
SELECT
    city,
    COUNT(order_id)                  AS total_orders,
    COUNT(DISTINCT customer_id)      AS unique_customers,
    ROUND(SUM(revenue)::numeric, 2)  AS total_revenue,
    ROUND(AVG(revenue)::numeric, 2)  AS avg_order_value,
    ROUND(AVG(rating)::numeric, 2)   AS avg_rating
FROM blinkit_sales
GROUP BY city
ORDER BY total_revenue DESC;

/*
Show me month by month sales trend for the entire year.
Is our revenue growing or declining
*/
SELECT
    order_year,
    order_month_num,
    order_month,
    COUNT(order_id)                  AS total_orders,
    ROUND(SUM(revenue)::numeric, 2)  AS total_revenue,
    ROUND(AVG(revenue)::numeric, 2)  AS avg_order_value
FROM blinkit_sales
GROUP BY order_year, order_month_num, order_month
ORDER BY order_year, order_month_num;

/*
Which are our top 10 best selling products and how much revenue did each generate?
*/
SELECT
    product_name,
    category,
    COUNT(order_id)                  AS times_ordered,
    SUM(quantity)                    AS total_quantity_sold,
    ROUND(SUM(revenue)::numeric, 2)  AS total_revenue
FROM blinkit_sales
GROUP BY product_name, category
ORDER BY total_revenue DESC
LIMIT 10;


/*
How do our customers prefer to pay?
Which payment method is most popular
*/
SELECT
    payment_method,
    COUNT(order_id)                  AS total_orders,
    ROUND(COUNT(order_id) * 100.0 /
          SUM(COUNT(order_id)) OVER()
    , 2)                             AS order_share_pct,
    ROUND(SUM(revenue)::numeric, 2)  AS total_revenue
FROM blinkit_sales
GROUP BY payment_method
ORDER BY total_orders DESC;

/*Which delivery time slot gets the most orders?
And what is the average delivery time per slot
*/

SELECT
    delivery_slot,
    COUNT(order_id)                           AS total_orders,
    ROUND(SUM(revenue)::numeric, 2)           AS total_revenue,
    ROUND(AVG(delivery_time_min)::numeric, 2) AS avg_delivery_time
FROM blinkit_sales
GROUP BY delivery_slot
ORDER BY total_orders DESC;

/*
Who are our top 10 most valuable customers?
How much have they spent in total
*/
SELECT
    customer_id,
    customer_name,
    COUNT(order_id)                  AS total_orders,
    ROUND(SUM(revenue)::numeric, 2)  AS total_spent,
    ROUND(AVG(revenue)::numeric, 2)  AS avg_order_value,
    ROUND(AVG(rating)::numeric, 2)   AS avg_rating
FROM blinkit_sales
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;

/*
Are discounts actually helping us?
Do discounted orders have higher average value than non-discounted ones?"
*/
SELECT
    discount_applied,
    discount_pct,
    COUNT(order_id)                  AS total_orders,
    ROUND(AVG(revenue)::numeric, 2)  AS avg_order_value,
    ROUND(SUM(revenue)::numeric, 2)  AS total_revenue
FROM blinkit_sales
GROUP BY discount_applied, discount_pct
ORDER BY discount_pct;


/*
Show me our cumulative revenue growth month by month 
— how much total revenue have we made from January till each month
*/
SELECT
    order_month_num,
    order_month,
    ROUND(SUM(revenue)::numeric, 2)        AS monthly_revenue,
    ROUND(SUM(SUM(revenue))
          OVER(ORDER BY order_month_num)
    ::numeric, 2)                          AS cumulative_revenue
FROM blinkit_sales
GROUP BY order_month_num, order_month
ORDER BY order_month_num;


/*
Do people order more on weekends or weekdays?
Is there a revenue difference?"
*/
SELECT
    is_weekend,
    COUNT(order_id)                  AS total_orders,
    ROUND(SUM(revenue)::numeric, 2)  AS total_revenue,
    ROUND(AVG(revenue)::numeric, 2)  AS avg_order_value
FROM blinkit_sales
GROUP BY is_weekend
ORDER BY total_orders DESC;
