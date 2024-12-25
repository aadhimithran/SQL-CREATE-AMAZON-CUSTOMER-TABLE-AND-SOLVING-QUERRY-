CREATE  DATABASE AMAZON_DB;
USE AMAZON_DB;

1) -- CREATE USERS TABLE:

CREATE TABLE USERS(
user_id INT IDENTITY(1,1)PRIMARY KEY,
name VARCHAR(20)NOT NULL,
email VARCHAR(150) UNIQUE,
registered_date DATETIME DEFAULT GETDATE(),
membership VARCHAR(10) DEFAULT 'Basic' CHECK (membership IN ('Basic', 'Prime')),
);
 
 SELECT*FROM USERS;



INSERT INTO USERS (name, email, registered_date, membership)
VALUES 
    ( 'Alice Johnson', 'alice.j@example.com', '2024-01-15', 'Prime'),
    ( 'Bob Smith', 'bob.s@example.com', '2024-02-01', 'Basic'),
    ( 'Charlie Brown', 'charlie.b@example.com', '2024-03-10', 'Prime'),
    ( 'Daisy Ridley', 'daisy.r@example.com', '2024-04-12', 'Basic');

	SET IDENTITY_INSERT USERS OFF;

	2)-- CREATE TABLE PRODUCT


CREATE TABLE products(
product_id INT  PRIMARY KEY,
name VARCHAR(200) NOT NULL,
price DECIMAL(10,2) NOT NULL,
category VARCHAR(100) NOT NULL,
stock INT NOT NULL,
);

SELECT*FROM products;

INSERT INTO Products (product_id,name, price, category, stock) VALUES
(1,'Echo Dot', 49.99, 'Electronics', 120),
(2,'Kindle Paperwhite', 129.99, 'Books', 50),
(3,'Fire Stick', 39.99, 'Electronics', 80),
(4,'Yoga Mat', 19.99, 'Fitness', 200),
(5,'Wireless Mouse', 24.99, 'Electronics', 150);

	SET IDENTITY_INSERT USERS OFF;

3)-- CREATE ORDER TABLE:

 CREATE TABLE ORDERS(
 order_id INT IDENTITY (1,1) PRIMARY KEY,
 user_id INT  NOT NULL,
 order_date DATETIME DEFAULT GETDATE(),
 total_amount DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (USER_ID)REFERENCES USERS(USER_ID))
 ;

 SELECT* FROM ORDERS;

 
 INSERT INTO ORDERS(user_id,order_date,total_amount)
 VALUES
 (1,'2024-05-01','79.98'),
 (2,'2024-05-03','129.99'),
 (3,'2024-05-04','49.99'),
 (4,'2024-05-05','24.99')
 ;
 ? order_details_id (INT, PRIMARY KEY, AUTO_INCREMENT)
? order_id (INT, FOREIGN KEY REFERENCES Orders(order_id))
? product_id (INT, FOREIGN KEY REFERENCES Products(product_id))
? quantity (INT, NOT NULL)

-- 4)CREATE ORDER_DETAILS TABLE:

CREATE TABLE order_details(
orderdetails_id INT IDENTITY PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
FOREIGN KEY (order_id)REFERENCES orders(order_id),
FOREIGN KEY( product_id)REFERENCES products(product_id)
);

SELECT*FROM order_details;




INSERT INTO order_details(order_id,product_id,quantity)
VALUES
(1,'1','2'),
(2,'2','1'),
(3,'1','1'),
(4,'5','1');

                                              --PRACTICE QUESTIONS:

--1. List all customers who have made purchases of more than $80.

--SOLUTION;

SELECT 
      u.name AS customer_name,
      SUM (p.price*od.quantity)AS total_purchase
FROM 
      USERS u
JOIN
    ORDERS o ON u.user_id = o.user_id
JOIN 
   order_details od ON o.order_id=od.order_id
JOIN 
   products p ON p.product_id= od.product_id

GROUP BY
 u.user_id,u.name
HAVING 
SUM(p.price * od.quantity)>80;

--2)Retrieve all orders placed in the last 280 days along with the customer name and email.


  SELECT 
    U.name,
    U.email,
    O.order_id,
    O.order_date,
    O.total_amount
FROM 
    USERS U
JOIN 
    ORDERS O ON U.user_id = O.user_id
WHERE 
    O.order_date >= DATEADD(DAY, -280, GETDATE());

3)--. Find the average product price for each category.

--SOLUTION:
	SELECT category,
	       AVG(price )AS total_price
	FROM
	   products
	GROUP BY 
	    category;

4)--List all customers who have purchased a product from the category Electronics

SELECT 
   U.name AS customer_name,
   U.email AS cutomer_email
FROM 
    USERS U

JOIN
   ORDERS O ON O.USER_ID  =U.USER_ID 

JOIN
   order_details OD ON OD.order_id=O.order_id
join 
   PRODUCTS P ON OD.product_id = P.product_id
  

 WHERE
       P.category = 'Electronics';

5)-- Retrieve the average rating for all products in the Electronics category.

SELECT 
      CATEGORY,
	  AVG (PRICE)AS TOTAL_PRICE
FROM
   products
WHERE
      category ='electronics'
GROUP BY 
       category;

6)-- . Fetch all customers and the total number of orders they have placed.
      
	   
SELECT * FROM Order_details WHERE order_id = 1;
	   
SELECT * FROM Orders WHERE user_id = 1;
 
 SELECT * FROM products WHERE product_id=1;

 
--solution
SELECT 
    U.name AS customer_name,
    COUNT(DISTINCT O.order_id) AS total_orders,
	SUM (OD.quantity)AS totalquantity_record
FROM 
    Users U
LEFT JOIN 
    Orders O ON U.user_id = O.user_id
LEFT JOIN 
    order_details OD ON O.order_id = OD.order_id
GROUP BY 
    U.name;

7)--Find the total number of products sold and the total revenue generated for each product.

1)SELECT quantity,product_id
FROM

   order_details;

2)SELECT PRICE,product_id,name
FROM
   PRODUCTS;
  

SELECT p.product_id,
       p.name AS product_name,
       SUM(DISTINCT  OD.quantity) AS total_quantity_sold,
       SUM(OD.quantity * p.price)AS total_revenue
FROM 
   PRODUCTS p

JOIN
   (SELECT DISTINCT order_id, product_id, quantity FROM ORDER_DETAILS) OD
    ON P.product_id = OD.product_id
GROUP BY
  p.product_id,p.name;
 
 SELECT * 
FROM ORDER_DETAILS
WHERE product_id = 1;

 8)--Remove all orders that were placed before 2020

 --DELETE FROM ORDERS
--WHERE order_date < '2020-01-01';

DELETE FROM ORDERS
WHERE order_date < '2024-05-05';

--9)Update the price of all products in the Books category, increasing it by 10%.
SELECT price
FROM
    PRODUCTS
WHERE 
     category= 'Books';

UPDATE
     products
SET
  price =price*1.10
WHERE 
  category='books';
-- before update and after update price:
SELECT 
    t.product_id, 
    t.name AS book_name, 
    t.price AS before_update_price, 
    p.price AS after_update_price
FROM 
    temp_book_prices t
JOIN 
    products p ON t.product_id = p.product_id;

--10) Write a query to fetch the order details, including customer name, product name, and quantity, for orders placed on 2024-05-01.

SELECT u.name AS customer_name,
       o.order_id,
	   p.name AS product_name,
	   od.quantity
       
FROM 
    ORDERS O
JOIN 
   USERS U  ON U.USER_ID  =O. USER_ID
JOIN 
   ORDER_DETAILS OD ON OD.order_id=O.order_id
JOIN
   PRODUCTS P ON OD.PRODUCT_ID = P.PRODUCT_ID
WHERE
    O.order_date='2024-05-01';

--11) List all customers who purchased more than 1 units of any product, including the product name and total quantity purchased.
SELECT 
    u.name AS customer_name,
    o.order_id,
    p.name AS product_name,
    SUM(od.quantity) AS total_quantity
FROM 
    ORDERS O
JOIN 
    USERS U ON U.user_id = O.user_id
JOIN 
    ORDER_DETAILS OD ON OD.order_id = O.order_id
JOIN 
    PRODUCTS P ON OD.product_id = P.product_id
GROUP BY 
    u.name, o.order_id, p.name
HAVING 
    SUM(od.quantity) > 1;

--12)Find the total revenue generated by each category along with the category name.


SELECT 
    p.category AS category_name,
    COALESCE(SUM(od.quantity * p.price), 0) AS total_revenue
FROM 
    PRODUCTS p
LEFT JOIN 
    ORDER_DETAILS od ON p.product_id = od.product_id
GROUP BY 
    p.category;
--and if need total revenue value is  > 175or any values using HAVING clause 
HAVING
 COALESCE(SUM(od.quantity * p.price), 0)>175;


SELECT DISTINCT category FROM PRODUCTS;


