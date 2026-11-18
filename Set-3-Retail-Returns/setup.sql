-- Day 7 | Set 3: Retail Returns and Refunds
IF DB_ID('Day7RetailReturns') IS NULL CREATE DATABASE Day7RetailReturns;
GO
USE Day7RetailReturns;
GO
DROP TABLE IF EXISTS ReturnFeedback, Refunds, Returns, Employees, Products, Customers, Stores;
GO
CREATE TABLE Stores(store_id INT PRIMARY KEY,store_name VARCHAR(80) NOT NULL,region VARCHAR(40) NOT NULL);
CREATE TABLE Customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(100) NOT NULL);
CREATE TABLE Products(product_id INT PRIMARY KEY,product_name VARCHAR(100) NOT NULL,sold_units INT NOT NULL);
CREATE TABLE Employees(employee_id INT PRIMARY KEY,employee_name VARCHAR(100) NOT NULL,manager_id INT NULL REFERENCES Employees(employee_id),store_id INT NULL REFERENCES Stores(store_id));
CREATE TABLE Returns(return_id INT PRIMARY KEY,product_id INT NOT NULL REFERENCES Products(product_id),customer_id INT NOT NULL REFERENCES Customers(customer_id),store_id INT NOT NULL REFERENCES Stores(store_id),employee_id INT NULL REFERENCES Employees(employee_id),return_date DATE NOT NULL,quantity INT NOT NULL,reason VARCHAR(100));
CREATE TABLE Refunds(refund_id INT PRIMARY KEY,return_id INT NOT NULL REFERENCES Returns(return_id),refund_date DATE NOT NULL,refund_amount DECIMAL(10,2) NOT NULL);
CREATE TABLE ReturnFeedback(feedback_id INT PRIMARY KEY,return_id INT NOT NULL REFERENCES Returns(return_id),rating INT NOT NULL,comments VARCHAR(200));
INSERT INTO Stores VALUES (1,'Chennai City','South'),(2,'Coimbatore','South'),(3,'Bengaluru','South'),(4,'Mumbai Central','West');
INSERT INTO Customers VALUES (1,'Ira'),(2,'Jeeva'),(3,'Kavya'),(4,'Lokesh'),(5,'Mohan');
INSERT INTO Products VALUES (1,'Wireless Mouse',100),(2,'Keyboard',80),(3,'Monitor',50),(4,'USB Hub',120);
INSERT INTO Employees VALUES (1,'Riya',NULL,1),(2,'Sanjay',1,1),(3,'Tara',1,2),(4,'Vikram',3,3);
INSERT INTO Returns VALUES
(301,1,1,1,2,'2026-10-02',5,'Not working'),
(302,1,2,2,3,'2026-10-04',4,'Changed mind'),
(303,2,3,1,2,'2026-10-06',3,'Wrong item'),
(304,3,4,3,4,'2026-10-08',8,'Damaged'),
(305,4,1,4,NULL,'2026-10-10',2,'Missing part'),
(306,2,5,3,4,'2026-10-12',2,'Not as expected');
INSERT INTO Refunds VALUES
(1,301,'2026-10-05',2500),(2,303,'2026-10-09',1800),
(3,304,'2026-10-10',12000),(4,306,'2026-10-15',1200);
INSERT INTO ReturnFeedback VALUES
(1,301,2,'Replacement took time'),(2,302,3,'Return was easy'),
(3,304,1,'Product arrived damaged'),(4,306,4,'Support was helpful');
