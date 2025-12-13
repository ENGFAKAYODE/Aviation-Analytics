-- Question 1
select concat(firstname, ' ', LastName) as FullName,
       Fl.FlightNumber,
	   Fl.DepartureTime,
	   P.Model
from [Air].[Passengers] Pa
join [Air].[Bookings] B on Pa.PassengerID = B.PassengerID
join [Air].[Flights] Fl on B.FlightID = Fl.FlightID
join [Air].[Planes] P on P.PlaneID = Fl.PlaneID
where  concat(firstname, ' ', LastName) = 'Michelle Taylor'

-- Question 2
select T.SeatNumber,
       T.Class,
	   T.Price,
       Fl.FlightNumber,
	   Fl.DepartureTime,
	   Fl.ArrivalTime,
	   P.Model
from [Air].[Tickets] T 
join [Air].[Bookings] B on T.BookingID = B.BookingID
join [Air].[Flights] Fl on B.FlightID = Fl.FlightID
join [Air].[Planes] P on P.PlaneID = Fl.PlaneID
where B.BookingID = 'B0019'

-- Question 3
select Fl.FlightNumber,
	   Fl.DepartureTime,
	   Fl.ArrivalTime,
	   P.Model
from [Air].[Tickets] T 
join [Air].[Bookings] B on T.BookingID = B.BookingID
join [Air].[Flights] Fl on B.FlightID = Fl.FlightID
join [Air].[Planes] P on P.PlaneID = Fl.PlaneID
join [Air].[Crew] C on C.CrewID = Fl.CrewID
where C.CrewID = 'C0123'

-- Question 4
select Fl.FlightNumber,
       count(T.SeatNumber) as Booked_Seats,
	   (P.Capacity - count(T.SeatNumber)) as Available_Seats
from [Air].[Tickets] T
join [Air].[Bookings] B 
     on B.BookingID = T.BookingID
join [Air].[Flights] Fl 
     on Fl.FlightID = B.FlightID
join [Air].[Planes] P 
     on P.PlaneID = Fl.PlaneID
where B.FlightID = 'F0897'
group by Fl.FlightNumber, P.Capacity


-- Question 5
Select CONCAT(Pa.FirstName, ' ', Pa.Lastname) as [Full Name],
	   Pa.PassengerID,
	   Pa.PhoneNumber,
	   Pa.Email
from [Air].[Flights] Fl
join [Air].[Bookings] B on B.FlightID = Fl.FlightID
join [Air].[Passengers] Pa on B.PassengerID = Pa.PassengerID
where Fl.FlightNumber = 778


-- Question 6
Select  CONCAT(Pa.FirstName, ' ', Pa.Lastname) as [Full Name]
from [Air].[Flights] Fl
join [Air].[Bookings] B on B.FlightID = Fl.FlightID
join [Air].[Passengers] Pa on B.PassengerID = Pa.PassengerID
where Fl.FlightNumber = 505


-- Question 7
select P.Model,
       Fl.FlightNumber,
	   Fl.DepartureTime,
	   fl.ArrivalTime
from [Air].[Flights] Fl
left join [Air].[Planes] P on P.PlaneID = Fl.PlaneID


-- Question 8
Select  CONCAT(Pa.FirstName, ' ', Pa.Lastname) as [Full Name]
from [Air].[Flights] Fl
join [Air].[Bookings] B 
     on B.FlightID = Fl.FlightID
join [Air].[Passengers] Pa 
     on B.PassengerID = Pa.PassengerID
where datepart(day,Fl.DepartureTime) = 14
      and datepart(month,Fl.DepartureTime) = 5
	  and datepart(year,Fl.DepartureTime) = 2022


-- Question 9
Select CONCAT(Pa.FirstName, ' ', Pa.Lastname) as [Full Name],
       Fl.FlightNumber
from [Air].[Flights] Fl
join [Air].[Bookings] B 
     on B.FlightID = Fl.FlightID
join [Air].[Passengers] Pa 
     on B.PassengerID = Pa.PassengerID
;


-- Question 10
;with monthly_revenue as(
select  Fl.FlightNumber,
        datename(month, Fl.DepartureTime) as Month,
		datename(year, Fl.DepartureTime) as Year,
        datepart(month, Fl.DepartureTime) as MonthNum,
		sum(T.Price) as Price
from [Air].[Tickets] T 
join [Air].[Bookings] B 
     on B.BookingID  = T.BookingID
join [Air].[Flights] Fl 
     on Fl.FlightID = B.FlightID
where B.Status = 'Confirmed'
group by Fl.FlightNumber,
         BookingDate,
		 datepart(month, Fl.DepartureTime),
		 datename(Year, Fl.Departuretime),
		 datename(month, Fl.Departuretime)
)     
select Month,
       Year,
       FlightNumber,
	   Price as Revenue,
	   Rank() over(partition by MonthNum, Year order by Price desc) as Revenue_Rank
from monthly_revenue
order by Year, MonthNum, Revenue_Rank


-- Question 11
select CONCAT(C.FirstName, ' ', C.LastName) as Name,
       C.Position,
       count(F.FlightID) as Num_Flights,
       sum(DATEDIFF(hour, F.DepartureTime, F.ArrivalTime)) as hours_logged,
	   DENSE_RANK() over(order by sum(DATEDIFF(hour, F.DepartureTime, F.ArrivalTime)) desc) as utilisation_rank

from [Air].[Crew] C left join [Air].[Flights] F
on C.CrewID = F.CrewID and datepart(year, F.DepartureTime) = 2022
group by CONCAT(C.FirstName, ' ', C.LastName), Position
order by utilisation_rank


-- Question 12
select CONCAT(P.FirstName, ' ', P.LastName) as PassengerName,
       COUNT(distinct B.FlightID) as Num_Flights,
	   sum(T.Price) as Total_Spent,
	   RANK() over( order by sum(T.Price) desc) as Rank
from [Air].[Passengers] P join  [Air].[Bookings] B
on P.PassengerID = B.PassengerID
join [Air].[Tickets] T on T.BookingID = B.BookingID
where B.Status = 'Confirmed'
and B.BookingDate >= '2021-01-01' and B.BookingDate < '2022-01-01'
group by P.PassengerID, P.FirstName, P.LastName
order by sum(T.Price) desc


-- Question 13
select T.Class,
       count(T.TicketID) as Num_Ticket,
	   sum(T.Price) as Revenue,
	   Rank() over(order by sum(T.Price) desc) as Most_Profitable
from [Air].[Tickets] T join [Air].[Bookings] B
on T.BookingID = B.BookingID
where B.Status = 'Confirmed'
group by T.Class ;

-- Question 14
;with customer_info as(
select distinct P.PassengerID,
       CONCAT(P.FirstName, ' ', P.LastName) as PassengerName,
	   P.Gender,
	   P.Email,
	   P.PhoneNumber,
	   DATEDIFF(year, P.DateOfBirth, GETDATE()) as Age
from [Air].[Passengers] P join [Air].[Bookings] B
on P.PassengerID = B.PassengerID
join [Air].[Flights] F on F.FlightID = B.FlightID
where F.DepartureTime between '2021-01-01' and '2021-12-31'
and B.Status = 'Confirmed')

select gender,
       AVG(Age) as Avg_Age,
	   COUNT(PassengerID) as Passengers
from customer_info
group by gender



-- Question 15
select F.FlightID,
       count(T.SeatNumber) as Seats_booked,
	   sum(T.Price) as Revenue,
	   count(T.BookingID)*100.0/P.Capacity as Seat_utilization
from [Air].[Tickets] T join [Air].[Bookings] B
on T.BookingID = B.BookingID
join [Air].[Flights] F on F.FlightID = B.FlightID
join [Air].[Planes] P on P.PlaneID = F.PlaneID
where B.Status = 'Confirmed'
group by F.FlightID, P.Capacity
order by count(T.BookingID)*100.0/P.Capacity desc

-- Question 16
;with flights_per_user as (
select CONCAT(P.FirstName, ' ', P.LastName) as Passenger_Name,
       count(F.FlightID) as Num_Flights
from [Air].[Passengers] P join [Air].[Bookings] B
on P.PassengerID = B.PassengerID
join [Air].[Flights] F on F.FlightID = B.FlightID
where F.DepartureTime between '2021-01-01' and '2021-12-31'
and B.Status = 'Confirmed'
group by P.PassengerID, P.FirstName, P.LastName
)
select  Passenger_Name,
        Num_Flights,
        case when Num_Flights > 10 then 'Platinum'
        when Num_Flights > 5 then 'Gold'
        when Num_Flights > 2 then 'Silver'
		else 'Bronze' end as Tiers
from flights_per_user
order by Num_Flights desc


-- Question 17
Select F.DepartureAirport,
       concat(datename(month, F.DepartureTime), ' ', datename(year, F.DepartureTime)) as Month,
	   count(distinct F.FlightID) as #_Flights,
	   sum(T.Price) as Revenue
from [Air].[Flights] F join [Air].[Bookings] B
on F.FlightID = B.FlightID
join [Air].[Tickets] T 
on T.BookingID = B.BookingID
group by F.DepartureAirport, concat(datename(month, F.DepartureTime), ' ', datename(year, F.DepartureTime))
order by sum(T.Price) desc

-- Question 18
select concat(datename(month, B.BookingDate), ' ', datename(year, B.BookingDate)) as Month,
       count(B.BookingID) as Bookings,
	   Avg(DATEDIFF(day, B.BookingDate, F.DepartureTime)*1.0) as Days_Diff
from [Air].[Bookings] B join [Air].[Flights] F
on B.FlightID = F.FlightID
where B.Status = 'Confirmed'
group by concat(datename(month, B.BookingDate), ' ', datename(year, B.BookingDate)), 
         YEAR(B.BookingDate), Month(B.BookingDate)
order by YEAR(B.BookingDate), Month(B.BookingDate)

-- Question 18.1
SELECT DATENAME(dw, B.BookingDate) AS Day_of_Week,
       COUNT(B.BookingID) AS Total_Bookings,
       AVG(DATEDIFF(day, B.BookingDate, F.DepartureTime)) AS Avg_Lead_Time_Days
FROM [Air].[Bookings] B jOIN [Air].[Flights] F ON B.FlightID = F.FlightID
GROUP BY DATENAME(dw, B.BookingDate), DATEPART(dw, B.BookingDate) 
ORDER BY DATEPART(dw, B.BookingDate)

-- Question 18.2
select T.class,
       concat(datename(month, B.BookingDate), ' ', datename(year, B.BookingDate)) as Month,
       count(B.BookingID) as Bookings,
	   Avg(DATEDIFF(day, B.BookingDate, F.DepartureTime)*1.0) as Days_Diff
from [Air].[Bookings] B join [Air].[Flights] F
on B.FlightID = F.FlightID
join [Air].[Tickets] T on T.BookingID = B.BookingID
where B.Status = 'Confirmed'
group by T.class,
         concat(datename(month, B.BookingDate), ' ', datename(year, B.BookingDate)), 
         YEAR(B.BookingDate), Month(B.BookingDate)
order by YEAR(B.BookingDate), Month(B.BookingDate)


-- Question 19
-- No required field to calculates

-- Question 20
SELECT F.FlightNumber,
       F.DepartureAirport,
       F.DepartureTime,
       COUNT(T.TicketID) as Tickets_Sold,
       SUM(T.Price) as Total_Revenue,
       RANK() OVER (ORDER BY SUM(T.Price) DESC) as Revenue_Rank
FROM [Air].[Flights] F JOIN [Air].[Bookings] B ON F.FlightID = B.FlightID
JOIN [Air].[Tickets] T ON B.BookingID = T.BookingID
WHERE B.Status = 'Confirmed'
GROUP BY F.FlightNumber, F.DepartureAirport, F.DepartureTime
ORDER BY Total_Revenue DESC

-- Question 20.1
SELECT DATENAME(year, F.DepartureTime) as Year,
       DATENAME(month, F.DepartureTime) as Month,
       F.FlightNumber,
       SUM(T.Price) as Total_Revenue,
       RANK() OVER (PARTITION BY YEAR(F.DepartureTime), MONTH(F.DepartureTime) ORDER BY SUM(T.Price) DESC) as Rank_In_Month
FROM [Air].[Flights] F
JOIN [Air].[Bookings] B ON F.FlightID = B.FlightID
JOIN [Air].[Tickets] T ON B.BookingID = T.BookingID
WHERE B.Status = 'Confirmed'
GROUP BY DATENAME(year, F.DepartureTime), 
         DATENAME(month, F.DepartureTime),
         YEAR(F.DepartureTime), 
         MONTH(F.DepartureTime),
         F.FlightNumber
ORDER BY YEAR(F.DepartureTime), MONTH(F.DepartureTime), Rank_In_Month


-- Question 20.2
SELECT F.DepartureAirport,
       F.FlightNumber,
       SUM(T.Price) as Total_Revenue,
       RANK() OVER (PARTITION BY F.DepartureAirport ORDER BY SUM(T.Price) DESC) as Rank_In_Airport
FROM [Air].[Flights] F
JOIN [Air].[Bookings] B ON F.FlightID = B.FlightID
JOIN [Air].[Tickets] T ON B.BookingID = T.BookingID
WHERE B.Status = 'Confirmed'
GROUP BY F.DepartureAirport, F.FlightNumber
ORDER BY F.DepartureAirport, Rank_In_Airport



-- Question 21
SELECT CONCAT(P.FirstName, ' ', P.LastName) AS PassengerName,
       P.Email,
       P.PhoneNumber,
       COUNT(DISTINCT B.BookingID) AS Flights_Taken,
       SUM(T.Price) AS Total_Spent,
       DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT B.BookingID) DESC) as Frequency_Rank,
       DENSE_RANK() OVER (ORDER BY SUM(T.Price) DESC) as Spending_Rank
FROM [Air].[Passengers] P
JOIN [Air].[Bookings] B ON P.PassengerID = B.PassengerID
JOIN [Air].[Tickets] T ON B.BookingID = T.BookingID
WHERE B.Status = 'Confirmed'
GROUP BY P.PassengerID, P.FirstName, P.LastName, P.Email, P.PhoneNumber
ORDER BY Total_Spent DESC


-- Question 22
SELECT P.PlaneID,
       P.Model,
       COUNT(F.FlightID) AS Total_Flights,
       ISNULL(SUM(DATEDIFF(hour, F.DepartureTime, F.ArrivalTime)), 0) AS Total_Hours_Flown,
       CASE WHEN COUNT(F.FlightID) > 3 THEN 'Over-utilised'
           WHEN COUNT(F.FlightID) <= 0 THEN 'Under-utilised'
           ELSE 'Well-utilised' END AS Utilisation_Status
FROM [Air].[Planes] P
LEFT JOIN [Air].[Flights] F ON P.PlaneID = F.PlaneID
GROUP BY P.PlaneID, P.Model
ORDER BY Total_Flights DESC


-- Question 22.1
SELECT P.Model,
       P.PlaneID,
       DATENAME(year, F.DepartureTime) AS Year,
       DATENAME(month, F.DepartureTime) AS Month,
       COUNT(F.FlightID) AS Flights_Completed,
       SUM(DATEDIFF(hour, F.DepartureTime, F.ArrivalTime)) AS Hours_Flown
FROM [Air].[Planes] P
JOIN [Air].[Flights] F ON P.PlaneID = F.PlaneID
GROUP BY P.Model, P.PlaneID, 
         DATENAME(year, F.DepartureTime), DATENAME(month, F.DepartureTime),
         DATEPART(year, F.DepartureTime), DATEPART(month, F.DepartureTime)
ORDER BY DATEPART(year, F.DepartureTime), DATEPART(month, F.DepartureTime)


-- Question 22.2
SELECT TOP 5 
       P.Model,
       P.PlaneID,
       COUNT(F.FlightID) AS Total_Flights,
       SUM(DATEDIFF(hour, F.DepartureTime, F.ArrivalTime)) AS Total_Hours_Flown
FROM [Air].[Planes] P
JOIN [Air].[Flights] F ON P.PlaneID = F.PlaneID
GROUP BY P.Model, P.PlaneID
ORDER BY Total_Flights DESC


-- Question 22.3
SELECT P.Model,
       P.PlaneID,
       COUNT(F.FlightID) AS Total_Flights
FROM [Air].[Planes] P
LEFT JOIN [Air].[Flights] F ON P.PlaneID = F.PlaneID
GROUP BY P.Model, P.PlaneID
HAVING COUNT(F.FlightID) <= 0

-- Question 23
SELECT CASE WHEN DATEDIFF(year, DateOfBirth, GETDATE()) < 18 THEN 'Under 18'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) BETWEEN 36 AND 50 THEN '36-50'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) > 50 THEN 'Over 50'
        ELSE 'Unknown' END AS Age_Group,
    COUNT(PassengerID) AS Total_Passengers
FROM [Air].[Passengers]
GROUP BY CASE WHEN DATEDIFF(year, DateOfBirth, GETDATE()) < 18 THEN 'Under 18'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) BETWEEN 36 AND 50 THEN '36-50'
        WHEN DATEDIFF(year, DateOfBirth, GETDATE()) > 50 THEN 'Over 50'
        ELSE 'Unknown' END
ORDER BY Total_Passengers DESC


-- Question 23.1
SELECT Gender,
       COUNT(PassengerID) AS Total_Passengers,
       CAST(COUNT(PassengerID) * 100.0 / (SELECT COUNT(*) FROM [Air].[Passengers]) AS DECIMAL(5,2)) AS Percentage
FROM [Air].[Passengers]
GROUP BY Gender
ORDER BY Total_Passengers DESC



-- Question 24
SELECT CASE WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) < 18 THEN '0-17'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 18 AND 24 THEN '18-24'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 45 AND 54 THEN '45-54'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+' END AS Age_Group,
    COUNT(DISTINCT P.PassengerID) AS Passenger_Count
FROM [Air].[Passengers] P
JOIN [Air].[Bookings] B ON P.PassengerID = B.PassengerID
WHERE B.Status = 'Confirmed'
GROUP BY CASE WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) < 18 THEN '0-17'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 18 AND 24 THEN '18-24'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 45 AND 54 THEN '45-54'
        WHEN DATEDIFF(year, P.DateOfBirth, GETDATE()) BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+' END
ORDER BY Age_Group


-- Question 25
SELECT TOP 10
       F.DepartureAirport,
       F.ArrivalAirport,
       COUNT(B.BookingID) AS Total_Bookings,
       RANK() OVER (ORDER BY COUNT(B.BookingID) DESC) AS Route_Rank
FROM [Air].[Flights] F
JOIN [Air].[Bookings] B ON F.FlightID = B.FlightID
WHERE B.Status = 'Confirmed'
GROUP BY F.DepartureAirport, F.ArrivalAirport
ORDER BY Total_Bookings DESC


-- Question 26
SELECT DATENAME(year, BookingDate) AS Year,
       DATENAME(month, BookingDate) AS Month,
       COUNT(BookingID) AS Total_Bookings,
       SUM(CASE WHEN Status = 'Confirmed' THEN 1 ELSE 0 END) AS Confirmed_Bookings,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending_Bookings,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Bookings
FROM [Air].[Bookings]
GROUP BY DATENAME(year, BookingDate), DATENAME(month, BookingDate), YEAR(BookingDate), MONTH(BookingDate)
ORDER BY YEAR(BookingDate), MONTH(BookingDate)


-- Question 27
SELECT cast(BookingDate as date) as Day,
       COUNT(BookingID) AS Total_Bookings,
       SUM(CASE WHEN Status = 'Confirmed' THEN 1 ELSE 0 END) AS Confirmed_Bookings,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending_Bookings,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Bookings
FROM [Air].[Bookings]
GROUP BY cast(BookingDate as date)
ORDER BY cast(BookingDate as date)


-- Question 28
Select Status,
       count(*) as Total_Bookings
from [Air].[Bookings]
group by Status
order by Total_Bookings desc


-- Question 29
select datepart(week, BookingDate) as Week,
       datepart(year, BookingDate) as Year,
	   COUNT(BookingID) as Total_Booking,
	   sum(case when Status = 'Confirmed' then 1 else 0 end) as Confirmed_Bookings,
	   sum(case when Status = 'Cancelled' then 1 else 0 end) as Cancelled_Bookings,
       sum(case when Status = 'Pending' then 1 else 0 end) as Pending_Bookings
from [Air].[Bookings]
group by datepart(week, BookingDate), datepart(year, BookingDate)
order by Week, Year


-- Question 30
;WITH MonthlyStats AS (
    SELECT YEAR(BookingDate) AS BookingYear,
           MONTH(BookingDate) AS MonthNum,
           DATENAME(month, BookingDate) AS MonthName,
           COUNT(BookingID) AS Total_Bookings
    FROM [Air].[Bookings]
    WHERE Status = 'Confirmed'
    GROUP BY YEAR(BookingDate), MONTH(BookingDate), DATENAME(month, BookingDate))

SELECT 
    BookingYear,
    MonthName,
    Total_Bookings,
    LAG(Total_Bookings) OVER (ORDER BY BookingYear, MonthNum) AS Previous_Month_Bookings,
    CAST( (Total_Bookings - LAG(Total_Bookings) OVER (ORDER BY BookingYear, MonthNum)) * 100.0 
        / LAG(Total_Bookings) OVER (ORDER BY BookingYear, MonthNum) 
    AS DECIMAL(5,2)) AS Growth_Percent
FROM MonthlyStats
ORDER BY BookingYear, MonthNum


-- Question 31
select CAST(BookingDate as date) as Day,
       COUNT(*) as Total_Booking
from [Air].[Bookings]
group by CAST(BookingDate as date)


-- Question 32
select DATEPART(week, BookingDate) as Week,
       YEAR(BookingDate) AS Year,
       COUNT(*) as Total_Booking
from [Air].[Bookings]
group by DATEpart(week, BookingDate),YEAR(BookingDate)
order by Week, Year


-- Question 33
select YEAR(BookingDate) AS Year,
       COUNT(*) as Total_Booking
from [Air].[Bookings]
group by YEAR(BookingDate)
order by Year


-- Question 34
select Manufacturer,
       Status,
       avg(DATEDIFF(YEAR, YearOfManufacture, GETDATE())*1.0) as Avg_AGE,
       count(PlaneID) as Planes
from [Air].[Planes]
group by Manufacturer, Status
order by Planes


-- Question 35
select Status,
       count(PlaneID) as Planes
from [Air].[Planes]
group by Status
order by Planes


-- Question 36
select PlaneID,
       model,
	   Capacity,
	   YearOfManufacture,
	   Status
from [Air].[Planes]
where model like 'Boeing%'
order by Capacity


-- Question 37
select case
       when Capacity > 300 then 'Greater than 300'
	   when Capacity >= 201 then 'Between 201 and 300'
	   when Capacity >= 101 then 'Between 101 and 200'
	   when Capacity <= 100 then 'Less than 100' end as Capacity_Group,
	   count(*) as Planes
from [Air].[Planes]
group by case
       when Capacity > 300 then 'Greater than 300'
	   when Capacity >= 201 then 'Between 201 and 300'
	   when Capacity >= 101 then 'Between 101 and 200'
	   when Capacity <= 100 then 'Less than 100' end
order by Planes desc


-- Question 38
select case
       when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) > 20 then '20+ years'
	   when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) >= 11 then '11-20 years'
	   when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) >= 6 then '6-10 years'
	   when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) < 6 then '0-5 years' end as Plane_Age,
	   count(*) as Planes
from [Air].[Planes]
group by case
       when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) > 20 then '20+ years'
	   when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) >= 11 then '11-20 years'
	   when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) >= 6 then '6-10 years'
	   when DATEDIFF(YEAR, YearOfManufacture, GETDATE()) < 6 then '0-5 years' end
order by Planes desc


-- Question 39
select Class,
       COUNT(TicketID) as Tickets_Sold,
       AVG(Price) as Avg_Price_Per_Ticket,
       Sum(Price) as Revenue
from [Air].[Tickets]
group by Class


-- Question 40
select T.Class,
       DATENAME(month, B.BookingDate) as Month,
       DATENAME(year, B.BookingDate) as Year,
	   COUNT(distinct T.TicketID) as Tickets_Sold,
	   sum(T.Price) as Revenue,
	   Avg(T.Price) as Avg_Ticket_Price
from [Air].[Tickets] T join [Air].[Bookings] B
on T.BookingID = B.BookingID
where B.Status = 'Confirmed'
group by T.Class, DATENAME(month, B.BookingDate),  DATENAME(year, B.BookingDate),
                  DATEpart(month, B.BookingDate),  DATEpart(year, B.BookingDate)
order by DATEpart(month, B.BookingDate),  DATEpart(year, B.BookingDate)


-- Question 41
select top 5 TicketID,
       Class,
	   Price
from [Air].[Tickets]
order by Price DESC


-- Question 42
SELECT CASE 
        WHEN T.Price > 400 THEN '400+'
        WHEN T.Price >= 301 THEN '301-400'
        WHEN T.Price >= 201 THEN '201-300'
        WHEN T.Price >= 101 THEN '101-200'
        WHEN T.Price < 101 THEN '0-100' END AS Price_Range,
    COUNT(T.TicketID) AS Total_Tickets_Sold,
    SUM(T.Price) AS Total_Revenue
FROM [Air].[Tickets] T
JOIN [Air].[Bookings] B ON T.BookingID = B.BookingID
WHERE B.Status = 'Confirmed'
GROUP BY CASE 
        WHEN T.Price > 400 THEN '400+'
        WHEN T.Price >= 301 THEN '301-400'
        WHEN T.Price >= 201 THEN '201-300'
        WHEN T.Price >= 101 THEN '101-200'
        WHEN T.Price < 101 THEN '0-100' END
ORDER BY MIN(T.Price) 
