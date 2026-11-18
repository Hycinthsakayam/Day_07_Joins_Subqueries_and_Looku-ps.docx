# Set 1 – Logistics Shipment Analysis

## Join choices

| Question | Join / method | Why |
|---|---|---|
| Q1 | INNER JOIN | Only shipments with matching customers, carriers and hubs are useful in this report. |
| Q2 | INNER JOIN | Carrier details are required for shipments that have a delivery date. |
| Q3 | LEFT JOIN | Keeps every hub; NULL on the shipment side identifies hubs with no outbound shipment. |
| Q4 | Self LEFT JOIN | Employees and supervisors are rows in the same Employees table; LEFT keeps top-level employees. |
| Q5 | FULL OUTER JOIN | Shows hub rows and shipment rows even when one side has no match. |
| Q6 | NOT EXISTS | Checks that there is no hub missing from a customer's destination history. |
| Q7 | Aggregate subquery | Compares each carrier average with one overall average. |
| Q8 | IN and INNER JOIN | Both return customers with qualifying shipments. IN reads like a membership test; JOIN is convenient when more shipment columns are needed. |
| Q9 | ANY | A carrier qualifies when it has a shipment cost greater than at least one SwiftLine shipment cost. |
| Q10 | Nested correlated subqueries | Finds the maximum cost below the maximum cost for each origin hub. |

## Subquery rewritten as a join

Q8 shows the same customer filter in two forms. The IN version is compact when the only question is whether a customer ID appears in the shipment result. The JOIN version makes the relationship visible and is easier to extend with shipment columns; DISTINCT prevents duplicate customers.

## MongoDB: when to embed and when to use $lookup

Embedding is a good fit for small, bounded data that is usually read with its parent and does not need independent updates. Delivery events can be embedded in a shipment when the event list is short and shipment-centred reads are common. Use $lookup when related records are large, independently maintained, shared by many documents, or need to be queried separately. Here hubs, carriers and customers are shared reference data, so keeping them separate and joining them with $lookup is reasonable.

## Note

The sample data is deliberately small for learning. The carrier pipeline reports average shipping cost; a true delay statistic needs actual delivery timestamps in the MongoDB shipment documents, which this compact sample does not include.
