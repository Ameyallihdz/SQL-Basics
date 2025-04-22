--1. Write a query that links the Sales.SalesOrderHeader table to the
--Sales.SalesOrderDetail table and displays all the columns from both tables
select *
from Sales.SalesOrderHeader H full outer join Sales.SalesOrderDetail D on H.SalesOrderID = D.SalesOrderID

--2. Write a query that links the Sales.SalesOrderDetail table to the Production.Product table and 
--displays the following columns: SalesOrderID, ProductID, Name, ProductNumber, and LineTotal.
--Think which table should be used to display the ProductID column.
select D.SalesOrderID, P.ProductID, P.Name, P.ProductNumber, D.LineTotal
from Sales.SalesOrderDetail D join Production.Product P on D.ProductID = P.ProductID

--3. In this query we will examine the profitability of each order record:
--Write a query that links the Sales.SalesOrderDetail table to the Production.Product table and 
--displays the following columns: SalesOrderID, ProductID, LineTotal, StandardCost, OrderQty, and the profit per order record (calculated column).
select D.SalesOrderID, D.ProductID, D.LineTotal,P.StandardCost, D.OrderQty,ProfitPerOrder= D.LineTotal-(P.StandardCost*D.OrderQTY)
from Sales.SalesOrderDetail D inner join Production.Product P on D.ProductID = P.ProductID

--4.Write a query that links the Sales.SalesOrderHeader table to the Sales.SalesOrderDetail table and 
--displays the following columns: SalesOrderID, OrderDate, ProductID, and LineTotal. Display only the details of the orders from 2012.
select d.SalesOrderID, s.OrderDate, d.ProductID, d.LineTotal
from Sales.SalesOrderDetail d left join Sales.SalesOrderHeader s on s.SalesOrderID = d.SalesOrderID --Me interesa conservar OrderDetail
where year(s.OrderDate)=2012

--Write a query that links the Sales.SalesOrderDetail table to the Production.Product table.
--a. Display the following columns: SalesOrderID, ProductID, and Name. Display only the details of the products for which the color is "Null".
--b. Must the Color field be selected in the Select section In order to filter the data according to color? Not neccesary
--c. If the columns are not displayed, how can the correctness of the results be verified? Show the color column
select sod.SalesOrderID, sod.ProductID, pp.Name
--pp.Color
from Sales.SalesOrderDetail sod inner join Production.Product pp on sod.ProductID=pp.ProductID
where Color is NULL

--6.Write a query that links between the Sales.SalesOrderDetail table, the Production.Product table and the Sales.SalesOrderHeader table 
--and displays the following columns: SalesOrderID, OrderDate, ProductID, Color and LineTotal.
select sod.SalesOrderID, soh.OrderDate,sod.ProductID, pp.Color, sod.LineTotal
from Sales.SalesOrderDetail sod join Production.Product pp on sod.ProductID=pp.ProductID
								join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID

--7.Write a query that displays the quantity of products ordered each year. Instructions: Write a query that 
--links the Sales.SalesOrderDetail table to the Sales.SalesOrderHeader table and groups the data according to year (in a column
--calculated from the OrderDate field). The query will display the following columns: Year and OrderQty.
select year(soh.OrderDate) as OrderYear, sum(sod.OrderQty) as OrderPerYear
from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
group by year(soh.OrderDate)

--8. Write a query that displays the ProductID and LineTotal only for orders from 2011
--in which the total paid (LineTotal) is greater than 1,000. (Calculate the date from the OrderDate column.)
select sod.ProductID, sod.LineTotal, soh.OrderDate, year(soh.OrderDate) as OrderYear --2nd Colocar los años 
from Sales.SalesOrderDetail sod left join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID --1st Unir tablas y mostrar todos los valores en select
--es left join porque me dicen displat the productID y LineTotal, ambas en SOD table
where year(OrderDate)=2011 and LineTotal>1000 --3rd Filtrar por año y line total
order by LineTotal

--9.Write a query that displays the customer details of each order in the Sales.SalesOrderHeader table, The following columns should be displayed:
--SalesOrderID, Order Date, CustomerID, First Name, Last Name, and SubTotal. Sort the data by last name and then by first name.
--Instruction: Check in ERD which are the relevant tables and what are the relationships between the tables.

--Empezar de afuera para dentro
select soh.SalesOrderID, soh.OrderDate, pp.FirstName, pp.LastName, soh.SubTotal, soh.CustomerID --es SOH porque es el 1ro que usamos
from Sales.SalesOrderHeader soh LEFT join Sales.Customer sc on  soh.CustomerID=sc.CustomerID --De aqui sale PersonID que es el BEntityID de PPerson
								--El result es toda una tabla que uniremos con PPerson
								join Person.Person pp on pp.BusinessEntityID=sc.PersonID
order by LastName, FirstName

--12.In order to send marketing mailings to customers, write a query that displays the following data for each BusinessEntityID 
--from the Person.BusinessEntityAddress table, by linking to the Person.Address table: BusinessEntityID, AddressLine1, AddressLine2, City, StateProvinceID.
select bea.BusinessEntityID, pa.AddressLine1, pa.AddressLine2, pa.City, pa.StateProvinceID, bea.AddressID
from Person.BusinessEntityAddress bea join Person.Address pa on bea.AddressID=pa.AddressID

--13.Continuing from the previous question, can the First and Last Names be added, as well? 
--If so, link the table and add the relevant columns to the query results.
select bea.BusinessEntityID, pa.AddressLine1, pa.AddressLine2, pa.City, pa.StateProvinceID, bea.AddressID, pp.FirstName, pp.LastName
from Person.BusinessEntityAddress bea join Person.Address pa on bea.AddressID=pa.AddressID
									  join Person.Person pp on pp.BusinessEntityID=bea.BusinessEntityID

--14.Write a query that displays the customer code and the highest order amount (SubTotal) in 2012 and 2013 for each customer from the Sales.SalesOrderHeader
--table, Display only the orders with values in both the salesman column and the PurchaseOrderNumber column. Check the names of the appropriate columns in the table.
select CustomerID, max(SubTotal) as MaxSale --2nd calculamos el max de compra por cx
--year(OrderDate) as OrderYear --1st ponemos la tabla, filtrando solo 2012-2013
from Sales.SalesOrderHeader
where year(OrderDate) between 2012 and 2013 and SalesPersonID is not NULL and PurchaseOrderNumber is not NULL --Agregar filtos extras
group by CustomerID
