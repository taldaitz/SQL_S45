CREATE DATABASE formation;

SHOW DATABASES;

USE formation;

SHOW TABLES;

CREATE TABLE contact (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    city VARCHAR(200) NULL,
    date_of_birth DATE NULL
);

SHOW TABLES;

DESCRIBE contact;

ALTER TABLE contact
	DROP COLUMN city;
    
    
DROP TABLE contact;


INSERT INTO contact (firstname, lastname, email, date_of_birth)
VALUES ('Thomas', 'Aldaitz', 'taldaitz@dawan.fr', '1985-04-28');

INSERT INTO contact (firstname, lastname, email, date_of_birth)
VALUES ('Robert', 'test', 'rtest@dawan.fr', '1986-04-28');

INSERT INTO contact ( email, date_of_birth)
VALUES ( 'rtest@dawan.fr', '1986-04-28');

SELECT * FROM contact;

UPDATE contact
SET lastname = 'Test'
WHERE id = 2;

UPDATE contact
SET city = 'Lyon';




CREATE TABLE product (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    price FLOAT NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    description TEXT NULL,
    category VARCHAR(100) NOT NULL
);


SHOW TABLES;
DESCRIBE product;
DESCRIBE category;
DESCRIBE company;


CREATE TABLE category (
	id INT PRIMARY KEY AUTO_INCREMENT,
    label VARCHAR(100) NOT NULL
);


CREATE TABLE customer (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    tel VARCHAR(30) NOT NULL,
    email VARCHAR(250) NOT NULL,
    company VARCHAR(100) NULL
);


CREATE TABLE company (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(250) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL
);



ALTER TABLE category
	ADD COLUMN description TEXT NULL;


ALTER TABLE company
	DROP COLUMN address;
    
    
ALTER TABLE company
	ADD COLUMN tel VARCHAR(30) NOT NULL;


INSERT INTO category (label, description)
VALUES ('informatique', 'Tous les produits informatiques.');

INSERT INTO category (label, description)
VALUES ('vestimentaire', 'Tous les vetements de travail du secteur.');

INSERT INTO category (label, description)
VALUES ('consommable', 'Tous les produits pour les appareils de type imprimante ou scanner.');

SELECT * FROM category;


INSERT INTO product (name, price, stock, description, category)
VALUES ('Ecran 24 pouces', 125.58, 25, 'Superbe écran de 24 pouces', 'informatique');

INSERT INTO product (name, price, stock, description, category)
VALUES ('Manteau vert foncé', 82.73, 90, 'Manteau chaud pour temps d\'hiver', 'vestimentaire');

SELECT * FROM product;


INSERT INTO company (name, postal_code, city, tel)
VALUES ('Dawan', 69006, 'Lyon', '04569810124'),
		('Google', 75001, 'Paris', '01454984684'),
		('Microsoft', 77190, 'Melun', '0145498489')
;


SELECT * FROM company;
SELECT * FROM customer;



USE formation;

SELECT * FROM category;
SELECT name AS Nom, price AS prix FROM product;

UPDATE category
SET label = 'Bureautique'
WHERE id = 1;

UPDATE product
SET category = 'Bureautique'
WHERE id = 1;

/* OU */
UPDATE product
SET category = 'Bureautique'
WHERE category = 'informatique';


UPDATE product
SET stock = 450
WHERE price > 100;



SELECT * FROM full_order;

/*-> Le nom, prénom et email des clients dont le prénom est "Julien"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'Julien'
ORDER BY customer_lastname;

/*-> Le nom, prénom et email des clients dont l'email termine par "@gmail.com"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com'
ORDER BY customer_lastname, customer_firstname DESC
LIMIT 100;


/*-> toutes les commandes  non payées*/
SELECT * 
FROM full_order
WHERE is_paid = 0;


/*-> toutes les commandes  payées mais non livré*/
SELECT * 
FROM full_order
WHERE is_paid = 1
AND shipment_date IS NOT NULL;

/*-> toutes les commandes  livré hors de France*/
SELECT *
FROM full_order
WHERE shipment_country <> 'France';




/*-> toutes les commandes au montant de plus 8000€ ordonnées du plus grand au plus petit*/
SELECT * 
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC;


/*-> La commande le montant le plus bas (une seule)*/
SELECT * 
FROM full_order
ORDER BY amount
LIMIT 1;


/*-> toutes les commandes réglé en Cash en 2022 livré en France dont le montant est inférieur à 5000 €*/
SELECT * 
FROM full_order
WHERE payment_type = 'Cash'
AND payment_date BETWEEN '2022-01-01' AND '2022-12-31'
AND shipment_country = 'France'
AND amount < 5000;


/*-> toutes les commandes payés par carte ou payé aprés le 15/10/2021*/
SELECT * 
FROM full_order
WHERE payment_type = 'Credit Card'
OR payment_date > '2021-10-15';



/*-> les 3 dernières commandes envoyées en France*/
SELECT * 
FROM full_order
WHERE shipment_country = 'France'
ORDER BY shipment_date DESC 
LIMIT 3;



SELECT COUNT(*) FROM full_order;


/*-> la somme des commandes non payés*/
SELECT SUM(amount)
FROM full_order
WHERE is_paid = 0;


/*-> la moyenne des montants des commandes payés en cash*/
SELECT ROUND(AVG(amount), 2) AS moyenne_des_commande_payés_en_liquide
FROM full_order
WHERE payment_type = "Cash";


/*-> le nombre de client dont le nom est "Laporte"*/
SELECT COUNT(customer_lastname)
FROM full_order
WHERE customer_lastname = "Laporte";

/*-> Le nombre de jour Maximum entre la date de payment et la date de livraison -> DATEDIFF()*/
SELECT MAX(DATEDIFF(payment_date, shipment_date))
FROM full_order
;



/*-> Le délai moyen (en jour) de réglement d'une commande*/
SELECT AVG(DATEDIFF(payment_date, date))
FROM full_order
WHERE is_paid = 1
;


/*-> le nombre de commande payés en chèque sur 2021*/
SELECT COUNT(*)
FROM full_order
WHERE payment_type = 'Check'
AND payment_date BETWEEN '2021-01-01' AND '2021-12-31'
;


SELECT * FROM full_order;

SELECT payment_type, COUNT(*) AS total_order
FROM full_order
WHERE is_paid = 1
GROUP BY payment_type
	HAVING total_order > 1700
;

/*-> La somme total des montants des commandes par type de paiement*/
SELECT payment_type, ROUND(SUM(amount), 2) AS Somme_Total
FROM full_order
WHERE is_paid = 1
GROUP BY payment_type
;

/*-> La moyenne des montants des commandes par Pays*/
SELECT shipment_country, ROUND(AVG(amount), 2) AS Moyenne_des_commandes
FROM full_order
WHERE shipment_country IS NOT NULL
GROUP BY shipment_country
ORDER BY shipment_country
;

/*-> Par année la somme des commandes*/
SELECT YEAR(date) AS Annee, ROUND(SUM(amount), 2)
FROM full_order
GROUP BY Annee
ORDER BY Annee
;



/*-> Liste des clients (nom, prénom) qui ont au moins deux commandes*/
SELECT customer_lastname, customer_firstname, COUNT(*) AS nb_order
FROM full_order
GROUP BY customer_lastname, customer_firstname
HAVING nb_order > 1
;





SELECT * FROM customer;
SELECT * FROM bill;

SELECT customer_id, lastname, firstname, COUNT(*)
FROM bill JOIN customer ON bill.customer_id = customer.id
GROUP BY customer_id;

/*-> La moyenne des montants des factures*/
SELECT ROUND(AVG(li.quantity * pr.unit_price),2) AS average_amount
FROM bill bi	
	JOIN line_item li ON bi.id = li.bill_id
    JOIN product pr ON li.product_id = pr.id
;

/*-> le nom, prénom et somme des 3 clients qui ont le plus grand nombre de facture*/
SELECT 
	cu.lastname, 
	cu.firstname, 
	SUM(li.quantity * pr.unit_price) AS total,
    COUNT(bi.id) AS nb_bill
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY cu.lastname, cu.firstname
ORDER BY nb_bill DESC
LIMIT 3
;

/*-> le nom, prénom et somme des 3 clients qui ont les factures les plus cheres*/


/*-> le nom, prénom et somme des 3 clients qui ont le montant total des factures les plus élevés*/

/*-> La moyenne d'age pour chaque catégorie de produit*/


/*-> Afficher la liste des produits : leur noms, leur prix et le nom
de leur catégorie.*/

SELECT pr.name, pr.unit_price, ca.label
FROM product pr 
	JOIN category ca ON pr.category_id = ca.id
;

/*-> Afficher pour chaque client : Son nom, son prénom et la date de sa 
derniere Facture*/

SELECT cu.lastname, cu.firstname, MAX(bi.date)
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
GROUP BY cu.id
;



/*-> Afficher pour chaque catégorie : Le label, la quantité disponible moyenne 
de ses produits*/

SELECT ca.label, ROUND(AVG(pr.quantity_available))
FROM product pr 
	JOIN category ca ON pr.category_id = ca.id
GROUP BY ca.label
;


USE formation;

SHOW TABLES;

SELECT * FROM product;
SELECT * FROM category;

ALTER TABLE product
	ADD COLUMN category_id int not null;
    
ALTER TABLE product
	ADD CONSTRAINT FK_Product_Category
    FOREIGN KEY product(category_id)
    REFERENCES category(id)
;

DELETE FROM category WHERE id = 1;

SELECT * FROM customer;
SELECT * FROM company;


ALTER TABLE customer
	ADD COLUMN company_id INT NOT NULL;
    
SELECT ROUND(RAND()*(3 - 1) + 1);

UPDATE customer
SET company_id = ROUND(RAND()*(3 - 1) + 1)
;
    
    
ALTER TABLE customer
	ADD CONSTRAINT FK_Customer_Company
    FOREIGN KEY customer(company_id)
    REFERENCES company(id)
;


SELECT cu.lastname, cu.firstname, co.name
	FROM customer cu
		JOIN company co ON cu.company_id = co.id
;
	





USE billings;

/*-> Pour chaque client (nom, prénom) remonter le nombre de facture associé*/
SELECT cu.lastname, cu.firstname, COUNT(bi.id) AS nbr_factures
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
GROUP BY cu.id;
 
 
/*-> Pour chaque Facture afficher le montant total*/
SELECT bill.id,SUM( line_item.quantity * product.unit_price) AS montant
FROM line_item
JOIN bill ON bill.id = line_item.bill_id
JOIN product ON product.id = line_item.product_id
GROUP BY bill.id;


/*-> Pour chaque client compter le nombre de produit différents qu'il a commandé*/
SELECT
		cu.id,
        cu.lastname,
        cu.firstname,
        COUNT(pr.id) AS Nb_product
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY cu.id
;









/*-> Pour chaque produit compter le nombre de client différents qu'ils l'ont commandé*/
SELECT
		pr.id,
        pr.name,
        COUNT(cu.id)
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY pr.id
ORDER BY pr.id
;

/*-> pour chaque catégorie de produit la somme des facture payées*/

SELECT 
	ca.label,
    SUM(li.quantity * pr.unit_price) AS amount
FROM line_item li
JOIN bill bi ON li.bill_id = bi.id
JOIN product pr ON pr.id = li.product_id
JOIN category ca ON pr.category_id = ca.id
WHERE bi.is_paid = 1
GROUP BY ca.id
;


/*-> par Année de facture la moyenne d'age des clients*/

SELECT YEAR(bi.date) AS BillYear, AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, CURRENT_DATE()))
FROM bill bi
	JOIN customer cu ON bi.customer_id = cu.id
GROUP BY BillYear
ORDER BY BillYear
;

/*-> les nom, prénom et num de tel des clients qui ont des factures de produit de 
camping ces deux dernières années*/
SELECT cu.lastname, cu.firstname, cu.phone_number
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
WHERE ca.label = 'camping'
AND bi.date > '2021-11-08'
;
    
    
CREATE VIEW View_list_of_customer_with_camping_items_in_last_two_years AS   
SELECT cu.lastname, cu.firstname, cu.phone_number
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
WHERE ca.label = 'camping'
AND bi.date > '2021-11-08'
;
    
    
SELECT * FROM View_list_of_customer_with_camping_items_in_last_two_years;
    
    
SELECT id
FROM category
WHERE  label IN ('Camping', 'Streetwear', 'Working')
;


SELECT * 
FROM product
WHERE category_id IN (
	SELECT id
	FROM category
	WHERE  label IN ('Camping', 'Streetwear', 'Working')
);


CREATE VIEW View_bill_with_total_amount AS
SELECT bi.*, SUM(li.quantity * pr.unit_price) AS total_amount
	FROM bill bi
		JOIN line_item li ON li.bill_id = bi.id
        JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
;


SELECT * FROM view_bill_with_total_amount;

/*-> le nom, prénom et somme des 3 clients qui ont le plus grand nombre de facture*/
SELECT cu.id, cu.lastname, cu.firstname, SUM(vb.total_amount) AS total, COUNT(vb.id) AS nb_bill
FROM customer cu
	JOIN view_bill_with_total_amount vb ON vb.customer_id = cu.id
GROUP BY cu.id
ORDER BY nb_bill DESC
LIMIT 3
;


/*-> le nom, prénom et somme des 3 clients qui ont les factures les plus cheres*/

SELECT cu.id, cu.lastname, cu.firstname, SUM(vb.total_amount) AS total, MAX(vb.total_amount) AS Max_bill
FROM customer cu
	JOIN view_bill_with_total_amount vb ON vb.customer_id = cu.id
GROUP BY cu.id
ORDER BY Max_bill DESC
LIMIT 3
;

/*-> le nom, prénom et somme des 3 clients qui ont le montant total des factures les plus élevés*/
SELECT cu.id, cu.lastname, cu.firstname, SUM(vb.total_amount) AS total
FROM customer cu
	JOIN view_bill_with_total_amount vb ON vb.customer_id = cu.id
GROUP BY cu.id
ORDER BY total DESC
LIMIT 3
;



CREATE TABLE import_netflix (
	show_id VARCHAR(250),
	type VARCHAR(250),
	title VARCHAR(250),
	director VARCHAR(250),
	cast TEXT,
	country VARCHAR(250),
	date VARCHAR(250),
	year VARCHAR(250),
	release_year VARCHAR(250),
	rating VARCHAR(250),
	duration VARCHAR(250),
	listed_in TEXT,
	description TEXT
);

/*Paramétrage du serveur*/
SET GLOBAL local_infile=1;


LOAD DATA LOCAL INFILE 'C:\\formations\\SQL\\netflix.csv'
INTO TABLE import_netflix
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;



SELECT * FROM import_netflix;

TRUNCATE TABLE import_netflix;







SET @toto = 'toto,titi,tata';
SET @name = substring_index(@toto, ',', 1);
SELECT @name;

SET @toto = REPLACE(@toto, CONCAT(@name, ','), '');


/*Netflix*/

DROP DATABASE netflix;

CREATE DATABASE netflix;
USE netflix;


CREATE TABLE director (
	id INT PRIMARY KEY AUTO_INCREMENT,
	lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100)
); 


CREATE TABLE movie (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(250) NOT NULL,
    release_year INT NOT NULL,
    description TEXT,
    director_id INT NOT NULL,
    FOREIGN KEY (director_id)
    REFERENCES director(id)
);

CREATE TABLE actor (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100)
);

CREATE TABLE actor_movie (
	actor_id INT,
    movie_id INT,
     PRIMARY KEY (actor_id, movie_id)
);

ALTER TABLE actor_movie
	ADD CONSTRAINT FK_actor_actor_movie
    FOREIGN KEY actor_movie(actor_id)
    REFERENCES actor(id);

ALTER TABLE actor_movie
	ADD CONSTRAINT FK_movie_actor_movie
    FOREIGN KEY actor_movie(movie_id)
    REFERENCES movie(id);
    
CREATE TABLE category (
	id INT PRIMARY KEY AUTO_INCREMENT,
    label VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE category_movie (
	movie_id INT,
    category_id INT,
    PRIMARY KEY (movie_id, category_id)
);

ALTER TABLE category_movie 
	ADD CONSTRAINT FK_movie_category_movie
    FOREIGN KEY category_movie(movie_id)
    REFERENCES movie(id);

ALTER TABLE category_movie 
	ADD CONSTRAINT FK_category_category_movie
    FOREIGN KEY category_movie(category_id)
    REFERENCES category(id);
    



 
CREATE TABLE subscription (
	id INT PRIMARY KEY AUTO_INCREMENT,
    label  VARCHAR(100),
    description TEXT,
    nb_ecran INT NOT NULL
);

CREATE TABLE user (
	id INT PRIMARY KEY AUTO_INCREMENT,
	lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    mail VARCHAR(100) NOT NULL,
    password VARCHAR(100),
    subscription_id INT NOT NULL,
	FOREIGN KEY (subscription_id) REFERENCES subscription(id)
);

CREATE TABLE viewing (
	id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (movie_id) REFERENCES movie(id)
); 

    SELECT * FROM import_netflix;

SELECT * FROM movie;
SELECT * FROM actor;
SELECT * FROM director;

DELETE FROM director;

SELECT * FROM director
WHERE lastname = 'Shinohara'
AND firstname = 'Toshiya';


SELECT SUBSTRING_INDEX(director, ' ', -1) AS lastname,
	SUBSTRING_INDEX(director, ' ', 1) AS firstname
FROM import_netflix
WHERE director <> ''
AND type = 'Movie'
GROUP BY lastname, firstname
;


INSERT INTO director (lastname, firstname)
SELECT SUBSTRING_INDEX(director, ' ', -1) AS lastname,
	SUBSTRING_INDEX(director, ' ', 1) AS firstname
FROM import_netflix
WHERE director <> ''
AND type = 'Movie'
GROUP BY lastname, firstname
;


SELECT inx.title, 
		inx.release_year, 
		inx.description, 
		di.id AS director_id, 
		CASE WHEN inx.release_year REGEXP '^[0-9]+$' = 1  THEN 'Valid' ELSE 'Invalid' END
FROM import_netflix inx
	JOIN director di ON inx.director = CONCAT(di.firstname, ' ', di.lastname)
WHERE inx.type = 'Movie'
AND inx.director <> ''
;


DELETE FROM movie;

INSERT INTO movie (title, release_year, description, director_id)
SELECT inx.title, inx.release_year, inx.description, di.id AS director_id
FROM import_netflix inx
	JOIN director di ON inx.director = CONCAT(di.firstname, ' ', di.lastname)
WHERE inx.type = 'Movie'
AND inx.director <> ''
AND inx.release_year REGEXP '^[0-9]+$' = 1
;


SELECT * FROM import_netflix;
SELECT lastname, firstname, CONCAT(firstname, ' ', lastname)
FROM director;


SELECT * FROM movie;

CALL update_description();


/*Procédure Stockée*/

DELIMITER //

CREATE PROCEDURE update_description()
BEGIN

	UPDATE movie
    SET description = CONCAT(description, ' / ', CURRENT_DATE());

END//



DELIMITER //

CREATE PROCEDURE init_netflix_tables()
BEGIN

DELETE FROM movie;
DELETE FROM director;


INSERT INTO director (lastname, firstname)
SELECT SUBSTRING_INDEX(director, ' ', -1) AS lastname,
	SUBSTRING_INDEX(director, ' ', 1) AS firstname
FROM import_netflix
WHERE director <> ''
AND type = 'Movie'
GROUP BY lastname, firstname
;

INSERT INTO movie (title, release_year, description, director_id)
SELECT inx.title, inx.release_year, inx.description, di.id AS director_id
FROM import_netflix inx
	JOIN director di ON inx.director = CONCAT(di.firstname, ' ', di.lastname)
WHERE inx.type = 'Movie'
AND inx.director <> ''
AND inx.release_year REGEXP '^[0-9]+$' = 1
;


END //



DELIMITER //

CREATE PROCEDURE init_netflix_tables_with_transaction()
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
BEGIN
	ROLLBACK;
	SELECT ('Une erreur est survenue durant le chargement.') AS Warning;
END;

START TRANSACTION;

	DELETE FROM movie;
	DELETE FROM director;


	INSERT INTO director (lastname, firstname)
	SELECT SUBSTRING_INDEX(director, ' ', -1) AS lastname,
		SUBSTRING_INDEX(director, ' ', 1) AS firstname
	FROM import_netflix
	WHERE director <> ''
	AND type = 'Movie'
	GROUP BY lastname, firstname
	;

	INSERT INTO movie (title, release_year, description, director_id)
	SELECT inx.title, inx.release_year, inx.description, di.id AS director_id
	FROM import_netflix inx
		JOIN director di ON inx.director = CONCAT(di.firstname, ' ', di.lastname)
	WHERE inx.type = 'Movie'
	AND inx.director <> ''
    AND inx.release_year REGEXP '^[0-9]+$' = 1
	;
    
    SET @nbMovies = (SELECT COUNT(*) FROM movie); 
    
	 IF @nbMovies > 0
		THEN
			COMMIT;
		ELSE 
			ROLLBACK;
	END IF;

END//


DELIMITER //

CREATE PROCEDURE generate_viewings()
BEGIN

	DELETE FROM viewing;
	
    SET @i = 0;
    REPEAT
    
		SET @userid = (SELECT id FROM User ORDER BY RAND() LIMIT 1); 
		SET @movieid = (SELECT id FROM Movie ORDER BY RAND() LIMIT 1); 
		
        INSERT INTO viewing (date, user_id, movie_id)
			VALUES(
				CURRENT_DATE(),
                @userid,
                @movieid
            )
        ;
    
		SET @i = @i + 1;
    UNTIL @i >= 5000 END REPEAT;

END//



SELECT id FROM User ORDER BY RAND() LIMIT 1;
SELECT * FROM Movie;

SET GLOBAL MAX_EXECUTION_TIME=10000;


SELECT * FROM Viewing;

CALL generate_viewings();



CREATE VIEW view_film_popularity AS
SELECT 
	mo.title, 
	mo.release_year, 
    COUNT(vi.id),
    CASE WHEN COUNT(vi.id) = 0 
		THEN 'Flop' 
        ELSE
			CASE WHEN COUNT(vi.id) <= 3
				THEN 'Normale'
                ELSE 'Top'
            END
    END AS popularity
FROM movie mo
	LEFT JOIN viewing vi ON vi.movie_id = mo.id
GROUP BY mo.id
ORDER BY release_year DESC, title
;


SELECT * FROM view_film_popularity;
