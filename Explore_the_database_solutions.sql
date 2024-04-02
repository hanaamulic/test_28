-- 1. How many orders are there in the dataset? The orders table contains a row for each order, so this should be easy to find out!-- 
select count(*) from ord;

SELECT count(order_id), count(distinct order_id) from order_items;


-- 2. Are orders actually delivered? Look at the columns in the orders table: one of them is called order_status. 
-- Most orders seem to be delivered, but some aren’t. Find out how many orders are delivered and how many are cancelled, 
-- unavailable, or in any other status by grouping and aggregating this column.
Select order_status, FORMAT(count(order_id),0) AS No_of_orders
from orders
group by order_status
order by count(order_id) desc;


-- 3. Is Magist having user growth? A platform losing users left and right isn’t going to be very useful 
-- to us. It would be a good idea to check for the number of orders grouped by year and month.
--  Tip: you can use the functions YEAR() and MONTH() to separate the year and the month of the order_purchase_timestamp.

select year(order_purchase_timestamp) as `Year`, month(order_purchase_timestamp) as `Month`, count(order_id)
From orders
Group by  `Year`, `Month`
HAVING `Year` > 2016 AND NOT(`Year` = 2018 AND `Month` >= 9)
Order by  `Year`, `Month`;

SELECT HOUR(order_purchase_timestamp), COUNT(order_id)
FROM orders
GROUP BY HOUR(order_purchase_timestamp)
ORDER BY HOUR(order_purchase_timestamp);

-- 4. How many products are there on the products table? (Make sure that there are no duplicate products.)
SELECT COUNT(DISTINCT product_id) AS num_products
FROM products;

SELECT count(product_id), count(distinct product_id) from order_items;

-- 5. Which are the categories with the most products? Since this is an external database and has been partially 
-- anonymized, we do not have the names of the products. But we do know which categories products belong to. 
-- This is the closest we can get to knowing what sellers are offering in the Magist marketplace. By counting the 
-- rows in the products table and grouping them by categories, we will know how many products are offered in each category. 
-- This is not the same as how many products are actually sold by category. To acquire this insight we will have to combine 
-- multiple tables together: we’ll do this in the next lesson.
SELECT p.product_category_name, p_c_n.product_category_name_english, COUNT(p.product_id)
FROM products AS p
LEFT JOIN product_category_name_translation AS p_c_n
ON p.product_category_name = p_c_n.product_category_name
GROUP BY p.product_category_name
ORDER BY COUNT(p.product_id) DESC
LIMIT 5;

select count(product_id), product_category_name
from products
group by product_category_name
order by count(product_id) desc
LIMIT 10;

SELECT *
FROM products AS p
LEFT JOIN product_category_name_translation AS p_c_n
-- ON p.product_category_name = p_c_n.product_category_name;
USING (product_category_name);


-- 6. How many of those products were present in actual transactions? The products table is a “reference” of 
-- all the available products. Have all these products been involved in orders? Check out the order_items table to find out!
SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;

-- 7. What’s the price for the most expensive and cheapest products? Sometimes, having a broad range of prices is informative. 
-- Looking for the maximum and minimum values is also a good way to detect extreme outliers.
select max(price) as Maximum_price, min(price) as Minimum_price
from order_items;


-- SELECT p.product_category_name, MAX(o_i.price)  
-- FROM order_items AS o_i
-- LEFT JOIN products AS p
-- ON o_i.product_id = p.product_id
-- GROUP BY p.product_category_name;

SELECT product_id, price
FROM products
RIGHT JOIN order_items
USING(product_id)
ORDER BY price DESC
LIMIT 1;

SELECT product_id, price
FROM products
RIGHT JOIN order_items
USING(product_id)
ORDER BY price
LIMIT 1;

-- Difference between USING and ON:
SELECT product_id
FROM products
RIGHT JOIN order_items
USING(product_id)
ORDER BY price
LIMIT 1;

SELECT p.product_id
FROM products p
RIGHT JOIN order_items oi
ON p.product_id = oi.product_id
ORDER BY price
LIMIT 1;




-- 8. What are the highest and lowest payment values? Some orders contain multiple products. 
-- What’s the highest someone has paid for an order? Look at the order_payments table and try to find it out.
SELECT
	MAX(payment_value) AS max_value,
    MIN(payment_value) AS min_value
FROM
	order_payments;

SELECT order_id, payment_value
FROM order_payments
ORDER BY payment_value DESC
LIMIT 1;

SELECT order_id, payment_value
FROM order_payments
WHERE payment_value > 0
ORDER BY payment_value
LIMIT 1;
