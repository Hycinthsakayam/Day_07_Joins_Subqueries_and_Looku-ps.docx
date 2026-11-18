# Set 3 – Retail Returns and Refunds

## Join and subquery choices

| Question | Method | Why |
|---|---|---|
| Q1 | INNER JOIN + HAVING | Only products with returns are included; HAVING filters the calculated rate. |
| Q2 | EXISTS + NOT EXISTS | Confirms a return exists and no refund exists for any return belonging to that customer. |
| Q3 | INNER JOIN + GROUP BY | Only refunded returns contribute to the store refund total. |
| Q4 | Self LEFT JOIN | Employee and manager are both rows in Employees; LEFT keeps employees without managers. |
| Q5 | LEFT JOIN | Stores remain visible even if no return has been recorded. |
| Q6 | NOT IN demonstration and NOT EXISTS correction | A NULL in a NOT IN subquery can make the comparison UNKNOWN; NOT EXISTS avoids that issue. |
| Q7 | ANY | The store total must exceed at least one other store total in the same region. |
| Q8 | ALL | The store total must exceed every other store total in its region. |
| Q9–Q10 | Nested subqueries | Compare a per-product total with a grouped average, and a refund with the overall refund average. |

## NOT IN and NULL

In Q6 the CASE expression deliberately inserts NULL into the subquery result. With NOT IN, SQL must compare against every returned value; a NULL makes the result UNKNOWN for otherwise unmatched rows. The NOT EXISTS version checks for an actual matching return row and is the safer anti-join pattern when NULLs may be present.

## MongoDB and SQL Server comparison

The pipelines use $lookup to attach feedback to returns, refunds to returns, and return/product/customer context to feedback. SQL Server expresses the same relationships with JOIN clauses. Both approaches combine related records at query time; MongoDB's pipeline form also allows sorting, filtering or limiting the related documents before they are attached.

## Assumptions

The assignment does not define a sales transaction table. The setup uses `Products.sold_units` as the denominator for return rate and sums returned quantity as the numerator. This keeps the calculation explicit for the sample exercise.
