--3. Gaseste primii 10 clienti cu cea mai mare valoare totala a achizitiilor.

select top 10 
sc.customerid,
pp.firstname + ' '+ pp.lastname,
sum(soh.totaldue) as TotalPurchaseAmount
from Sales.Customer sc 
join Person.Person pp
	on sc.PersonID = pp.BusinessEntityID
join Sales.SalesOrderHeader soh
	on sc.CustomerID = soh.CustomerID
group by sc.customerid,
pp.firstname + ' '+ pp.lastname

--9. Gaseste numarul total de comenzi plasate de fiecare client.


select
sc.customerid,
pp.firstname,
pp.lastname,
count(soh.salesorderid) as TotalOrders
from sales.customer sc
join person.person pp 
	on sc.CustomerID = pp.BusinessEntityID
join Sales.SalesOrderHeader soh
	on sc.CustomerID = soh.CustomerID
group by sc.customerid,
pp.firstname,
pp.lastname
order by TotalOrders desc;

--37. Listeaza toti clientii care au realizat mai mult de 10 achizitii.

with CustomerCountPurchases as (
select
soh.CustomerID,
count(soh.salesorderid) as countPurchases
from Sales.SalesOrderHeader soh
group by 
soh.CustomerID
)
select 
ccp.customerid,
ccp.countpurchases,
pp.firstname+' '+pp.lastname as CustomerfullName
from CustomerCountPurchases ccp
join sales.Customer sc
	on ccp.CustomerID = sc.CustomerID
join Person.Person pp
	on sc.PersonID = pp.BusinessEntityID
where ccp.countPurchases >= 10
order by ccp.countPurchases desc;

--19. Afiseaza primii 3 clienti care au cheltuit cel mai mult in total.

select top 3 
sc.customerid,
pp.firstname +' ' + pp.lastname as FullNameCustomer,
sum(soh.totaldue) as totalCustomerSpend
from sales.Customer sc
join Person.Person pp 
on sc.CustomerID = pp.BusinessEntityID
join sales.SalesOrderHeader soh
on sc.CustomerID = soh.CustomerID
group by sc.customerid,
pp.firstname, pp.lastname
order by totalCustomerSpend desc;