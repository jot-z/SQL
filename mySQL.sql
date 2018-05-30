SELECT AgreementNbr, AgreementDate, GrossAmount 
FROM AGREEMENT_T
WHERE GrossAmount between 1500 and 2000;



SELECT CustomerID, CustomerName 
FROM CUSTOMER_T
WHERE CustomerName like "%Arts%";




SELECT ArtistID, StartDate, EndDate, RoyaltyPerc 
FROM CONTRACT_T
WHERE RoyaltyPerc > 20 and StartDate < now() and EndDate > now()
ORDER BY ArtistID;



SELECT ArtistID, sum(Amount) 
FROM ARTISTPAYMENT_T
WHERE year(APaymentDate) = 2015 and month(APaymentDate) between 01 and 03
GROUP BY ArtistID
HAVING sum(Amount) >= 2000;



SELECT distinct(concat(a.FirstName, ' ', a.LastName)) Fullname, a.ArtistID, a.YearOfBirth, c.RoyaltyPerc 
FROM ARTIST_T a, CONTRACT_T c
WHERE a.ArtistID=c.ArtistID
AND a.ArtistID in (select ArtistID from CONTRACTEDARTIST_T where EndDate >=now());



SELECT distinct(EventID), EventDesc, DateTime 
FROM EVENT_T
WHERE EventID in (SELECT EVENTID from AGREEMENT_T 
WHERE ContractID in (SELECT ContractID from CONTRACT_T
WHERE ArtistID in (Select ArtistID from ARTIST_T
WHERE FirstName='Juan' and LastName = 'Becker')));



SELECT a.FirstName, a.LastName, e.EventID, e.DateTime, g.GrossAmount, e.EventDesc
FROM ARTIST_T AS a, EVENT_T AS e, CONTRACT_T AS c, AGREEMENT_T AS g, CONTRACTEDARTIST_T AS con
WHERE a.ArtistID=con.ArtistID 
AND con.ArtistID=c.ArtistID
AND c.ContractID=g.ContractID
AND g.EventID= e.EventID
AND con.AManagerID=1 AND e.DateTime BETWEEN "2014-12-01" AND "2015-01-31";



select pc.product_category, sum(store_sales) as TotalSales
from sales_fact sf, product_class pc, product p
where sf.product_id = p.product_id and p.product_class_id = pc.product_class_id
group by pc.product_category
order by TotalSales DESC limit 1;



select DAYNAME(the_date) as Days, sum(store_sales) as TotalSales
from sales_fact sf, time_by_day t
where t.time_id = sf.time_id
group by Days
order by TotalSales DESC;



select count(Expenses) as num
from Transactions
where TransDate='2012-8-1 00:00:00' and Expenses > (select avg(Expenses)
from Transactions
where TransDate='2012-8-1 00:00:00');



select *
from (select sum(Sales) as SumSales, ProductLine, MarketSize
from Transactions
group by ProductLine, MarketSize
order by SumSales  desc) NewT
group by ProductLine;



select C.CustName, avg(T.Sales) as avgSales
from Transactions T, Reps R, Customers C
where R.RepID=T.RepID and T.CustID = C.CustID and State='Texas' and Gender='F' and R.RepID in (select R.RepID
from Reps R, Transactions T
where R.Gender='F' and T.Sales>(select avg(Sales)
from Transactions T
where ProductType= 'Electric' and MarketSize='Small Market'))
group by C.CustName
order by avg(T.Sales) desc;

