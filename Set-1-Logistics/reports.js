// Day 7 | Set 1: Logistics Shipment Analysis
// Run: mongosh reports.js
use('day7_logistics');

db.hubs.drop(); db.carriers.drop(); db.customers.drop();
db.shipments.drop(); db.delivery_events.drop();

db.hubs.insertMany([
  {_id:1,hub_name:'Chennai Central',city:'Chennai'},
  {_id:2,hub_name:'Bengaluru Hub',city:'Bengaluru'},
  {_id:3,hub_name:'Hyderabad Hub',city:'Hyderabad'},
  {_id:4,hub_name:'Kochi Hub',city:'Kochi'}
]);
db.carriers.insertMany([{_id:1,carrier_name:'SwiftLine'},{_id:2,carrier_name:'BlueRoute'},{_id:3,carrier_name:'CargoMax'}]);
db.customers.insertMany([{_id:1,customer_name:'Asha Stores'},{_id:2,customer_name:'Metro Supplies'},{_id:3,customer_name:'Green Basket'}]);
db.shipments.insertMany([
  {_id:101,customer_id:1,carrier_id:1,origin_hub_id:1,destination_hub_id:2,shipping_cost:850,status:'Delivered'},
  {_id:102,customer_id:2,carrier_id:2,origin_hub_id:2,destination_hub_id:3,shipping_cost:1200,status:'Delivered'},
  {_id:103,customer_id:3,carrier_id:1,origin_hub_id:3,destination_hub_id:4,shipping_cost:640,status:'In Transit'},
  {_id:104,customer_id:1,carrier_id:3,origin_hub_id:1,destination_hub_id:3,shipping_cost:1500,status:'Delivered'}
]);
db.delivery_events.insertMany([
  {_id:1,shipment_id:101,event_type:'Picked Up',event_note:'Collected at origin'},
  {_id:2,shipment_id:101,event_type:'Delivered',event_note:'Received by customer'},
  {_id:3,shipment_id:102,event_type:'Delayed',event_note:'Weather disruption'}
]);

// Pipeline 1: shipments with their delivery events.
db.shipments.aggregate([
  {$lookup:{from:'delivery_events',localField:'_id',foreignField:'shipment_id',as:'delivery_events'}},
  {$project:{_id:1,customer_id:1,status:1,delivery_events:1}}
]).forEach(print);

// Pipeline 2: customers with all their shipments.
db.customers.aggregate([
  {$lookup:{from:'shipments',localField:'_id',foreignField:'customer_id',as:'shipments'}},
  {$project:{customer_name:1,shipments:1}}
]).forEach(print);

// Pipeline 3: carriers with shipment count and average shipping cost (delay metric placeholder is transit data).
db.carriers.aggregate([
  {$lookup:{from:'shipments',localField:'_id',foreignField:'carrier_id',as:'shipments'}},
  {$unwind:{path:'$shipments',preserveNullAndEmptyArrays:true}},
  {$group:{_id:'$_id',carrier_name:{$first:'$carrier_name'},shipment_count:{$sum:1},average_shipping_cost:{$avg:'$shipments.shipping_cost'}}}
]).forEach(print);
