MATCH (cart:Cart)-[c:CONTAINS]->(item:Item)
MATCH (shop:EShop)-[p:PROVIDES]->(item)
RETURN 
  shop.name AS shop,
  item.name AS product,
  p.stock AS currStock,
  c.number AS quantityInCart,
  (p.stock - c.number) AS leftAfterPurchase,
  item.price AS unitPrice,
  (item.price * c.number) AS cartValue,
  (item.price * (p.stock - c.number)) AS leftInvVal
ORDER BY leftAfterPurchase

//compare cart value to remaining inventory after purchase