# Day 7 – Joins, Subqueries and Lookups

This repository contains my solutions for the Day 7 assignment on SQL Server 2025 and MongoDB 8.0. I have covered all three business scenarios from the assignment so the examples can be run and compared separately.

## What I'm practising

- INNER, LEFT, FULL OUTER and self joins.
- Subqueries with IN, EXISTS, NOT EXISTS, ANY and ALL.
- Correlated and uncorrelated subqueries.
- Rewriting subqueries as joins and comparing readability.
- Nested subqueries, including the second-highest value per group.
- MongoDB aggregation pipelines using $lookup.

## Assignment sets

### Set 1 – Logistics Shipment Analysis
Shipments, hubs, carriers, customers, employees and delivery events.

[Open Set 1](./Set-1-Logistics/)

### Set 2 – Bank Loan Portfolio
Loans, customers, branches, repayments and guarantors.

[Open Set 2](./Set-2-Bank-Loans/)

### Set 3 – Retail Returns and Refunds
Returns, refunds, products, customers, stores, employees and feedback.

[Open Set 3](./Set-3-Retail-Returns/)

## Folder contents

Each set contains:
- `setup.sql` – creates the tables and inserts sample records.
- `advanced_reports.sql` – the SQL Server questions and queries.
- `reports.js` – MongoDB collections and the three required $lookup pipelines.
- `SET-NOTES.md` – join choices, subquery explanations and running notes.

## Running the files

For each set, open SQL Server Management Studio and run `setup.sql` first. Then run `advanced_reports.sql`. The MongoDB script is separate; run it with `mongosh reports.js` after switching to the database named at the top of that file.

The sample data is intentionally small so it is easier to follow the joins and check why a row appears in a result. The SQL and MongoDB scripts are provided as runnable examples; actual result rows depend on running them in the respective database engines.
