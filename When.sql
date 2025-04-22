--1. Write a query based on the Person.Person table, that displays the following data:
--First name, Last name, A column named TitleEdited that will contain the following data:
--If there is a value in the Title column, it will display it, and if there is no value, it will display "No Title".
select FirstName, LastName,
	case Title
		when Title then Title
		else 'No title'
	end as TitleEdited
from Person.Person

--2.Write a query based on the Production.Product table, that displays the following data: 
--ProductID, Name, A column named StyleEdited that will contain the information to whom the model is suited, 
--according to the value in the Style column and the following key: a. M →Man, b. W → Woman, c. U → Unisex, No value → Accessories
select ProductID, Name, 
		case Style
			when 'M' then 'Man'
			when 'W' then 'Woman'
			when 'U' then 'Unisex'
			else 'Accesories'
		end as StyleEdited 
from  Production.Product

--3.Write a query that ranks each row in the Sales.SalesOrderDetail table, and displays the following data:
--SalesOrderID, OrderQty, Group Code (details below). The Group code will be based on the value that appears in the Order Quantity
--column, and the following key: a. up to one item = D, b. 2-5 items (inclusive) = C, c. 6-30 items (inclusive) = B, d. more than 30 = A
select SalesOrderID, OrderQty, 
		case 
			when OrderQty<=1 then 'D'
			when OrderQty between 2 and 5 then 'C'
			when OrderQty between 6 and 30  then 'B'
			when OrderQty>30 then 'A'
			else 'Other'
		end as GroupCode
from Sales.SalesOrderDetail

--4.The previous query produced a list of all the order records with the rank of each record according to the quantity of items ordered.
--Now, we want to refine the display to see how many times each group code appears. To do this, write a query that shows 
--how many times each group code (A, B, C, D –according to the data in the previous question) appears in the Sales.SalesOrderDetail table.
--Instruction: Look at the results of the previous query, and think how the answer could be calculated manually.
select  sum(OrderQty) as 'TotalQTYperGC',
		case 
			when OrderQty=1 then 'D'
			when OrderQty between 2 and 5 then 'C'
			when OrderQty between 6 and 30  then 'B'
			when OrderQty>30 then 'A'
			else 'Other'
		end as GroupCode
from Sales.SalesOrderDetail
Group by case 
			when OrderQty=1 then 'D'
			when OrderQty between 2 and 5 then 'C'
			when OrderQty between 6 and 30  then 'B'
			when OrderQty>30 then 'A'
			else 'Other'
		end

--select SalesOrderID, sum(OrderQty) as 'TotalQTYperGC'
--from Sales.SalesOrderDetail
--group by SalesOrderID

--5.In order to segment employees according to gender and marital status, write a query based on the HumanResources.Employee table 
--that shows the number of employees in each segment of gender and family status.
--To make the results clearer, use the following key to change the displayed data: a. Gender column: F → Female, M → Male, 
--b.Marital Status column: S → Single, M → Married, Any other value → Other Note: Currently the values in this column are only 'S' or 'M', but since there
--are other family statuses (e.g., widowed, divorced, etc.), the query shoud support the other options and classify them as 'other'.
select  case Gender
			when 'F' then 'Female'
			when 'M' then 'Male'
			else 'NA'
		end 'Gender2', 
		case MaritalStatus
			when 'S' then 'Single'
			when 'M' then 'Married'
			else 'Other'
		end 'MaritalStatus2',
		count(*) as QTY
from HumanResources.Employee
group by Gender, MaritalStatus

--6.Write a query that displays the SubTotal of every order from the Order Header table according to the following rules:
--a. All orders under 1000 → Low, b. All orders of 1000 or more, but less than 3000 → Good, c. All other orders → Excellent
select SalesOrderID, case
		when SubTotal<=1000 then 'Low'
		when SubTotal>1000 and SubTotal<=3000 then 'Good'
		else 'Excellent'
	   end 'DescriptionSubTotal'
from Sales.SalesOrderHeader

--7.Continuing from the previous question, now display how many orders of each price type there are.
--Instruction: Before you start solving it, think about the way you would solve it if you were doing it manually.
select case
		when SubTotal<=1000 then 'Low'
		when SubTotal>1000 and SubTotal<=3000 then 'Good'
		else 'Excellent'
	   end 'DescriptionSubTotal',
	   count(*) as OrderQTY
from Sales.SalesOrderHeader
group by case
		when SubTotal<=1000 then 'Low'
		when SubTotal>1000 and SubTotal<=3000 then 'Good'
		else 'Excellent'
	   end