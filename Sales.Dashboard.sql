--12. Gaseste valoarea totala a vanzarilor pentru fiecare an.

select 
YEAR(OrderDate)as salesyear,
sum(Totaldue) as TotalSalesAmount
from Sales.SalesOrderHeader
group by year(OrderDate)
order by TotalSalesAmount desc;

--24. Afiseaza numarul total de comenzi plasate in fiecare luna.

select 
year(orderdate) as orderyear,
datename(month,orderdate) as OrderMonth,
month(orderdate) as ordernumbermonth,
count(salesorderid) as TotalOrdersPlaced
from Sales.SalesOrderHeader
group by year(orderdate),
month(OrderDate),
datename(month,OrderDate)
order by orderyear,
ordernumbermonth

--40. Gaseste numarul total de produse unice vandute in fiecare teritoriu de vanzari.

select 
soh.TerritoryID,
count(distinct sod.ProductID) as TotalUniqueProducts
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh
    on sod.SalesOrderID = soh.SalesOrderID
group by soh.TerritoryID
order by soh.TerritoryID;