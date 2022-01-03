-- 1. Write the query to determine which travelers meet all of the following conditions:
-- a.  Have gone to less than 17 Chinese restaurants on their trip since February 17, 2015
-- b. Booked more than 62 trips to Seattle between March 28, 2017 and December 19, 2020
SELECT T.TravelerID, Fname, Lname, TotalSeattleTrips, COUNT(*) AS TotalChineseRest
FROM tblTRAVELER T
   JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
   JOIN tblBOOKING_RESTAURANT BR ON B.BookingID = BR.BookingID
   JOIN tblRESTAURANT R ON BR.RestID = R.RestID
   JOIN tblCUISINE C ON R.CuisineID = C.CuisineID
   JOIN (
           SELECT T.TravelerID, Fname, Lname, COUNT(*) AS TotalSeattleTrips
           FROM tblTRAVELER T
               JOIN tblBOOKING B ON T.BookingID = B.BookingID
               JOIN tblBOOKING_FLIGHT BF ON B.FlightID = BF.FlightID
               JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
               JOIN tblAIRPORT A ON F.AirportID = A.AirportID
               JOIN tblCITY ON A.CityID = tblCITY.CityID
           WHERE B.BookingDate between 'March 28, 2017' and 'December 19, 2020'
           AND tblCITY.CityName = 'Seattle'
           GROUP BY T.TravelerID, Fname, Lname
           HAVING COUNT(*) > 62) AS subq1 ON T.TravelerID = subq1.TravelerID
WHERE C.CuisineName = 'Chinese'
   AND B.BookingDate > 'February 17, 2015'
GROUP BY T.TravelerID, Fname, Lname, TotalSeattleTrips
HAVING COUNT(*) < 17

-- 2. Write the query to determine which travelers meet all of the following conditions:
-- a. Is a female who is older than 65 years old and flying to JFK airport.
-- b. Booked more than 23 Hilton Hotels in Los Angeles in 2014.
SELECT T.TravelerID, Fname, Lname, TotalHiltonHotel
FROM tblGENDER G
   JOIN tblTRAVELER T ON G.GenderID = T.GenderID
   JOIN tblBOOKING B ON T.BookingID = B.BookingID
   JOIN tblBOOKING_FLIGHT BF ON B.FlightID = BF.FlightID
   JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
   JOIN tblAIRPORT A ON F.AirportID = A.AirportID
   JOIN (
           SELECT T.TravelerID, Fname, Lname, COUNT(*) AS TotalHiltonHotel
           FROM tblTRAVELER T
               JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
               JOIN tblBOOKING_HOTEL BH ON B.BookingID = BH.BookingID
               JOIN tblHOTEL H ON BH.HotelID = H.HotelID
               JOIN tblBOOKING_FLIGHT BF ON B.FlightID = BF.FlightID
               JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
               JOIN tblAIRPORT A ON F.AirportID = A.AirportID
               JOIN tblCITY ON A.CityID = tblCITY.CityID
           WHERE YEAR(B.BookingDate) = '2014'
           AND tblCITY.CityName = 'Los Angeles'
           AND H.HotelName = 'Hilton'
           GROUP BY T.TravelerID, Fname, Lname
           HAVING COUNT(*) > 23) AS subq1 ON T.TravelerID = subq1.TravelerID
WHERE G.GenderName = 'Female'
   AND DATEDIFF(YEAR, T.DOB, GetDate()) > '65'
   AND A.AirportAbbr = 'JFK'
GROUP BY T.TravelerID, Fname, Lname, TotalHiltonHotel

-- 3. Write the query to determine all of the cities that have more than 10 attractions.
SELECT C.CityName, C.CityID
FROM tblCITY C
	JOIN tblAIRPORT AP ON C.CityID = AP.CityID
	JOIN tblFLIGHT F ON AP.FlightID = F.FlightID
	JOIN tblBOOKING_FLIGHT BF ON F.FlightID = BF.FlightID
	JOIN tblBOOKING B ON BF.BookingID = B.BookingID
	JOIN tblBOOKING_ATTRACTION BA ON B.BookingID = BA.BookingID
	JOIN tblATTRACTION A ON BA.AttractionID = A.AttractionID
GROUP BY C.CityID
HAVING COUNT(DISTINCT A.AttractionID) > 10


-- 4. Write the query to determine the top 10 'Italian' restaurants in New York that have a min price of $30 to a max price of $500.
SELECT TOP 10 (R.RestName)
FROM tblRESTAURANT R
	JOIN tblCUISINE C ON R.CuisineID = C.CuisineID
	JOIN tblPRICE_RANGE_RESTAURANT PRR ON R.PriceRangeRestID = PR.PriceRangeRestID
	JOIN tblBOOKING_RESTAURANT BR ON R.RestID = BR.RestID
	JOIN tblBOOKING B ON BR.BookingID = B.BookingID
	JOIN tblBOOKING_FLIGHT BF ON B.BookingID = BF.BookingID
	JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
	JOIN tblAIRPORT AP ON F.FlightID = AP.FlightID
	JOIN tblCITY CY ON AP.CityID = CY.CityID
WHERE C.CuisineName =  'Italian'
AND CY.CityName = 'New York'
AND PRR.MaxPrice = 500
AND PRR.MinPrice = 30

-- 5. Write the query to determine which travelers meet all of the following conditions:
-- a. Have stayed at a hotel that has a 'luxury shopping mall' as an amenity
-- b. Have flown to Dubai more than 5 times
SELECT A.TravelerID, A.Fname, A.Lname, B.NumDubaiTrips
FROM
(SELECT T.TravelerID, T.Fname, T.Lname
FROM tblTRAVELER T
JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
JOIN tblBOOKING_HOTEL BH ON B.BookingID = BH.BookingID
JOIN tblHOTEL H ON BH.HotelID = H.HotelID
JOIN tblHOTEL_AMENITY HA ON H.HotelID = HA.HotelID
JOIN tblAMENITY AY ON H.AmenityID = AY.AmenityID
AND A.AmenityName = 'Luxury Shopping Mall') AS A,

(SELECT T.TravelerID, T.Fname, T.Lname, COUNT(B.BookingID) AS NumDubaiTrips
FROM tblTRAVELER T
JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
JOIN tblBOOKING_FLIGHT BF ON B.BookingFlightID = BF.BookingFlightID
JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
JOIN tblAIRPORT A ON F.FlightID = A.FlightID
JOIN tblCITY C ON A.CityID = C.CityID
WHERE C.City = 'Dubai'
GROUP BY T.TravelerID
HAVING NumDubaiTrips > 5) AS B

WHERE A.TravelerID = B.TravelerID


-- 6. Write the query to determine which travelers meet all of the following conditions:
-- a. Has booked an 'Eiffel Tower' attraction more than 2 times
-- b. Has booked a flight to Paris 1 time or less
SELECT A.TravelerID, A.Fname, A.Lname, A.NumEiffelTrips, B.NumParisTrips
FROM
(SELECT T.TravelerID, T.Fname, T.Lname, COUNT(B.BookingID) AS NumEiffelTrips
FROM tblTRAVELER T
JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
JOIN tblBOOKING_ATTRACTION BA ON B.BookingAttractionID = BH.BookingAttractionID
JOIN tblATTRACTION A ON BA.AttractionID = A.AttractionID
WHERE A.AttractionName = 'Eiffel Tower'
GROUP BY T.TravelerID
HAVING NumEiffelTrips > 2) AS A,

(SELECT T.TravelerID, T.Fname, T.Lname, COUNT(B.BookingID) AS NumParisTrips
FROM tblTRAVELER T
JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
JOIN tblBOOKING_FLIGHT BF ON B.BookingFlightID = BF.BookingFlightID
JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
JOIN tblAIRPORT A ON F.FlightID = A.FlightID
JOIN tblCITY C ON A.CityID = C.CityID
WHERE C.City = 'Paris'
GROUP BY T.TravelerID
HAVING NumParisTrips <= 1) AS B

WHERE A.TravelerID = B.TravelerID

-- 7. Write the query to determine which traveler meets the following conditions:
-- a. Flew from Seattle to New York in the past 5 years
-- b. Have had more than 2 bookings with an attraction type of 'Night Time'
SELECT A.TravelerID, A.Fname, A.Lname, B.NumBookNight
FROM
(SELECT T.TravelerID, T.Fname, T.Lname
FROM tblTRAVELER T
	JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
	JOIN tblBOOKING_FLIGHT BF ON B.BookingID = BF.BookingID
	JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
	JOIN tblROUTE R ON F.RouteID = R.RouteID
WHERE R.RouteDesc = 'Seattle to New York'
AND B.BookingDate >= DateAdd(Year, -5, GetDate()))
GROUP BY T.TravelerID) AS A,

(SELECT T.TravelerID, T.Fname, T.Lname, COUNT(*) AS NumBookNight
FROM tblTRAVELER T
	JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
	JOIN tblBOOKING_ATTRACTION BA ON B.BookingID = BA.BookingID
	JOIN tblATTRACTION A ON BA.AttractionID = A.AttractionID
	JOIN tblATTRACTION_TYPE AT ON A.AttractionTypeID = AT.AttractionType
WHERE AT.AttractionTypeName = 'Night Time'
GROUP BY T.TravelerID
HAVING NumBookNight > 2) AS B

WHERE A.TravelerID = B.TravelerID


-- 8. Write the query to determine the number of female travelers that meet all of the following conditions:
-- a. Have eaten at an expensive 'Thai' restaurant with a review of type 'Amazing' in 2018
-- b. Have flown more than 3 times in 2018
SELECT COUNT(T.TravelerID)
FROM tblTRAVELER T
	JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
	JOIN tblBOOKING_FLIGHT BF ON B.BookingID = BF.BookingID
	JOIN tblBOOKING_RESTAURANT BR ON B.BookingID = BR.BookingID
	JOIN tblRESTUARANT R ON BR.RestID = R.RestID
	JOIN tblCUISINE C ON R.CuisineID = C.CuisineID
	JOIN tblREVIEW RW ON B.BookingID = RW.BookingID
	JOIN tblREVIEW RWT ON RW.ReviewTypeID = RWT.ReviewTypeID
	JOIN tblGENDER G ON T.GenderID = G.GenderID
WHERE C.CuisineName = 'Thai'
AND RWT.ReviewTypeName = 'Amazing'
AND G.GenderName = 'Female'
AND B.BookingDate BETWEEN 'January 1, 2018' AND 'December 31, 2018'
HAVING COUNT(BF.BookingFlightID) > 3
GROUP BY T.TravelerID
