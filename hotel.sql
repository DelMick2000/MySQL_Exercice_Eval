<--Lot 1:-->

<--1 - Afficher la liste des hotels.-->

SELECT hot_nom, hot_ville FROM hotel;

<--2 - Afficher la ville de résidence de Mr White.-->

SELECT cli_nom, cli_prenom, cli_adresse, cli_ville FROM client
WHERE cli_id = 4;

<--3 - Afficher la liste des stations dont l'altitude < 1000 -->

SELECT sta_nom, sta_altitude FROM station WHERE sta_altitude < 1000;

<--4 - Afficher la liste des chambres ayant une capacité >1 -->

SELECT cha_numero, cha_capacite FROM chambre WHERE cha_capacite > 1;

<--5 - Afficher les clients n'habitant pas à Londres -->

SELECT cli_nom, cli_ville FROM client WHERE cli_ville != 'Londres';

<--6 - Afficher la liste des hotels située sur la ville de Bretou et possedant une catégorie > 3 -->

SELECT hot_nom, hot_ville, hot_categorie FROM hotel WHERE hot_ville != 'Pralo' 'Vonten' 'Toras' AND hot_categorie > 3;

<--Lot 2:-->

<--7 - Afficher la liste des hotels avec leur station -->

SELECT sta_nom, hot_nom, hot_categorie, hot_ville FROM station INNER JOIN hotel ON hot_sta_id = sta_id;

<--8 - Afficher la liste des chambres et leur hotel -->

SELECT hot_nom, hot_categorie, hot_ville, cha_numero FROM hotel INNER JOIN chambre ON cha_hot_id = hot_sta_id;

<--9 - Afficher la liste des chambres de plus d'une place dans des hotels situés sur la ville de Bretou -->

SELECT hot_nom, hot_categorie, hot_ville, cha_numero, cha_capacite FROM hotel INNER JOIN chambre ON cha_hot_id = hot_sta_id;

<--10 - Afficher la liste des réservations avec le nom des clients -->

SELECT cli_nom, hot_nom, res_date FROM client JOIN hotel ON hot_id = cli_id JOIN reservation ON cli_id = res_id;

<--11 - Afficher la liste des chambres avec le nom de l'hotel et le nom de la station -->

SELECT sta_nom, hot_nom, cha_numero, cha_capacite FROM station JOIN hotel ON hot_id = sta_id JOIN chambre ON sta_id = cha_id;

<--12 - Afficher les réservations avec le nom du client et le nom de l'hotel avec datediff -->

SELECT  cli_nom, hot_nom, res_date_debut, res_date_fin FROM client JOIN hotel ON hot_id = cli_id JOIN reservation ON DATEDIFF (res_date_debut, res_date_fin);

<--Lot 3:-->

<--13 - Compter le nombre d'hotel par station -->

SELECT COUNT(hot_id),sta_nom
FROM hotel
INNER JOIN station ON sta_id = hot_sta_id
GROUP BY sta_id;

<--14 - Compter le nombre de chambres par station -->

SELECT COUNT(cha_id),sta_id
FROM chambre
INNER JOIN hotel ON cha_hot_id=hot_id
INNER JOIN station ON sta_id = hot_sta_id 
GROUP BY sta_id;

<--15 - Compter le nombre de chambres par station ayant une capacité > 1 -->

SELECT COUNT(cha_id),sta_nom
FROM chambre 
INNER JOIN station ON sta_id = cha_hot_id 
WHERE cha_capacite > 1
GROUP BY sta_id;

<--16 - Afficher la liste des hotels pour lesquels Mr Squire a effectué une réservation -->

SELECT hot_nom AS "Hotel"
FROM hotel
INNER JOIN chambre ON hotel.hot_id = chambre.cha_hot_id
INNER JOIN reservation ON chambre.cha_id = reservation.res_cha_id
INNER JOIN client ON reservation.res_cli_id = client.cli_id
WHERE cli_nom = "Squire"
GROUP BY hot_id;

<--17 - Afficher la durée moyenne des réservations par station -->

SELECT AVG(DATEDIFF(res_date_fin,res_date_debut)),sta_nom
FROM reservation
INNER JOIN chambre ON chambre.cha_id = reservation.res_cha_id
INNER JOIN hotel ON hotel.hot_id = chambre.cha_hot_id
INNER JOIN station ON station.sta_id= hotel.hot_sta_id
GROUP BY sta_id