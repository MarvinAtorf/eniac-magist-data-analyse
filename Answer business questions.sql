#What categories of tech products does Magist have?
SELECT product_category_name_english AS 'category'
FROM product_category_name_translation
WHERE product_category_name_english
          IN (
              'computers',
              'computers_accessories',
              'electronics',
              'audio',
              'pc_gamer',
              'tablets_printing_image',
              'cine_photo',
              'consoles_games',
              'fixed_telephony',
              'telephony',
              'signaling_and_security');
#How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
SELECT
    COUNT(*)
FROM order_items ot
         INNER JOIN products p
                    ON ot.product_id = p.product_id
         INNER JOIN product_category_name_translation pt
                    ON p.product_category_name = pt.product_category_name
WHERE product_category_name_english
          IN (
              'computers',
              'computers_accessories',
              'electronics',
              'audio',
              'pc_gamer',
              'tablets_printing_image',
              'cine_photo',
              'consoles_games',
              'fixed_telephony',
              'telephony',
              'signaling_and_security');

SELECT pt.product_category_name_english,
       COUNT(*)                                                        AS 'tech_products_sold',
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_items), 2) AS 'tech_product_percentage (%)',
       (SELECT COUNT(*) FROM order_items o1)                           AS 'total_amount_of_orders'
FROM order_items ot
         INNER JOIN products p
                    ON ot.product_id = p.product_id
         INNER JOIN product_category_name_translation pt
                    ON p.product_category_name = pt.product_category_name
WHERE product_category_name_english
          IN (
              'computers',
              'computers_accessories',
              'electronics',
              'audio',
              'pc_gamer',
              'tablets_printing_image',
              'cine_photo',
              'consoles_games',
              'fixed_telephony',
              'telephony',
              'signaling_and_security')
GROUP BY pt.product_category_name_english;

#What’s the average price of the products being sold?
SELECT ROUND(AVG(ot.price),2) AS 'avg_selling_price' FROM order_items ot;
#Are expensive tech products popular?


#little fun and test to try iqr in sql
SELECT quartile,
       MIN(price) AS min_price,
       MAX(price) AS max_price,
       COUNT(*)   AS products_in_quartile
FROM (SELECT ot.price,
             NTILE(4) OVER (ORDER BY ot.price) AS quartile
      FROM order_items ot
               JOIN products p
                    ON ot.product_id = p.product_id
               JOIN product_category_name_translation pcnt
                    ON p.product_category_name = pcnt.product_category_name
      WHERE pcnt.product_category_name_english IN ('computers',
                                                   'computers_accessories',
                                                   'telephony'
          )) AS q
GROUP BY quartile
ORDER BY quartile;

#75% of tech products sold are under 119.99€
#The upper part ranges from 119.99 to 6729
#as basis of my previously calculated iqr here is a table with their related iqr categories
SELECT
    product_category_name_english,
    ot.price,
CASE
    WHEN ot.price >= 131 THEN 'Premium Tech'
    WHEN ot.price >= 59  THEN 'Mid-Range Tech'
    ELSE 'Budget Tech'
END AS price_segment


FROM order_items ot
      INNER JOIN products p
                    ON ot.product_id = p.product_id
         INNER JOIN product_category_name_translation pt
                    ON p.product_category_name = pt.product_category_name
      WHERE pt.product_category_name_english IN ('computers',
                                                   'computers_accessories',
                                                   'telephony'
          )
GROUP BY product_category_name_english,ot.price;


#Are expensive tech products popular?
SELECT
    count_expensive_price,
    count_non_expensive_price,

    ROUND(count_expensive_price * 100.0 / total_orders, 2)
        AS expensive_percentage,

    ROUND(count_non_expensive_price * 100.0 / total_orders, 2)
        AS non_expensive_percentage

FROM (
    SELECT
        (SELECT COUNT(*)
         FROM order_items
         WHERE price >= 119) AS count_expensive_price,

        (SELECT COUNT(*)
         FROM order_items
         WHERE price <= 118.99) AS count_non_expensive_price,

        (SELECT COUNT(*)
         FROM order_items) AS total_orders
) AS x;


#expensive products makes ~ 30.6% of the sales while non expensive products make ~ 69.6 out of magist sales

