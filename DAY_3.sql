 
# DISTINCT CLAUSE ---------------------------------------------
/*
Here is the syntax of the DISTINCT clause:

SELECT DISTINCT
    select_list
FROM
    table_name;
*/


# 1. select unique last names from the employess table
use classicmodels;

SELECT 
    DISTINCT lastname
FROM
    employees
ORDER BY 
    lastname;
# 2. get a unique combination of city and state from the customers table

SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY 
    state, 
    city;
  
 -- select * from  classicmodels.customers;
    
-- select * from customers;

# Managing MySQL databases and tables ------------------------------------------

#  list all database
show databases;

# select database
use classicmodels;

# get name of current database
select database();

/*
To create a database in MySQL, you use the CREATE DATABASE  statement as follows:

CREATE DATABASE [IF NOT EXISTS] database_name;

To delete a database, you use the DROP DATABASE statement as follows:

DROP DATABASE [IF EXISTS] database_name;
*/

# create database
CREATE DATABASE mydeb;
CREATE DATABASE IF NOT EXISTS mydeb;

# drop database
CREATE DATABASE IF NOT EXISTS TEMP;
SHOW DATABASES;
DROP DATABASE mydeb;
DROP DATABASE IF EXISTS mydeb;

drop database classicmodels;

# MySQL CREATE TABLE ---------------------------------------------








/*

The following illustrates the basic syntax of the CREATE TABLE  statement:

CREATE TABLE [IF NOT EXISTS] table_name(
   column_1_definition,
   column_2_definition,
   ...,
   table_constraints
) ENGINE=storage_engine;

The following shows the syntax for a column’s definition:

column_name data_type(length) [NOT NULL] [DEFAULT value] [AUTO_INCREMENT] column_constraint;

PRIMARY KEY (col1,col2,...)

*/

create table test(
col1 int,
col2 varchar(255)
)

select * from test;

# 1. creates a new table named tasks:

CREATE TABLE IF NOT EXISTS task (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    `status` TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)  ENGINE = INNODB;

drop table task;

select * from task;
# check the structure of the tabel;
DESCRIBE task;
select * from task;

# 2. CREATE TABLE with a foreign key primary key 

CREATE TABLE IF NOT EXISTS checklists (
    todo_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT,
    todo VARCHAR(255) NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (task_id)
        REFERENCES task (task_id)
        ON UPDATE RESTRICT ON DELETE CASCADE
);


DESCRIBE checklists;
select * from checklists;

# 3.  creates a table named emp that has the emp_no column is an 
# AUTO_INCREMENT column:
drop table empl;

CREATE TABLE empl (
    emp_no INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) ,
    last_name VARCHAR(50) default "xyz",
    email varchar(80) NOT NULL
);

select * from empl;
describe empl;

# 4. insert two new rows into the employees table:
INSERT INTO empl(first_name,last_name)
VALUES('John','Doe'),
      ('Mary','Jane');
      
INSERT INTO empl(first_name, email)
VALUES('asdf', "abc"),
      ('Masdfary', "abc");
      
select * from empl;

# MySQL INSERT statement -------------------

/*

 insert multiple rows into a table using a single INSERT statement, you use the following syntax

INSERT INTO table(c1,c2,...)
VALUES 
   (v11,v12,...),
   (v21,v22,...),
    ...
   (vnn,vn2,...);

*/

# create a new table 
CREATE TABLE IF NOT EXISTS task2(
    task_id INT AUTO_INCREMENT, 
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    priority TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY (task_id)
);

CREATE TABLE emp(
emp_no int auto_increment primary key,
fn varchar(50),
ln varchar(50) default 'xyz'
);


# 1.  insert a new row into the tasks table
INSERT INTO task2(title,priority)
VALUES('HELLO World',1);
select * from task2;

# 2. add date
INSERT INTO task2(title, start_date, due_date)
VALUES('Insert date into table','2018-01-09','2018-09-15');

select CURRENT_DATE();

# 3. add current date
INSERT INTO task2(title,start_date,due_date)
VALUES('Use current date for the task',CURRENT_DATE(),CURRENT_DATE());

# 4. inserts three rows into the tasks table:
INSERT INTO task2(title, priority)
VALUES
	('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3),
    ('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3),
    ('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3),
    ('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3),
	('It is the second task',2),
	('This is the third task of the week',3),
    ('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3);

select * from task2;



