MATCH (cart:Cart)
WITH avg(cart.price) AS avgCartVal
MATCH (account:Account)-[:PROVIDES]->(cart:Cart)-[:CONTAINS]->(item:Item)
MATCH (customer:Shopper)-[:OWNS]->(account)
WHERE cart.price > avgCartVal
RETURN 
  customer.firstName + ' ' + customer.familyName AS customer,
  cart.price AS cartVal,
  round(avgCartVal, 2) AS avgCartValue,
  round(cart.price - avgCartVal, 2) AS aboveAvg,
  item.name AS itemInCart
ORDER BY cartVal DESC

//carts with higher value than average