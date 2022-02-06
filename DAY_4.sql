
# MySQL ALTER TABLE – Add columns to a table ---------------------------------

/*
To add a column to a table, you use the ALTER TABLE ADD syntax:

# ADD
ALTER TABLE table_name
    ADD new_column_name column_definition
    [FIRST | AFTER column_name],
    
    ADD new_column_name column_definition
    [FIRST | AFTER column_name],
    ...;
    
# MODIFIY 
ALTER TABLE table_name
    MODIFY column_name column_definition
    [ FIRST | AFTER column_name],
    MODIFY column_name column_definition
    [ FIRST | AFTER column_name],
    ...;
    

*/

# 1. Add two columns in above table
select * from empl;

ALTER TABLE empl
ADD city VARCHAR(50),
ADD email2 VARCHAR(255);

select * from empl;
# 2. modify table column
describe empl;
ALTER TABLE empl 
MODIFY email VARCHAR(100) NOT NULL;
describe empl;

# 3. rename column
ALTER TABLE empl 
CHANGE COLUMN city addr VARCHAR(100);
# 4. Drop both new columns 
ALTER TABLE empl
DROP COLUMN email;
select * from empl;
# 5. rename table empl to test
ALTER TABLE empl 
RENAME TO test2;

select * from test;
# 6. Drop table test
DROP TABLE empl;
select * from empl;
DROP TABLE IF EXISTS test;

# MySQL UPDATE statement
/*
The following illustrates the basic syntax of the UPDATE statement:

UPDATE [LOW_PRIORITY] [IGNORE] table_name 
SET 
    column_name1 = expr1,
    column_name2 = expr2,
    ...
[WHERE
    condition];

*/

# 1. update the email of any emplyees to the new email 
select * from employees;

SELECT 
    firstname, 
    lastname, 
    email
FROM
    employees
WHERE
    employeeNumber = 1002;
    
UPDATE employees 
SET 
    email = 'test@gmail.com'
WHERE
    employeeNumber = 1056;
    
# 2. update the lastname and first name 

UPDATE employees 
SET 
    lastname = 'new laafasdstname',
    firstname = 'firstasdf name'
WHERE
    employeeNumber = 1056;
    
# 4. add 100$ to all product price in products table

select * from products;

UPDATE products 
SET 
    buyPrice = buyPrice + 100;
    

# MySQL DELETE and LIMIT clause ----------------------

# You are using a safe mode and you tried to update a table without a WHERE that uses a Key column.

# 1. delete all records from the task table
select * from task;
delete from task;
drop table task;

# 2. delete all records where country is france
select * from customers;
DELETE FROM customers
WHERE country = 'France';

# 3. delete top 5 records where country is USA
DELETE FROM customers
WHERE country = 'USA' 
ORDER BY creditLimit desc
LIMIT 5;


#  MySQL GROUP BY clause ----------------------

 /*
 SELECT 
    c1, c2,..., cn, aggregate_function(ci)
FROM
    table
WHERE
    where_conditions
GROUP BY c1 , c2,...,cn;
 */

# 1. select status group value from orders 
select * from orders;

SELECT 
    status
FROM
    orders
GROUP BY status;
# or 
SELECT DISTINCT
    status
FROM
    orders;

# 2. count number of orders in each status
select count(*) from orders;




SELECT 
    `status`, COUNT(*) as `count no`
FROM
    `orders`
GROUP BY `status`;

# 3. returns the order numbers and the 
# total amount of each order.



select * from orderdetails;
select * from orders;


SELECT 
    orderNumber,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orderdetails
GROUP BY 
    orderNumber;
    

# 4. extract year from order date, count order per year
select * from orders;
SELECT 
    YEAR(orderDate) AS year, 
    COUNT(orderNumber) `count xys`
FROM
    orders
GROUP BY 
    year;

# HAVING Clause ----------------------
/*
The  HAVING clause is used in the SELECT statement to specify 
filter conditions for a group of rows or aggregates.
The following illustrates the syntax of the HAVING clause:

SELECT 
    select_list
FROM 
    table_name
WHERE 
    search_condition
GROUP BY 
    group_by_expression
HAVING 
    group_condition;

*/

# 1. get order numbers, the number of items sold per order, 
# and total sales for each from the orderdetails table:
select * from orderdetails;
select * from orders;
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY ordernumber;

# 2.  find which order has total sales greater than 1000

SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY 
   ordernumber
HAVING 
   total > 1000;

# 3.  find orders that have total amounts greater than 1000 
# and contain more than 600 items

SELECT 
    ordernumber,
    SUM(quantityOrdered) AS `items Count`,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY ordernumber
HAVING 
    total > 1000 AND 
    `items Count` > 600;

# MySQL alias for tables and columns  ----------------------

/*
he following statement illustrates how to use the column alias:

SELECT 
   [column_1 | expression] AS descriptive_name
FROM table_name;

or 

SELECT 
   [column_1 | expression] AS `descriptive name`
FROM 
   table_name;
*/


# 1. join first name and last name

SELECT 
    CONCAT_WS('_', lastName, firstname)
FROM
    employees;

# or 

SELECT
	CONCAT_WS(', ', lastName, firstname) `Full name`
FROM
	employees
    
ORDER BY
	`Full name`;


# 2. selects the orders whose total amount are greater than 60000.

SELECT
	orderNumber `Order no.`,
	SUM(priceEach * quantityOrdered) total
FROM
	orderDetails
GROUP BY
	`Order no.`
HAVING
	total > 60000;
    
# 3. use alias name for table

SELECT 
    e.firstName, 
    e.lastName
FROM
    employees e
ORDER BY e.firstName;


# MySQL Joins ----------------------------------

/*

MySQL supports the following types of joins:

1. Inner join
2. Left join
3. Right join
4. Cross join

*/


# 1. create sample table meber and committes


CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);

CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);

INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');

INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

SELECT * FROM members;
SELECT * FROM committees;

# 1. INNER JOIN -----

/*
The following shows the basic syntax 
of the inner join clause that joins two tables table_1 and table_2:

SELECT column_list
FROM table_1
INNER JOIN table_2 ON join_condition;

If the join condition uses the equal operator (=) 
and the column names in both tables used 
for matching are the same, you can use the USING clause instead:

SELECT column_list
FROM table_1
INNER JOIN table_2 USING (column_name);

*/

# 1. finds members who are also the committee members:


SELECT 
    m.member_id, 
    m.name as `name`, 
    c.committee_id, 
    c.name `committee`
FROM
    members m
INNER JOIN committees c 
	ON c.name = m.name;


SELECT 
	m.member_id, 
    m.name members, 
    c.committee_id, 
    c.name committee
FROM
    members m
right JOIN committees c 
	ON c.name = m.name;

# OR 

SELECT 
    m.member_id, 
    m.name AS members , 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c USING(name);

# 2. LEFT JOIN -----

/*
The following shows the basic syntax 
of the inner join clause that joins two tables table_1 and table_2:

SELECT column_list 
FROM table_1 
LEFT JOIN table_2 ON join_condition;

If the join condition uses the equal operator (=) 
and the column names in both tables used 
for matching are the same, you can use the USING clause instead:

SELECT column_list 
FROM table_1 
LEFT JOIN table_2 USING (column_name);

*/

SELECT 
    m.member_id, 
    m.name AS members, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
LEFT JOIN committees c USING(name);



# 3. RIGHT JOIN -----

/*
The following shows the basic syntax 
of the inner join clause that joins two tables table_1 and table_2:

SELECT column_list 
FROM table_1 
RIGHT JOIN table_2 ON join_condition;

If the join condition uses the equal operator (=) 
and the column names in both tables used 
for matching are the same, you can use the USING clause instead:

SELECT column_list 
FROM table_1 
RIGHT JOIN table_2 ON join_condition;

*/

SELECT 
    m.member_id, 
    m.name AS members, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
RIGHT JOIN committees c on c.name = m.name;


# 4. CROSS JOIN 

/*
The following shows the basic syntax of the cross join clause:

SELECT select_list
FROM table_1
CROSS JOIN table_2;

*/

SELECT 
    m.member_id, 
    m.name AS  members, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
CROSS JOIN committees c;

# 1. select productCode and productName from the products table.
# textDescription of product lines from the productlines table.
SELECT * FROM classicmodels.products;
SELECT * FROM classicmodels.productlines;

SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products t1
INNER JOIN productlines t2 
    ON t1.productline = t2.productline;

# 2. return order number, order status and total sales from the orders 
# and orderdetails tables using the INNER JOIN clause with the GROUP BYclause:


SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) total
FROM
    orders t1
INNER JOIN orderdetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;

# 3. uses two INNER JOIN clauses to join three tables: orders, orderdetails, and products:

SELECT 
    orderNumber,
    orderDate,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN
    orderdetails USING (orderNumber)
INNER JOIN
    products USING (productCode)
ORDER BY 
    orderNumber, 
    orderLineNumber;
    

# 4. uses three INNER JOIN clauses to query data from the four tables

SELECT 
    orderNumber,
    orderDate,
    customerName,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
INNER JOIN products 
    USING (productCode)
INNER JOIN customers 
    USING (customerNumber)
ORDER BY 
    orderNumber, 
    orderLineNumber;
    
# 5. use the LEFT JOIN clause to find all customers and their orders:

SELECT 
    customers.customerNumber, 
    customerName, 
    orderNumber, 
    status
FROM
    customers
LEFT JOIN orders ON 
    orders.customerNumber = customers.customerNumber;
    
# 6. use two LEFT JOIN clauses to join the three tables: employees, customers, and payments.

SELECT 
    lastName, 
    firstName, 
    customerName, 
    checkNumber, 
    amount
FROM
    employees
LEFT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
LEFT JOIN payments ON 
    payments.customerNumber = customers.customerNumber
ORDER BY 
    customerName, 
    checkNumber; 

# 7.  use the RIGHT JOIN clause join the table customers with the table employees

SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees 
    ON salesRepEmployeeNumber = employeeNumber
ORDER BY 
	employeeNumber;

# 8. use the RIGHT JOIN clause to find employees who do not in charge of any customers:


SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees ON 
	salesRepEmployeeNumber = employeeNumber
WHERE customerNumber is NULL
ORDER BY employeeNumber;

# 9. To get the whole organization structure, you can join the 
# employees table to itself using the employeeNumber and reportsTo columns. 
# The table employees has two roles: one is the Manager and the other is Direct Reports.

select * from employees;


SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
    