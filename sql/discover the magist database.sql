#1.How many orders are there in the dataset?
SELECT COUNT(*) AS orders_count
FROM orders;
#2.Are orders actually delivered?
SELECT o.order_status,
       COUNT(o.order_status) AS 'amount',
CASE
    WHEN  COUNT(o.order_status) >1 AND o.order_status = "delivered" THEN 'yes'
END AS 'delivered'
FROM orders o
GROUP BY o.order_status
ORDER BY amount DESC;
#3. Is Magist having user growth?
SELECT YEAR(order_purchase_timestamp)  AS year_,
       MONTH(order_purchase_timestamp) AS month_,
       COUNT(customer_id)
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_;
#4. How many products are there in the products table?
SELECT COUNT(*)
FROM products;

#5. Which are the categories with most products?
SELECT product_category_name,
       COUNT(DISTINCT product_id) AS n_products
FROM products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

#6. How many of those products were present in actual transactions?
SELECT COUNT(DISTINCT product_id) AS n_products
FROM order_items;
#7 What’s the price for the most expensive and cheapest products?
SELECT MIN(price) AS cheapest,
       MAX(price) AS most_expensive
FROM order_items;
#8. What are the highest and lowest payment values?
#Highest and lowest payment values:

SELECT MAX(payment_value) AS highest,
       MIN(payment_value) AS lowest
FROM order_payments;

#Maximum someone has paid for an order:

SELECT SUM(payment_value) AS highest_order
FROM order_payments
GROUP BY order_id
ORDER BY highest_order DESC
LIMIT 1;

#discover product_translation
SELECT * FROM  product_category_name_translation;
# spain -> english

# discover sellers
SELECT * FROM sellers;
#seller_id -> seller_zip refs geo

#discover order_items
SELECT * FROM order_items; #all order_item info
SELECT  MIN(shipping_limit_date) #min shipping limit date 2016
FROM order_items;
