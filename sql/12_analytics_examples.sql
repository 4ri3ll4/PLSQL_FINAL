-- 1. Running total of sales per product by date
SELECT product_id, sale_date,
       SUM(quantity_sold) OVER (PARTITION BY product_id ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
       AS running_total
FROM sales
WHERE product_id = 1
ORDER BY sale_date;

-- 2. Ranking top products by monthly sales
SELECT product_id, month, total_sold,
       RANK() OVER (ORDER BY total_sold DESC) AS sales_rank
FROM (
    SELECT product_id, TRUNC(sale_date,'MM') AS month, SUM(quantity_sold) AS total_sold
    FROM sales
    GROUP BY product_id, TRUNC(sale_date,'MM')
)
WHERE month >= ADD_MONTHS(TRUNC(SYSDATE,'MM'), -3)
ORDER BY month, sales_rank;
