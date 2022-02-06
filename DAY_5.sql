## MySQL Subquery ------------------------

# 1. select all the employees who work in offices located in the USA.
SELECT * FROM offices;
SELECT * FROM employees;


SELECT 
    lastName, firstName
FROM
    employees
WHERE
    officeCode IN (SELECT 
            officeCode
        FROM
            offices
        WHERE
            country = 'USA');
            
# 2. select customer who ahs the maximum payment
SELECT 
    customerName
FROM
    customers
WHERE
    customerNumber = (SELECT 
            customerNumber
        FROM
            payments
        WHERE
            amount = (SELECT 
                    MAX(amount)
                FROM
                    payments));
        
select * from customers where customerNumber = 141;
        

SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount = (SELECT MAX(amount) FROM payments);

    
# 3. find customers whose payments are greater than 
# the average payment using a subquery

SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount > (SELECT 
            AVG(amount)
        FROM
            payments);
# 4.  find the customers who have not placed any orders



SELECT 
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN (SELECT DISTINCT
            customerNumber
        FROM
            orders);
            

## MySQL constraints --------------

/*
1. NOT NULL constraint
2. Primary Key
3. Foreign key
4. UNIQUE constraint
5. CHECK Constraint

*/

# Not Null 

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);


INSERT INTO tasks(title ,start_date, end_date)
VALUES('Learn MySQL NOT NULL constraint', '2017-02-01','2017-02-02'),
      ('Check and update NOT NULL consttasksraint to your database', '2017-02-01',NULL);

SELECT * 
FROM tasks
WHERE end_date IS NULL;  


UPDATE tasks 
SET 
    end_date = start_date + 7
WHERE
    end_date IS NULL;

SELECT * FROM tasks;


ALTER TABLE tasks 
CHANGE 
    end_date 
    end_date DATE NOT NULL;

DESCRIBE tasks;

# primary key 

CREATE TABLE users(
   user_id INT AUTO_INCREMENT PRIMARY KEY,
   username VARCHAR(40),
   password VARCHAR(255),
   email VARCHAR(255)
);


CREATE TABLE pkdemos(
   id INT,
   title VARCHAR(255) NOT NULL
);

DESCRIBE pkdemos;

ALTER TABLE pkdemos
ADD PRIMARY KEY(id);

## Foreign key

/*
MySQL has five reference options: CASCADE, SET NULL, NO ACTION, RESTRICT, and SET DEFAULT.

CASCADE: if a row from the parent table is deleted or updated, the values of the matching 
rows in the child table automatically deleted or updated.

SET NULL:  if a row from the parent table is deleted or updated, the values of the 
foreign key column (or columns) in the child table are set to NULL.

RESTRICT:  if a row from the parent table has a matching row in the child table, 
MySQL rejects deleting or updating rows in the parent table.

NO ACTION: is the same as RESTRICT.

SET DEFAULT: is recognized by the MySQL parser. However, this action is rejected by 
both InnoDB and NDB tables.
*/

CREATE DATABASE fkdemo;
USE fkdemo;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
) ;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
) ENGINE=INNODB;

INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');
    
INSERT INTO products(productName, categoryId)
VALUES('iPhone',1);

select * from categories;
select * from products;

#  Attempt to insert a new row into the products table with a categoryId  
# value does not exist in the categories table

INSERT INTO products(productName, categoryId)
VALUES('iPad',3);

# Update the value in the categoryId column in the categories table to 100

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

# Note: Because of the RESTRICT option, you cannot delete or 
# update categoryId 1 since it is referenced by the productId 1 in the products table.

DROP TABLE products;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT NOT NULL,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
    REFERENCES categories(categoryId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=INNODB;

## Unique Constraint 

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id),
    CONSTRAINT uc_name_address UNIQUE (name , address)
);

INSERT INTO suppliers(name, phone, address) 
VALUES( 'ABC Inc', 
       '(408)-908-2476',
       '4000 North 1st Street');

#  insert a different supplier but has the 
# phone number that already exists in the suppliers table

select * from suppliers;

INSERT INTO suppliers(name, phone, address) 
VALUES( 'XYZ Corporation','(408)-908-2476','3000 North 1st Street');

# change the phone number to a different one and execute the insert statement again

INSERT INTO suppliers(name, phone, address) 
VALUES( 'XYZ Corporation','(408)-908-3333','3000 North 1st Street');


##  CHECK CONSTRAINT

CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    age int Not null check (age >=0 and age<=100)
    
);

INSERT INTO parts(part_no, description,cost,price, age) 
VALUES('A-001','Cooler',0,100, 350);


# new clause defines a table CHECK 
# constraint that ensures the price is always greater than or equal to cost

CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT parts_chk_price_gt_cost 
        CHECK(price >= cost)
);

INSERT INTO parts(part_no, description,cost,price) 
VALUES('A-001','Cooler',200,100);

## STORED PROCEDURE -----------------------------------------------------

/*
If you want to save this query on the database server for execution later, 
one way to do it is to use a stored procedure.

By definition, a stored procedure is a segment of declarative SQL statements 
stored inside the MySQL Server.

Advantages:
1. Reduce network traffic
2. Centralize business logic in the database
3. Make database more secure

Disadvantages :
1. Resource usages
2. Troubleshooting
3. Maintenances

# General Syntax 

DELIMITER $$

CREATE PROCEDURE sp_name()
BEGIN
  -- statements
END $$

DELIMITER ;

*/

# SELECT statement returns all rows in the table customers from the sample database

SELECT 
    customerName, 
    city, 
    state, 
    postalCode, 
    country
FROM
    customers
ORDER BY customerName;


# CREATE PROCEDURE statement creates a new stored procedure that wraps the query above



DELIMITER $$

CREATE PROCEDURE stp_GetCustomers()
BEGIN
	SELECT 
		customerName, 
		city, 
		state, 
		postalCode, 
		country
	FROM
		customers
	ORDER BY customerName;    
     
END$$
DELIMITER ;

#  invoke it by using the CALL statement
CALL stp_GetCustomers();

 # 1 . create a new stored procedure that returns employee and office information for one user:

DELIMITER $$
CREATE PROCEDURE stp_GetEmployees()
BEGIN
    SELECT 
        firstName, 
        lastName, 
        city, 
        state, 
        country
    FROM employees
    INNER JOIN offices using (officeCode);
END$$
DELIMITER ;

# 2. Call procedure 

CALL stp_GetEmployees();

# 3. DROP PROCEDURE to delete the GetEmployees() stored procedure:

DROP PROCEDURE GetEmployees;
DROP PROCEDURE IF EXISTS GetEmployees;

# Stored Procedure Variables ----------------------------
/*
variables in stored procedures to hold immediate results. 
These variables are local to the stored procedure.

Syntax: 
DECLARE variable_name datatype(size) [DEFAULT default_value];
*/

# declares a variable named totalSale with the data type DEC(10,2) and default value 0.0
# DECLARE totalSale DEC(10,2) DEFAULT 0.0;
# DECLARE x, y INT DEFAULT 0;

# Once a variable is declared, it is ready to use. To assign a variable a value, 
# you use the SET statement
SET variable_name = value;

# EG.
# DECLARE total INT DEFAULT 0;
SET @total2 = 10;
select @total2


DELIMITER $$
CREATE PROCEDURE GetTotalOrder()
BEGIN
	DECLARE totalOrder INT DEFAULT 0;
    
    SELECT COUNT(*) 
    INTO totalOrder
    FROM orders;
    
    SELECT totalOrder;
END$$
DELIMITER ;

CALL GetTotalOrder();

SELECT COUNT(*) 
    FROM orders;

# stored procedure parameters ------------------------

/*
A parameter in a stored procedure has one of three modes: IN,OUT, or INOUT.

1. IN :  is the default mode. When you define an IN parameter in a stored procedure, 
		 the calling program has to pass an argument to the stored procedure.

2. OUT : The value of an OUT parameter can be changed inside the stored procedure 
		 and its new value is passed back to the calling program. 


3. INOUT : An INOUT  parameter is a combination of IN and OUT parameters. 
			It means that the calling program may pass the argument, and the stored 
            procedure can modify the INOUT parameter, and pass the new value back to the calling program.

syntax of defining a parameter in stored procedures:
[IN | OUT | INOUT] parameter_name datatype[(length)]

*/

# 1. creates a stored procedure that finds all offices 
# that locate in a country specified by the input parameter
SELECT * 
 	FROM offices
	WHERE country = "USA";


DELIMITER //
CREATE PROCEDURE GetOfficeByCountry(
	IN countryName VARCHAR(255)
)
BEGIN
	SELECT * 
 	FROM offices
	WHERE country = countryName;
END //
DELIMITER ;


CALL GetOfficeByCountry();
CALL GetOfficeByCountry('USA');
CALL GetOfficeByCountry('France')

# 2. returns the number of orders by order status


DELIMITER $$

CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus;
END$$

DELIMITER ;

CALL GetOrderCountByStatus('Shipped', @total);
SELECT @total; # Session Variables

# 3. INOUT STP
DELIMITER $$
CREATE PROCEDURE SetCounter(
	INOUT counter INT,
    IN inc INT
)
BEGIN
	SET counter = counter + inc;
END$$
DELIMITER ;


SET @counter = 1;
CALL SetCounter(@counter,1); -- 2
CALL SetCounter(@counter,1); -- 3
CALL SetCounter(@counter,5); -- 8
SELECT @counter; -- 8

#  Alter Stored Procedures --------------

/*
Sometimes, you may want to alter a stored procedure by adding or 
removing parameters or even changing its body.
Fortunately, MySQL does not have any statement that allows you to 
directly modify the parameters and body of the stored procedure.
To make such changes, you must drop ad re-create the 
stored procedure using the DROP PROCEDURE and 
CREATE PROCEDURE statements.


*/

# 1.  create a stored procedure that returns the total amount of all sales orders
 
DELIMITER $$

CREATE PROCEDURE GetOrderAmount()
BEGIN
    SELECT 
        SUM(quantityOrdered * priceEach) 
    FROM orderDetails;
END$$

DELIMITER ;

# Alter STP by get the total amount by a given sales order
# Note: Second, right-click the stored procedure that you want 
# to change and select Alter Stored Procedure… 

DELIMITER $$

CREATE PROCEDURE GetOrderAmount(
	IN pOrderNumber INT
)
BEGIN
    SELECT 
        SUM(quantityOrdered * priceEach) 
    FROM orderDetails
    WHERE orderNumber = pOrderNumber;
END$$

DELIMITER ;

call GetOrderAmount(1001);
            