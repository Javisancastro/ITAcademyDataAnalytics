# Partiendo de algunos archivos CSV diseñarás y crearás tu base de datos.

## NIVEL 1 ##

# Descarga los archivos CSV, estudiales y diseña una base de datos con un esquema de estrella que contenga, al menos 4 tablas de las que puedas realizar las siguientes consultas:

-- Creamos un nuevo schema para el sprint 4

CREATE SCHEMA IF NOT EXISTS Spr4;

-- Nos preparamos para crear las tablas y exportar los datos de los CSVs

#1era tabla , en este caso la tabla companies. Esta tabla contiene la informacion relevante a identificadores unicos, nombres , telefono, mail, pais y página web

Create table if not exists companies (
company_id VARCHAR(15) PRIMARY KEY,
company_name VARCHAR(255),
phone VARCHAR(255),
email VARCHAR(255),
country VARCHAR(255),
website VARCHAR(255));

-- comprobamos se ha creado:

Select* 
From companies

-- Comprobamos el directorio de subida de datos

SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

-- Importamos datos desde el csv "companies"  y comprobamos que la informacion ha sido actualizada de manera correcta

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv"
Into table spr4.companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- comprobamos se ha subido toda la informacion 
Select* 
From companies;


/*2nda tabla , en este caso la tabla credit_cards . Esta tabla contiene información relevante respecto al identificador unico de la tarjeta, identificador usuario (Este dato se podrá relacionar con otras tablas,
y los datos concretos de estas tarjetas 

Revisando el csv , es posible que se tengan corregir los siguientes campos
 - Datos de la columna user id,  ,pan ,pin y cvv pasado a formato numerico
 - Columna pan - eliminar los espacios en blanco
  -La columna expiring_date tiene formato texto y formato fecha */

Create table if not exists credit_cards (
id VARCHAR(15) primary key,
user_id VARCHAR(15),
iban VARCHAR(50),
pan VARCHAR (50),
pin VARCHAR(4),
cvv INT,
track1 VARCHAR (255),
track2 varchar (255),
expiring_date VARCHAR(20));

-- Comprobamos que se haya creado

Select* 
From credit_cards;

-- Importamos datos desde el csv "credit_card"  y comprobamos que la informacion ha sido actualizada de manera correcta

SET GLOBAL local_infile = 1

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv"
Into table spr4.credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Comprobamos que se la informacion se ha añadido

Select* 
From credit_cards;

-- Realizamos modificiones - Formato numerico ID

ALTER TABLE credit_cards MODIFY COLUMN user_id INT;

-- Eliminar espacios en blanco PAN

SET SQL_SAFE_UPDATES = 0;

UPDATE credit_cards
SET pan = TRIM(REPLACE(pan, ' ', ''));

SET SQL_SAFE_UPDATES = 1;

--   Comprobamos que se la informacion se ha modificado

Select* 
From credit_cards;

-- Unificar el formato en la columna expiring_date y convertirlo en fecha

SET SQL_SAFE_UPDATES = 0;
UPDATE credit_cards
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%Y');

ALTER TABLE credit_cards MODIFY COLUMN expiring_date DATE;

SET SQL_SAFE_UPDATES = 1;

-- Comprobar cambios

Select* 
From credit_cards;

#3era tabla , en este caso la tabla Products . Esta tabla contiene la informacion relevante a identificadores unicos de producto, nombres , precio, color, peso e identificador de warehouse.
-- Revisando el archivo CSV antes de importar los datos, hemos observado que el campo precio y id está en formato texto, por lo que crearemos la columna ID como INT y luego modificaremos los datos de la columna price_usd

Create table if not exists products (
id INT PRIMARY KEY,
product_name VARCHAR(255),
price_usd VARCHAR (255),
colour VARCHAR(255),
weight dec (10, 1),
wwarehouse_id VARCHAR(15));

-- Comprobamos que se ha creado

SHOW CREATE TABLE products;

SET GLOBAL local_infile = 1;

-- Cargamos la informacion ddel csv products  

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv"
Into table spr4.products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select * 
From products;

-- Modificamos el valor precio para que tengamos un valor numérico - a la tabla se le ha llamado usd para identificar la divisa

SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET price_usd = substr(price_usd,2);

ALTER TABLE products  MODIFY COLUMN price_usd decimal(10,2);

SET SQL_SAFE_UPDATES = 1;

Select price_usd
From products;

#4a tabla , en este caso la tabla data_users

CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        personal_email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
        );
-- Comprobamos que se ha creado 

Use spr4;
Show columns from users;

-- volcamos la informacion de los archivos csv users_usa

SET GLOBAL local_infile = 1;

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv"
Into table spr4.users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Comprobamos que se ha subido 

Select*
From users;

-- volcamos la informacion de los archivos csv. users_uk en la tabla users

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv"
Into table spr4.users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- volcamos la informacion de los archivos csv. users_ca en la tabla users

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv"
Into table spr4.users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Comprobamos que se ha subido 

Select*
From users;

-- se puede observar en la tabla que la informacion de fecha de nacimiento no se ha subido como fecha - Realizamos el cambio 

SET SQL_SAFE_UPDATES = 0;
UPDATE users
SET birth_date = STR_TO_DATE(birth_date, '%b %d, %Y')
WHERE STR_TO_DATE(birth_date, '%b %d, %Y') IS NOT NULL;

ALTER TABLE users MODIFY COLUMN birth_date DATE;

SET SQL_SAFE_UPDATES = 1;

-- Comprobamos que se ha actualizado 

Select birth_date
From users;

-- Creamos la tabla transacciones --

Show create table transactions.transaction;

CREATE TABLE if not exists transacciones (
  id varchar(255) PRIMARY KEY,
  card_id varchar(15),
  business_id varchar(20),
  time_stamps timestamp,
  amount decimal(10,2),
  declined tinyint,
  products_id varchar(255),
  user_id int,
  lat float,
  longitude float
  );

---------

Use spr4;
Show columns from transacciones;

-- Cargamos la informacion de la tabla transacciones

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv"
Into table spr4.transacciones
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Comprobamos que funciona bien 

select *
From transacciones;

# comenzamos a relacionar la informacion de las tablas entre si 

-- Tabla transacciomnes con tabla users

ALTER TABLE transacciones
ADD CONSTRAINT fk_users_id
FOREIGN KEY (user_id) references users(id);

Show columns from transacciones;

-- Tabla transacciones con tabla companies 

ALTER TABLE transacciones
ADD CONSTRAINT fk_companies_id
FOREIGN KEY (business_id) references companies(company_id);

Show columns from transacciones;

-- Tabla transacciones con tabla credit_cards

ALTER TABLE transacciones
ADD CONSTRAINT fk_credit_cards_id
FOREIGN KEY (card_id) references credit_cards(id);

-- Tabla credit_cards  con tabla users

ALTER TABLE credit_cards
ADD CONSTRAINT fk_users_credit_id
FOREIGN KEY (user_id) references users(id);

/*Vinculamos la tabla transacciones con la tabla productos , tal y como se ve en la informacio de la tabla transacciones, 
tenemos una columna que contiene varios ID de producto, por ese motivo, tendremos que crear una tabla intermedia que permita obtener la informacion unica*/

CREATE TABLE transacciones_productos(
    transaccion_id VARCHAR(255),
    producto_id INT,
    PRIMARY KEY (transaccion_id, producto_id),
    FOREIGN KEY (transaccion_id) REFERENCES transacciones(id),
    FOREIGN KEY (producto_id) REFERENCES products(id));
    

-- Introducimos los datos en la nueva tabla a traves de un INSERT TO, uniendo ambas tablas y realizando un FIND_IN_SET y substring INDEX

INSERT INTO transacciones_productos (transaccion_id, producto_id)
SELECT
    t.id AS transaccion_id,
    p.id AS producto_id
FROM
    transacciones t
JOIN
    products p ON FIND_IN_SET(p.id, t.products_id) > 0;

INSERT INTO transacciones_productos (transaccion_id, producto_id)
SELECT
    id,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(products_id, ',', 2),
        ',',
        -1
    ) AS segundo_producto_id
FROM
    transacciones
WHERE
    CHAR_LENGTH(products_id) - CHAR_LENGTH(REPLACE(products_id, ',', '')) >= 1;
    
INSERT INTO transacciones_productos (transaccion_id, producto_id)
SELECT
    id,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(products_id, ',', 3),
        ',',
        -1
    ) AS tercer_producto_id
FROM
    transacciones
WHERE
    CHAR_LENGTH(products_id) - CHAR_LENGTH(REPLACE(products_id, ',', '')) >= 2;
    
INSERT INTO transacciones_productos (transaccion_id, producto_id)    
    SELECT
    id,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(products_id, ',', 4),
        ',',
        -1
    ) AS cuarto_producto_id
FROM
    transacciones
WHERE
    CHAR_LENGTH(products_id) - CHAR_LENGTH(REPLACE(products_id, ',', '')) >= 3;
    
    
#Ahora que tenemos la base de datos creada y relacionada entre si , procederemos a realizar las consultas


# Ejercicio 1.1

-- Realiza una subconsulta que muestre a todos los usuarios con más de 30 transacciones utilizando al menos 2 tablas.

SELECT user_id, users.name, users.surname
FROM transacciones
Join users on users.id = transacciones.user_id
GROUP BY user_id
HAVING COUNT(user_id) > 30;

# Ejercicio 2
-- Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.

SELECT companies.company_name, iban, AVG(transacciones.amount) AS media_amount
FROM credit_cards 
JOIN transacciones ON credit_cards.id = transacciones.card_id
JOIN companies ON transacciones.business_id = companies.company_id
WHERE companies.company_name = "Donec Ltd"
GROUP BY  credit_cards.iban;

#NIVEL 2. Ejercicio 1

-- Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en si las últimas tres transacciones fueron declinadas y genera la siguiente consulta: ¿Cuántas tarjetas están activas?

CREATE TABLE credit_cards_status (
    card_id VARCHAR(15) PRIMARY KEY,
    status VARCHAR(10)
    );
 
-- Insertamos los valores 

INSERT INTO credit_cards_status (card_id, status)
SELECT credit_cards.id, CASE
        WHEN (
            SELECT COUNT(*)
            FROM transacciones 
            WHERE transacciones.card_id = credit_cards.id AND transacciones.declined = 1 
            ORDER BY transacciones.time_stamps DESC
            LIMIT 3
        ) = 3 
        THEN 'deactivated'
        ELSE 'active'
    END
FROM credit_cards; 


-- Realizamos la consulta

Select count(status)
From credit_cards_status
where status = "Active";

-- parece ser que todas las tarjetas estan activas, realizamos una pequeña consulta, asumiendo que esta desactivada si hay 1 transaccion o mas declinadas, para ver si hay algun error

SELECT credit_cards.id, CASE
        WHEN (
            SELECT COUNT(*)
            FROM transacciones 
            WHERE transacciones.card_id = credit_cards.id AND transacciones.declined = 1 
            ORDER BY transacciones.time_stamps DESC
            LIMIT 3
        ) = 1
        THEN 'deactivated'
        ELSE 'active'
    END as deactivated_status
FROM credit_cards; 

#NIVEL 3

-- Ya hemos creado la tabla intermedia en pasos anteriores para crear nuesta base de datos - Realizamos la consulta.

SELECT products.id, product_name, count(producto_id) as total_ventas
From transacciones_productos
Join products on transacciones_productos.producto_id = products.id
Group by producto_id
ORDER BY total_ventas DESC;