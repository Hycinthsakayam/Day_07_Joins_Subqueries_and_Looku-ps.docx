-- Day 7 | Set 1: Logistics Shipment Analysis
USE Day7Logistics;
GO

-- Q1. Shipment details with customer, carrier and both hub names.
SELECT s.shipment_id, cu.customer_name, ca.carrier_name,
       origin.hub_name AS origin_hub, destination.hub_name AS destination_hub,
       s.shipping_cost, s.status
FROM Shipments s
INNER JOIN Customers cu ON cu.customer_id = s.customer_id
INNER JOIN Carriers ca ON ca.carrier_id = s.carrier_id
INNER JOIN Hubs origin ON origin.hub_id = s.origin_hub_id
INNER JOIN Hubs destination ON destination.hub_id = s.destination_hub_id;

-- Q2. Shipments delayed by more than two days (delivered date compared with ship date).
SELECT s.shipment_id, ca.carrier_name, s.shipped_at, s.delivered_at,
       DATEDIFF(DAY, s.shipped_at, s.delivered_at) AS transit_days
FROM Shipments s
INNER JOIN Carriers ca ON ca.carrier_id = s.carrier_id
WHERE s.delivered_at IS NOT NULL
  AND DATEDIFF(DAY, s.shipped_at, s.delivered_at) > 2;

-- Q3. Hubs that have no outbound shipments. LEFT JOIN keeps hubs without a match.
SELECT h.hub_id, h.hub_name
FROM Hubs h
LEFT JOIN Shipments s ON s.origin_hub_id = h.hub_id
WHERE s.shipment_id IS NULL;

-- Q4. Employee and supervisor names (self join).
SELECT e.employee_name AS employee, COALESCE(m.employee_name, 'No supervisor') AS supervisor
FROM Employees e
LEFT JOIN Employees m ON m.employee_id = e.supervisor_id;

-- Q5. Every hub and its shipments, including hubs with no shipments and shipments' hub rows.
SELECT h.hub_name, s.shipment_id, s.status
FROM Hubs h
FULL OUTER JOIN Shipments s ON s.origin_hub_id = h.hub_id
ORDER BY h.hub_name, s.shipment_id;

-- Q6. Customers who have shipped to every hub (relational division using NOT EXISTS).
SELECT c.customer_id, c.customer_name
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Hubs h
    WHERE NOT EXISTS (
        SELECT 1 FROM Shipments s
        WHERE s.customer_id = c.customer_id
          AND s.destination_hub_id = h.hub_id
    )
);

-- Q7. Carriers whose average delivery delay (transit days) is above the overall average.
SELECT ca.carrier_id, ca.carrier_name, AVG(CAST(DATEDIFF(DAY,s.shipped_at,s.delivered_at) AS DECIMAL(10,2))) AS avg_transit_days
FROM Carriers ca
JOIN Shipments s ON s.carrier_id = ca.carrier_id
WHERE s.delivered_at IS NOT NULL
GROUP BY ca.carrier_id, ca.carrier_name
HAVING AVG(CAST(DATEDIFF(DAY,s.shipped_at,s.delivered_at) AS DECIMAL(10,2))) >
       (SELECT AVG(CAST(DATEDIFF(DAY,shipped_at,delivered_at) AS DECIMAL(10,2)))
        FROM Shipments WHERE delivered_at IS NOT NULL);

-- Q8. Two ways to find customers with at least one delayed shipment.
-- Subquery form:
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Shipments
    WHERE status IN ('Delayed','In Transit')
);
-- Join form:
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customers c
JOIN Shipments s ON s.customer_id = c.customer_id
WHERE s.status IN ('Delayed','In Transit');

-- Q9. Carriers with a shipment cost greater than ANY shipment cost charged by SwiftLine.
SELECT carrier_name
FROM Carriers
WHERE carrier_id IN (
    SELECT carrier_id FROM Shipments
    WHERE shipping_cost > ANY (
        SELECT shipping_cost FROM Shipments
        WHERE carrier_id = (SELECT carrier_id FROM Carriers WHERE carrier_name = 'SwiftLine')
    )
);

-- Q10. Second-highest shipping cost in each hub (nested subquery; ties are retained).
SELECT h.hub_id, h.hub_name,
       (SELECT MAX(s1.shipping_cost)
        FROM Shipments s1
        WHERE s1.origin_hub_id = h.hub_id
          AND s1.shipping_cost < (
              SELECT MAX(s2.shipping_cost)
              FROM Shipments s2
              WHERE s2.origin_hub_id = h.hub_id
          )) AS second_highest_shipping_cost
FROM Hubs h
WHERE EXISTS (SELECT 1 FROM Shipments sx WHERE sx.origin_hub_id = h.hub_id);

-- Extra EXISTS example: customers with at least one shipment event.
SELECT c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Shipments s
    JOIN DeliveryEvents de ON de.shipment_id = s.shipment_id
    WHERE s.customer_id = c.customer_id
);


-- ALL example: shipments whose cost is greater than every shipment cost for BlueRoute.
SELECT shipment_id,shipping_cost
FROM Shipments
WHERE shipping_cost > ALL (
    SELECT shipping_cost FROM Shipments
    WHERE carrier_id = (SELECT carrier_id FROM Carriers WHERE carrier_name = 'BlueRoute')
);
