-- Day 7 | Set 3: Retail Returns and Refunds
USE Day7RetailReturns;
GO

-- Q1. Products with a return rate above 10 percent (returned quantity / sold units).
SELECT p.product_id,p.product_name,
       SUM(r.quantity)*100.0/NULLIF(p.sold_units,0) AS return_rate_percent
FROM Products p JOIN Returns r ON r.product_id=p.product_id
GROUP BY p.product_id,p.product_name,p.sold_units
HAVING SUM(r.quantity)*100.0/NULLIF(p.sold_units,0)>10;

-- Q2. Customers with returns but no refund for any of their returns.
SELECT c.customer_id,c.customer_name
FROM Customers c
WHERE EXISTS(SELECT 1 FROM Returns r WHERE r.customer_id=c.customer_id)
AND NOT EXISTS(
 SELECT 1 FROM Returns r JOIN Refunds f ON f.return_id=r.return_id
 WHERE r.customer_id=c.customer_id
);

-- Q3. Stores ranked by total refund value.
SELECT s.store_id,s.store_name,SUM(f.refund_amount) AS total_refund_value
FROM Stores s JOIN Returns r ON r.store_id=s.store_id
JOIN Refunds f ON f.return_id=r.return_id
GROUP BY s.store_id,s.store_name
ORDER BY total_refund_value DESC;

-- Q4. Employees and their managers (self join).
SELECT e.employee_name,COALESCE(m.employee_name,'No manager') AS manager_name
FROM Employees e LEFT JOIN Employees m ON m.employee_id=e.manager_id;

-- Q5. Every store and its returns, including stores with no returns.
SELECT s.store_name,r.return_id,r.return_date
FROM Stores s LEFT JOIN Returns r ON r.store_id=s.store_id;

-- Q6. Demonstrate the NOT IN NULL pitfall.
-- This can return no rows because the subquery contains NULL:
SELECT c.customer_id,c.customer_name
FROM Customers c
WHERE c.customer_id NOT IN (
 SELECT CASE WHEN r.return_id=305 THEN NULL ELSE r.customer_id END
 FROM Returns r
);
-- Correct version: NOT EXISTS handles the anti-match without NULL poisoning.
SELECT c.customer_id,c.customer_name
FROM Customers c
WHERE NOT EXISTS(
 SELECT 1 FROM Returns r WHERE r.customer_id=c.customer_id
);

-- Q7. Stores whose refund total is greater than ANY other store's refund total in the same region.
WITH StoreRefunds AS (
 SELECT s.store_id,s.store_name,s.region,COALESCE(SUM(f.refund_amount),0) AS refund_total
 FROM Stores s LEFT JOIN Returns r ON r.store_id=s.store_id
 LEFT JOIN Refunds f ON f.return_id=r.return_id
 GROUP BY s.store_id,s.store_name,s.region
)
SELECT sr.store_id,sr.store_name,sr.region,sr.refund_total
FROM StoreRefunds sr
WHERE sr.refund_total > ANY(
 SELECT other.refund_total FROM StoreRefunds other
 WHERE other.region=sr.region AND other.store_id<>sr.store_id
);

-- Q8. Stores whose refund total is greater than ALL other stores in their region.
WITH StoreRefunds AS (
 SELECT s.store_id,s.store_name,s.region,COALESCE(SUM(f.refund_amount),0) AS refund_total
 FROM Stores s LEFT JOIN Returns r ON r.store_id=s.store_id
 LEFT JOIN Refunds f ON f.return_id=r.return_id
 GROUP BY s.store_id,s.store_name,s.region
)
SELECT sr.store_id,sr.store_name,sr.region,sr.refund_total
FROM StoreRefunds sr
WHERE sr.refund_total > ALL(
 SELECT other.refund_total FROM StoreRefunds other
 WHERE other.region=sr.region AND other.store_id<>sr.store_id
);

-- Q9. Nested subquery: products whose return quantity is above the average return quantity per product.
SELECT p.product_name
FROM Products p
WHERE (SELECT COALESCE(SUM(r.quantity),0) FROM Returns r WHERE r.product_id=p.product_id) >
      (SELECT AVG(product_return_qty) FROM
        (SELECT SUM(quantity) AS product_return_qty FROM Returns GROUP BY product_id) AS product_totals);

-- Q10. Nested subquery: returns whose refund amount is above the average refund amount.
SELECT r.return_id,r.customer_id,f.refund_amount
FROM Returns r JOIN Refunds f ON f.return_id=r.return_id
WHERE f.refund_amount>(SELECT AVG(refund_amount) FROM Refunds);

-- Extra: return details with product, customer, store and optional refund.
SELECT r.return_id,p.product_name,c.customer_name,s.store_name,f.refund_amount
FROM Returns r JOIN Products p ON p.product_id=r.product_id
JOIN Customers c ON c.customer_id=r.customer_id
JOIN Stores s ON s.store_id=r.store_id
LEFT JOIN Refunds f ON f.return_id=r.return_id;
