--1. Write a query that displays the ProductID, the ListPrice, and the average list price of all the items in the product table.
select ProductID, ListPrice, 
		(select avg(ListPrice) from Production.Product) as AvgListPrice 
from Production.Product

--2.Continuing from the previous question, name the column with the average list price "AverageListPrice".
--In addition, make sure that the average price list price is calculated only with the items with a list price greater than 0, so as not to skew the result.
select ProductID, ListPrice, 
		(select avg(ListPrice) 
		 from Production.Product
		 where ListPrice>0) as AvgListPrice 
from Production.Product

--3.Write a query that displays the ProductID and the Item Color from the Production.Product table for the items with 
--the color identical to that of item number 741
select ProductID, Color
from Production.Product
where Color=
	(select Color 
	from Production.Product
	where ProductID=741) --El subquery me va a dar el resultado SILVER 1st

--4.Write a query that displays the BusinessEntityID and Gender of all the employees in the employee table whose gender is the same 
--as the gender of the employee with code 38.
select BusinessEntityID, Gender
from HumanResources.Employee
where Gender=(select Gender 
				from HumanResources.Employee
				where BusinessEntityID=38)

--5.Continuing from the previous question, add the first and last names of the employees from the Persons table.
--Use the diagram or ERD to check which column links the tables.
select hr.BusinessEntityID, Gender, FirstName, LastName
from HumanResources.Employee hr left join Person.Person pp on hr.BusinessEntityID=pp.BusinessEntityID
where Gender=(select Gender 
				from HumanResources.Employee
				where BusinessEntityID=38)

--6.Write a query that displays the orders from the Sales.SalesOrderHeader table that have a SubTotal lower than the average of the SubTotals 
--of all the orders. Display only the order number.
select SalesOrderID
from Sales.SalesOrderHeader
where SubTotal<(select avg(SubTotal) as AvgSubtotal
				from Sales.SalesOrderHeader)

--7.Continuing from the previous question, display how many orders meet the condition.
select count(SalesOrderID) as OrdersUnderAvg
from Sales.SalesOrderHeader
where SubTotal<(select avg(SubTotal) as AvgSubtotal
				from Sales.SalesOrderHeader)

--8.Write a query that displays, the product code, price per item after discount (calculated column), 
--and the difference between the LineTotal of each order record 
-- and the average of the LineTotals (a calculated column, named DiffFromAVG) for all the records in the order details table.
select ProductID, 
		UnitPriceAfterDiscount=LineTotal/OrderQty, 
		DiffFromAVG=LineTotal-(select avg(LineTotal)
								from Sales.SalesOrderDetail)
from Sales.SalesOrderDetail

--9.Continuing from the previous question, write a query that displays the product codes
--and names of all the products in the products table that were ordered at least once in 2013
--WRONG
select pp.ProductID, pp.Name, sod.OrderQty
from Production.Product pp left join Sales.SalesOrderDetail sod on pp.ProductID=sod.ProductID
							join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
where year(soh.OrderDate)=2013 and sod.OrderQty<=1

--OptionB RIGHT ONE!
select ProductID, Name
from Production.Product
where ProductID in (select sod.ProductID
					from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
					where year(soh.OrderDate)=2013)

--10.Continuing from the previous question, write a query that displays the product codes and names of all the products 
--in the product table where the total quantity ordered in 2013 was at least 300 units.
select ProductID, Name
from Production.Product
where ProductID in (select sod.ProductID -- No agregar aqui sum(sod.OrderQTY) as TotalQTY porque IN solo acepta 1 value
					from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
					where year(soh.OrderDate)=2013
					group by sod.ProductID
					having sum(sod.OrderQty)>=300)

--11.In this query, you must check the quantity and value of orders in 2013, of the ten products with the highest quantity of orders in 2012.
--In other words, check how the ten products that were ordered the most in 2012 functioned in 2013. (Were they ordered many times?
--Not ordered at all? Are they still profitable?)
--Instructions: Write a query that shows the order number, product code, product name, quantity of items in the order, and LineTotal per order record of the
--products ordered in 2013. The query results should show the data for only the ten best-selling products in 2012.
--Think which tables and columns are involved in the query. Use the ERD for assistance.

--Productos 2013
select soh.SalesOrderID, sod.ProductID, pp.Name, sod.OrderQty, sod.LineTotal
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where year(soh.OrderDate)=2013 

--Productos de 2012 top10 vendidos
select top 10 sod.SalesOrderID, sum(sod.OrderQty) as TotalQTY
from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
where year(OrderDate)=2012
group by sod.SalesOrderID
order by sum(sod.OrderQty) desc

--FINAL ONE
select soh.SalesOrderID, sod.ProductID, pp.Name, sod.OrderQty, sod.LineTotal
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where year(soh.OrderDate)=2013 and sod.ProductID in (select top 10 sod.ProductID
													from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
													where year(soh.OrderDate)=2012
													group by sod.ProductID
													order by sum(sod.OrderQty) desc)
												--In the IN clause subquery, you're selecting SUM(sod.OrderQty), which is a value 
												--but you need to compare against sod.ProductID to filter by product
												-- IN expects a list of IDs, not aggregate values


--12.Continuing from the previous question, write a query that displays the following data for each of the ten most ordered products in 2012: 
--product code, product name, total quantity of items ordered in 2013 and total order amount in 2013.
--Think which tables and columns are involved in the query. Use the ERD for assistance.

--Productos top10 vendidos en 2012
select top 10 pp.ProductID, pp.Name, sum(sod.OrderQty) as TotalQTY
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where year(soh.OrderDate)=2012
group by pp.ProductID, pp.Name --Any NONAgregatted column, se debe agregar aqui

--Productos 2013
select sod. ProductID, sum(sod.OrderQty) as TotalQTY, sum(soh.Subtotal) as OrderAmount
from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
where year(soh.OrderDate)=2013
group by sod.ProductID

--Productos top10 vendidos en 2012
--Shows the top 10 products by order quantity in 2012, but the subqueries for 2013 are returning total sales across all products instead of per product
select top 10 pp.ProductID, pp.Name, sum(sod.OrderQty) as TotalQTY2012,
			(select sum(sod.OrderQty)
			from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
			where year(soh.OrderDate)=2013)as TotalQTY2013,
			--group by sod.ProductID) as TotalQTY2013
			(select sum(soh.SubTotal)
			from Sales.SalesOrderDetail sod join Sales.SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID
			where year(soh.OrderDate)=2013)as TotalAmount2013
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where year(soh.OrderDate)=2012 
group by pp.ProductID, pp.Name --Any NONAgregatted column, se debe agregar aqui

--FINAL ONE: All info from 2013
select pp.ProductID, pp.Name, sum(sod.OrderQty) as TotalQTY, sum(soh.Subtotal) as OrderAmount
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where year(soh.OrderDate)=2013
group by pp.ProductID, pp.Name --Any NONAgregatted column, se debe agregar aqui

--FINAL ONE + Adding 2012
select pp.ProductID, pp.Name, sum(sod.OrderQty) as TotalQTY2013, sum(sod.LineTotal) as OrderAmount2013
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where year(soh.OrderDate)=2013 and pp.ProductID in (select top 10 sod.ProductID
													from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
													where year(soh.OrderDate)=2012
													group by sod.ProductID
													order by sum(sod.OrderQty) desc)
group by pp.ProductID, pp.Name --Any NONAgregatted column, se debe agregar aqui

--13.Continuing from the previous question, write a query showing the total quantity of items ordered and total order amount
--for 2012 and 2013 of the ten most ordered products in 2012. what can be deduced from the results of the query?

--LAST ONE
select pp.ProductID, pp.Name, 
		sum(case
			when year(soh.Orderdate)=2012 then sod.OrderQty --Cuando la OD sea 2012, dame las OrderQTY para sumarlas
			end) as TotalOrders2012,
		sum(case
			when year(soh.OrderDate)=2013 then sod.OrderQty
			end) as TotalOrders2013,
		sum(case
			when year(soh.Orderdate)=2012 then sod.LineTotal
			end) as TotalAmount2012,
		sum(case
			when year(soh.Orderdate)=2013 then sod.LineTotal
			end) as TotalAmount2013
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
where pp.ProductID in (select top 10 sod.ProductID
						from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
						where year(soh.OrderDate)=2012
						group by sod.ProductID
						order by sum(sod.OrderQty) desc)
group by pp.ProductID, pp.Name --Any NONAgregatted column, se debe agregar aqui
order by pp.ProductID

--14.An order for a single item is an order that has only one order line. Write a query that displays the SalesOrderID and ProductID of single item orders.
--Decide which table you should use.
--Contar single orders
select SalesOrderID, count(*) as OrdersCount
from Sales.SalesOrderDetail
group by SalesOrderID
having count(*)=1

select SalesOrderID, ProductID
from Sales.SalesOrderDetail 
where SalesOrderID in (select SalesOrderID
							from Sales.SalesOrderDetail
							group by SalesOrderID
							having count(*)=1)

--15.Write a query that displays all the products from the products table that were never ordered.
select *
from Production.Product
where ProductID not in (select ProductID
						from Sales.SalesOrderDetail
						where OrderQty>=1)
order by ProductID

--PART2
--1. Write a query based on the data from the order details table that displays the product code, total quantity ordered,
--and total amount to be paid (LineTotal) for each product code.
select ProductID, sum(OrderQty) as TotalQTY, sum(LineTotal) as TotalAmount
from Sales.SalesOrderDetail
group by ProductID

--2. Continuing from the previous question, write a query based on the order details and products tables, that displays the following data for each product code:
--product code, Name, ProductNumber, color, total quantity ordered, LineTotal.
--Instructions: Write a query that returns the product details from the product table. Also, use the query you wrote in the previous question as a sub-query that returns
--a table, and link between the two tables using JOIN. Remember, when using a sub-query as a table, the sub-query must be named.
select pp.ProductID, pp.Name, pp.ProductNumber, pp.Color, t1.TotalQty, t1.TotalAmount
from Production.Product pp join (select ProductID, sum(OrderQty) as TotalQTY, sum(LineTotal) as TotalAmount
								from Sales.SalesOrderDetail
								group by ProductID
								) as t1 on t1.ProductID=pp.ProductID
--group by sod.ProductID

--3.In this question you must examine the numerical data and their relationship with the order header and order details tables.
--Question: Does the SubTotal column in the order header table contain the sum of all the rows in the LineTotal column of the Order Details table for that same order?
--Instructions: Write a query, based on the Order header and Order details tables, that displays the following columns: Order Number, SubTotal from the Order
--header table, total of the LineTotals from the Order Details table.
select soh.SalesOrderNumber, soh.SubTotal, sod.TotalAmount
from sales.SalesOrderHeader soh left join (select SalesOrderID, sum(LineTotal) as TotalAmount
										from Sales.SalesOrderDetail
										group by SalesOrderID
										) as sod on soh.SalesOrderID=sod.SalesOrderID

--4.Continuing from the previous question, it is difficult to tell from the results whether there are lines with differences between the sums. 
--So we will refine the query: In the query, add a column called Diff, which shows the difference between the total payment from the Order details table 
--and the total payment from the Order header table.
select soh.SalesOrderNumber, soh.SubTotal, sod.TotalAmount, Diff=sod.TotalAmount-soh.SubTotal
from sales.SalesOrderHeader soh left join (select SalesOrderID, sum(LineTotal) as TotalAmount
										from Sales.SalesOrderDetail
										group by SalesOrderID
										) as sod on soh.SalesOrderID=sod.SalesOrderID

--5.Continuing from the previous question, examine the results of the previous query. Note that there are many order lines that do not have any differences, 
--which is great. Add an instruction to the query to display only the lines with a difference (Diff).
select soh.SalesOrderNumber, soh.SubTotal, sod.TotalAmount, Diff=sod.TotalAmount-soh.SubTotal
from sales.SalesOrderHeader soh left join (select SalesOrderID, sum(LineTotal) as TotalAmount
										from Sales.SalesOrderDetail
										group by SalesOrderID
										) as sod on soh.SalesOrderID=sod.SalesOrderID
where sod.TotalAmount-soh.SubTotal!=0

--6.Continuing from the previous question, examine the results. What is the range of differences? That is, what is the lowest difference and what is the highest
--difference? To answer this question, simply sort the results of the previous query according to the value in the Diff column.
select soh.SalesOrderNumber, soh.SubTotal, sod.TotalAmount, Diff=sod.TotalAmount-soh.SubTotal
from sales.SalesOrderHeader soh left join (select SalesOrderID, sum(LineTotal) as TotalAmount
										from Sales.SalesOrderDetail
										group by SalesOrderID
										) as sod on soh.SalesOrderID=sod.SalesOrderID
where sod.TotalAmount-soh.SubTotal!=0
order by Diff
--Lowest value = 0.000049 and Highest value = -0.000050

--8.Write a query that shows the ProductID, Name, ListPrice, ProductSubcategoryID and the difference between the list price and the average list price of all the
--products in the same sub-category for each product in the Production.Product table.
--Sort it by subcategory, in ascending order. Include in the calculation of the average list price only products with a ListPrice
--and with ProductSubcategoryID that is not NULL

--Tabla1
select ProductID, Name, ListPrice, ProductSubcategoryID
from Production.Product
--Ordenar por subcategory = son 38 subcategories
select ProductSubcategoryID, count(*) as QTYSubcategories
from Production.Product
group by ProductSubcategoryID
--Average subcategory
select ProductSubcategoryID, avg(ListPrice) as AvgListPrice
from Production.Product 
group by ProductSubcategoryID

--Tabla2
select pp.ProductID, pp.Name,pp.ListPrice, pp.ProductSubcategoryID, Diff=pp.ListPrice-apl.AvgListPrice
from Production.Product pp join (select ProductSubcategoryID, avg(ListPrice) as AvgListPrice
								from Production.Product
								where ListPrice!=0 and ProductSubcategoryID is not Null
								group by ProductSubcategoryID) as apl on pp.ProductSubcategoryID=apl.ProductSubcategoryID
order by pp.ProductSubcategoryID


