MERGE (Corp1:Owner {identifier:'FR33Z3'}) ON CREATE SET Corp1.name = 'Goth Corp';
MERGE (Corp2:Owner {identifier:'8UTTL3R'}) ON CREATE SET Corp2.name = 'Wayne Enterprises';
MERGE (Corp3:Owner {identifier:'HAT3R_1'}) ON CREATE SET Corp3.name = 'Lex Corp';

MERGE (Customer1:Shopper {familyName:'Boyle'}) ON CREATE SET Customer1.firstName = 'Ferris';
MERGE (Customer2:Shopper {familyName:'Wayne'}) ON CREATE SET Customer2.firstName = 'Bruce';
MERGE (Customer3:Shopper {familyName:'Luthor'}) ON CREATE SET Customer3.firstName = 'Lex';

MERGE (Shop1:EShop {name: 'Goth Fridges'}) ON CREATE SET Shop1.url = 'https://www.gothcorp.com/shop/fridges', Shop1.image = 'https://example.org/images/fridge.png';
MERGE (Shop2:EShop {name: 'Wayne's Gains'}) ON CREATE SET Shop2.url = 'https://www.waynesgains.com', Shop2.image = 'https://example.org/images/protein.png';
MERGE (Shop3:EShop {name: 'Lex Rides'}) ON CREATE SET Shop3.url = 'https://www.lexcorp.com/vehicles/shop', Shop3.image = 'https://example.org/images/car.png';

MERGE (Shop1Item:Item {name: 'Cold Cold Fridge'}) ON CREATE SET Shop1Item.price = 999.99, Shop1Item.description = 'Perfect to keep your vegetables fresh', Shop1Item.availability = 'https://schema.org/InStock', Shop1Item.image = ['https://example.org/images/fridge_front.png','https://example.org/images/fridge_side.png','https://example.org/images/fridge_open.png'];
MERGE (Shop2Item:Item {name: 'Bat-Protein'}) ON CREATE SET Shop2Item.price = 50.49, Shop2Item.description = 'Keep out of reach of penguins.', Shop2Item.availability = 'https://schema.org/OutOfStock', Shop2Item.image = ['https://example.org/images/protein_top.png','https://example.org/images/protein_side.png','https://example.org/images/protein_inside.png'];
MERGE (Shop3Item:Item {name: 'SuperVan'}) ON CREATE SET Shop3Item.price = 10024.99, Shop3Item.description = 'Made on Earth by humans.', Shop3Item.availability = 'https://schema.org/PreOrder', Shop3Item.image = ['https://example.org/images/van_front.png','https://example.org/images/van_back.png','https://example.org/images/van_leather_seats.png'];

MERGE (Shop1Cart:Cart {numberOfItems: 1, price: 999.99});
MERGE (Shop2Cart:Cart {numberOfItems: 1, price: 50.49});
MERGE (Shop3Cart:Cart {numberOfItems: 1, price: 10024.99});

MERGE (Customer1Account:Account {accountName: 'Boyoyoyle', password: 'nothing2c'});
MERGE (Customer2Account:Account {accountName: 'BatMan4Ever', password: 'AlfredDaButtler'});
MERGE (Customer3Account:Account {accountName: 'SuperLoser', password: '1a1a1A'});


MATCH (Corp1:Owner {identifier:'FR33Z3'})
MATCH (Shop1:EShop {name: 'Goth Fridges'})
MERGE (Corp1)-[:OWNS {since: date('1940-12-01')}]->(Shop1);

MATCH (Corp2:Owner {identifier:'8UTTL3R'})
MATCH (Shop2:EShop {name: 'Wayne's Gains'})
MERGE (Corp2)-[:OWNS {since: date('1987-05-01')}]->(Shop2);

MATCH (Corp3:Owner {identifier:'HAT3R_1'})
MATCH (Shop3:EShop {name: 'Lex Rides'})
MERGE (Corp3)-[:OWNS {since: date('1940-04-01')}]->(Shop3);


MATCH (Shop1:EShop {name: 'Goth Fridges'})
MATCH (Shop1Item:Item {name: 'Cold Cold Fridge'})
MERGE (Shop1)-[:PROVIDES {stock: 10}]->(Shop1Item);

MATCH (Shop2:EShop {name: 'Wayne's Gains'})
MATCH (Shop2Item:Item {name: 'Bat-Protein'})
MERGE (Shop2)-[:PROVIDES {stock: 11}]->(Shop2Item);

MATCH (Shop3:EShop {name: 'Lex Rides'})
MATCH (Shop3Item:Item {name: 'SuperVan'})
MERGE (Shop3)-[:PROVIDES {stock: 25}]->(Shop3Item);


MATCH (Shop1:EShop {name: 'Goth Fridges'})
MATCH (Customer1Account:Account {accountName: 'Boyoyoyle'})
MERGE (Shop1)-[:PROVIDES {since: date('1940-12-02')}]->(Customer1Account);

MATCH (Shop2:EShop {name: 'Wayne's Gains'})
MATCH (Customer2Account:Account {accountName: 'BatMan4Ever'})
MERGE (Shop2)-[:PROVIDES {since: date('1987-05-07')}]->(Customer2Account);

MATCH (Shop3:EShop {name: 'Lex Rides'})
MATCH (Customer3Account:Account {accountName: 'SuperLoser'})
MERGE (Shop3)-[:PROVIDES {since: date('1940-04-11')}]->(Customer3Account);


MATCH (Customer1:Shopper {familyName:'Boyle'})
MATCH (Customer1Account:Account {accountName: 'Boyoyoyle'})
MERGE (Customer1)-[:OWNS]->(Customer1Account);

MATCH (Customer2:Shopper {familyName:'Wayne'})
MATCH (Customer2Account:Account {accountName: 'BatMan4Ever'})
MERGE (Customer2)-[:OWNS]->(Customer2Account);

MATCH (Customer3:Shopper {familyName:'Luthor'})
MATCH (Customer3Account:Account {accountName: 'SuperLoser'})
MERGE (Customer3)-[:OWNS]->(Customer3Account);


MATCH (Customer1Account:Account {accountName: 'Boyoyoyle'})
MATCH (Shop1Cart:Cart {numberOfItems: 1, price: 999.99})
MERGE (Customer1Account)-[:PROVIDES]->(Shop1Cart);

MATCH (Customer2Account:Account {accountName: 'BatMan4Ever'})
MATCH (Shop2Cart:Cart {numberOfItems: 1, price: 50.49})
MERGE (Customer2Account)-[:PROVIDES]->(Shop2Cart);

MATCH (Customer3Account:Account {accountName: 'SuperLoser'})
MATCH (Shop3Cart:Cart {numberOfItems: 1, price: 10024.99})
MERGE (Customer3Account)-[:PROVIDES]->(Shop3Cart);


MATCH (Shop1Cart:Cart {numberOfItems: 1, price: 999.99})
MATCH (Shop1Item:Item {name: 'Cold Cold Fridge'})
MERGE (Shop1Cart)-[:CONTAINS {number: 1}]->(Shop1Item);

MATCH (Shop2Cart:Cart {numberOfItems: 1, price: 50.49})
MATCH (Shop2Item:Item {name: 'Bat-Protein'})
MERGE (Shop2Cart)-[:CONTAINS {number: 1}]->(Shop2Item);

MATCH (Shop3Cart:Cart {numberOfItems: 1, price: 10024.99})
MATCH (Shop3Item:Item {name: 'SuperVan'})
MERGE (Shop3Cart)-[:CONTAINS {number: 1}]->(Shop3Item);
