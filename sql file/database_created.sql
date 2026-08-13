-- ============================================================
-- E-COMMERCE / SUPPLY CHAIN DATABASE
-- PostgreSQL Database Schema
-- ============================================================
-- Purpose:
-- This database manages customers, products, sellers, suppliers,
-- warehouses, orders, payments, shipments, returns, reviews,
-- coupons, purchase orders, and website sessions.
--
-- Primary Key  = PK
-- Foreign Key  = FK
-- ============================================================


-- ============================================================
-- 1. CATEGORIES
-- ============================================================
-- Stores product categories and supports hierarchical
-- parent-child category relationships.

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,

    -- Self-referencing FK:
    -- A category can belong to another parent category.
    CONSTRAINT fk_parent_category
        FOREIGN KEY (parent_category_id)
        REFERENCES categories(category_id)
);


-- ============================================================
-- 2. CUSTOMERS
-- ============================================================
-- Stores customer personal, contact and registration information.

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    customer_name VARCHAR(150),
    email VARCHAR(150),
    alternate_email VARCHAR(150),
    address_line1 VARCHAR(255),
    apartment_number VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country VARCHAR(100),
    registration_date DATE
);


-- ============================================================
-- 3. SELLERS
-- ============================================================
-- Stores information about sellers/vendors who sell products
-- through the e-commerce platform.

CREATE TABLE sellers (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(150),
    email VARCHAR(150),
    seller_description TEXT,
    website VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    seller_rating DECIMAL(3,2),
    registration_date DATE
);


-- ============================================================
-- 4. SUPPLIERS
-- ============================================================
-- Stores supplier information.
-- This table must be created before PRODUCTS because PRODUCTS
-- contains a foreign key referencing suppliers.

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(150),
    contact_email VARCHAR(150),
    city VARCHAR(100),
    country VARCHAR(100),
    registration_date DATE
);


-- ============================================================
-- 5. WAREHOUSES
-- ============================================================
-- Stores warehouse location and storage capacity information.

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    capacity INT
);


-- ============================================================
-- 6. PRODUCTS
-- ============================================================
-- Stores product master information.
--
-- Relationships:
-- category_id -> categories
-- seller_id   -> sellers
-- supplier_id -> suppliers

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    category_id INT,
    seller_id INT,
    supplier_id INT,
    brand VARCHAR(100),
    product_description TEXT,
    warranty_period VARCHAR(100),
    unit_price NUMERIC(10,2),
    stock_quantity INT,

    -- Product belongs to a category.
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    -- Product is associated with a seller.
    CONSTRAINT fk_product_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id),

    -- Product is supplied by a supplier.
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);


-- ============================================================
-- 7. COUPONS
-- ============================================================
-- Stores discount coupons and their validity information.

CREATE TABLE coupon (
    coupon_id INT PRIMARY KEY,
    coupon_code VARCHAR(50),
    discount_type VARCHAR(20),
    discount_value NUMERIC(10,2),
    minimum_order_value NUMERIC(10,2),
    maximum_discount NUMERIC(10,2),
    valid_from DATE,
    valid_to DATE,
    status VARCHAR(20)
);


-- ============================================================
-- 8. ORDERS
-- ============================================================
-- Stores customer order information.
--
-- Relationships:
-- customer_id -> customers
-- coupon_id   -> coupon
-- warehouse_id -> warehouses

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    coupon_id INT,
    order_date DATE,
    order_status VARCHAR(50),
    warehouse_id INT,
    order_notes TEXT,
    order_total NUMERIC(12,2),

    -- Identifies the customer who placed the order.
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    -- Identifies the coupon used for the order.
    CONSTRAINT fk_order_coupon
        FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id),

    -- Identifies the warehouse responsible for the order.
    CONSTRAINT fk_order_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);


-- ============================================================
-- 9. ORDER ITEMS
-- ============================================================
-- Stores individual products belonging to an order.
--
-- One order can contain multiple order items.

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    seller_id INT,
    quantity INT,
    unit_price NUMERIC(10,2),
    line_total NUMERIC(12,2),

    -- Links item to its order.
    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    -- Links item to the purchased product.
    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    -- Identifies the seller of the product.
    CONSTRAINT fk_item_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);


-- ============================================================
-- 10. PAYMENTS
-- ============================================================
-- Stores payment transactions associated with orders.

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    amount NUMERIC(12,2),
    transaction_reference VARCHAR(150),
    payment_gateway VARCHAR(100),

    -- Each payment belongs to an order.
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


-- ============================================================
-- 11. SHIPMENTS
-- ============================================================
-- Stores shipment and delivery tracking information.

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    warehouse_id INT,
    shipment_date DATE,
    carrier VARCHAR(100),
    tracking_number VARCHAR(150),
    tracking_notes TEXT,
    delivered_timestamp TIMESTAMP,
    shipment_status VARCHAR(50),

    -- Links shipment to the customer order.
    CONSTRAINT fk_shipment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    -- Identifies the warehouse from which shipment is dispatched.
    CONSTRAINT fk_shipment_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);


-- ============================================================
-- 12. PURCHASE ORDERS
-- ============================================================
-- Stores procurement orders placed with suppliers.

CREATE TABLE purchase_orders (
    purchase_order_id INT PRIMARY KEY,
    supplier_id INT,
    warehouse_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    unit_cost NUMERIC(10,2),
    status VARCHAR(50),
    expected_delivery_date DATE,

    -- Identifies the supplier.
    CONSTRAINT fk_po_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id),

    -- Identifies the receiving warehouse.
    CONSTRAINT fk_po_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),

    -- Identifies the product being purchased.
    CONSTRAINT fk_po_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- ============================================================
-- 13. RETURNS
-- ============================================================
-- Stores product return and refund information.

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_item_id INT,
    customer_id INT,
    return_date DATE,
    return_status VARCHAR(50),
    return_reason TEXT,
    refund_amount NUMERIC(10,2),
    refund_reference VARCHAR(150),

    -- Identifies which order item was returned.
    CONSTRAINT fk_return_orderitem
        FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id),

    -- Identifies the customer who returned the item.
    CONSTRAINT fk_return_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ============================================================
-- 14. REVIEWS
-- ============================================================
-- Stores customer reviews and seller responses.

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    seller_id INT,
    review_date DATE,
    rating DECIMAL(2,1),
    review_comment TEXT,
    seller_reply TEXT,

    -- Identifies the reviewed product.
    CONSTRAINT fk_review_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    -- Identifies the customer who submitted the review.
    CONSTRAINT fk_review_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    -- Identifies the seller associated with the review.
    CONSTRAINT fk_review_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);


-- ============================================================
-- 15. WEBSITE SESSIONS
-- ============================================================
-- Stores customer website browsing/session information.
-- Useful for marketing and customer behavior analysis.

CREATE TABLE website_sessions (
    session_id INT PRIMARY KEY,
    customer_id INT,
    session_start TIMESTAMP,
    session_end TIMESTAMP,
    device_type VARCHAR(50),
    referral_source VARCHAR(100),
    campaign_name VARCHAR(100),
    pages_viewed INT,

    -- Identifies the customer associated with the session.
    CONSTRAINT fk_session_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);