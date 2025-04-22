--LESSON 4, #1
--Write a query that displays the ProductID and total quantity of that product sold from the Sales.SalesOrderDetail table. 
--Display only the products with an Order quantity (OrderQty) between 600 and 850 units.
select ProductID, sum(OrderQty) as QTYofSales
from Sales.SalesOrderDetail
group by ProductID
having sum(OrderQty)between 600 and 850

--LESSON 4, #2
--Write a query that displays how many people with each Title there are in the Persons table. Sort the results according the number 
--of people with the Title, in descending order.
select Title, count(*) as 'QTYperTitle'
from Person.Person
group by Title
order by QTYperTitle desc

--LESSON 5 #1
--Write a query that displays the Business Entity ID, First Name, Middle Name, Last Name, and Modified Date from the Person.Person table. 
--Display the data only for the people whose name ends with the letter "O" 
--and for whom the Modified Date is not between the dates March 1, 2008 and Dec. 1, 2008.
select	BusinessEntityID, FirstName, MiddleName, LastName, ModifiedDate
from Person.Person
where FirstName like '%O' and ModifiedDate not between '2008-03-01' and '2008-12-01'

--LESSON 5 #2
--Write a query that displays the Product number from the Sales.SalesOrderDetail table 
--for the products with a total order quantity over all the years between 600 and 850 units.
select ProductID, sum(OrderQty) as TotalQTY
from Sales.SalesOrderDetail
group by ProductID
having sum(OrderQty) between 600 and 850
order by TotalQTY

--LESSON 6 #1
--What are the 3 product colors with the highest order amounts? Instructions: Write a query that shows the total order amount 
--for each product color. Sort the results from highest to lowest,  and display only the first three rows. Think which tables 
--contain the detailed data for the orders and the products. Use the ERD page for assistance.
select top 3 pp.Color, sum(sod.OrderQty) as TotalQTYperColor
from Production.Product pp join Sales.SalesOrderDetail sod on pp.ProductID=sod.ProductID
where pp.Color is not NULL
group by pp.Color
order by TotalQTYperColor desc

--LESSON 6 #2
--Write a query that shows the 10 orders in 2013 (from the Order Header table) with the highest SubTotals, 
--where the customer's last name contains the string 'lan' and the customer's first name does not contain the letter 'r'.
select top 10 soh.CustomerID, pp.FirstName, pp.LastName, year(soh.OrderDate) as OrderYear, soh.SubTotal
from Person.Person pp full outer join Sales.Customer sc on pp.BusinessEntityID=sc.CustomerID
	                  right join Sales.SalesOrderHeader soh on sc.CustomerID=soh.CustomerID
where year(soh.OrderDate)=2013 and pp.LastName like '%lan%' and pp.FirstName not like '%r%'
order by soh.SubTotal desc

--LESSON 6 #3
--Check whether there are products in the Products table that were never sold. If so, display the products’ codes and names. 
--Instructions: Think what "never sold" means and how it is reflected in the data. Think about what type of JOIN is appropriate, and between which tables.
select distinct pp.ProductID, pp.Name
from Production.Product pp left join Purchasing.PurchaseOrderDetail pod on pp.ProductID=pod.ProductID
--Never sold are the products that are not in PurchasingOrderDetail

select distinct pp.ProductID, pp.Name
from Production.Product pp left join Sales.SalesOrderDetail sod on pp.ProductID=sod.ProductID
--Never sold are the products that are not in Sales.SalesOrderDetail

--LESSON 7
--In order to better arrange the store and provide a larger display space for items with a higher average order amount, 
--analyze the average quantity of each product ordered during May 2012. To do this, write a query that answers the following:
--a.The query will display the following columns: 
		--i. Product ID, 
		--ii. Total Order Quantity for that product, 
		--iii. The number of order rows for the product (Count the number of rows in which the product was ordered.),
		--iv. A verbal description of the average order amount, as follows: 
				--1. The average order amount < 3 → “Low quantity”
				--2. The average order amount ≤ 6 → “Reasonable quantity”
				--3. Above 6 → “High quantity”
--b. Sort the query results according to the average order amount in descending order.
--c. The order data is ProductID and OrderQty from the Sales.SalesOrderDetail table.
--d. Only the sales during May 2012 should be included. The date is calculated from the OrderDate field in the Sales.SalesOrderHeader table.
--NOTES:
	--1st Sales from May2012 = TABLE1
	--2nd QTY of sales for each product (Sum) and #of Times Ordered (Count) = TABLE2
	--3rd Add when in Table2 and order by avg(OrderQTY)

--FINAL
select sod.ProductID, sum(sod.OrderQty) as TotalQTYOrdered, count(*) as TimesOrdered, 
		avg(sod.OrderQty) as AvgOrdered,
		case
			when avg(sod.OrderQty)<3 then 'Low Quantity'
			when avg(sod.OrderQty)<=6 then 'Resonable Quantity'
			else 'High Quantity'
		end 'Description'
from Sales.SalesOrderHeader soh join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
where OrderDate between '2012-05-01' and '2012-05-31' 
group by sod.ProductID
order by avg(sod.OrderQty) desc

--Just May2012
--select *
--from Sales.SalesOrderHeader
--where OrderDate between '2012-05-01' and '2012-05-31' 

--Join
--select *
--from Sales.SalesOrderHeader soh join Sales.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID
--where OrderDate between '2012-05-01' and '2012-05-31' 

--With all the info in SSODetail, not considering date of 2012 from SSOHeader
--select ProductID, sum(OrderQty) as TotalQTYOrdered, count(*) as TimesOrdered, 
		--avg(OrderQty) as AvgOrdered,
		--case
			--when avg(OrderQty)<3 then 'Low Quantity'
			--when avg(OrderQty)<=6 then 'Resonable Quantity'
			--else 'High Quantity'
		--end 'Description'
--from Sales.SalesOrderDetail
--group by ProductID
--order by avg(OrderQty) desc

 
--select ProductID, count(*) as QTYOrdered
--from Sales.SalesOrderDetail
--group by ProductID