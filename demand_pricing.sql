-- creating tables

-- customer table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL
);

--orders table
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(20) NOT NULL,

    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME NOT NULL
);

-- order item table

CREATE TABLE order_items (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,

    shipping_limit_date DATETIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id)
);

-- products table
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100) NULL,

    product_name_length INT NULL,
    product_description_length INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,

    product_length_cm INT NULL,
    product_height_cm INT NULL,
    product_width_cm INT NULL
);

-- sellers table
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL
);

-- order_review table
CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,

    review_score INT NULL,
    review_comment_title VARCHAR(255) NULL,
    review_comment_message VARCHAR(2000) NULL,

    review_creation_date DATETIME NOT NULL,
    review_answer_timestamp DATETIME NULL
);

-- Foreign key
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);


ALTER TABLE order_reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- check primary key
EXEC sp_help customers;
EXEC sp_help orders;
EXEC sp_help order_items;

-- check foreign key
SELECT
    name AS fk_name,
    OBJECT_NAME(parent_object_id) AS child_table,
    OBJECT_NAME(referenced_object_id) AS parent_table
FROM sys.foreign_keys;

SELECT COUNT(*) AS row_count FROM customers;
SELECT COUNT(*) AS row_count FROM sellers;
SELECT COUNT(*) AS row_count FROM products;
SELECT COUNT(*) AS row_count FROM orders;
SELECT COUNT(*) AS row_count FROM order_items;
SELECT COUNT(*) AS row_count FROM order_reviews;


SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- inserting imported data into manual table
-- customer
INSERT INTO customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM olist_customers_dataset;

-- seller
INSERT INTO sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM olist_sellers_dataset;

-- products
INSERT INTO products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    product_id,
    product_category_name,
    product_name_lenght,            
    product_description_lenght,     
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset;

-- order

INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset;

--order_item
INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM olist_order_items_dataset;


-- order reviews

WITH dedup_reviews AS (
    SELECT
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY review_id
            ORDER BY review_creation_date DESC
        ) AS rn
    FROM olist_order_reviews_dataset
)
INSERT INTO order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM dedup_reviews
WHERE rn = 1;


SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT review_id
    FROM olist_order_reviews_dataset
    GROUP BY review_id
    HAVING COUNT(*) > 1
) d;



-- verify
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM olist_customers_dataset;

SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM olist_order_items_dataset;

SELECT COUNT(*) FROM order_reviews;
SELECT COUNT(*) FROM olist_order_reviews_dataset;

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM olist_orders_dataset;

SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM olist_products_dataset;

SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM olist_sellers_dataset;

--clean
DROP TABLE olist_customers_dataset;
DROP TABLE olist_sellers_dataset;
DROP TABLE olist_products_dataset;
DROP TABLE olist_orders_dataset;
DROP TABLE olist_order_items_dataset;
DROP TABLE olist_order_reviews_dataset;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;

-- verifying data
SELECT TOP 10
    o.order_id,
    c.customer_city,
    oi.price,
    r.review_score
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%order%';

EXEC sp_help orders;

SELECT MIN(price), MAX(price) FROM order_items;

--1.Seller Reliability & Cancellation Risk
--Which sellers are unreliable due to cancellations or slow delivery?

SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders,
    ROUND(
        SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) * 100.0
        / COUNT(DISTINCT o.order_id), 2
    ) AS cancel_rate_pct,
    AVG(
        DATEDIFF(
            DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )
    ) AS avg_delivery_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
ORDER BY cancel_rate_pct DESC;

--Insight
--Cancellation risk is concentrated in a small set of low-volume sellers
--High-volume sellers are generally more reliable
--Delivery time consistency improves with seller experience/scale



--2.Delivery Delay Root Cause (Seller vs Carrier)
-- Are delays caused more by sellers or logistics partners?

SELECT
    CASE
        WHEN DATEDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_carrier_date) > 3
            THEN 'Seller Delay'
        WHEN DATEDIFF(DAY, o.order_delivered_carrier_date, o.order_delivered_customer_date) > 5
            THEN 'Carrier Delay'
        ELSE 'On Time'
    END AS delay_reason,
    COUNT(*) AS orders
FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    CASE
        WHEN DATEDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_carrier_date) > 3
            THEN 'Seller Delay'
        WHEN DATEDIFF(DAY, o.order_delivered_carrier_date, o.order_delivered_customer_date) > 5
            THEN 'Carrier Delay'
        ELSE 'On Time'
    END;
--insights
--Carrier delays are the dominant cause of late deliveries
--Seller delays are significant but not the primary bottleneck


--3.Low-Rating Product Categories (Quality Risk)
-- Which product categories receive the worst customer feedback?

SELECT
    p.product_category_name,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING COUNT(r.review_id) > 100
ORDER BY avg_review_score ASC;
--insights
--Several high-volume categories have only average satisfaction
--Products with missing category mapping (NULL) also receive poor feedback

-- 4.Price Sensitivity vs Satisfaction
--Do higher-priced products result in worse reviews or slower delivery?

SELECT
    CASE
        WHEN oi.price < 50 THEN 'Low Price'
        WHEN oi.price BETWEEN 50 AND 150 THEN 'Mid Price'
        ELSE 'High Price'
    END AS price_bucket,
    ROUND(AVG(r.review_score), 2) AS avg_review,
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date
            )
        ), 2
    ) AS avg_delivery_days
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    CASE
        WHEN oi.price < 50 THEN 'Low Price'
        WHEN oi.price BETWEEN 50 AND 150 THEN 'Mid Price'
        ELSE 'High Price'
    END;
--insights
--Premium pricing must be supported with better logistics
--Faster delivery for high-value orders can improve perceived value



--5.Customer Repeat Purchase Risk
-- How delivery experience affects repeat customer behavior?

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    ROUND(AVG(co.total_orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date
            )
        ), 2
    ) AS avg_delivery_days
FROM orders o
JOIN customer_orders co ON o.customer_id = co.customer_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL;
-- insights
--Marketplace is dominated by one-time buyers
--Delivery experience alone is not driving repeat purchases




--6. Revenue Concentration by Sellers (Platform Risk)
--Is revenue dependent on a small group of sellers?

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
FROM order_items
GROUP BY seller_id;
-- insights
--Revenue is highly concentrated among top sellers
--Platform risk exists if top sellers churn


--7.Weekend vs Weekday Operational Risk
--Are weekends riskier in terms of delivery and customer satisfaction?

SELECT
    CASE
        WHEN DATENAME(WEEKDAY, o.order_purchase_timestamp) IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date
            )
        ), 2
    ) AS avg_delivery_days
FROM orders o
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    CASE
        WHEN DATENAME(WEEKDAY, o.order_purchase_timestamp) IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END;
-- insights
--Current staffing & logistics coverage is adequate
--No weekend-specific operational escalation needed