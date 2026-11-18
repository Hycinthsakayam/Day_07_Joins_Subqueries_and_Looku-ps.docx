-- Day 7 | Set 2: Bank Loan Portfolio
USE Day7BankLoans;
GO

-- Q1. Loans overdue by more than three instalments.
SELECT l.loan_id,c.customer_name,b.branch_name,l.overdue_instalments,l.outstanding_amount
FROM Loans l JOIN Customers c ON c.customer_id=l.customer_id
JOIN Branches b ON b.branch_id=l.branch_id
WHERE l.overdue_instalments>3;

-- Q2. Customers who hold loans in more than one branch.
SELECT c.customer_id,c.customer_name,COUNT(DISTINCT l.branch_id) AS branch_count
FROM Customers c JOIN Loans l ON l.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING COUNT(DISTINCT l.branch_id)>1;

-- Q3. Guarantors who are also borrowers (self relationship through Customers).
SELECT DISTINCT g.customer_id,c.customer_name,g.loan_id AS guaranteed_loan_id
FROM Guarantors g JOIN Loans borrower_loan ON borrower_loan.customer_id=g.customer_id
JOIN Customers c ON c.customer_id=g.customer_id;

-- Q4. Branches with no loans.
SELECT b.branch_id,b.branch_name
FROM Branches b LEFT JOIN Loans l ON l.branch_id=b.branch_id
WHERE l.loan_id IS NULL;

-- Q5. Loan, borrower and repayment details (one row per repayment; loans without repayment remain).
SELECT l.loan_id,c.customer_name,r.repayment_date,r.amount
FROM Loans l JOIN Customers c ON c.customer_id=l.customer_id
LEFT JOIN Repayments r ON r.loan_id=l.loan_id;

-- Q6. Customers whose total loan exposure is above their branch's average customer exposure (correlated subquery).
WITH CustomerExposure AS (
 SELECT branch_id,customer_id,SUM(outstanding_amount) AS total_exposure
 FROM Loans GROUP BY branch_id,customer_id
)
SELECT ce.branch_id,ce.customer_id,ce.total_exposure
FROM CustomerExposure ce
WHERE ce.total_exposure > (
 SELECT AVG(x.total_exposure) FROM CustomerExposure x
 WHERE x.branch_id=ce.branch_id
);

-- Q7. Customers with at least one loan but no repayment in the last 60 days.
SELECT c.customer_id,c.customer_name
FROM Customers c
WHERE EXISTS (SELECT 1 FROM Loans l WHERE l.customer_id=c.customer_id)
AND NOT EXISTS (
 SELECT 1 FROM Loans l JOIN Repayments r ON r.loan_id=l.loan_id
 WHERE l.customer_id=c.customer_id
 AND r.repayment_date>=DATEADD(DAY,-60,CONVERT(date,GETDATE()))
);

-- Q8. Branches whose largest loan is above the bank-wide average of branch maximum loan amounts.
SELECT b.branch_id,b.branch_name
FROM Branches b
WHERE (SELECT MAX(l.principal) FROM Loans l WHERE l.branch_id=b.branch_id) >
      (SELECT AVG(CAST(branch_max AS DECIMAL(12,2)))
       FROM (SELECT MAX(principal) AS branch_max FROM Loans GROUP BY branch_id) AS branch_maxima);

-- Q9. Two equivalent ways to find customers with a loan above 400,000.
-- Uncorrelated IN subquery:
SELECT customer_id,customer_name FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Loans WHERE principal>400000);
-- INNER JOIN:
SELECT DISTINCT c.customer_id,c.customer_name
FROM Customers c JOIN Loans l ON l.customer_id=c.customer_id
WHERE l.principal>400000;

-- Q10. Loans with principal greater than ALL loans issued by branch 1.
SELECT loan_id,principal,branch_id FROM Loans
WHERE principal>ALL(SELECT principal FROM Loans WHERE branch_id=1);

-- Extra: latest repayment date for each loan using a correlated subquery.
SELECT l.loan_id,
 (SELECT MAX(r.repayment_date) FROM Repayments r WHERE r.loan_id=l.loan_id) AS last_repayment_date
FROM Loans l;
