--4. Listeaza toate produsele impreuna cu nivelurile lor curente de inventar.
select 
pp.productid,
pp.name as productname,
ppi.quantity
from Production.Product pp
join Production.ProductInventory ppi
	on pp.ProductID = ppi.ProductID
order by pp.Name

--30. Afiseaza numarul total de comenzi plasate pentru fiecare produs.

select 
p.ProductID,
p.Name as ProductName,
count(distinct sod.SalesOrderID) as TotalordersPlaced
from Production.Product p
join sales.SalesOrderDetail sod
	on P.ProductID = sod.ProductID
group by p.ProductID,
p.Name
order by TotalordersPlaced desc;