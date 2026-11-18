-- Day 7 | Set 2: Bank Loan Portfolio
IF DB_ID('Day7BankLoans') IS NULL CREATE DATABASE Day7BankLoans;
GO
USE Day7BankLoans;
GO
DROP TABLE IF EXISTS Repayments, Guarantors, Loans, Customers, Branches;
GO
CREATE TABLE Branches(branch_id INT PRIMARY KEY,branch_name VARCHAR(80) NOT NULL,city VARCHAR(60) NOT NULL);
CREATE TABLE Customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(100) NOT NULL);
CREATE TABLE Loans(
 loan_id INT PRIMARY KEY,customer_id INT NOT NULL REFERENCES Customers(customer_id),
 branch_id INT NOT NULL REFERENCES Branches(branch_id),principal DECIMAL(12,2) NOT NULL,
 outstanding_amount DECIMAL(12,2) NOT NULL,loan_date DATE NOT NULL,
 total_instalments INT NOT NULL,paid_instalments INT NOT NULL,
 overdue_instalments INT NOT NULL DEFAULT 0
);
CREATE TABLE Repayments(
 repayment_id INT PRIMARY KEY,loan_id INT NOT NULL REFERENCES Loans(loan_id),
 repayment_date DATE NOT NULL,amount DECIMAL(10,2) NOT NULL
);
CREATE TABLE Guarantors(
 guarantor_id INT PRIMARY KEY,loan_id INT NOT NULL REFERENCES Loans(loan_id),
 customer_id INT NOT NULL REFERENCES Customers(customer_id)
);
INSERT INTO Branches VALUES (1,'Chennai Main','Chennai'),(2,'Tambaram','Chennai'),(3,'Bengaluru Central','Bengaluru'),(4,'Mysuru','Mysuru');
INSERT INTO Customers VALUES (1,'Ananya'),(2,'Bharat'),(3,'Charan'),(4,'Deepa'),(5,'Eshan');
INSERT INTO Loans VALUES
(201,1,1,500000,320000,'2025-01-10',36,12,4),
(202,1,2,250000,180000,'2025-06-15',24,8,1),
(203,2,1,400000,100000,'2024-11-20',36,25,0),
(204,3,3,600000,550000,'2026-02-01',48,3,5),
(205,4,3,300000,210000,'2025-09-05',24,6,2);
INSERT INTO Repayments VALUES
(1,201,'2026-09-10',15000),(2,201,'2026-10-10',15000),
(3,202,'2026-10-12',10000),(4,203,'2026-10-01',12000),
(5,204,'2026-07-01',8000),(6,205,'2026-08-15',9000);
INSERT INTO Guarantors VALUES (1,201,2),(2,202,1),(3,204,5),(4,205,3);
