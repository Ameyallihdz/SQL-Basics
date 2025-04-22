--1.Write a query that returns a single list of all customer numbers from the
--Sales.Customer table and sales people from the Sales.SalesPerson table.
--Check the names of the appropriate columns in the table.
select CustomerID
from Sales.Customer
union all
select BusinessEntityID
from Sales.SalesPerson

--2.Write a query that displays the ProductID for the products that meet at least one of the following requirements. 
--If the item meets more than one requirement, the product code should be displayed only once. Solve with union only:
--a. The product was ordered (Sales.SalesOrderDetail) at a unit price after discount (calculated using the existing columns) 
--greater than 1800, and the CarrierTrackingNumber starts with the letters 4E.
--b. The order record is for a quantity of product greater than 10 units and the tracking number ends with the number 4.
select  ProductID, UnitPrice, CarrierTrackingNumber, OrderQty
from Sales.SalesOrderDetail
where (UnitPrice * (1 - UnitPriceDiscount))>1800 and CarrierTrackingNumber like '4E%'
union
select ProductID, UnitPrice, CarrierTrackingNumber, OrderQty
from Sales.SalesOrderDetail
where  OrderQty>10 and CarrierTrackingNumber like'%4'

--3.In the following query, we want to compare the quantity of products of each color in the product table to the quantity of items 
--of each color ordered, in order to understand which colors are ordered most by customers.
--a. The query will return 3 columns: Color, number of items (a calculated column named NoOfItems), and the data source (calculated column named SourceOfData).
--b. The query will return a single row for each color from the product table. The row will contain the color, the number of products 
--of that color and the constant text 'P', to show that the data came from the product table.
--c. In addition, the query will return one row for each color from the Sales.SalesOrderDetail table. The row will contain the color, 
--the number of products of that color ordered and the constant text 'O', to show that the data came from the orders table.
--d. Sort the results according to color code.
--NOTES
--1st Put the outputs you want Color, NoofItems and Source of data que puede ser P o Q (tablas diferentes)
--2nd Descubrir que es NoofItems que es el conteo de colores agrupando por colores - tabla con P
--3rd Pasa a otra union con SSODetail table con Color y el conteo de ordenes por color pero no tenemos Color, 
--sooo, lo obtendremos de ProductID de tabla PProduct y lo join con tabla SSODetal (Sacamos de PProduct el Color)
--4th Agrupar por color para sacar conteo de QTYperColor y UNIR
select Color, count(*) as NoOfItems, 'P' as SourceofData
from Production.Product
group by Color --First table DONE
union
select  pp.Color, sum(sod.OrderQty) as QTYperColor, 'Q'
--sod.ProductID, sod.OrderQty, pp.Color Para sacar color de PProduct
from Sales.SalesOrderDetail sod left join Production.Product pp on sod.ProductID=pp.ProductID 
group by pp.Color
order by Color
