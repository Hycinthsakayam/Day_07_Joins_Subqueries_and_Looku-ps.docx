# Set 2 – Bank Loan Portfolio

## Join and subquery choices

| Question | Method | Why |
|---|---|---|
| Q1 | INNER JOIN | A loan must have a matching customer and branch for the report. |
| Q2 | JOIN + GROUP BY + HAVING | Counts distinct branches for each customer and filters after grouping. |
| Q3 | Self-role check through Customers and Loans | The same customer can appear as guarantor and as borrower. |
| Q4 | LEFT JOIN | Keeps branches even when no loan exists. |
| Q5 | LEFT JOIN to Repayments | A loan must still appear when it has no repayment record. |
| Q6 | Correlated subquery | The average is recalculated for the current branch. |
| Q7 | EXISTS + NOT EXISTS | Confirms the customer has a loan and rules out any recent repayment. |
| Q8 | Nested subqueries | Compares a branch maximum with the average of all branch maximums. |
| Q9 | IN and JOIN | IN expresses membership; JOIN is more direct when loan columns are also required. |
| Q10 | ALL | Requires the principal to be greater than every principal returned for branch 1. |

## Correlated vs uncorrelated

Q6 is correlated because its inner query refers to the current row's branch ID. An uncorrelated subquery runs independently of the outer row; for example, the inner branch-maximum calculation in Q8 produces the bank-wide comparison value.

## MongoDB $lookup

The three pipelines attach customer details, repayment histories, and the latest repayment to loan documents. The last pipeline uses the pipeline form of $lookup with let, $expr, sort and limit so only one repayment is returned for each loan.

## Assumptions

The assignment mentions overdue instalments but does not provide a detailed repayment schedule schema. For this exercise, `overdue_instalments` is stored on each loan as a supplied count. The 60-day condition uses the database server's current date at execution time.
