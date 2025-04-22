--LESSON 8 #1
--Write a query based on the data in the Orders table that ranks the years according to the profits from all the orders during each year. Instructions:
--a. Decide which tables are involved in solving the query. Use the ERD for assistance. Hint: 3 tables.
--b. How is profit calculated? 
		-- ANSWER: LineTotal-(StandardCost*OrderQty)----------------------------------------------------------------------------------------------------------------------> HERE
--c. Is the profit calculated per item, or for all the items in the order record? (Pay attention to the OrderQty column.) 
		--ANSWER: The 'FINAL ONE' calculates the anual profit of all the items sold --------------------------------------------------------------------------------------> HERE
--Profit por producto
select ProductID, Name, StandardCost, ListPrice, Profit=ListPrice-StandardCost 
from Production.Product
--Orden por year
select SalesOrderID, year(OrderDate) as OrderYear
from Sales.SalesOrderHeader
--Profit de todas las ordenes de SOH
select  year(soh.OrderDate) as OrderYear, sum(pp.ListPrice-pp.StandardCost) as ProfitperYear,
			 rank() over(order by sum(pp.ListPrice-pp.StandardCost)) as Ranking --solo se usa order by because ya agrupamos por year al inicio
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
group by year(soh.OrderDate)

--FINAL ONE--------------------------------------------------------------------------------------------------------------------------------------------------------------> HERE
select  year(soh.OrderDate) as OrderYear, sum(sod.LineTotal-(pp.StandardCost*sod.OrderQty)) as ProfitperYear,COUNT(*) AS OrderCount,
			 rank() over(order by  sum(sod.LineTotal-(pp.StandardCost*sod.OrderQty))) as Ranking
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
								join Production.Product pp on sod.ProductID=pp.ProductID
group by year(soh.OrderDate)





--LESSON 8 #2
--Continuing from the previous question: Are the ranking and comparison done annually analytically correct? (To answer this question, 
--examine the order dates and data.) 
--A.K.A. Does the rank changes based on previous years if new data is added? Is ranking totalprofit is a good way to look at the data?
		--ANSWER: Yes, it is made annually analytical correct because is considering for the Profit the LinePrice (Amount sold including all the ProductQTY) 
		--even though some products could have had discounts in some years. --------------------------------------------------------------------------------------------> HERE

--We are doing a ranking over the sales year so, first, we need to review that there are not NULLS in orderdate 
		--ANSWER: No NULLS values 
SELECT COUNT(*) AS MissingOrderDates
FROM Sales.SalesOrderHeader
WHERE OrderDate IS NULL
--Now, review the years
		--Answer: 2011, 2012,2013,2014
SELECT DISTINCT YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
ORDER BY OrderYear
--Now, review the orders per year
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear
--Review the orders per year but adding the SalesOrderDetail
	--Gives different results, so, something is wrong because, we are just adding the info from SODetail, giving importance to SOHeader.
	--Is different because we the counting the Orderdetails so, there are more than 1 order per product
select year(soh.OrderDate) as OrderYear, count(*) as Ordercount
from Sales.SalesOrderHeader soh left join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
group by year(OrderDate)
order by OrderYear
--Now we have to review that ListPrice, StandardCost and OrderQTY are valid
	--No invalid data
SELECT COUNT(*) AS InvalidProfitData
FROM Production.Product pp join Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
WHERE pp.ListPrice IS NULL OR pp.StandardCost IS NULL OR sod.OrderQty IS NULL





--LESSON 9 #1
--As an analyst working for AdventureWorks, you are required to check the order data for regular customers only, during 2013. 
--The company defines a regular customer as a customer who already made a purchase from the store in previous years (i.e., bought in 2012 or 2011). 
--For each order in 2013, display the order number, the SubTotal and the difference between the SubTotal of that order and 
--the average for all the orders in 2013, based on the Sales.SalesOrderHeader table,. Note: Display the data for regular customers only.
select SalesOrderID, SubTotal, Diff=SubTotal-(select avg(SubTotal)
												from Sales.SalesOrderHeader
												where year(OrderDate)=2013)
from Sales.SalesOrderHeader
where year(OrderDate)=2013 and CustomerID in (select CustomerID
											from Sales.SalesOrderHeader
											where year(OrderDate) between 2011 and 2012)




									
--LESSON 9 #2
--Now calculate the same data for all the years and all the customers, similarly to the previous question. 
--For each order in the Sales.SalesOrderHeader table, display the order number, the SubTotal and the difference between the SubTotal of that order 
--and the average for all the orders.
select SalesOrderID, SubTotal, Diff=SubTotal-(select avg(SubTotal)
												from Sales.SalesOrderHeader)
from Sales.SalesOrderHeader
order by SalesOrderID





--LESSON 9 #3
--Continuing on from the previous question and based on the query you wrote, display the number of orders that are equal to and above the average, 
--and the number of orders below the average. Hint: You will need to use the tools from previous lessons Instruction: Before you begin writing the query, 
--think how you would solve it manually (i.e., if you got an order table with 10 rows). What calculations would you perform? How would you approach
--the solution? Once you have found a way to solve this manually, you can convert it into an SQL query.

--Separado por Above/Low
select SalesOrderID, SubTotal, case
								when SubTotal>(select avg(SubTotal)
												from Sales.SalesOrderHeader) then 'Above Average'
								else 'Lower Average'
								end as Description
from Sales.SalesOrderHeader

--FINAL ONE
select fd.Description, count(*) as CountNo
from Sales.SalesOrderHeader soh join (select SalesOrderID, SubTotal, case
																		when SubTotal>(select avg(SubTotal)
																						from Sales.SalesOrderHeader) then 'Above Average'
																		else 'Lower Average'
																		end as Description
										from Sales.SalesOrderHeader) as fd on soh.SalesOrderID=fd.SalesOrderID
group by fd.Description
order by fd.Description
								