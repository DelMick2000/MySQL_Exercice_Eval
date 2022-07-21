<-- 1 - Quelles sont les commandes du fournisseur n*9120 -->

SELECT fournis.numfou, entcom.numcom
FROM fournis
INNER JOIN entcom ON fournis.numfou = entcom.numfou
INNER JOIN ligcom ON entcom.numcom = ligcom.numcom 
INNER JOIN produit ON ligcom.codart = produit.codart
WHERE entcom.numfou = "9120"
GROUP BY entcom.numcom;

<-- 2 - Afficher le code des fournisseurs pour lesquels des commandes ont été passées. -->

SELECT fournis.numfou AS "code fournisseur", entcom.datcom AS "commande passées"
FROM entcom
INNER JOIN fournis ON entcom.numfou = fournis.numfou
INNER JOIN vente ON fournis.numfou = vente.numfou
INNER JOIN produit ON vente.codart = produit.codart
INNER JOIN ligcom ON produit.codart = ligcom.codart
GROUP BY entcom.datcom;

<-- 3 - Afficher le nombre de commandes fournisseurs passées, et le nombre de fournisseur concernés. -->

SELECT fournis.numfou AS "fournisseur" , ligcom.derliv AS "commandes passées"
FROM ligcom
INNER JOIN entcom ON ligcom.numcom = entcom.numcom
INNER JOIN fournis ON entcom.numfou = fournis.numfou
INNER JOIN vente ON fournis.numfou = vente.numfou
INNER JOIN produit ON vente.codart = produit.codart
GROUP BY ligcom.derliv;

<-- 4 - Extraire les produits ayant un stock inférieur ou égal au stock d'alerte, et dont la quantité annuelle est inférieur à 1000 -->
<-- stkale = stock alerte -->
<-- stkphy = stock physique -->
<-- qteann = quantite annee -->

SELECT produit.codart AS "n° produit",
produit.libart AS "libellé produit",
produit.stkphy AS "stock actuel",
produit.stkale AS "stock d'alerte",
produit.qteann AS "quantité annuelle"
FROM produit
WHERE produit.stkphy <= produit.stkale AND produit.qteann < "1000"
GROUP BY produit.stkale;

<-- 5 - Quels sont les fournisseurs situés dans les départements 75,78,92,77 -->

SELECT fournis.posfou AS "département", fournis.nomfou AS "nom fournisseur"
FROM fournis
WHERE fournis.posfou LIKE "75%" 
OR fournis.posfou LIKE "78%" 
OR fournis.posfou LIKE "92%" 
OR fournis.posfou LIKE "77%"
ORDER BY fournis.posfou DESC, fournis.nomfou ASC;

<-- 6 - Quelles sont les commandes passées en mars et en avril ? 

SELECT ligcom.derliv AS "commandes passées"
FROM ligcom
WHERE ligcom.derliv LIKE "%-04-%"
OR ligcom.derliv LIKE "%-05-%"

<-- 7 - Quelles sont les commandes du jour qui ont des observations particuliéres ?

SELECT entcom.numcom AS "numéro de commande", entcom.datcom AS "date de commande"
FROM entcom
WHERE entcom.obscom NOT LIKE ""


<-- 8 - Lister le total de chaque commande par total décroissant. -->

SELECT ligcom.numcom AS "numéro de commande", ligcom.qteliv AS "total commande"
FROM ligcom
ORDER BY ligcom.qteliv DESC;

<-- 9 - Lister les commandes dont le total est supérieur à 10 000 euros; on exclura dans le calcul du total les articles commandés en quantité supérieure ou égale à 1000.

SELECT ligcom.numcom AS "numéro de commande", qtecde AS "quantité commandée", SUM(ligcom.qtecde * ligcom.priuni) AS "total"
FROM ligcom 
WHERE ligcom.qtecde <= "1000"
AND ligcom.qtecde * ligcom.priuni > "10000"
GROUP BY ligcom.numcom
ORDER BY total DESC

<-- 10 - Lister les commandes par nom de fournisseur -->

SELECT fournis.nomfou AS "nom du fournisseur", ligcom.numcom AS "numéro de commande", ligcom.derliv AS "date"
FROM fournis 
INNER JOIN entcom ON fournis.numfou = entcom.numfou
INNER JOIN ligcom ON entcom.numcom = ligcom.numcom
INNER JOIN produit ON ligcom.codart = produit.codart
INNER JOIN vente ON produit.codart = vente.codart
GROUP BY fournis.nomfou;

<-- 11 - Sortir les produits des commandes ayant le mot "urgent" en observation. -->

SELECT fournis.nomfou AS "nom du fournisseur", ligcom.numcom AS "numéro de commande", produit.libart AS "libellé du produit", SUM(ligcom.qtecde * ligcom.priuni) AS "total"
FROM produit
INNER JOIN vente ON vente.codart = produit.codart
INNER JOIN fournis ON fournis.numfou = vente.numfou
INNER JOIN ligcom ON ligcom.codart = produit.codart
INNER JOIN entcom ON entcom.numcom = ligcom.numcom
WHERE entcom.obscom NOT LIKE "urgente"
GROUP BY ligcom.numcom;


<-- 12 - Coder de 2 manières différentes la requete suivante: Lister les nom des fournisseurs susceptibles de livrer au moins un article -->

SELECT fournis.nomfou AS "nom fournisseur", fournis.numfou AS "numéro fournisseur", ligcom.qteliv AS "quantité livrée"
FROM fournis
INNER JOIN entcom ON fournis.numfou = entcom.numfou
INNER JOIN ligcom ON entcom.numcom = ligcom.numcom
WHERE ligcom.qteliv > "0"
GROUP BY fournis.nomfou

<-- Ou -->

SELECT fournis.nomfou AS "nom fournisseur", fournis.numfou AS "numéro fournisseur", ligcom.qteliv AS "quantité livrée"
FROM fournis
INNER JOIN entcom ON fournis.numfou = entcom.numfou
INNER JOIN ligcom ON entcom.numcom = ligcom.numcom
WHERE ligcom.qteliv != "0"
GROUP BY fournis.nomfou

<-- 13 - Coder de 2 manières différentes la requete suivante: Lister les commandes dont le fournisseur est celui de la commande n°70210 -->

SELECT ligcom.numcom AS "numéro de commande",produit.libart AS "nom de l'article", produit.codart AS "code article"
FROM ligcom
INNER JOIN produit ON produit.codart = ligcom.codart
WHERE ligcom.numcom = "70210" 
GROUP BY ligcom.numcom

<-- Ou --> 

SELECT ligcom.numcom AS "numéro de commande",produit.libart AS "nom de l'article", produit.codart AS "code article"
FROM ligcom
INNER JOIN produit ON produit.codart = ligcom.codart
WHERE ligcom.numcom LIKE "70210"
GROUP BY ligcom.numcom

<-- 14 - Dans les articles susceptibles d'etre vendus, lister les articles moins cher (basés sur prix1) que le moins cher des rubans (article dont le premier caractère commence par R)

SELECT produit.libart AS "libellé de l'article", vente.prix1 AS "prix"
FROM produit
INNER JOIN vente ON produit.codart = vente.codart
WHERE vente.prix1 < "120"
GROUP BY produit.libart

<-- 15 - Sortir la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur ou égal à 150% du stock d'alerte -->

SELECT fournis.nomfou AS "nom fournisseur", produit.libart, produit.stkphy, produit.stkale
FROM produit
INNER JOIN vente ON produit.codart = vente.codart
INNER JOIN fournis ON vente.numfou = fournis.numfou
WHERE produit.stkphy <= (produit.stkale * 1.5)
ORDER BY fournis.nomfou ASC, produit.libart ASC;

<-- 16 - Sortir la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur ou égal à 150 % du stock d'alerte, et un délai de livraison d'au maximum 30 jours. -->

SELECT fournis.nomfou AS "nom fournisseur", produit.libart, produit.stkphy, produit.stkale, vente.delliv
FROM produit
INNER JOIN vente ON produit.codart = vente.codart
INNER JOIN fournis ON vente.numfou = fournis.numfou
WHERE produit.stkphy <= (produit.stkale * 1.5) AND vente.delliv < 30
ORDER BY fournis.nomfou ASC, produit.libart ASC;

<-- 17 - Avec le même type de sélection que ci-dessus, sortir un total des stocks par fournisseur, triés par total décroissant.

SELECT fournis.nomfou AS "nom fournisseur", produit.libart AS "libellé", produit.stkphy AS "stock physique", produit.stkale "stock alerte"
FROM produit 
INNER JOIN vente ON produit.codart = vente.codart
INNER JOIN fournis ON vente.numfou = fournis.numfou
GROUP BY fournis.nomfou
ORDER BY fournis.nomfou DESC;

<-- 18 - En fin d'année, sortir la liste des produits dont la quantité réellement commandée dépasse 90% de la quantité annuelle prévue. -->

SELECT produit.libart AS "produit", ligcom.qtecde AS "produit commandée", 




























