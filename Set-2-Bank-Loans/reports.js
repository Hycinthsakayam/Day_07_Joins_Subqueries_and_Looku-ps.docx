// Day 7 | Set 2: Bank Loan Portfolio
// Run: mongosh reports.js
use('day7_bank_loans');

db.branches.drop(); db.customers.drop(); db.loans.drop(); db.repayments.drop();
db.branches.insertMany([
 {_id:1,branch_name:'Chennai Main',city:'Chennai'},
 {_id:2,branch_name:'Tambaram',city:'Chennai'},
 {_id:3,branch_name:'Bengaluru Central',city:'Bengaluru'}
]);
db.customers.insertMany([{_id:1,customer_name:'Ananya'},{_id:2,customer_name:'Bharat'},{_id:3,customer_name:'Charan'}]);
db.loans.insertMany([
 {_id:201,customer_id:1,branch_id:1,principal:500000,outstanding_amount:320000},
 {_id:202,customer_id:1,branch_id:2,principal:250000,outstanding_amount:180000},
 {_id:203,customer_id:2,branch_id:1,principal:400000,outstanding_amount:100000},
 {_id:204,customer_id:3,branch_id:3,principal:600000,outstanding_amount:550000}
]);
db.repayments.insertMany([
 {_id:1,loan_id:201,repayment_date:new Date('2026-10-10'),amount:15000},
 {_id:2,loan_id:201,repayment_date:new Date('2026-09-10'),amount:15000},
 {_id:3,loan_id:202,repayment_date:new Date('2026-10-12'),amount:10000}
]);

// Pipeline 1: loans with customer details.
db.loans.aggregate([
 {$lookup:{from:'customers',localField:'customer_id',foreignField:'_id',as:'customer'}},
 {$unwind:'$customer'},
 {$project:{loan_id:'$_id',principal:1,outstanding_amount:1,customer_name:'$customer.customer_name'}}
]).forEach(print);

// Pipeline 2: loans with their repayment history.
db.loans.aggregate([
 {$lookup:{from:'repayments',localField:'_id',foreignField:'loan_id',as:'repayments'}},
 {$project:{loan_id:'$_id',customer_id:1,repayments:1}}
]).forEach(print);

// Pipeline 3: each loan with only its most recent repayment.
db.loans.aggregate([
 {$lookup:{
   from:'repayments',
   let:{currentLoanId:'$_id'},
   pipeline:[
     {$match:{$expr:{$eq:['$loan_id','$$currentLoanId']}}},
     {$sort:{repayment_date:-1}},
     {$limit:1}
   ],
   as:'last_repayment'
 }},
 {$unwind:{path:'$last_repayment',preserveNullAndEmptyArrays:true}},
 {$project:{loan_id:'$_id',customer_id:1,outstanding_amount:1,last_repayment:1}}
]).forEach(print);
