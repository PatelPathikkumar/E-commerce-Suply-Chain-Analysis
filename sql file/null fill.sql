-- ============================================================
                        -- CUSTOMERS
-- ============================================================

-- Check the total number of NULL values in each column.
-- Total NULL values:
-- middle_name = 10959
-- alternate_email = 12841
-- apartment_number = 17929

select 
      sum(case when cu.first_name is null then 1 else 0 end) as first_name,
      sum(case when cu.last_name is null then 1 else 0 end) as last_name,
      sum(case when cu.middle_name is null then 1 else 0 end) as middle_name,
      sum(case when cu.customer_name is null then 1 else 0 end) as customer_name,
      sum(case when cu.email is null then 1 else 0 end) as email,
      sum(case when cu.alternate_email is null then 1 else 0 end) as alternate_email,
      sum(case when cu.apartment_number is null then 1 else 0 end) as apartment_number,
      sum(case when cu.city is null then 1 else 0 end) as city,
      sum(case when cu.state is null then 1 else 0 end) as state,
      sum(case when cu.zip_code is null then 1 else 0 end) as zip_code,
      sum(case when cu.country is null then 1 else 0 end) as country,
      sum(case when cu.registration_date is null then 1 else 0 end) as registration_date
from customers as cu;


-- Identify records containing NULL values.
-- NULL values were found in middle_name,
-- alternate_email, and apartment_number.

SELECT *
FROM customers AS cu
WHERE cu.customer_id IS NULL 
   OR cu.first_name IS NULL
   OR cu.last_name IS NULL
   OR cu.middle_name IS NULL
   OR cu.customer_name IS NULL
   OR cu.email IS NULL
   OR cu.alternate_email IS NULL
   OR cu.address_line1 IS NULL
   OR cu.apartment_number IS NULL
   OR cu.city IS NULL 
   OR cu.state IS NULL
   OR cu.zip_code IS NULL
   OR cu.country IS NULL
   OR cu.registration_date IS NULL;


-- Fill NULL values in the middle_name column
-- with the default value 'NA'.

UPDATE customers AS c
SET middle_name = 'NA'
WHERE c.middle_name IS NULL;


-- Fill NULL values in the apartment_number column
-- with the default value 'NA'.

UPDATE customers AS c
SET apartment_number = 'NA'
WHERE c.apartment_number IS NULL;


-- Fill NULL values in the alternate_email column
-- using the customer's email address as a fallback value.

UPDATE customers AS c
SET alternate_email = c.email
WHERE c.alternate_email IS NULL;


-- ============================================================
                         -- CATEGORIES
-- ============================================================

-- No NULL-value check is required for this table
-- based on the current data-quality requirements.
SELECT * from categories;







-- ============================================================
--                         PRODUCTS
-- ============================================================

-- Check the total number of NULL values in each column.
-- Total NULL values:
-- brand = 2464
-- product_description = 3364
-- warranty_period = 3814

SELECT
    SUM(CASE WHEN pr.product_id IS NULL THEN 1 ELSE 0 END) AS product_id,
    SUM(CASE WHEN pr.product_name IS NULL THEN 1 ELSE 0 END) AS product_name,
    SUM(CASE WHEN pr.category_id IS NULL THEN 1 ELSE 0 END) AS category_id,
    SUM(CASE WHEN pr.seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id,
    SUM(CASE WHEN pr.supplier_id IS NULL THEN 1 ELSE 0 END) AS supplier_id,
    SUM(CASE WHEN pr.brand IS NULL THEN 1 ELSE 0 END) AS brand,
    SUM(CASE WHEN pr.product_description IS NULL THEN 1 ELSE 0 END) AS product_description,
    SUM(CASE WHEN pr.warranty_period IS NULL THEN 1 ELSE 0 END) AS warranty_period,
    SUM(CASE WHEN pr.unit_price IS NULL THEN 1 ELSE 0 END) AS unit_price,
    SUM(CASE WHEN pr.stock_quantity IS NULL THEN 1 ELSE 0 END) AS stock_quantity
FROM products AS pr;


-- Identify records containing NULL values.
-- NULL values were found in:
-- brand, product_description, and warranty_period.

SELECT *
FROM products AS pr
WHERE pr.product_id IS NULL
   OR pr.product_name IS NULL
   OR pr.category_id IS NULL
   OR pr.seller_id IS NULL
   OR pr.supplier_id IS NULL
   OR pr.brand IS NULL
   OR pr.product_description IS NULL
   OR pr.warranty_period IS NULL
   OR pr.unit_price IS NULL
   OR pr.stock_quantity IS NULL;


-- ============================================================
-- Fill NULL values in product_description
-- ============================================================

-- Replace NULL product_description values
-- with the default value 'NA'.

UPDATE products AS p
SET product_description = 'NA'
WHERE p.product_description IS NULL;


-- ============================================================
-- Fill NULL values in brand
-- ============================================================

-- Fill NULL brand values using the existing brand
-- associated with the same product_name.

UPDATE products AS p
SET brand = (
    SELECT avg_total
    FROM (
        SELECT
            o.product_name AS product_name,
            o.brand AS avg_total
        FROM products AS o
        WHERE o.brand IS NOT NULL
        GROUP BY o.product_name, o.brand
    ) AS t
    WHERE p.product_name = t.product_name
)
WHERE p.brand IS NULL;


-- Fill any remaining NULL brand values
-- with the default value 'NA'.

UPDATE products AS p
SET brand = 'NA'
WHERE p.brand is null;


-- ============================================================
-- Fill NULL values in warranty_period
-- ============================================================

-- Calculate the average warranty_period for each product_name
-- and use the calculated average to fill NULL warranty_period values.
-- The average is rounded to 2 decimal places.

UPDATE products AS p
SET warranty_period = (
    SELECT avg_total
    FROM (
        SELECT
            o.product_name AS product_name,
            ROUND(AVG(o.warranty_period), 2) AS avg_total
        FROM products AS o
        WHERE o.warranty_period IS NOT NULL
        GROUP BY o.product_name
    ) AS t
    WHERE p.product_name = t.product_name
)
WHERE p.warranty_period IS NULL;



-- ============================================================
                    -- PURCHASE ORDERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- expected_delivery_date = 4733

SELECT   
       SUM(CASE WHEN po.product_id IS NULL THEN 1 ELSE 0 END) AS product_id,
       SUM(CASE WHEN po.supplier_id IS NULL THEN 1 ELSE 0 END) AS supplier_id,
       SUM(CASE WHEN po.warehouse_id IS NULL THEN 1 ELSE 0 END) AS warehouse_id,
       SUM(CASE WHEN po.purchase_order_id IS NULL THEN 1 ELSE 0 END) AS purchase_order_id,
       SUM(CASE WHEN po.order_date IS NULL THEN 1 ELSE 0 END) AS order_date,
       SUM(CASE WHEN po.quantity IS NULL THEN 1 ELSE 0 END) AS quantity,
       SUM(CASE WHEN po.status IS NULL THEN 1 ELSE 0 END) AS status,
       SUM(CASE WHEN po.expected_delivery_date IS NULL THEN 1 ELSE 0 END) AS expected_delivery_date
FROM purchase_orders AS po;


-- Identify records containing NULL values.
-- NULL values were found in expected_delivery_date.

SELECT *
FROM purchase_orders AS po
WHERE po.product_id IS NULL 
   OR po.supplier_id IS NULL
   OR po.warehouse_id IS NULL
   OR po.purchase_order_id IS NULL
   OR po.order_date IS NULL
   OR po.quantity IS NULL 
   OR po.status IS NULL 
   OR po.expected_delivery_date IS NULL;


-- Fill NULL values in expected_delivery_date.
-- The average delivery time in days is calculated for each
-- product, warehouse, and supplier combination.
-- The calculated average number of days is added to order_date
-- to generate the expected_delivery_date.

UPDATE purchase_orders AS p
SET expected_delivery_date = p.order_date + (
    SELECT t.total_days * INTERVAL '1 day'
    FROM (
        SELECT 
            po.product_id,
            po.warehouse_id,
            po.supplier_id,
            ROUND(AVG(po.expected_delivery_date - po.order_date), 2) AS total_days
        FROM purchase_orders AS po
        WHERE po.expected_delivery_date IS NOT NULL
        GROUP BY 
            po.product_id,
            po.warehouse_id,
            po.supplier_id
    ) AS t
    WHERE t.product_id = p.product_id
      AND t.warehouse_id = p.warehouse_id
      AND t.supplier_id = p.supplier_id
)
WHERE p.expected_delivery_date IS NULL;


-- ============================================================
                          -- SELLERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- seller_description = 622
-- website = 392

SELECT  
       SUM(CASE WHEN s.seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id,
       SUM(CASE WHEN s.seller_name IS NULL THEN 1 ELSE 0 END) AS seller_name,
       SUM(CASE WHEN s.email IS NULL THEN 1 ELSE 0 END) AS email,
       SUM(CASE WHEN s.seller_description IS NULL THEN 1 ELSE 0 END) AS seller_description,
       SUM(CASE WHEN s.website IS NULL THEN 1 ELSE 0 END) AS website,
       SUM(CASE WHEN s.city IS NULL THEN 1 ELSE 0 END) AS city,
       SUM(CASE WHEN s.state IS NULL THEN 1 ELSE 0 END) AS state,
       SUM(CASE WHEN s.country IS NULL THEN 1 ELSE 0 END) AS country,
       SUM(CASE WHEN s.seller_rating IS NULL THEN 1 ELSE 0 END) AS seller_rating,
       SUM(CASE WHEN s.registration_date IS NULL THEN 1 ELSE 0 END) AS registration_date
FROM sellers AS s;


-- Identify records containing NULL values.
-- NULL values were found in seller_description and website.

SELECT *
FROM sellers AS s
WHERE s.seller_id IS NULL 
   OR s.seller_name IS NULL
   OR s.email IS NULL 
   OR s.seller_description IS NULL
   OR s.website IS NULL
   OR s.city IS NULL 
   OR s.state IS NULL 
   OR s.country IS NULL 
   OR s.seller_rating IS NULL
   OR s.registration_date IS NULL;


-- Fill NULL values in seller_description
-- with the default value 'NA'.

UPDATE sellers AS s
SET seller_description = 'NA'
WHERE s.seller_description IS NULL;


-- Fill NULL values in website
-- with the default value 'NA'.

UPDATE sellers AS s
SET website = 'NA'
WHERE s.website IS NULL;


-- ============================================================
                        -- WAREHOUSES
-- ============================================================

-- Check for NULL values in warehouse data.
-- No NULL values were found based on the current dataset.

SELECT *
FROM warehouses AS w
WHERE w.warehouse_id IS NULL
   OR w.warehouse_name IS NULL
   OR w.city IS NULL 
   OR w.state IS NULL 
   OR w.country IS NULL
   OR w.capacity IS NULL;


-- ============================================================
                   -- WEBSITE SESSIONS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- referral_source = 66999
-- campaign_name = 83554

SELECT
        SUM(CASE WHEN ws.session_id IS NULL THEN 1 ELSE 0 END) AS session_id,
        SUM(CASE WHEN ws.customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
        SUM(CASE WHEN ws.session_start IS NULL THEN 1 ELSE 0 END) AS session_start,
        SUM(CASE WHEN ws.session_end IS NULL THEN 1 ELSE 0 END) AS session_end,
        SUM(CASE WHEN ws.device_type IS NULL THEN 1 ELSE 0 END) AS device_type,
        SUM(CASE WHEN ws.referral_source IS NULL THEN 1 ELSE 0 END) AS referral_source,
        SUM(CASE WHEN ws.campaign_name IS NULL THEN 1 ELSE 0 END) AS campaign_name,
        SUM(CASE WHEN ws.pages_viewed IS NULL THEN 1 ELSE 0 END) AS pages_viewed
FROM website_sessions AS ws;


-- Identify records containing NULL values.
-- NULL values were found in referral_source
-- and campaign_name.

SELECT *
FROM website_sessions AS ws
WHERE ws.session_id IS NULL
   OR ws.customer_id IS NULL
   OR ws.session_end IS NULL
   OR ws.session_start IS NULL
   OR ws.device_type IS NULL
   OR ws.referral_source IS NULL
   OR ws.campaign_name IS NULL
   OR ws.pages_viewed IS NULL;


-- ============================================================
-- Fill NULL values in referral_source
-- ============================================================

-- Replace NULL referral_source values
-- with the default value 'NA'.

UPDATE website_sessions AS ws
SET referral_source = 'NA'
WHERE ws.referral_source IS NULL;


-- ============================================================
-- Fill NULL values in campaign_name
-- ============================================================

-- Replace NULL campaign_name values
-- with the default value 'NA'.

UPDATE website_sessions AS ws
SET campaign_name = 'NA'
WHERE ws.campaign_name IS NULL;



-- ============================================================
                   -- SUPPLIERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- No NULL values were found based on the current dataset.				
SELECT 
        sum(case when su.supplier_id is null then 1 else 0 end) as supplier_id,
		sum(case when su.supplier_name is null then 1 else 0 end) as supplier_name,
		sum(case when su.contact_email is null then 1 else 0 end) as contact_email,
		sum(case when su.city is null then 1 else 0 end) as city,
		sum(case when su.country is null then 1 else 0 end) as country,
		sum(case when su.registration_date is null then 1 else 0 end) as registration_date
from suppliers as su;


-- ============================================================
                        -- SHIPMENTS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- tracking_notes = 45622
-- delivered_timestamp = 46072

SELECT
       SUM(CASE WHEN sh.shipment_id IS NULL THEN 1 ELSE 0 END) AS shipment_id,
       SUM(CASE WHEN sh.order_id IS NULL THEN 1 ELSE 0 END) AS order_id,
       SUM(CASE WHEN sh.carrier IS NULL THEN 1 ELSE 0 END) AS carrier,
       SUM(CASE WHEN sh.shipment_date IS NULL THEN 1 ELSE 0 END) AS shipment_date,
       SUM(CASE WHEN sh.tracking_number IS NULL THEN 1 ELSE 0 END) AS tracking_number,
       SUM(CASE WHEN sh.tracking_notes IS NULL THEN 1 ELSE 0 END) AS tracking_notes,
       SUM(CASE WHEN sh.delivered_timestamp IS NULL THEN 1 ELSE 0 END) AS delivered_timestamp,
       SUM(CASE WHEN sh.shipment_status IS NULL THEN 1 ELSE 0 END) AS shipment_status
FROM shipments AS sh;


-- Identify records containing NULL values.
-- NULL values were found in tracking_notes
-- and delivered_timestamp.

SELECT *
FROM shipments AS sh
WHERE sh.shipment_id IS NULL
   OR sh.order_id IS NULL
   OR sh.carrier IS NULL 
   OR sh.shipment_date IS NULL
   OR sh.tracking_notes IS NULL
   OR sh.tracking_number IS NULL
   OR sh.delivered_timestamp IS NULL
   OR sh.shipment_status IS NULL;


-- ============================================================
-- Fill NULL values in tracking_notes
-- ============================================================

-- Replace NULL tracking_notes values
-- with the default value 'NA'.

UPDATE shipments AS sh
SET tracking_notes = 'NA'
WHERE sh.tracking_notes IS NULL;



-- ============================================================
                       -- RETURNS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- return_reason = 9537
-- refund_reference = 7173

SELECT  
       SUM(CASE WHEN re.return_id IS NULL THEN 1 ELSE 0 END) AS return_id,
       SUM(CASE WHEN re.order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_id,
       SUM(CASE WHEN re.customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
       SUM(CASE WHEN re.return_date IS NULL THEN 1 ELSE 0 END) AS return_date,
       SUM(CASE WHEN re.return_status IS NULL THEN 1 ELSE 0 END) AS return_status,
       SUM(CASE WHEN re.return_reason IS NULL THEN 1 ELSE 0 END) AS return_reason,
       SUM(CASE WHEN re.refund_amount IS NULL THEN 1 ELSE 0 END) AS refund_amount,
       SUM(CASE WHEN re.refund_reference IS NULL THEN 1 ELSE 0 END) AS refund_reference
FROM "returns" AS re;


-- Identify records containing NULL values.
-- NULL values were found in return_reason
-- and refund_reference.

SELECT *
FROM "returns" AS re
WHERE re.return_id IS NULL
   OR re.order_item_id IS NULL
   OR re.customer_id IS NULL
   OR re.return_date IS NULL
   OR re.return_status IS NULL
   OR re.return_reason IS NULL
   OR re.refund_amount IS NULL
   OR re.refund_reference IS NULL;


-- ============================================================
-- Fill NULL values in return_reason
-- ============================================================

-- Replace NULL return_reason values
-- with the default value 'NA'.

UPDATE "returns" AS r
SET return_reason = 'NA'
WHERE r.return_reason IS NULL;


-- ============================================================
-- Fill NULL values in refund_reference
-- ============================================================

-- Replace NULL refund_reference values
-- with the default value 'NA'.

UPDATE "returns" AS r
SET refund_reference = 'NA'
WHERE r.refund_reference IS NULL;




-- ============================================================
                       -- PAYMENTS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- transaction_reference = 79038
-- payment_gateway = 64344

SELECT
       SUM(CASE WHEN pa.payment_id IS NULL THEN 1 ELSE 0 END) AS payment_id,
       SUM(CASE WHEN pa.order_id IS NULL THEN 1 ELSE 0 END) AS order_id,
       SUM(CASE WHEN pa.payment_date IS NULL THEN 1 ELSE 0 END) AS payment_date,
       SUM(CASE WHEN pa.payment_method IS NULL THEN 1 ELSE 0 END) AS payment_method,
       SUM(CASE WHEN pa.payment_status IS NULL THEN 1 ELSE 0 END) AS payment_status,
       SUM(CASE WHEN pa.amount IS NULL THEN 1 ELSE 0 END) AS amount,
       SUM(CASE WHEN pa.transaction_reference IS NULL THEN 1 ELSE 0 END) AS transaction_reference,
       SUM(CASE WHEN pa.payment_gateway IS NULL THEN 1 ELSE 0 END) AS payment_gateway
FROM payments AS pa;


-- Identify records containing NULL values.
-- NULL values were found in transaction_reference
-- and payment_gateway.

SELECT *
FROM payments AS pa 
WHERE pa.payment_id IS NULL
   OR pa.order_id IS NULL 
   OR pa.payment_date IS NULL
   OR pa.payment_method IS NULL
   OR pa.payment_status IS NULL
   OR pa.amount IS NULL
   OR pa.transaction_reference IS NULL
   OR pa.payment_gateway IS NULL;


-- ============================================================
-- Fill NULL values in transaction_reference
-- ============================================================

-- Replace NULL transaction_reference values
-- with the default value 'NA'.

UPDATE payments AS pa 
SET transaction_reference = 'NA'
WHERE pa.transaction_reference IS NULL;


-- ============================================================
-- Fill NULL values in payment_gateway
-- ============================================================

-- Replace NULL payment_gateway values
-- with the default value 'NA'.

UPDATE payments AS pa 
SET payment_gateway = 'NA'
WHERE pa.payment_gateway IS NULL;

-- ============================================================
                            -- REVIEWS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- review_comment = 33554
-- seller_reply = 21567

SELECT  
       SUM(CASE WHEN r.customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
       SUM(CASE WHEN r.product_id IS NULL THEN 1 ELSE 0 END) AS product_id,
       SUM(CASE WHEN r.review_id IS NULL THEN 1 ELSE 0 END) AS review_id,
       SUM(CASE WHEN r.seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id,
       SUM(CASE WHEN r.review_date IS NULL THEN 1 ELSE 0 END) AS review_date,
       SUM(CASE WHEN r.rating IS NULL THEN 1 ELSE 0 END) AS rating,
       SUM(CASE WHEN r.review_comment IS NULL THEN 1 ELSE 0 END) AS review_comment,
       SUM(CASE WHEN r.seller_reply IS NULL THEN 1 ELSE 0 END) AS seller_reply
FROM reviews AS r;


-- Identify records containing NULL values.
-- NULL values were found in review_comment
-- and seller_reply.

SELECT *
FROM reviews AS r
WHERE r.customer_id IS NULL
   OR r.product_id IS NULL
   OR r.review_id IS NULL
   OR r.seller_id IS NULL
   OR r.review_date IS NULL
   OR r.rating IS NULL
   OR r.review_comment IS NULL
   OR r.seller_reply IS NULL;


-- ============================================================
-- Fill NULL values in review_comment
-- ============================================================

-- Replace NULL review_comment values
-- with the default value 'NA'.

UPDATE reviews AS r
SET review_comment = 'NA'
WHERE r.review_comment IS NULL;


-- ============================================================
-- Fill NULL values in seller_reply
-- ============================================================

-- Replace NULL seller_reply values
-- with the default value 'NA'.

UPDATE reviews AS r
SET seller_reply = 'NA'
WHERE r.seller_reply IS NULL;


-- ============================================================
                            -- ORDERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- Total NULL values:
-- coupon_id = 60076
-- order_notes = 70915

SELECT 
       SUM(CASE WHEN o.order_id IS NULL THEN 1 ELSE 0 END) AS order_id,
       SUM(CASE WHEN o.customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id,
       SUM(CASE WHEN o.warehouse_id IS NULL THEN 1 ELSE 0 END) AS warehouse_id,
       SUM(CASE WHEN o.order_date IS NULL THEN 1 ELSE 0 END) AS order_date,
       SUM(CASE WHEN o.order_status IS NULL THEN 1 ELSE 0 END) AS order_status,
       SUM(CASE WHEN o.coupon_id IS NULL THEN 1 ELSE 0 END) AS coupon_id,
       SUM(CASE WHEN o.order_total IS NULL THEN 1 ELSE 0 END) AS order_total,
       SUM(CASE WHEN o.order_notes IS NULL THEN 1 ELSE 0 END) AS order_notes
FROM orders AS o;


-- Identify records containing NULL values.
-- NULL values were found in coupon_id
-- and order_notes.

SELECT *
FROM orders AS o
WHERE o.order_id IS NULL
   OR o.customer_id IS NULL
   OR o.warehouse_id IS NULL
   OR o.order_date IS NULL
   OR o.order_status IS NULL
   OR o.coupon_id IS NULL 
   OR o.order_total IS NULL
   OR o.order_notes IS NULL;


-- ============================================================
-- Fill NULL values in order_notes
-- ============================================================

-- Replace NULL order_notes values
-- with the default value 'NA'.

UPDATE orders AS o
SET order_notes = 'NA'
WHERE o.order_notes IS NULL;


-- ============================================================
                       -- ORDER ITEMS
-- ============================================================

-- Check for NULL values in order-item data.
-- No NULL values were found based on the current dataset.

SELECT *
FROM order_items AS oi
WHERE oi.order_item_id IS NULL
   OR oi.order_id IS NULL
   OR oi.product_id IS NULL
   OR oi.seller_id IS NULL 
   OR oi.unit_price IS NULL
   OR oi.line_total IS NULL;
