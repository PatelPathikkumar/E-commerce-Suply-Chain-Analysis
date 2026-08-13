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
-- DATA QUALITY CHECKING PROJECT
-- ============================================================
-- Purpose:
-- This project checks NULL values, missing values, and data
-- quality issues across all major e-commerce tables.
--
-- The analysis identifies:
-- 1. Total NULL values in each column
-- 2. Records containing NULL values
-- 3. Columns with missing information
-- 4. Important fields that may affect analysis
-- 5. Potential data-quality issues
-- ============================================================




-- ============================================================
                           -- COUPON
-- ============================================================


-- Check the total number of NULL values in each column.
-- total maximum_discount=145 , minimum_order_value= 132

select 
      sum( case when co.coupon_code is null then 1 else 0 end) as coupon_code,
	  sum( case when co.coupon_id is null then 1 else 0 end) as coupon_id,
	  sum( case when co.discount_type is null then 1 else 0 end) as discount_type,
	  sum( case when co.discount_value is null then 1 else 0 end) as discount_value,
	  sum( case when co.maximum_discount is null then 1 else 0 end) as maximum_discount,
	  sum( case when co.minimum_order_value is null then 1 else 0 end) as minimum_order_value,
	  sum( case when co.status is null then 1 else 0 end) as status,
	  sum( case when co.valid_from is null then 1 else 0 end) as valid_from,
	   sum( case when co.valid_to is null then 1 else 0 end) as valid_to
FROM coupon as co


-- Identify records containing NULL values.
-- NULL values were found in maximum_discount
-- and minimum_order_value.


select * from coupon as co
WHERE co.coupon_code is null 
      or co.coupon_id is null
	  or co.discount_type is null
	  or co.discount_value is null
	  or co.maximum_discount is null
	  or co.minimum_order_value is null
	  or co.status is null
	  or co.valid_from is null
	  or co.valid_to is null;


-- ============================================================
                        -- CUSTOMERS
-- ============================================================

-- Check the total number of NULL values in each column.
-- total middle_name=10959,alternate_email=12841,apartment_number=17929
select 
      sum( case when cu.first_name is null then 1 else 0 end) as first_name,
	  sum( case when cu.last_name is null then 1 else 0 end) as last_name,
	  sum( case when cu.middle_name is null then 1 else 0 end) as middle_name,
	  sum( case when cu.customer_name is null then 1 else 0 end) as customer_name,
	  sum( case when cu.email is null then 1 else 0 end) as email,
	  sum( case when cu.alternate_email is null then 1 else 0 end) as alternate_email,
	  sum( case when cu.apartment_number is null then 1 else 0 end) as apartment_number,
	  sum( case when cu.city is null then 1 else 0 end) as city,
	  sum( case when cu.state is null then 1 else 0 end) as state,
	  sum( case when cu.zip_code is null then 1 else 0 end) as aszip_code,
	  sum( case when cu.country is null then 1 else 0 end) as country,
	  sum( case when cu.registration_date is null then 1 else 0 end) as registration_date
from customers as cu

-- Identify records containing NULL values.
-- NULL values were found in middle_name,
-- alternate_email, and apartment_number.
   SELECT * from customers as cu
where cu.customer_id is null 
       or cu.first_name is null
	   or cu.last_name is null
	   or cu.middle_name is null
	   or cu.customer_name is null
	   or cu.email is null
	   or cu.alternate_email is null
	   or cu.address_line1 is null
	   or cu.apartment_number is null
	   or cu.city is null 
	   or cu.state is NULL
	   or cu.zip_code is null
	   or cu.country is null
	   or cu.registration_date is null;

-- ============================================================
                         -- CATEGORIES
-- ============================================================

-- No NULL-value check is required for this table
-- based on the current data-quality requirements.
SELECT * from categories;

-- ============================================================
                            -- PRODUCTS
-- ============================================================

-- Check the total number of NULL values in each column.
-- total brand=2464 ,product_description=3364,warranty_period=3814

select  sum( case when pr.product_id is null then 1 else 0 end) as product_id,
        sum( case when pr.product_name is null then 1 else 0 end) as product_name,
		sum( case when pr.category_id is null then 1 else 0 end) as category_id,
		sum( case when pr.seller_id is null then 1 else 0 end) as seller_id,
		sum( case when pr.supplier_id is null then 1 else 0 end) as supplier_id,
		sum( case when pr.brand is null then 1 else 0 end) as brand,
		sum( case when pr.product_description is null then 1 else 0 end) as product_description,
		sum( case when pr.warranty_period is null then 1 else 0 end) as warranty_period,
		sum( case when pr.unit_price is null then 1 else 0 end) as unit_price,
		sum( case when pr.stock_quantity is null then 1 else 0 end) as stock_quantity
from products as pr	;


-- Identify records containing NULL values.
-- NULL values were found in brand, product_description,
-- and warranty_period.
SELECT * from products as pr
WHERE pr.product_id is null 
      or pr.product_name is null
	  or pr.category_id is null
	  or pr.seller_id is null 
	  or pr.supplier_id is null
	  or pr.brand is null
	  or pr.product_description is null
	  or pr.warranty_period is null
	  or pr.unit_price is null 
	  or pr.stock_quantity is null;

-- ============================================================
                    -- PURCHASE ORDERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total expected_delivery_date=4733

SELECT   
       sum(case when po.product_id is null then 1 else 0 end) as product_id,
	   sum(case when po.supplier_id is  null then 1 else 0 end) as supplier_id,
	   sum(case when po.warehouse_id  is null then 1 else 0 end) as warehouse_id,
	   sum(case when po.purchase_order_id  is null then 1 else 0 end) as purchase_order_id,
	   sum(case when po.order_date  is null then 1 else 0 end) as order_date,
	   sum(case when po.quantity is  null then 1 else 0 end) as quantity,
	   sum(case when po.status  is null then 1 else 0 end) as status,
	   sum(case when po.expected_delivery_date is null then 1 else 0 end) as expected_delivery_date
from purchase_orders as po;

-- Identify records containing NULL values.
-- NULL values were found in expected_delivery_date.

select * from purchase_orders as po
where po.product_id is null 
      or po.supplier_id is null
	  or po.warehouse_id is null
	  or po.purchase_order_id is  null
	  or po.order_date is null
	  or po.quantity is null 
	  or po.status is null 
	  or po.expected_delivery_date is null;

-- ============================================================
                          -- SELLERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total seller_description=622,website=392

SELECT  
       sum(case when s.seller_id is null then 1 else 0 end ) as seller_id,
	   sum(case when s.seller_name is null then 1 else 0 end ) as seller_name,
	   sum(case when s.email is null then 1 else 0 end ) as email,
	   sum(case when s.seller_description is null then 1 else 0 end ) as seller_description,
	   sum(case when s.website is null then 1 else 0 end ) as website,
	   sum(case when s.city is null then 1 else 0 end ) as city,
	   sum(case when s.state is null then 1 else 0 end ) as state,
	   sum(case when s.country is null then 1 else 0 end ) as country,
	   sum(case when s.seller_rating is null then 1 else 0 end ) as seller_rating,
	   sum(case when s.registration_date is null then 1 else 0 end ) as registration_date
from sellers as s;

-- Identify records containing NULL values.
-- NULL values were found in seller_description and website .
select  * from   sellers as s
where s.seller_id is null 
      or s.seller_name is null
	  or s.email is null 
	  or s.seller_description is null
	  or s.website is null
	  or s.city is null 
	  or s.state is null 
	  or s.country is null 
	  or s.seller_rating is null
	  or s. registration_date is null;
             
			 
-- ============================================================
                        -- WAREHOUSES
-- ============================================================

-- Check for NULL values in warehouse data.
-- No NULL values were found based on the current dataset.
SELECT * from warehouses as w
where w.warehouse_id is null
       or w.warehouse_name is null
	   or w.city is null 
	   or w.state is null 
	   or w.country is null
	   or w.capacity is null


-- ============================================================
                   -- WEBSITE SESSIONS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total referral_source=66999,campaign_name=83554

SELECT
        sum(case when ws.session_id is null then 1 else 0 end ) as session_id,
		sum(case when ws.customer_id is null then 1 else 0 end ) as customer_id,
		sum(case when ws.session_start is null then 1 else 0 end ) as session_start,
		sum(case when ws.session_end is null then 1 else 0 end ) as session_end,
		sum(case when ws.device_type is null then 1 else 0 end ) as device_type,
		sum(case when ws.referral_source is null then 1 else 0 end ) as referral_source,
		sum(case when ws.campaign_name is null then 1 else 0 end ) as campaign_name,
		sum(case when ws.pages_viewed is null then 1 else 0 end ) as pages_viewed
from website_sessions as ws;

-- Identify records containing NULL values.
-- NULL values were found in referral_source
-- and campaign_name.


select * from website_sessions as ws
where ws.session_id is null
      or ws.customer_id is null
	  or ws.session_end is null
	  or ws.session_start is null
	  or ws.device_type is null
	  or ws.referral_source is null
	  or ws.campaign_name is null 
	  or ws.pages_viewed is null;

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
-- total tracking_notes=45622,delivered_timestamp=46072

SELECT
       sum(case when sh.shipment_id is null then 1 else 0 end ) as shipment_id,
	   sum(case when sh.order_id is null then 1 else 0 end ) as order_id,
	   sum(case when sh.carrier is null then 1 else 0 end ) as carrier,
	   sum(case when sh.shipment_date is null then 1 else 0 end ) as shipment_date,
	   sum(case when sh.tracking_number is null then 1 else 0 end ) as tracking_number,
	   sum(case when sh.tracking_notes is null then 1 else 0 end ) as tracking_notes,
	   sum(case when sh.delivered_timestamp is null then 1 else 0 end ) as delivered_timestamp,
	   sum(case when sh.shipment_status is null then 1 else 0 end ) as shipment_status
from shipments as sh;


-- Identify records containing NULL values.
-- NULL values were found in tracking_notes
-- and delivered_timestamp.

select * from shipments as sh
WHERE sh.shipment_id is null
      or sh.order_id is null
	  or sh.carrier is null 
	  or sh.shipment_date is null
	  or sh.tracking_notes is null
	  or sh.tracking_number is null
	  or sh.delivered_timestamp is null
	  or sh.shipment_status is null;

-- ============================================================
                       -- RETURNS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total return_reason=9537,refund_reference=7173


SELECT  
       sum(case when  re.return_id is null  then 1 else 0 end) as return_id,
	   sum(case when  re.order_item_id is null  then 1 else 0 end) as order_item_id,
	   sum(case when  re.customer_id is null  then 1 else 0 end) as customer_id,
	   sum(case when  re.return_date is null  then 1 else 0 end) as return_date,
	   sum(case when  re.return_status is null  then 1 else 0 end) as return_status,
	   sum(case when  re.return_reason is null  then 1 else 0 end) as return_reason,
	   sum(case when  re.refund_amount is null  then 1 else 0 end) as refund_amount,
	   sum(case when  re.refund_reference is null  then 1 else 0 end) as refund_reference
from "returns" as re;

-- Identify records containing NULL values.
-- NULL values were found in return_reason and refund_reference

select * from  "returns" as re
where re.return_id is null
      or re.order_item_id is null
	  or re.customer_id is null
	  or re.return_date is null
	  or re.return_status is null
	  or re.return_reason is null
	  or re.refund_amount is null
	  or re.refund_reference is null;


-- ============================================================
                       -- PAYMENTS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total transaction_reference=79038,payment_gateway=64344

SELECT
        sum(case when pa.payment_id is null then 1 else 0 end) as payment_id,
		sum(case when pa.order_id is null then 1 else 0 end) as order_id,
		sum(case when pa.payment_date is null then 1 else 0 end) as payment_date,
		sum(case when pa.payment_method is null then 1 else 0 end) as payment_method,
		sum(case when pa.payment_status is null then 1 else 0 end) as payment_status,
		sum(case when pa.amount is null then 1 else 0 end) as amount,
		sum(case when pa.transaction_reference is null then 1 else 0 end) as transaction_reference,
		sum(case when pa.payment_gateway is null then 1 else 0 end) as payment_getway
from payments as pa;


-- Identify records containing NULL values.
-- NULL values were found in transaction_reference
-- and payment_gateway.


select * from payments as pa 
WHERE pa.payment_id is NULL
      or pa.order_id is null 
	  or pa.payment_date is null
	  or pa.payment_status is null
	  or pa.amount is null
	  or pa.transaction_reference is null
	  or pa.payment_gateway is null;


-- ============================================================
                            -- REVIEWS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total review_comment=33554,seller_reply=21567

SELECT  
        sum(case when r.customer_id is null then 1 else 0 end) as customer_id,
		sum(case when r.product_id is null then 1 else 0 end) as product_id,
		sum(case when r.review_id is null then 1 else 0 end) as review_id,
		sum(case when r.seller_id is null then 1 else 0 end) as seller_id,
		sum(case when r.review_date is null then 1 else 0 end) as review_date,
		sum(case when r.rating is null then 1 else 0 end) as rating,
		sum(case when r.review_comment is null then 1 else 0 end) as review_comment,
		sum(case when r.seller_reply is null then 1 else 0 end) as seller_reply		
from reviews as r


-- Identify records containing NULL values.
-- NULL values were found in review_comment
-- and seller_reply.

SELECT * from reviews as r
WHERE	r.customer_id is null
        or r.product_id is null
		or r.review_id is null
		or r.seller_id is null
		or r.review_date is null
		or r.rating is null
		or r.review_comment is null
		or r.seller_reply is null;
				   

-- ============================================================
                       -- ORDERS
-- ============================================================

-- Calculate the total number of NULL values in each column.
-- total coupon_id=60076,order_notes=70915

SELECT 
         sum(case when o.order_id is null then 1 else 0 end  ) as  order_id,
		 sum(case when o.customer_id is null then 1 else 0 end  ) as customer_id,
		 sum(case when o.warehouse_id is null then 1 else 0 end  ) as warehouse_id,
		 sum(case when o.order_date is null then 1 else 0 end  ) as order_date,
		 sum(case when o.order_status is null then 1 else 0 end  ) as order_status,
		 sum(case when o.coupon_id is null then 1 else 0 end  ) as coupon_id,
		 sum(case when o.order_total is null then 1 else 0 end  ) as order_total,
		  sum(case when o.order_notes is null then 1 else 0 end  ) as order_notes
from orders as o



-- Identify records containing NULL values.
-- NULL values were found in coupon_id and order_notes.


SELECT * from orders as o
WHERE o.order_id is null
      or o.customer_id is null
	  or o.warehouse_id is null
	  or o.order_date is null
	  or o.order_status is null
	  or o.coupon_id is null 
	  or o.order_total is null
	  or o.order_notes is null


-- ============================================================
      -- ORDER ITEMS
-- ============================================================

-- Check for NULL values in order-item data.
-- No NULL values were found based on the current dataset.
SELECT * from order_items as oi
WHERE oi.order_item_id is null
      or oi.order_id is null
	  or oi.product_id is null
	  or oi.seller_id is null 
	  or oi.unit_price is null
	  or oi.line_total is null





