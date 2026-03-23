--21. Listeaza toate produsele impreuna cu venitul total din vanzari.

select 
ppr.ProductID,
ppr.Name as ProductName,
sum(sod.linetotal) as TotalIncome
from Production.Product ppr
join sales.SalesOrderDetail sod
on ppr.ProductID = sod.ProductID
group by ppr.ProductID,
ppr.Name 
order by TotalIncome desc;

--38. Afiseaza primele 5 produse cu cea mai mare marja de profit.

with ProfitperProdus as(
select 
pp.ProductID,
pp.Name as ProductName,
sum(sod.linetotal) as Totalrevenue,
sum(sod.orderqty * pp.standardcost) as Totalcost,
sum(sod.linetotal-(sod.orderqty*pp.standardcost)) as profit
from sales.salesorderdetail sod
join Production.Product pp
	on	sod.ProductID = pp.ProductID
group by pp.ProductID,
pp.Name 
)
select top 5 
ppp.ProductID,
ppp.ProductName,
ppp.profit *1.0/Totalrevenue as profitMargin
from ProfitperProdus ppp
order by profitMargin desc;

--5. Afiseaza primele 5 produse cel mai bine vandute dupa cantitate.

select top 5
pp.ProductID,
pp.Name as productName,
sum(sod.orderqty) as TotalOrders
from Sales.SalesOrderDetail sod 
join Production.Product pp
	on sod.ProductID = pp.ProductID
group by pp.ProductID,
pp.Name
order by TotalOrders desc;