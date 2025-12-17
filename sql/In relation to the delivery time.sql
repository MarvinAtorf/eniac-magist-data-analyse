#What’s the average time between the order being placed and the product being delivered?
SELECT * FROM orders;
    SELECT
        AVG(DATEDIFF(o.order_approved_at,o.order_delivered_customer_date)* -1) AS'avg_delivery_days'
    FROM
         orders o;
#How many orders are delivered on time vs orders delivered with a delay?

SELECT
    CASE
        WHEN DATE_FORMAT(o.order_delivered_customer_date, '%Y-%m-%d')
          <=
      DATE_FORMAT(o.order_estimated_delivery_date, '%Y-%m-%d') THEN 'on_time'

        ELSE 'delayed'
        END AS delivery_status,
        COUNT(*) AS num_orders

FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY  delivery_status;


#Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT CASE
           WHEN product_weight_g < 500 THEN 'leicht'
           WHEN product_weight_g < 2000 THEN 'mittel'
           ELSE 'schwer'
           END  AS weight_class,
       COUNT(*) AS 'total_count',
       COUNT(
               CASE
                   WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) THEN 1
                   END
       )        AS delay_count,
       ROUND(COUNT(CASE
                       WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) THEN 1
           END) * 100.0 / COUNT(*), 2)
                AS 'delay_rate'
FROM orders o
         INNER JOIN order_items ot
                    ON o.order_id = ot.order_id
         INNER JOIN products p
                    ON ot.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY weight_class

