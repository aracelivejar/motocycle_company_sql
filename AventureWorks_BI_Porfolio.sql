--1. Listeaza toti angajatii impreuna cu informatiile lor de contact.

select 
he.BusinessEntityID,
pp.firstname+' ' +pp.lastname as EmployeName,
he.JobTitle,
pe.EmailAddress,
ppp.PhoneNumber 
from HumanResources.Employee he
join Person.Person pp
	on	he.BusinessEntityID = pp.BusinessEntityID
join  Person.EmailAddress pe
	on he.BusinessEntityID = pe.BusinessEntityID
join Person.PersonPhone ppp
	on he.BusinessEntityID = ppp.BusinessEntityID
order by he.BusinessEntityID,
pp.firstname;


--2. Afiseaza numarul total de produse din fiecare categorie de produse.

select
ppc.name as ProductCategory,
count(pp.productid) as Totalproducts
from Production.Product pp
join Production.ProductSubcategory pps
	on pp.ProductSubcategoryID = pps.ProductSubcategoryID
join Production.ProductCategory ppc
	on pps.ProductCategoryID = ppc.ProductCategoryID
group by ppc.Name


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

--4. Listeaza toate produsele impreuna cu nivelurile lor curente de inventar.
select 
pp.productid,
pp.name as productname,
ppi.quantity
from Production.Product pp
join Production.ProductInventory ppi
	on pp.ProductID = ppi.ProductID
order by pp.Name

--4.1 Listeaza toate produsele impreuna cu nivelurile lor curente de inventar pentru fiecare locatie.

select 
pp.productid,
pp.name as productname,
ppi.quantity as CurrentInventory,
pl.Name as LocationName
from Production.Product pp
join Production.ProductInventory ppi
	on pp.ProductID = ppi.ProductID
join Production.Location pl
	on	ppi.LocationID = pl.LocationID
order by pp.productid,pp.Name,
pl.Name;

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

--6. Gaseste limita medie de credit a tuturor clientilor.
/*vom considera valoare totala a comenzilor
ca fiind un indicator al creditului folosit de client*/

select
avg(customerTotal) as AVGcreditLimit
from (
select
customerid,
sum(TotalDue) as customerTotal
from Sales.SalesOrderHeader
group by CustomerID)
as customerTotals;

--7. Listeaza toti angajatii impreuna cu departamentele lor.

select
hre.businessentityid,
pp.FirstName +' '+ pp.lastname as EmployeeName,
hrd.name as DepartmentName
from HumanResources.Employee hre
join Person.Person pp 
	on hre.BusinessEntityID = pp.BusinessEntityID
join HumanResources.EmployeeDepartmentHistory hredh
	on hre.BusinessEntityID = hredh.BusinessEntityID
join HumanResources.Department hrd
	on hredh.DepartmentID = hrd.DepartmentID
order by hre.businessentityid

--8. Afiseaza primele 3 produse cel mai bine vandute din fiecare categorie de produse.

select top 3
ppc.name as ProductCategory,
pp.productid,
pp.name as ProductName,
sum(ssod.orderqty) as TotalQtySold
from Sales.SalesOrderDetail ssod
join Production.Product pp
	on ssod.ProductID = pp.ProductID
join Production.ProductSubcategory pps
	on pp.ProductSubcategoryID = pps.ProductSubcategoryID
join Production.ProductCategory ppc
	on	pps.ProductCategoryID = ppc.ProductCategoryID
group by pp.productid,
ppc.name,
pp.name
order by TotalQtySold desc;


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


--10. Afiseaza pretul mediu de lista al produselor.

select avg(listprice) as AVGlistprice
from Production.Product
where ListPrice >0


--11. Listeaza toate teritoriile de vanzari impreuna cu tarile corespunzatoare.

select
sst.territoryID,
pcr.name as Countryname
from Sales.SalesTerritory sst 
join Person.CountryRegion pcr
	on pcr.CountryRegionCode = sst.CountryRegionCode
order by sst.territoryID


--12. Gaseste valoarea totala a vanzarilor pentru fiecare an.

select 
YEAR(OrderDate)as salesyear,
sum(Totaldue) as TotalSalesAmount
from Sales.SalesOrderHeader
group by year(OrderDate)
order by TotalSalesAmount desc;


--13. Afiseaza primii 5 clienti care au realizat cea mai mare achizitie individuala.


select top 5
cpa.customerid,
cpa.FirstName,
cpa.lastname,
cpa.LargestPurchaseAmount
from
(select 
sc.customerid,
pp.firstname,
pp.lastname,
max(ssoh.Totaldue) as LargestPurchaseAmount
from sales.customer sc
join person.person pp
	on	sc.PersonID = pp.BusinessEntityID
join Sales.SalesOrderHeader ssoh
	on sc.CustomerID = ssoh.CustomerID
group by sc.customerid,
pp.firstname,
pp.lastname) as cpa
order by LargestPurchaseAmount desc;

--14. Listeaza toate produsele impreuna cu furnizorii lor.

select 
pp.ProductID,
pp.Name as ProductName,
pv.name as VendorName
from  Production.Product pp
join Purchasing.ProductVendor ppv
	on ppv.productid = pp.productid
join Purchasing.Vendor pv
	on ppv.BusinessEntityID = pv.BusinessEntityID
order by pp.ProductID,
pp.Name, 
pv.name 


--15. Gaseste numarul de angajati din fiecare departament.

select 
ned.deparmentname,
ned.TotalEmployees
from 
( select
hrd.name as deparmentname,
count(hre.businessentityid) as TotalEmployees
from HumanResources.Employee hre
join HumanResources.EmployeeDepartmentHistory hredh
	on	hredh.BusinessEntityID = hre.BusinessEntityID
join HumanResources.Department hrd
	on	hrd.DepartmentID = hredh.DepartmentID
	group by hrd.name 
) as ned
order by 
ned.TotalEmployees 


--16. Afiseaza primii 5 clienti care au facut cele mai multe achizitii.

select top 5
sc.customerid, 
pp.firstname,
pp.lastname,
count(soh.salesorderid) as TotalPurchases
from Sales.Customer sc
join Person.Person pp 
	on sc.PersonID = pp.BusinessEntityID
join sales.SalesOrderHeader soh
	on sc.CustomerID = soh.CustomerID
group by 
sc.customerid, 
pp.firstname,
pp.lastname
order by TotalPurchases desc;


--17. Listeaza toate produsele impreuna cu pretul lor de lista si costul standard.

select
ProductID,
ListPrice,
standardcost as Standardcost
from Production.Product pp
where ListPrice > 0
order by ProductID,
ListPrice,
standardcost desc;


--18. Gaseste numarul total de produse vandute in fiecare an.


select
year(soh.orderdate) as Year,
count(sod.orderqty) as TotalProductsPurchase
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh
on soh.SalesOrderID = sod.SalesOrderID
group by year(soh.OrderDate)
order by TotalProductsPurchase desc;


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


--20. Listeaza toti angajatii care au schimbat departamentele impreuna cu istoricul departamentelor.

select
he.BusinessEntityID,
pp.Firstname+ ' ' + pp.lastname as FullNameEmployee,
d.name as department,
edh.startdate as StartDate,
edh.EndDate as endDate
from HumanResources.Employee he
join Person.Person pp
on he.BusinessEntityID = pp.BusinessEntityID
join HumanResources.EmployeeDepartmentHistory edh
on he.BusinessEntityID = edh.BusinessEntityID
join HumanResources.Department d
on edh.DepartmentID = d.DepartmentID
where EndDate is not null
order by he.BusinessEntityID, edh.EndDate desc;


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


--22. Gaseste numarul total de angajati, angajati in fiecare an.

select 
year(hiredate) as Hireyear,
count(businessentityid) as TotalEmployees
from HumanResources.Employee
group by YEAR(hiredate)
order by Hireyear,
TotalEmployees 


--23. Listeaza toate produsele impreuna cu categoria si subcategoria lor.


Select 
pp.ProductID,
pp.Name as ProductName,
pc.Name as ProductCategory,
psb.name as ProductSubcategory
from Production.Product pp
join Production.ProductCategory pc
	on	pp.ProductID = pc.ProductCategoryID
join Production.ProductSubcategory psb
on pc.ProductCategoryID = psb.ProductCategoryID
order by pp.ProductID,pp.Name


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

--25. Gaseste primii 3 angajati cu cel mai mare numar de vanzari.

select TOP 3
e.BusinessEntityID,
pp.firstname +' '+ pp.lastname as EmployeeName,
COUNT(soh.SalesOrderID) as TotalnumberSales
from HumanResources.Employee E
join Person.Person pp
on e.BusinessEntityID = pp.BusinessEntityID
join Sales.SalesOrderHeader soh
	on e.BusinessEntityID = soh.SalesPersonID
group by e.BusinessEntityID,
pp.firstname,pp.lastname
order by TotalnumberSales desc;

--26. Listeaza toate teritoriile de vanzari impreuna cu numarul de clienti alocati fiecaruia.
select
st.territoryid,
st.name as TerritoryName,
count(sc.customerid) as TotalCUstomers
from sales.SalesTerritory st
 left join sales.Customer sc
	on	sc.TerritoryID = st.TerritoryID
group by st.territoryid,
st.Name
order by TerritoryID, TotalCUstomers desc

--27. Afiseaza limita medie de credit a clientilor din fiecare tara.



--28. Gaseste numarul total de produse vandute de fiecare angajat.

Select 
e.BusinessEntityID,
pp.firstname +' '+ pp.lastname as EmployeeFullName,
sum(sod.orderqty) as TotalProductsSold
from HumanResources.Employee e
join Person.Person pp
	on e.businessEntityID = pp.BusinessEntityID
join sales.SalesOrderHeader soh
	on e.BusinessEntityID = soh.SalesPersonID
join sales.SalesOrderDetail sod
	on soh.SalesOrderID = sod.SalesOrderID
group by e.BusinessEntityID,
pp.FirstName, pp.LastName
order by TotalProductsSold desc


--29. Listeaza toti angajatii care nu sunt alocati niciunui departament.

select 
e.BusinessEntityID,
pp.firstname + ' ' + pp.lastname as EmployeeFullName
from HumanResources.Employee e
join Person.Person pp
	on	e.BusinessEntityID = pp.BusinessEntityID
left join HumanResources.EmployeeDepartmentHistory edh
	on e.BusinessEntityID = edh.BusinessEntityID
where edh.BusinessEntityID IS NULL
Order by pp.FirstName

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


--31. Gaseste primii 5 clienti care au realizat cea mai scumpa achizitie individuala.


with rankedPurchases as (
select 
sc.customerid,
pp.FirstName +' '+ pp.lastname as CustomerFullName,
soh.totaldue,
row_number()over (
partition by sc.customerid
order by soh.totaldue desc ) as maxpurchase
from sales.Customer sc
join person.Person pp
	on	sc.PersonID = pp.BusinessEntityID
join sales.SalesOrderHeader soh
	on	sc.CustomerID = soh.CustomerID)
select top 5 *
from rankedPurchases
where maxpurchase = 1
order by TotalDue desc


--32. Listeaza toate produsele impreuna cu culorile lor.

select 
ProductID,
Color as colorProduct
from Production.Product
where Color is not null
order by ProductID, Color

--33. Afiseaza primii 3 clienti care au facut cele mai multe achizitii in functie de cantitate.

select top 3 
sc.PersonID,
pp.firstname+'  '+ pp.lastname as customerFullName,
sum(sod.OrderQty) as TotalOrders

from sales.Customer sc
join Person.Person pp
	on sc.PersonID = pp.BusinessEntityID
join sales.SalesOrderHeader soh
	on sc.CustomerID = soh.CustomerID
join sales.SalesOrderDetail sod
	on soh.SalesOrderID = sod.SalesOrderID
group by sc.PersonID,
pp.firstname,pp.lastname
order by TotalOrders desc

--34. Listeaza toate produsele impreuna cu dimensiunile si greutatile lor.

select 
ProductID,
Name as ProductName,
concat_ws(' ',Size,sizeunitMeasurecode) as Size,
concat_ws(' ',weight,WeightUnitMeasureCode) as weight
from Production.Product p
where size is not null and Weight is not null
order by ProductID

select * from Production.Product

--35. Gaseste numarul mediu de comenzi plasate pe luna.

with OrdersMonthly as (
select
year(orderdate) as OrderYear,
month(orderdate) as OrderMonth,
count(salesorderid) as MonthlyOrders
from Sales.SalesOrderHeader
group by year(orderdate),
month(orderdate)
)
select avg(MonthlyOrders) as AvgMonthlyOrders
from OrdersMonthly


--36. Afiseaza numarul total de produse vandute de fiecare agent de vanzari.

with SalesPerAgent as (
select 
soh.SalesPersonID,
sum(sod.orderqty) as TotalProductsSold
from sales.SalesOrderHeader soh
join sales.SalesOrderDetail sod
	on soh.SalesOrderID = sod.SalesOrderID
where soh.SalesPersonID is not null
group by soh.SalesPersonID
) 
select spa.SalesPersonID,
pp.FirstName + ' ' + pp.LastName AS EmployeeFullName,
spa.TotalProductsSold
FROM SalesPerAgent spa
JOIN Person.Person pp
ON spa.SalesPersonID = pp.BusinessEntityID
ORDER BY spa.TotalProductsSold DESC;


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

--39. Listeaza toti angajatii care au fost concediati impreuna cu data concedierii.


select 
    edh.BusinessEntityID,
    max(edh.EndDate) as TerminationDate,
    pp.FirstName + ' ' + pp.LastName as EmployeeFullName
from HumanResources.EmployeeDepartmentHistory edh
join Person.Person pp
    on edh.BusinessEntityID = pp.BusinessEntityID
group by edh.BusinessEntityID, pp.FirstName, pp.LastName
having max(edh.EndDate) is not null;


--40. Gaseste numarul total de produse unice vandute in fiecare teritoriu de vanzari.

select 
soh.TerritoryID,
count(distinct sod.ProductID) as TotalUniqueProducts
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh
    on sod.SalesOrderID = soh.SalesOrderID
group by soh.TerritoryID
order by soh.TerritoryID;