-- ============================================================
-- Домашнє завдання 5. Вкладені запити. Повторне використання коду
-- GoIT RDB Course
-- ============================================================

USE northwind;

-- ============================================================
-- Завдання 1: Вкладений запит в SELECT
-- Відобразити order_details + customer_id з таблиці orders
-- ============================================================

SELECT 
    od.*,
    (SELECT o.customer_id 
     FROM orders o 
     WHERE o.order_id = od.order_id) AS customer_id
FROM order_details od;

-- ============================================================
-- Завдання 2: Вкладений запит в WHERE
-- Відфільтрувати order_details де shipper_id = 3
-- ============================================================

SELECT * 
FROM order_details od
WHERE od.order_id IN (
    SELECT order_id 
    FROM orders 
    WHERE shipper_id = 3
);

-- ============================================================
-- Завдання 3: Вкладений запит в FROM
-- Рядки де quantity > 10, середнє quantity по order_id
-- ============================================================

SELECT order_id, AVG(quantity) AS avg_quantity
FROM (
    SELECT * FROM order_details WHERE quantity > 10
) AS filtered
GROUP BY order_id;

-- ============================================================
-- Завдання 4: WITH (CTE) — те саме що завдання 3
-- ============================================================

WITH temp AS (
    SELECT * FROM order_details WHERE quantity > 10
)
SELECT order_id, AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- ============================================================
-- Завдання 5: Функція divide_values(a, b) -> a / b
-- ============================================================

DROP FUNCTION IF EXISTS divide_values;

DELIMITER //
CREATE FUNCTION divide_values(a FLOAT, b FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    IF b = 0 THEN RETURN NULL; END IF;
    RETURN a / b;
END //
DELIMITER ;

-- Застосування функції до quantity з order_details
SELECT 
    order_detail_id,
    quantity,
    divide_values(quantity, 3) AS divided_by_3
FROM order_details;
