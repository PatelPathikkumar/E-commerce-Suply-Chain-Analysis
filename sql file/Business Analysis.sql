select * from coupon;
SELECT * from customers;
SELECT * from categories;
SELECT * from products;
SELECT * from purchase_orders;
SELECT * from sellers;
SELECT * from warehouses;
SELECT * from website_sessions;
SELECT * from orders;
SELECT * from order_items ;
SELECT * from payments;
SELECT * from reviews;
SELECT * from suppliers;
SELECT * from shipments;
SELECT * from "returns"



-- ============================================================
-- E-COMMERCE SQL BUSINESS ANALYSIS
-- Database: ecommerce.db
-- ============================================================


-- ============================================================
-- LEVEL 1 — FOUNDATIONS
-- ============================================================


-- ============================================================
-- 1. What are the top 10 product categories
--    by number of orders?
-- ============================================================

-- LOGIC:
-- 1. Products ko order_items ke saath join karenge.
-- 2. Products ko categories ke saath join karke category_name lenge.
-- 3. Har category ka total order value calculate karenge.
-- 4. Category-wise GROUP BY karenge.
-- 5. Highest total ko top par lane ke liye DESC order karenge.
-- 6. Sirf top 10 categories return karenge.

SELECT
    ca.category_name,
    SUM(oi.line_total) AS total
FROM products AS po
JOIN order_items AS oi
    ON oi.product_id = po.product_id
JOIN categories AS ca
    ON ca.category_id = po.category_id
GROUP BY ca.category_name
ORDER BY total DESC
LIMIT 10;


-- ============================================================
-- 2. Which payment method is used most often,
--    and what's the failure rate for each method?
-- ============================================================

-- LOGIC:
-- 1. Payment gateway ke according payments ko group karenge.
-- 2. COUNT(*) se har payment method ke total payments count karenge.
-- 3. Failed payments ko separately count karenge.
-- 4. Failure rate = Failed Payments / Total Payments * 100.
-- 5. 'NA' payment gateway ko exclude karenge.
-- 6. Highest usage wale payment method ko top par rakhenge.

SELECT
    pa.payment_gateway,
    COUNT(*) AS total_payments,

    SUM(
        CASE
            WHEN pa.payment_status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_payments,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN pa.payment_status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate

FROM payments AS pa
WHERE pa.payment_gateway != 'NA'
GROUP BY pa.payment_gateway
ORDER BY total_payments DESC;


-- ============================================================
-- 3. What is the average order value (total_amount)
--    by order status?
-- ============================================================

-- LOGIC:
-- 1. Orders table se order_status lenge.
-- 2. Har status ke orders ka average order_total calculate karenge.
-- 3. order_status ke according GROUP BY karenge.
-- 4. Highest average order value ko top par show karenge.

SELECT
    o.order_status,
    ROUND(AVG(o.order_total), 2) AS avg_total
FROM orders AS o
GROUP BY o.order_status
ORDER BY avg_total DESC;


-- ============================================================
-- 4. List the 10 warehouses with the most orders
--    shipped from them.
-- ============================================================

-- LOGIC:
-- 1. Warehouses ko shipments table ke saath join karenge.
-- 2. warehouse_id ke basis par matching shipments find karenge.
-- 3. Har warehouse ke shipments/orders count karenge.
-- 4. Highest shipment count ko top par rakhenge.
-- 5. LIMIT 10 se top 10 warehouses lenge.

SELECT
    wh.warehouse_name,
    COUNT(sh.warehouse_id) AS total_shipments
FROM warehouses AS wh
JOIN shipments AS sh
    ON sh.warehouse_id = wh.warehouse_id
GROUP BY wh.warehouse_name
ORDER BY total_shipments DESC
LIMIT 10;


-- ============================================================
-- 5. What percentage of orders used a coupon
--    vs. no coupon?
-- ============================================================

-- LOGIC:
-- 1. Har order ko check karenge ki coupon_id NULL hai ya nahi.
-- 2. coupon_id NOT NULL = Coupon Used.
-- 3. coupon_id NULL = No Coupon.
-- 4. CASE WHEN se dono categories create karenge.
-- 5. Total orders se percentage calculate karenge.

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN o.coupon_id IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS coupon_orders,

    SUM(
        CASE
            WHEN o.coupon_id IS NULL THEN 1
            ELSE 0
        END
    ) AS no_coupon_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN o.coupon_id IS NOT NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS coupon_percentage,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN o.coupon_id IS NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS no_coupon_percentage

FROM orders AS o;


-- ============================================================
-- 6. What's the monthly trend of new customer registrations
--    over time?
-- ============================================================

-- LOGIC:
-- 1. Customer registration_date ko month level par convert karenge.
-- 2. Har month mein registered customers count karenge.
-- 3. NULL registration dates ko exclude karenge.
-- 4. Month ke according GROUP BY karenge.
-- 5. Chronological order mein months show karenge.
-- 6. Isse customer registration ka monthly trend pata chalega.

SELECT
    DATE_TRUNC('month', registration_date)::date AS month,
    COUNT(*) AS new_customers
FROM customers
WHERE registration_date IS NOT NULL
GROUP BY DATE_TRUNC('month', registration_date)
ORDER BY month;


-- ============================================================
-- 7. Which device type generates the most website sessions,
--    and what's the average pages_viewed per device type?
-- ============================================================

-- LOGIC:
-- 1. Website sessions ko device_type ke according group karenge.
-- 2. COUNT(*) se har device ke total sessions count karenge.
-- 3. AVG(pages_viewed) se average pages viewed calculate karenge.
-- 4. ROUND(..., 2) se average ko 2 decimal places tak rakhenge.
-- 5. Total sessions ko DESC mein sort karenge.
-- 6. Sabse zyada sessions wala device top par aayega.

SELECT
    ws.device_type,
    COUNT(*) AS total_sessions,
    ROUND(AVG(ws.pages_viewed), 2) AS avg_pages_viewed
FROM website_sessions AS ws
GROUP BY ws.device_type
ORDER BY total_sessions DESC;


-- ============================================================
-- E-COMMERCE SQL BUSINESS ANALYSIS
-- LEVEL 2 — JOINS & AGGREGATION
-- PostgreSQL / pgAdmin
-- ============================================================


-- ============================================================
-- 8. Who are the top 20 customers by total lifetime spend
--    (based on payments, status = successful only)?
-- ============================================================

-- LOGIC:
-- 1. Orders ko payments ke saath order_id se join karenge.
-- 2. Sirf successful payments ko consider karenge.
-- 3. Customer-wise successful payment amount calculate karenge.
-- 4. Customer ka total lifetime spend SUM(amount) se niklega.
-- 5. Highest spend wale customers ko top par rakhenge.
-- 6. LIMIT 20 se top 20 customers return karenge.

SELECT
    o.customer_id,
    SUM(pa.amount) AS lifetime_spend
FROM orders AS o
JOIN payments AS pa
    ON pa.order_id = o.order_id
WHERE pa.payment_status = 'Success'
GROUP BY o.customer_id
ORDER BY lifetime_spend DESC
LIMIT 20;


-- ============================================================
-- 9. What is the return rate
--    (returned order_items / total order_items)
--    by product category?
-- ============================================================

-- LOGIC:
-- 1. order_items se products identify karenge.
-- 2. Products se category identify karenge.
-- 3. Category-wise total order_items count karenge.
-- 4. returns ko order_item_id ke through match karenge.
-- 5. Sirf Approved returns ko returned items maana jayega.
-- 6. Return Rate =
--       Returned Order Items / Total Order Items * 100
-- 7. Highest return-rate category ko top par show karenge.

SELECT
    ca.category_name,

    COUNT(DISTINCT oi.order_item_id) AS total_order_items,

    COUNT(
        DISTINCT CASE
            WHEN r.return_status = 'Approved'
            THEN r.order_item_id
        END
    ) AS returned_order_items,

    ROUND(
        100.0 *
        COUNT(
            DISTINCT CASE
                WHEN r.return_status = 'Approved'
                THEN r.order_item_id
            END
        )
        / NULLIF(COUNT(DISTINCT oi.order_item_id), 0),
        2
    ) AS return_rate

FROM order_items AS oi

JOIN products AS p
    ON p.product_id = oi.product_id

JOIN categories AS ca
    ON ca.category_id = p.category_id

LEFT JOIN "returns" AS r
    ON r.order_item_id = oi.order_item_id

GROUP BY ca.category_name

ORDER BY return_rate DESC;


-- ============================================================
-- 10. Which sellers have the highest average product rating
--     from reviews, among sellers with at least 50 reviews?
-- ============================================================

-- LOGIC:
-- 1. Reviews ko products ke saath product_id se join karenge.
-- 2. Product se seller_id identify karenge.
-- 3. Seller-wise average rating calculate karenge.
-- 4. Seller-wise total reviews count karenge.
-- 5. Sirf 50 ya usse zyada reviews wale sellers lenge.
-- 6. Highest average rating ko top par show karenge.

SELECT
    p.seller_id,

    COUNT(r.rating) AS total_reviews,

    ROUND(
        AVG(r.rating),
        2
    ) AS avg_rating

FROM reviews AS r

JOIN products AS p
    ON p.product_id = r.product_id

WHERE r.rating IS NOT NULL

GROUP BY p.seller_id

HAVING COUNT(r.rating) >= 50

ORDER BY avg_rating DESC;


-- ============================================================
-- 11. What is the average time between order_date
--     and delivered_timestamp from shipments,
--     broken down by carrier?
-- ============================================================

-- LOGIC:
-- 1. Shipments ko orders ke saath order_id se join karenge.
-- 2. delivered_timestamp - order_date se delivery duration nikalega.
-- 3. EPOCH se duration ko seconds mein convert karenge.
-- 4. 86400 se divide karke days mein convert karenge.
-- 5. Carrier-wise average delivery time calculate karenge.
-- 6. Shortest average delivery time wale carrier ko top par rakhenge.

SELECT
    sh.carrier,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    sh.delivered_timestamp - o.order_date
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days

FROM shipments AS sh

JOIN orders AS o
    ON o.order_id = sh.order_id

WHERE o.order_date IS NOT NULL
  AND sh.delivered_timestamp IS NOT NULL

GROUP BY sh.carrier

ORDER BY avg_delivery_days;


-- ============================================================
-- 12. Which product categories generate the
--     highest revenue per unit sold
--     (line_total / quantity)?
-- ============================================================

-- LOGIC:
-- 1. order_items ko products ke saath join karenge.
-- 2. Products ko categories ke saath join karenge.
-- 3. Category-wise total revenue calculate karenge.
-- 4. Category-wise total quantity sold calculate karenge.
-- 5. Revenue per Unit =
--       Total Revenue / Total Quantity
-- 6. NULLIF quantity = 0 hone par division error prevent karega.
-- 7. Highest revenue-per-unit category ko top par show karenge.

SELECT
    ca.category_name,

    SUM(oi.line_total) AS total_revenue,

    SUM(oi.quantity) AS total_quantity,

    ROUND(
        SUM(oi.line_total)
        / NULLIF(SUM(oi.quantity), 0),
        2
    ) AS revenue_per_unit

FROM order_items AS oi

JOIN products AS p
    ON p.product_id = oi.product_id

JOIN categories AS ca
    ON ca.category_id = p.category_id

GROUP BY ca.category_name

ORDER BY revenue_per_unit DESC;


-- ============================================================
-- 13. What's the refund amount as a percentage of revenue,
--     by month?
-- ============================================================

-- LOGIC:
-- 1. Returns se month-wise total refund calculate karenge.
-- 2. Orders se month-wise total revenue calculate karenge.
-- 3. Dono monthly results ko month ke basis par join karenge.
-- 4. Refund percentage calculate karenge:
--       Refund Amount / Revenue * 100
-- 5. NULLIF revenue = 0 hone par division error prevent karega.
-- 6. Month-wise chronological order mein result show karenge.

WITH monthly_refunds AS (

    SELECT
        DATE_TRUNC(
            'month',
            r.return_date
        )::date AS month,

        SUM(r.refund_amount) AS total_refund

    FROM "returns" AS r

    WHERE r.return_date IS NOT NULL

    GROUP BY DATE_TRUNC(
        'month',
        r.return_date
    )
),

monthly_revenue AS (

    SELECT
        DATE_TRUNC(
            'month',
            o.order_date
        )::date AS month,

        SUM(o.order_total) AS total_revenue

    FROM orders AS o

    WHERE o.order_date IS NOT NULL

    GROUP BY DATE_TRUNC(
        'month',
        o.order_date
    )
)

SELECT
    mr.month,

    mr.total_refund,

    mrev.total_revenue,

    ROUND(
        100.0 * mr.total_refund
        / NULLIF(mrev.total_revenue, 0),
        2
    ) AS refund_percentage

FROM monthly_refunds AS mr

JOIN monthly_revenue AS mrev
    ON mr.month = mrev.month

ORDER BY mr.month;


-- ============================================================
-- 14. Which suppliers have the highest late-delivery rate
--     on purchase orders?
-- ============================================================

-- LOGIC:
-- 1. Purchase orders ko supplier-wise group karenge.
-- 2. Expected delivery date aur actual delivery date compare karenge.
-- 3. Actual date > Expected date = Late delivery.
-- 4. CASE WHEN se late orders count karenge.
-- 5. Late Rate =
--       Late Orders / Total Purchase Orders * 100
-- 6. NULLIF total orders = 0 hone par division error prevent karega.
-- 7. Highest late-delivery rate ko top par show karenge.

SELECT
    po.supplier_id,

    COUNT(*) AS total_purchase_orders,

    SUM(
        CASE
            WHEN po.actual_delivery_date >
                 po.expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN po.actual_delivery_date >
                     po.expected_delivery_date
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate

FROM purchase_orders AS po

WHERE po.expected_delivery_date IS NOT NULL
  AND po.actual_delivery_date IS NOT NULL

GROUP BY po.supplier_id

ORDER BY late_delivery_rate DESC;


-- ============================================================
-- 15. What is the customer repeat-purchase rate?
--     % of customers with more than one order
-- ============================================================

-- LOGIC:
-- 1. Orders ko customer_id ke according group karenge.
-- 2. Har customer ke total orders count karenge.
-- 3. total_orders > 1 wale customers repeat customers hain.
-- 4. Repeat customers ko count karenge.
-- 5. Total customers ko count karenge.
-- 6. Repeat Purchase Rate =
--       Repeat Customers / Total Customers * 100
-- 7. NULLIF total customers = 0 hone par division error prevent karega.

WITH customer_orders AS (

    SELECT
        o.customer_id,

        COUNT(*) AS total_orders

    FROM orders AS o

    WHERE o.customer_id IS NOT NULL

    GROUP BY o.customer_id
)

SELECT

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders > 1
            THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN total_orders > 1
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_purchase_rate

FROM customer_orders;

-- ============================================================
                 -- 16. COHORT RETENTION
-- ============================================================

-- Cohort retention:
-- Group customers by the month they registered and calculate
-- what percentage of customers placed an order in each of
-- the following 3 months.


SELECT 
       -- Identify the customer cohort by registration year
       -- and registration month.
       EXTRACT(YEAR FROM c.registration_date) AS year,
       EXTRACT(MONTH FROM c.registration_date) AS month,

       -- Count the total number of unique customers
       -- registered in each cohort.
       COUNT(DISTINCT c.customer_id) AS total_count,


       -- =====================================================
       -- MONTH 1
       -- =====================================================

       -- Count unique customers who placed an order
       -- exactly one month after their registration month.
       COUNT(DISTINCT CASE
           WHEN DATE_TRUNC('month', o.order_date)
                = DATE_TRUNC('month', c.registration_date)
                  + INTERVAL '1 month'
           THEN c.customer_id
       END) AS month_1_customers,

       -- Calculate Month 1 retention percentage.
       -- Formula:
       -- Month 1 Customers / Total Cohort Customers * 100
       ROUND(
           COUNT(DISTINCT CASE
               WHEN DATE_TRUNC('month', o.order_date)
                    = DATE_TRUNC('month', c.registration_date)
                      + INTERVAL '1 month'
               THEN c.customer_id
           END) * 100.0
           / COUNT(DISTINCT c.customer_id),
           2
       ) AS month_1_retention,


       -- =====================================================
       -- MONTH 2
       -- =====================================================

       -- Count unique customers who placed an order
       -- exactly two months after their registration month.
       COUNT(DISTINCT CASE
           WHEN DATE_TRUNC('month', o.order_date)
                = DATE_TRUNC('month', c.registration_date)
                  + INTERVAL '2 months'
           THEN c.customer_id
       END) AS month_2_customers,

       -- Calculate Month 2 retention percentage.
       ROUND(
           COUNT(DISTINCT CASE
               WHEN DATE_TRUNC('month', o.order_date)
                    = DATE_TRUNC('month', c.registration_date)
                      + INTERVAL '2 months'
               THEN c.customer_id
           END) * 100.0
           / COUNT(DISTINCT c.customer_id),
           2
       ) AS month_2_retention,


       -- =====================================================
       -- MONTH 3
       -- =====================================================

       -- Count unique customers who placed an order
       -- exactly three months after their registration month.
       COUNT(DISTINCT CASE
           WHEN DATE_TRUNC('month', o.order_date)
                = DATE_TRUNC('month', c.registration_date)
                  + INTERVAL '3 months'
           THEN c.customer_id
       END) AS month_3_customers,

       -- Calculate Month 3 retention percentage.
       ROUND(
           COUNT(DISTINCT CASE
               WHEN DATE_TRUNC('month', o.order_date)
                    = DATE_TRUNC('month', c.registration_date)
                      + INTERVAL '3 months'
               THEN c.customer_id
           END) * 100.0
           / COUNT(DISTINCT c.customer_id),
           2
       ) AS month_3_retention


FROM customers AS c

-- Join customers with their orders using customer_id
-- to track purchasing activity after registration.
JOIN orders AS o
    ON o.customer_id = c.customer_id

-- Group customers into registration-month cohorts.
GROUP BY year, month

-- Display cohorts in chronological order.
ORDER BY year, month;



-- ============================================================
                 -- 17. COUPON EFFECTIVENESS
-- ============================================================

-- Coupon effectiveness:
-- Compare the average order value (AOV) of orders using
-- coupons against orders without coupons.
-- Also compare the AOV separately for each discount type:
-- percentage and fixed.


SELECT
       -- Identify the type of discount used by the customer.
       co.discount_type,

       -- Calculate the average order value for orders
       -- where a coupon was used.
       ROUND(AVG(o.order_total), 2) AS coupon_avg_order_value,

       -- Calculate the average order value for orders
       -- where no coupon was used.
       (
           SELECT ROUND(AVG(o2.order_total), 2)
           FROM orders AS o2
           WHERE o2.coupon_id IS NULL
       ) AS no_coupon_avg_order_value


FROM coupon AS co

-- Join coupons with orders to identify which discount type
-- was applied to each order.
JOIN orders AS o
    ON o.coupon_id = co.coupon_id

-- Calculate coupon AOV separately for each discount type.
GROUP BY co.discount_type

-- Sort the result alphabetically by discount type.
ORDER BY co.discount_type;


-- ============================================================
              -- 18. CUSTOMER SEGMENTATION (RFM)
-- ============================================================

-- RFM stands for:
-- Recency  = How recently the customer purchased
-- Frequency = How many orders the customer placed
-- Monetary = How much the customer spent
--
-- Customers are divided into 4 tiers using NTILE(4).
-- Score 1 represents the highest-value tier.
-- Therefore, R = 1, F = 1, M = 1 represents
-- the top-value customer segment.


SELECT
       customer_id,
       recent_date,
       count_order,
       total_spend,
       recency,
       frequency,
       monetary,

       -- Identify customers belonging to the
       -- highest RFM tier.
       CASE
           WHEN recency = 1
            AND frequency = 1
            AND monetary = 1
           THEN 'Top Value Customer'
           ELSE 'Other Customer'
       END AS customer_segment

FROM (
    SELECT
           customer_id,
           recent_date,
           count_order,
           total_spend,

           -- Most recent customers receive Recency score 1.
           NTILE(4) OVER (
               ORDER BY recent_date DESC
           ) AS recency,

           -- Customers with the highest number of orders
           -- receive Frequency score 1.
           NTILE(4) OVER (
               ORDER BY count_order DESC
           ) AS frequency,

           -- Customers with the highest total spending
           -- receive Monetary score 1.
           NTILE(4) OVER (
               ORDER BY total_spend DESC
           ) AS monetary

    FROM (
        SELECT
               c.customer_id,

               -- Most recent order date of each customer.
               MAX(o.order_date) AS recent_date,

               -- Total number of orders placed by the customer.
               COUNT(o.customer_id) AS count_order,

               -- Total amount spent by the customer.
               SUM(o.order_total) AS total_spend

        FROM orders AS o

        JOIN customers AS c
            ON c.customer_id = o.customer_id

        GROUP BY c.customer_id

    ) AS t
) AS rfm;
-- ============================================================
                      -- 19. CHURN RISK
-- ============================================================

-- Identify customers who:
-- 1. Placed at least one order within their first 90 days
--    after registration.
-- 2. Have placed no order during the last 6 months.


SELECT
       customer_id,
       registration_date,

       -- Count orders placed within the first 90 days
       -- after customer registration.
       SUM(
           CASE
               WHEN order_date BETWEEN registration_date
                                    AND registration_date + INTERVAL '90 days'
               THEN 1
               ELSE 0
           END
       ) AS first_90_days_orders,

       -- Count orders placed during the last 6 months
       -- from the current date.
       SUM(
           CASE
               WHEN order_date >= CURRENT_DATE - INTERVAL '6 months'
               THEN 1
               ELSE 0
           END
       ) AS last_6_months_orders

FROM (
    SELECT
           o.customer_id AS customer_order,
           o.order_date,
           c.customer_id,
           c.registration_date

    FROM customers AS c

    JOIN orders AS o
        ON o.customer_id = c.customer_id

) AS t

GROUP BY
         customer_id,
         registration_date

-- Customer must have at least one order
-- during the first 90 days.
HAVING
       SUM(
           CASE
               WHEN order_date BETWEEN registration_date
                                    AND registration_date + INTERVAL '90 days'
               THEN 1
               ELSE 0
           END
       ) > 0

       -- Customer must have NO order
       -- during the last 6 months.
       AND
       SUM(
           CASE
               WHEN order_date >= CURRENT_DATE - INTERVAL '6 months'
               THEN 1
               ELSE 0
           END
       ) = 0

ORDER BY
         first_90_days_orders DESC;




-- ============================================================
-- 20. SELLER PERFORMANCE SCORECARD
-- ============================================================
-- Objective:
-- For each seller, evaluate performance using:
-- 1. Seller rating
-- 2. Total order items
-- 3. Total revenue
-- 4. Total returns
--
-- NTILE(2) divides sellers into 2 groups:
-- Score 1 = Better 50%
-- Score 2 = Lower 50%
--
-- Best seller condition:
-- Rating       = 1  → High rating
-- Order volume = 1  → High order count
-- Revenue      = 1  → High revenue
-- Returns      = 1  → Low returns


SELECT
       seller_id,
       seller_rating,
       order_item_count,
       total,
       total_return,

       -- If seller belongs to the best group
       -- in all four performance metrics,
       -- classify the seller as BEST.
       CASE
           WHEN order_item_score = 1
            AND seller_p_rating = 1
            AND revenue_score = 1
            AND return_score = 1
           THEN 'Best'
           ELSE 'Worst'
       END AS ranked

FROM (

    SELECT
           seller_id,
           seller_rating,
           order_item_count,
           total_return,
           total,

           -- ------------------------------------------------
           -- Rating Score
           -- ------------------------------------------------
           -- Higher seller rating is better.
           -- DESC means highest rating gets NTILE = 1.
           NTILE(2) OVER (
               ORDER BY seller_rating DESC
           ) AS seller_p_rating,

           -- ------------------------------------------------
           -- Order Volume Score
           -- ------------------------------------------------
           -- More order items means higher seller activity.
           -- Highest order count gets score 1.
           NTILE(2) OVER (
               ORDER BY order_item_count DESC
           ) AS order_item_score,

           -- ------------------------------------------------
           -- Revenue Score
           -- ------------------------------------------------
           -- Higher revenue is better.
           -- Highest revenue gets score 1.
           NTILE(2) OVER (
               ORDER BY total DESC
           ) AS revenue_score,

           -- ------------------------------------------------
           -- Return Score
           -- ------------------------------------------------
           -- Lower returns are better.
           -- ASC means the lowest return count gets score 1.
           NTILE(2) OVER (
               ORDER BY total_return ASC
           ) AS return_score

    FROM (

        SELECT
               s.seller_id AS seller_id,

               -- Seller's rating from sellers table.
               s.seller_rating AS seller_rating,

               -- Total number of order items handled by seller.
               COUNT(oi.order_item_id) AS order_item_count,

               -- Total revenue generated by seller.
               SUM(oi.line_total) AS total,

               -- Total number of returned order items.
               COUNT(r.return_id) AS total_return

        FROM sellers AS s

        -- Connect sellers with their order items.
        JOIN order_items AS oi
            ON oi.seller_id = s.seller_id

        -- Connect seller with reviews.
        JOIN reviews AS re
            ON re.seller_id = s.seller_id

        -- Connect order items with returns.
        JOIN "returns" AS r
            ON r.order_item_id = oi.order_item_id

        -- Create one summary row for each seller.
        GROUP BY
                 s.seller_id,
                 s.seller_rating

    ) AS t

) AS p

-- Show Best sellers first.
-- Within the same ranking, higher revenue comes first.
ORDER BY
         ranked,
         total DESC;




-- ============================================================
-- 21. FUNNEL DROP-OFF
-- ============================================================
-- Objective:
-- Find what percentage of website sessions resulted
-- in an order on the same day.
--
-- Conversion Rate =
-- Same-day converted sessions / Total sessions × 100


SELECT
       COUNT(DISTINCT ws.session_id) AS total_sessions,

       -- Count sessions where the customer placed
       -- an order on the same calendar day.
       COUNT(
           DISTINCT CASE
               WHEN DATE(ws.session_start) = DATE(o.order_date)
               THEN ws.session_id
           END
       ) AS converted_sessions,

       -- Calculate same-day conversion percentage.
       ROUND(
           COUNT(
               DISTINCT CASE
                   WHEN DATE(ws.session_start) = DATE(o.order_date)
                   THEN ws.session_id
               END
           ) * 100.0
           / COUNT(DISTINCT ws.session_id),
           2
       ) AS conversion_percentage

FROM website_sessions AS ws

LEFT JOIN orders AS o
    ON o.customer_id = ws.customer_id;



	-- ============================================================
-- 22. CATEGORY CANNIBALIZATION / CROSS-SELL
-- ============================================================
-- Objective:
-- Find product-category pairs that are frequently
-- purchased together in the same order.


SELECT
       p1.category_id AS category_1,
       p2.category_id AS category_2,

       -- Count how many different orders
       -- contain both categories.
       COUNT(DISTINCT oi1.order_id) AS orders_together

FROM order_items AS oi1

JOIN products AS p1
    ON p1.product_id = oi1.product_id

-- Join order_items again to find another
-- product category from the same order.
JOIN order_items AS oi2
    ON oi2.order_id = oi1.order_id
   AND oi1.product_id <> oi2.product_id

JOIN products AS p2
    ON p2.product_id = oi2.product_id

-- Prevent duplicate pairs:
-- Electronics + Accessories
-- and Accessories + Electronics
-- should be counted only once.
WHERE p1.category_id < p2.category_id

GROUP BY
         p1.category_id,
         p2.category_id

ORDER BY
         orders_together DESC;


		 -- ============================================================
-- 23. WAREHOUSE EFFICIENCY
-- ============================================================
-- Objective:
-- Compare warehouses based on:
-- 1. Order volume
-- 2. Shipment volume
-- 3. Average delivery time
--
-- Note:
-- An exact on-time shipment rate requires a promised/
-- expected customer delivery date.
-- The current shipments table does not contain that field.


SELECT
       o.warehouse_id,

       -- Total number of orders handled by warehouse.
       COUNT(DISTINCT o.order_id) AS order_volume,

       -- Total number of shipments handled.
       COUNT(DISTINCT sh.shipment_id) AS shipment_volume,

       -- Calculate delivery time in days.
       ROUND(
           AVG(
               EXTRACT(
                   EPOCH FROM (
                       sh.delivered_timestamp - sh.shipment_date
                   )
               ) / 86400.0
           ),
           2
       ) AS avg_delivery_days

FROM orders AS o

JOIN shipments AS sh
    ON sh.order_id = o.order_id

WHERE sh.shipment_date IS NOT NULL
  AND sh.delivered_timestamp IS NOT NULL

GROUP BY
         o.warehouse_id

ORDER BY
         avg_delivery_days ASC,
         order_volume DESC;


		 -- ============================================================
-- 24. INVENTORY RISK / DEAD STOCK
-- ============================================================
-- Objective:
-- Identify products that have high inventory
-- but very few or zero orders during the last 6 months.


SELECT
       p.product_id,
       p.product_name,
       p.stock_quantity,

       -- Count orders for the product during
       -- the last 6 months.
       COUNT(DISTINCT o.order_id) AS last_6_month_orders

FROM products AS p

LEFT JOIN order_items AS oi
    ON oi.product_id = p.product_id

LEFT JOIN orders AS o
    ON o.order_id = oi.order_id
   AND o.order_date >= CURRENT_DATE - INTERVAL '6 months'

GROUP BY
         p.product_id,
         p.product_name,
         p.stock_quantity

-- Only products with very low order activity.
HAVING
       COUNT(DISTINCT o.order_id) <= 5

ORDER BY
         p.stock_quantity DESC;


		 -- ============================================================
-- 25. MARKETING ATTRIBUTION
-- ============================================================
-- Objective:
-- Find referral_source + campaign_name combinations
-- that generate the highest conversion to completed orders.
--
-- Conversion Rate =
-- Completed-order sessions / Total sessions × 100


SELECT
       ws.referral_source,
       ws.campaign_name,

       -- Total sessions generated by this
       -- marketing combination.
       COUNT(DISTINCT ws.session_id) AS total_sessions,

       -- Count sessions where the customer placed
       -- a completed order on the same day.
       COUNT(
           DISTINCT CASE
               WHEN DATE(ws.session_start) = DATE(o.order_date)
                AND LOWER(o.order_status) = 'completed'
               THEN ws.session_id
           END
       ) AS completed_order_sessions,

       -- Calculate conversion percentage.
       ROUND(
           COUNT(
               DISTINCT CASE
                   WHEN DATE(ws.session_start) = DATE(o.order_date)
                    AND LOWER(o.order_status) = 'completed'
                   THEN ws.session_id
               END
           ) * 100.0
           / NULLIF(COUNT(DISTINCT ws.session_id), 0),
           2
       ) AS conversion_percentage

FROM website_sessions AS ws

LEFT JOIN orders AS o
    ON o.customer_id = ws.customer_id

GROUP BY
         ws.referral_source,
         ws.campaign_name

ORDER BY
         conversion_percentage DESC;