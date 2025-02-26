#- Ejercicio 1.2 Usando JOIN, realiza las siguientes queries

#LISTA DE PAISES QUE REALIZAN COMPRAS .
Select distinct country 
From company
Inner join transaction on company.id=transaction.company_id

#DESDE CUANTOS PAISES SE ESTAN REALIZANDO LAS COMPRAS?
Select count(distinct country) as Paises
From company
Inner join transaction on company.id=transaction.company_id 

# IDENTIFICA LA COMPAÑIA CON LA MAYOR MEDIA DE VENTAS 
Select company_id, company_name, AVG(amount) AS Total_ventas
From Transaction
inner join company on company.id=transaction.company_id
where declined = 0
Group by company_id
Order by total_ventas Desc
Limit 1

#Ejercicio 1.3 - Utilizando sólo subconsultas (sin utilizar JOIN):

#Muestra todas las transacciones realizadas por empresas de Alemania.
Select id, amount, company_id
From transactions.transaction
where company_id In (
	Select id
    From company
    Where country ="Germany")
    
#Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT DISTINCT company_name
FROM company 
Where id IN (
	Select company_id
	From Transaction
	WHERE amount >(Select AVG(Amount) From Transaction))
    ORDER BY Company_name;

#Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas
SELECT distinct company_name
FROM company
Where not exists ( 
SELECT 1
From transaction
Where company_id =company.id)
	
# NIVEL 2

# Ejercicio 2.1 Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. Muestra la fecha de cada transacción junto con el total de las ventas.
Select date(timestamp) as Fecha, 
sum(amount) as Total_diario
From Transaction
WHERE Declined =0
Group by date(timestamp)
Order by Total_diario Desc
Limit 5

#Ejercicio 2.2 - Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor media.

Select country as Pais, AVG(amount) AS Media_pais
From Transaction
inner join company on company.id=transaction.company_id
WHERE Declined =0
Group by country
Order by media_pais Desc

# Ejercicio 2.3 compañía “Non Institute”. Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.

# Parte A (Usando join y subconsultas)
select transaction.id as transaccion
From transaction
join company on company.id = transaction.company_id
where company.country = ( Select country From company where company_name ='Non Institute') AND company_name != 'Non Institute';

# Parte B (Solo subconsultas)
select transaction.id as transaccion
From transaction
where company_id IN(
Select id
From company
Where country = ( Select country From company where company_name ='Non Institute') AND company_name != 'Non Institute')

#NIVEL 3

# Ejercicio 3.1 Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.

Select company_name, phone, country,  date(transaction.timestamp) as Fecha , transaction.amount As valor_transaccion
From Company
join transaction on company.id = transaction.company_id
Where transaction.amount between 100 and 200 and Date (transaction.timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13')
Order by valor_transaccion DESC

# Ejercicio 3.2 Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques si tienen más de 4 transacciones o menos.

Select company_name as compañia,
	CASE 
	WHEN COUNT(transaction.id) > 4 
	THEN 'Mas de 4' 
	ELSE '4 o menos' 
	END AS Cantidad_transacciones
From Company
join transaction on company.id = transaction.company_id
Group by company_name
ORder by Cantidad_transacciones DESC