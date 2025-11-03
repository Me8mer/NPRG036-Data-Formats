MATCH (owner:Owner)-[:OWNS]->(shop:EShop)-[p:PROVIDES]->(item:Item)
RETURN 
  owner.name AS corp,
  shop.name AS shop,
  item.name AS product,
  p.stock AS unitsInStock,
  item.price AS pricePerUnit,
  (p.stock * item.price) AS totalInvVal
ORDER BY totalInvVal DESC

// total inventory value per corporation