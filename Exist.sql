--1. Write a query that displays all the names of the products in the products table that were ordered at least once (Sales.SalesOrderDetail).
--Solve this twice: once by using In, and a second time by using Exists.
select sod.ProductID, pp.Name, sum(sod.OrderQty) as TotalQTY
from Production.Product pp join Sales.SalesOrderDetail sod on sod.ProductID=pp.ProductID
where sod.OrderQty>=1
group by sod.ProductID, pp.Name
---order by sod.ProductID

--WITH IN
select ProductID, Name
from Production.Product
where ProductID in (select ProductID
					from Sales.SalesOrderDetail
					where OrderQty>=1)

--WITH EXIST
select ProductID, Name
from Production.Product pp
where exists (select *
			from Sales.SalesOrderDetail sod
			where pp.ProductID=sod.ProductID and sod.OrderQty>=1)

--2. Write a query that displays the Name of the product from the Production.Product table that has the word "Wheels" in its 
--sub-category name in the Production.ProductSubcategory table. Solve this using Exists
select Name
from Production.Product pp
where exists (select Name
				from Production.ProductSubcategory sub
				where pp.ProductSubcategoryID=sub.ProductCategoryID and Name like '%wheels%')

--3.Write a query that displays the data of all the people from the Person.Person table who ordered a product in 2013.
--Instruction: Consider which tables must be used in the query. (Hint: 3 tables.) Note that each row with person details should appear only once – no more. 
--Solve this using Exists.
--1st Select tables that is Person.person pp -- data of people, SSOrderHeader -- date
--2nd Join lo que da dentro del subquery que son los que sabemos que son igual CXID=CXID
--3nd junta

--CX que ordenaron en 2013
select CustomerID, OrderDate
from Sales.SalesOrderHeader
where year(OrderDate)=2013

select *
from person.Person pp join sales.Customer sc on pp.BusinessEntityID=sc.PersonID
where exists (select CustomerID
				from Sales.SalesOrderHeader soh
				where PP.BusinessEntityID=soh.CustomerID and year(OrderDate)=2013) 
--CORRECT ONE
select *
from person.Person pp 
where exists (select *
				from Sales.SalesOrderHeader soh join sales.Customer sc on sc.CustomerID=soh.CustomerID
				where pp.BusinessEntityID=sc.PersonID and year(OrderDate)=2013) 

--4.What does the following query return?
select pe.BusinessEntityID, pe.LastName, pe.FirstName
from Person.Person pe join Sales.Customer sc on pe.BusinessEntityID = sc.PersonID
where exists( select *
				from Sales.SalesOrderHeader sh join Sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
												join Production.Product pr on sd.ProductID = pr.ProductID
				where pr.ProductSubcategoryID in (1, 2, 3) and pr.StandardCost > 600 and sh.CustomerID = sc.CustomerID)
--Tabla que muestra BEID, LastandFistName pero, solo que su SubCategory sea 1,2,3 y su SCost sea mayor a 600

--5.Write a query that displays all the columns from the Sales.SalesPerson table but displays only the salespeople who have sold at least one product with the word
--"frame" in its model name. Instruction:
		--a. Which tables are required for this query? (Hint: 4 tables.)
		--b. Consider which tables link the Sales.SalesPerson table to the
		--Production.ProductModel table, with the knowledge that each item from the
		--Production.Product table has its own ProductModelID.
		--c. Write the outer query, i.e., what is returned as the result of the query.
		--d. Add Exists to the filter, and write the sub-query with the connections between the tables (Join).
		--e. Connect the sub-query to the query that contains it.

select *
from Sales.SalesPerson sp
where exists (select *
				from Sales.SalesOrderHeader soh join Sales.SalesOrderDetail sod on  soh.SalesOrderID=sod.SalesOrderID
												join Production.Product pp on sod.ProductID=pp.ProductID
												join Production.ProductModel pm on pp.ProductModelID=pm.ProductModelID
				where pm.Name like '%Frame%' and sp.BusinessEntityID=soh.SalesPersonID)

--6.Write a query that displays the first name, last name, JobTitle and the number of employees in that department from the HumanResources.Employee table.
--Use the HumanResources.Employee and Person.Person tables. Note: This may be solved in several ways. One way includes a link between the internal and outer query, 
--without using Exists. Another solution uses Unrelated Nested Queries.