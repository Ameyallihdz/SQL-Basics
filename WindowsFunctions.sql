--1.Display the last names and first names of all the people who have the last name Adams and a first name that starts with the letter J. 
--Sort the data by last name + first name. Base your answer on the person.person table.
select LastName, FirstName
from person.Person
where LastName='Adams' and FirstName like'J%'
order by LastName, FirstName

--2.Continuing from the previous question, add a column called NameRank in which you rank the results so that for each last name 
--there is an internal ranking according to the alphabetical order of the first names.
select LastName, FirstName,
	rank () over (partition by LastName order by FirstName) as NameRank
from person.Person
where LastName='Adams' and FirstName like'J%'
--order by LastName, FirstName

--3.Continuing on, copy the query and add another column called NameDenseRank in which you rank the results with the DENSE_RANK function, 
--so that for each last name, there is an internal ranking according to the alphabetical order of the first name.
--Examine the differences in the results between RANK and DENSE_RANK.
select LastName, FirstName,
		--rank () over(partition by LastName order by FirstName) as Ranking
		dense_rank () over(partition by LastName order by FirstName) as NameDenseRank
from Person.Person
where LastName='Adams' and FirstName like'J%'

--4.Display the orders generated on the dates 01/01/2013 - 02/01/2013, based on the Order heading table. 
--Rate each day's orders from the order with the highest SubTotal amount (rating 1) to the lowest. 
--If there are orders with identical amounts, they receive the same rating, and then the rating continues from the next number.
select SalesOrderID, OrderDate, Subtotal,
		dense_rank () over (partition by day(Orderdate) order by Subtotal) as RankingPerDay
from Sales.SalesOrderHeader
where OrderDate between '2013-01-01' and '2013-01-02'

--5.Write a query that displays a line for each month of the year (i.e., a line for each of the months: 
--January 2011, February 2011 ... January 2012, February 2012...), and rank the months of each year separately according to 
--the total sales (SubTotal) in that month. (2011 has its own ranking, and the ranking starts again for 2012.) Sort the query results by year, and ranking.

--Agrupamos columnas por year y month - Sumando su Subtotal
select year(OrderDate) as Year, month(OrderDate) as Month, sum(SubTotal) as MTotalAmount
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)
order by year(OrderDate)

--Agregamos el ranking
select year(OrderDate) as Year, month(OrderDate) as Month, sum(SubTotal) as MTotalAmount,
		rank() over(partition by year(OrderDate) order by sum(SubTotal)) as RankingPerMo
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)
order by year(OrderDate), RankingPerMo

--Continuing from the previous question, copy the query code, replace the ranking function with the percent_rank() function and run the query.
--(This function does not turn pink, which is fine.) Replace the sorting within the ranking to ascending. What is the significance of the ranking?
select year(OrderDate) as Year, month(OrderDate) as Month, sum(SubTotal) as MTotalAmount,
		percent_rank() over(partition by year(OrderDate) order by sum(SubTotal)) as RankingPerMo
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)
order by year(OrderDate), RankingPerMo