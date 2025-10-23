drop table if exists customers;
drop table if exists orders;

create table customers (
 id int primary key auto_increment,
 first_name varchar(50),
 last_name varchar(50)
) COMMENT = 'Customer information';

create table orders (
 id int primary key,
 customer_id int null,
 order_date date,
 total_amount decimal(10, 2),
 foreign key (customer_id) references customers(id)
) COMMENT = 'Order information';

insert into customers (id, first_name, last_name) values
# Add 4 customers to customers table
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Smith'),
(4, 'Bob', 'Brown');

insert into orders (id, customer_id, order_date, total_amount) values
# Add 6 orders to orders table
(1, 1, '2023-01-01', 100.00),
(2, 1, '2023-02-01', 150.00),
(3, 2, '2023-01-01', 200.00),
(4, 3, '2023-04-01', 250.00),
(5, 3, '2023-04-01', 300.00),
(6, NULL, '2023-04-01', 100.00);

# use GROUP BY to find the total amount spent by each customer
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

# use GROUP BY to find the total amount spent by each customer on each order date
SELECT customer_id, order_date, 
SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id, order_date;

# use GROUP BY to find the total amount spent by each customer for orders > $200
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
WHERE total_amount > 200
GROUP BY customer_id;

# use GROUP BY to find the total amount spent by each customer who has spent > $200
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 200;

# use INNER JOIN to show all orders that have customer's first and last name
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id;

# use LEFT JOIN to show all of the orders and customer's first and last name (even if NULL)
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id;

# show orders where total_amount >= the average total_amount of all orders
SELECT id, order_date, total_amount
FROM orders
WHERE total_amount >= (SELECT AVG(total_amount) FROM orders); 

# show orders where the customer ID is in the list of IDs of customers with the last name Smith
SELECT id, order_date, total_amount, customer_id
FROM orders
WHERE customer_id IN (SELECT id FROM customers WHERE last_name = 'Smith');

# use a subquery to get all of the columns from the orders table then show the order dates from that selection
SELECT order_date
FROM (SELECT id, order_date, total_amount FROM orders) AS order_summary;