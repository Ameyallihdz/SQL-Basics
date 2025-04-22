--Continuing from the 2 previous questions, use the mouse to select the codes of
--both queries and run them together. Note that both results will appear in the
--Results window. These are the corresponding query results.
--Examine the Average Price column for the colors that had a minimum price of 0.
--Are there discrepancies in the average?
--Pay attention to this is a very important point!
--Sometimes we must filter out data that skew the calculations. Therefore, it is
--important to verify the data and the results.

--NUM7
select Color, count(*) as'QTYofColors', max(ListPrice) as 'MaxListPrice', avg(ListPrice) as 'AvrListPrice', Min(ListPrice) as 'MinListPrice'
from Production.Product
group by Color

--NUM8
select Color, count(*) as'QTYofColors', max(ListPrice) as 'MaxListPrice', avg(ListPrice) as 'AvrListPrice', Min(ListPrice) as 'MinListPrice'
from Production.Product
where ListPrice!=0
group by Color