#How many months of data are included in the magist database?

#How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?


SELECT total_sellers,
       tech_sellers,
       percantages_tech_seller

FROM (SELECT (SELECT COUNT(*)
              FROM sellers)                                          AS 'total_sellers',
             (SELECT COUNT(DISTINCT s.seller_id)
              FROM sellers s
                       INNER JOIN order_items ot
                                  ON s.seller_id = ot.seller_id
                       INNER JOIN products p
                                  ON ot.product_id = p.product_id
                       INNER JOIN product_category_name_translation pcnt
                                  ON p.product_category_name = pcnt.product_category_name
              WHERE pcnt.product_category_name_english
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
                            'signaling_and_security'))               AS 'tech_sellers',
             (SELECT ROUND(100.0 / total_sellers * tech_sellers, 2)) AS percantages_tech_seller) AS tssoppC;

#What is the total amount earned by all sellers?
SELECT Sum(op.payment_value) AS 'total_amount' FROM order_payments op;



#What is the total amount earned by all Tech sellers?

SELECT
    ROUND(SUM(ot.price), 2) AS 'total_amount'
FROM order_items ot
         INNER JOIN products p
                    ON ot.product_id = p.product_id
         INNER JOIN magist.product_category_name_translation pcnt
                    ON p.product_category_name = pcnt.product_category_name
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


#further thougts is their revenue on all tech product in avg higher than ours?
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%M')                        AS month,
       ROUND(SUM(ot.price + ot.freight_value), 2)                           AS revenue,
       1170000                                                              AS eniac_avg_month_revenue,
       ROUND(ROUND(SUM(ot.price + ot.freight_value), 2) / 1170000 * 100, 2) AS magist_eniac_rate
FROM orders o
         INNER JOIN order_items ot
                    ON o.order_id = ot.order_id
         INNER JOIN products p
                    ON ot.product_id = p.product_id
         INNER JOIN product_category_name_translation t
                    ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IN (
                                          'computers',
                                          'computers_accessories',
                                          'telephony'
    )

  AND o.order_delivered_customer_date >= '2017-04-01'
  AND o.order_delivered_customer_date < '2018-04-01'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%M')
ORDER BY magist_eniac_rate DESC;
#conclusion, magist is a standard warehouse not specialist at our premium portfolio.
#We should consider to have a look for warehouses with our needs

# check Christmas delivery and revenue
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%M') AS month,
       ROUND(SUM(ot.price + ot.freight_value),2)   AS revenue
FROM orders o
         INNER JOIN order_items ot
                    ON o.order_id = ot.order_id
         INNER JOIN products p
                    ON ot.product_id = p.product_id
         INNER JOIN product_category_name_translation t
                    ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IN (
                                          'computers',
                                          'computers_accessories',
                                          'electronics',
                                          'telephony'
    )
AND
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') = '2018-02'

GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%M')
ORDER BY Month;

# | Vergleich                                                              | Sinnvoll?      |
# | ---------------------------------------------------------------------- | -------------- |
# | Euer **Avg. Item Price (€540)** vs. **BR Avg. Tech Item Price**        | ✅ **Sehr gut** |
# | Euer **Avg. Order Price (€710)** vs. **BR Avg. Order Basket**          | ✅ **Sehr gut** |
# | Euer **Avg. Monthly Revenue (€1.17M)** vs. **BR Tech Monthly Revenue** | ✅ **Sehr gut** |
# | Euer **Total Revenue (€14M)** vs. BR Jahres-Revenue                    | ✅ **Sehr gut** |

SELECT DISTINCT * FROM order_reviews;

SELECT DATEDIFF(orders.order_delivered_customer_date, orders.order_estimated_delivery_date) FROM orders;
SELECT orders.order_delivered_customer_date,
       orders.order_estimated_delivery_date,
       ROUND(AVG(DATEDIFF(orders.order_delivered_customer_date, orders.order_estimated_delivery_date))
       ) AS 'date-diff-avg'
FROM orders
GROUP BY orders.order_id;