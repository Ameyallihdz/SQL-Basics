--LESSON 2 #1
--Write a query that displays the Order number (SalesOrderID), Order date, Customer Number (CustomerID) and Order amount (SubTotal) 
--from the Sales.SalesOrderHeader table, for the orders above $1500 and an Order date from Jan. 1,2013 onwards.
select SalesOrderID, OrderDate, CustomerID, SubTotal
from Sales.SalesOrderHeader 
where SubTotal>1500 and OrderDate>='2013-01-01'

--LESSON 2 #2
--Write a query that displays all the data from the Person.Person table, 
--only for people whose BusinessEntityID is above 10,000 and their first name is either Jack or Crystal.
select *
from Person.Person
where BusinessEntityID>10000 and FirstName='Jack' or FirstName='Crystal'

--Lesson2 #3
--Write a query that displays the SalesOrderID, ProductID, and total amount for that order line (LineTotal)
--only for items with a Line Total between 100 and 1.000, inclusive.
select SalesOrderID, ProductID, LineTotal
from Sales.SalesOrderDetail
where LineTotal>='100' and LineTotal<='1000'
order by LineTotal

--LESSON 3 #1
--Write a query that displays the ProductID, Product Name, Color, Weight and the profit margin (ListPrice – StandardCost) 
--from the Production.Product table. Display only the products that have a value for Weight. 
--Sort the results by Color, descending, and Weight, ascending.
select ProductID, Name, Color, Weight, ProfitMargin=ListPrice-StandardCost
from Production.Product
where Weight!=0
order by color desc, Weight

--LESSON 3 #2
--The company wants to check how the prices will change if every order has a $50 delivery charge added. 
--Write a query that displays the following columns from the Sales.SalesOrderHeader table: 
--Order number (SalesOrderID), Order amount (SubTotal), and Order amount + $50 (named SubTotalPlus50). 
--Sort the query results according to Order Amount from the highest to lowest.
select SalesOrderID, SubTotal, SubTotalPlus50=SubTotal+50
from Sales.SalesOrderHeader
order by SubTotal desc

