<-- 1 - Liste des clients français: -->

SELECT customers.CompanyName AS "Société",
customers.ContactName AS "Contact",
customers.ContactTitle AS "Fonction",
customers.Phone AS "Téléphone"
FROM customers 
WHERE customers.country = "France"

<-- 2 - Liste des produits vendus par le fournisseur "Exotic Liquids": -->

SELECT suppliers.SupplierID AS "ID",
products.ProductName AS "Produit",
products.UnitPrice AS prix
FROM suppliers 
INNER JOIN products ON suppliers.SupplierID = products.SupplierID
WHERE suppliers.CompanyName = "Exotic Liquids";

<-- 3 - Nombre de produits mis à disposition par les fournisseurs français (tri par nombre de produits décroissant): -->

SELECT suppliers.CompanyName AS "Fournisseur", COUNT(products.ProductID) AS "Nbre produits"
FROM suppliers 
INNER JOIN products ON suppliers.SupplierID = products.SupplierID 
WHERE suppliers.Country = "France"
GROUP BY suppliers.CompanyName
ORDER BY COUNT(products.ProductID) DESC;

<-- 4 - Liste des clients français ayant passé plus de 10 commandes: -->

SELECT customers.CompanyName AS "Client", COUNT(orders.OrderID) AS "Nbre commandes"
FROM customers
INNER JOIN orders ON customers.CustomerID = orders.CustomerID
WHERE customers.Country = "France"
GROUP BY customers.CompanyName
HAVING COUNT(orders.OrderID) > 10

<-- 5 - Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000 €:

SELECT customers.CompanyName AS "Client", SUM(`order details`.UnitPrice * `order details`.Quantity) AS "CA", customers.Country AS "Pays"
FROM customers
INNER JOIN orders ON customers.CustomerID = orders.CustomerID
INNER JOIN `order details` ON orders.OrderID = `order details`.OrderID
GROUP BY customers.CompanyName
HAVING SUM(`order details`.UnitPrice * `order details`.Quantity) > 30000
ORDER BY SUM(`order details`.UnitPrice * `order details`.Quantity) DESC;

<-- 6 - Liste des pays dans lesquels des produits fournis par "Exotic Liquids" ont été livrés:

SELECT orders.ShipCountry AS "Pays"
FROM orders
INNER JOIN `order details` ON orders.OrderID = `order details`.OrderID
INNER JOIN products ON `order details`.ProductID = products.ProductID
INNER JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE suppliers.CompanyName = "Exotic Liquids"
GROUP BY orders.ShipCountry
ORDER BY orders.shipcountry ASC;

<-- 7 - Chiffre d'affaires global sur les ventes de 1997: -->

SELECT SUM(`order details`.UnitPrice * `order details`.Quantity) AS "Montant Ventes 97"
FROM `order details`
INNER JOIN orders ON `order details`.OrderID = orders.OrderID
WHERE orders.OrderDate LIKE '1997-%-%'

<-- 8 - Chiffre d'affaires détaillé par mois, sur les ventes de 1997:

SELECT MONTH(orders.OrderDate) AS "Mois 97", SUM(`order details`.UnitPrice * `order details`.Quantity) AS "Montant Vente 97"
FROM `order details` 
INNER JOIN orders ON `order details`.OrderId = orders.OrderID
WHERE (orders.OrderDate) LIKE '1997-%-%'
GROUP BY MONTH(orders.OrderDate);

<-- 9 - A quand remonte la dernière commande du client nommé "Du monde entier" ? -->

SELECT MAX(orders.OrderDate) AS "Date de dernière commande"
FROM orders
INNER JOIN customers ON orders.CustomerID = customers.CustomerID
WHERE customers.CompanyName = "Du Monde Entier"

<-- 10 - Quel est le délai moyen de livraison en jours ? -->

SELECT ROUND(AVG(DATEDIFF(orders.ShippedDate,orders.OrderDate))) AS "Délai moyen de livraison en jours"
FROM orders