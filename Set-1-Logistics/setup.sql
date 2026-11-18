-- Day 7 | Set 1: Logistics Shipment Analysis
IF DB_ID('Day7Logistics') IS NULL CREATE DATABASE Day7Logistics;
GO
USE Day7Logistics;
GO

DROP TABLE IF EXISTS DeliveryEvents, Shipments, Employees, Customers, Carriers, Hubs;
GO
CREATE TABLE Hubs (
    hub_id INT PRIMARY KEY,
    hub_name VARCHAR(60) NOT NULL,
    city VARCHAR(60) NOT NULL
);
CREATE TABLE Carriers (
    carrier_id INT PRIMARY KEY,
    carrier_name VARCHAR(80) NOT NULL
);
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(60)
);
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    supervisor_id INT NULL REFERENCES Employees(employee_id),
    hub_id INT NULL REFERENCES Hubs(hub_id)
);
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES Customers(customer_id),
    carrier_id INT NOT NULL REFERENCES Carriers(carrier_id),
    origin_hub_id INT NOT NULL REFERENCES Hubs(hub_id),
    destination_hub_id INT NOT NULL REFERENCES Hubs(hub_id),
    employee_id INT NULL REFERENCES Employees(employee_id),
    shipped_at DATE NOT NULL,
    delivered_at DATE NULL,
    shipping_cost DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL
);
CREATE TABLE DeliveryEvents (
    event_id INT PRIMARY KEY,
    shipment_id INT NOT NULL REFERENCES Shipments(shipment_id),
    event_time DATETIME2 NOT NULL,
    event_type VARCHAR(40) NOT NULL,
    event_note VARCHAR(200)
);

INSERT INTO Hubs VALUES
(1,'Chennai Central','Chennai'),(2,'Bengaluru Hub','Bengaluru'),
(3,'Hyderabad Hub','Hyderabad'),(4,'Kochi Hub','Kochi');
INSERT INTO Carriers VALUES (1,'SwiftLine'),(2,'BlueRoute'),(3,'CargoMax');
INSERT INTO Customers VALUES
(1,'Asha Stores','Chennai'),(2,'Metro Supplies','Bengaluru'),
(3,'Green Basket','Hyderabad'),(4,'North Star Retail','Kochi');
INSERT INTO Employees VALUES
(1,'Meera',NULL,1),(2,'Arun',1,1),(3,'Divya',1,2),
(4,'Kiran',3,3),(5,'Nila',3,4);
INSERT INTO Shipments VALUES
(101,1,1,1,2,2,'2026-10-01','2026-10-03',850,'Delivered'),
(102,2,2,2,3,3,'2026-10-02','2026-10-07',1200,'Delivered'),
(103,3,1,3,4,4,'2026-10-04',NULL,640,'In Transit'),
(104,1,3,1,3,2,'2026-10-05','2026-10-10',1500,'Delivered'),
(105,4,2,4,1,5,'2026-10-06','2026-10-07',500,'Delivered'),
(106,2,3,2,1,3,'2026-10-08',NULL,920,'Delayed'),
(107,3,1,3,2,4,'2026-10-09','2026-10-10',700,'Delivered');
INSERT INTO DeliveryEvents VALUES
(1,101,'2026-10-01T09:00:00','Picked Up','Collected at origin'),
(2,101,'2026-10-03T14:00:00','Delivered','Received by customer'),
(3,102,'2026-10-02T10:00:00','Picked Up','Collected at origin'),
(4,102,'2026-10-06T11:00:00','Delayed','Weather disruption'),
(5,103,'2026-10-04T12:00:00','Picked Up','Collected at origin'),
(6,104,'2026-10-05T08:00:00','Picked Up','Collected at origin'),
(7,104,'2026-10-09T16:00:00','Delayed','Vehicle issue'),
(8,105,'2026-10-07T15:00:00','Delivered','Received by customer');
