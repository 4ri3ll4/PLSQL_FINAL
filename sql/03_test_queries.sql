-- 1. Counts
SELECT (SELECT COUNT(*) FROM suppliers) AS suppliers,
       (SELECT COUNT(*) FROM products)  AS products,
       (SELECT COUNT(*) FROM sales)     AS sales,
       (SELECT COUNT(*) FROM employees) AS employees
FROM dual;

-- 2. Top 10 selling products (by quantity)
SELECT p.product_id, p.product_name, SUM(s.quantity_sold) total_sold
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
FETCH FIRST 10 ROWS ONLY;

-- 3. Products currently below reorder level
SELECT product_id, product_name, stock_quantity, reorder_level
FROM products
WHERE stock_quantity <= reorder_level
ORDER BY product_id;

-- 4. Sample inventory log
SELECT * FROM inventory_log WHERE ROWNUM <= 10;

-- 5. Check random product
SELECT * FROM products WHERE product_id = 5;
