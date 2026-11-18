// Day 7 | Set 3: Retail Returns and Refunds
// Run: mongosh reports.js
use('day7_retail_returns');

db.stores.drop(); db.customers.drop(); db.products.drop();
db.returns.drop(); db.refunds.drop(); db.return_feedback.drop();

db.stores.insertMany([
 {_id:1,store_name:'Chennai City',region:'South'},
 {_id:2,store_name:'Coimbatore',region:'South'},
 {_id:3,store_name:'Bengaluru',region:'South'}
]);
db.customers.insertMany([{_id:1,customer_name:'Ira'},{_id:2,customer_name:'Jeeva'},{_id:3,customer_name:'Kavya'}]);
db.products.insertMany([{_id:1,product_name:'Wireless Mouse'},{_id:2,product_name:'Keyboard'},{_id:3,product_name:'Monitor'}]);
db.returns.insertMany([
 {_id:301,product_id:1,customer_id:1,store_id:1,quantity:5},
 {_id:302,product_id:1,customer_id:2,store_id:2,quantity:4},
 {_id:303,product_id:2,customer_id:3,store_id:1,quantity:3}
]);
db.refunds.insertMany([
 {_id:1,return_id:301,refund_amount:2500},
 {_id:2,return_id:303,refund_amount:1800}
]);
db.return_feedback.insertMany([
 {_id:1,return_id:301,rating:2,comments:'Replacement took time'},
 {_id:2,return_id:302,rating:3,comments:'Return was easy'}
]);

// Pipeline 1: return records with their feedback.
db.returns.aggregate([
 {$lookup:{from:'return_feedback',localField:'_id',foreignField:'return_id',as:'feedback'}},
 {$project:{return_id:'$_id',product_id:1,customer_id:1,feedback:1}}
]).forEach(print);

// Pipeline 2: return records with refund details.
db.returns.aggregate([
 {$lookup:{from:'refunds',localField:'_id',foreignField:'return_id',as:'refunds'}},
 {$project:{return_id:'$_id',customer_id:1,store_id:1,refunds:1}}
]).forEach(print);

// Pipeline 3: feedback joined with return, product and customer context.
db.return_feedback.aggregate([
 {$lookup:{from:'returns',localField:'return_id',foreignField:'_id',as:'return_record'}},
 {$unwind:'$return_record'},
 {$lookup:{from:'products',localField:'return_record.product_id',foreignField:'_id',as:'product'}},
 {$unwind:'$product'},
 {$lookup:{from:'customers',localField:'return_record.customer_id',foreignField:'_id',as:'customer'}},
 {$unwind:'$customer'},
 {$project:{rating:1,comments:1,product_name:'$product.product_name',customer_name:'$customer.customer_name',return_id:'$return_record._id'}}
]).forEach(print);
