MATCH (owner:Owner)-[:OWNS]->(shop:EShop)
MATCH (shop)-[p:PROVIDES]->(item:Item)
MATCH (shop)-[:PROVIDES]->(account:Account)
MATCH (customer:Shopper)-[:OWNS]->(account)
MATCH (account)-[:PROVIDES]->(cart:Cart)
MATCH (cart)-[:CONTAINS]->(item)
RETURN 
  owner.name AS corp,
  shop.name AS shop,
  item.name AS product,
  p.stock AS leftInStock,
  customer.firstName + ' ' + customer.familyName AS customer,
  account.accountName AS username,
  cart.price AS cartTotal
ORDER BY cartTotal DESC

//complete purchase chain from owner to item