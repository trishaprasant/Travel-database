-- 1. Write the code to create a computed column to measure the total number of flights each traveler has booked in the past
-- 4.5 years in the country 'United States'.
CREATE FUNCTION fn_TotalNumFlights(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER =(SELECT COUNT(DISTINCT F.FlightID)
FROM tblTRAVELER T
   JOIN tblBOOKING B ON T.BookingID = B.BookingID
   JOIN tblBOOKING_FLIGHT BF ON B.FlightID = BF.FlightID
   JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
   JOIN tblAIRPORT A ON F.AirportID = A.AirportID
   JOIN tblCITY ON A.CityID = tblCITY.CityID
   JOIN tblSTATE S ON tblCITY.StateID = S.StateID
   JOIN tblCOUNTRY C ON S.CountryID = C.CountryID
WHERE C.CountryName = 'United States'
   AND B.BookingDate > DateAdd (Month, -54, GetDate())
   AND T.TravelerID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblTRAVELER
ADD CalcTotalNumFlights AS (dbo.fn_TotalNumFlights(TravelerID))

-- 2. Write the code to create a computed column to measure the total number of hotel bookings each traveler
-- has booked in the past 3.5 years that were at any hotel with the amenity of type 'Spa'.
CREATE FUNCTION fn_TotalNumHotelBooking(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER =(SELECT COUNT(DISTINCT BH.BookingHotelID)
FROM tblTRAVELER T
   JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
   JOIN tblBOOKING_HOTEL BH ON B.BookingID = BH.BookingID
   JOIN tblHOTEL H ON BH.HotelID = H.HotelID
   JOIN tblHOTEL_AMENITY HA ON H.HotelID = HA.HotelID
   JOIN tblAMENITY A ON HA.AmenityID = A.AmenityID
   JOIN tblAMENITY_TYPE AT on A.AmenityTypeID = AT.AmenityTypeID
WHERE AT.AmenityTypeName = 'Spa'
   AND TC.BeginDate > DateAdd (Month, -42, GetDate())
   AND T.TravelerID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblTRAVELER
ADD CalcTotalNumHotelBooking AS (dbo.fn_TotalNumHotelBooking(TravelerID))

-- 3. Write the SQL to create a computed column to list the total number of travelers who traveled to New York City.
CREATE FUNCTION fn_CalcNumTravelers(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER =(SELECT COUNT(DISTINCT T.TravelerID)
 	FROM tblTRAVELER T
JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
                        JOIN tblBOOKING_FLIGHT BF ON B.BookingID = BF.BookingID
		JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
		JOIN tblAIRPORT AP ON F.FlightID = AP.FlightID
		JOIN tblCITY C ON AP.CityID = C.CityID
WHERE C.CityName = 'New York'
AND T.TravelerID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblTRAVELER
ADD CalcNumTravelers AS (dbo.fn_CalcNumTravelers(TravelerID))

-- 4. Write the SQL to create a computed column to list the total number of hotels for each State.
CREATE FUNCTION fn_CalcNumHotels(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER =(SELECT COUNT(DISTINCT H.HotelID)
 	FROM tblHOTEL H
		JOIN tblBOOKING_HOTEL BH ON H.HotelID = BH.HotelID
JOIN tblBOOKING B ON BH.BookingID = B.BookingID
                        JOIN tblBOOKING_FLIGHT BF ON B.BookingID = BF.BookingID
		JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
		JOIN tblAIRPORT AP ON F.FlightID = AP.FlightID
		JOIN tblCITY C ON AP.CityID = C.CityID
		JOIN tblSTATE S on C.StateID = S.StateID
WHERE S.StateID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblSTATE
ADD CalcNumHotels AS (dbo.fn_CalcNumHotels(StateID))

-- 5. Write the SQL to create a computed column to measure the number of bookings for each hotel in ''Dubai'
-- with an amenity of 'private beach' in the past 5 years
CREATE FUNCTION fn_Num_Bookings_Dubai_Beach(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = (SELECT COUNT(BH.BookingHotelID)
FROM tblTRAVELER T
	JOIN tblBOOKING B on T.TravelerID = B.TravelerID
	JOIN tblBOOKING_HOTEL BH ON B.BookingID = BH.BookingID
	JOIN tblHOTEL H ON BH.HotelID = H.HotelID
	JOIN tblHOTEL_AMENITY HA ON H.HotelID = HA.HotelID
	JOIN tblAMENITY AY ON H.AmenityID = AY.AmenityID
	JOIN tblBOOKING_FLIGHT BF ON B.BookingFlightID = BF.BookingFlightID
	JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
	JOIN tblAIRPORT A ON F.FlightID = A.FlightID
	JOIN tblCITY C ON A.CityID = C.CityID
	WHERE C.CityName = 'Dubai'
	AND AY.AmenityName = 'Private Beach'
	AND B.BookingDate >= DATEADD(Year, -5, GetDate())
AND H.HotelID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblHOTEL
ADD CalcNum5YrDubaiBeachers AS (dbo.fn_Num_Bookings_Dubai_Beach(HotelID))

-- 6. Write the SQL to create a computed column to count the total number of restaurant bookings in the last 2 years in each continent.
CREATE FUNCTION fn_NumRestContBooking(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER =(SELECT COUNT(DISTINCT BR.BookingRestID)
FROM tblBOOKING B
	JOIN tblBOOKING_RESTAURANT BR ON B.BookingID = BH.BookingID
	JOIN tblRESTAURANT R ON BR.RestID = R.RestID
	JOIN tblBOOKING_FLIGHT BF ON B.BookingFlightID = BF.BookingFlightID
	JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
	JOIN tblAIRPORT A ON F.FlightID = A.FlightID
	JOIN tblCITY C ON A.CityID = C.CityID
	JOIN tblSTATE S ON C.StateID = S.StateID
	JOIN tblCOUNTRY CRY ON S.CountryID = CRY.CountryID
	JOIN tblCONTINENT CT ON CRY.ContinentID = CT.ContinentID
WHERE B.BookingDate >= DATEADD(Year, -2, GetDate())
AND CT.ContinentID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblCONTINENT
ADD CalcTotalNumRestCont
AS (dbo. fn_NumRestContBooking(ContinentID))

-- 7. Write the SQL to create a computed column to measure the number bookings for each Italian restaurant YTD.
CREATE FUNCTION fn_Num_RestBookings(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = (SELECT COUNT(DISTINCT BookingRestID)
FROM tblBOOKING_RESTAURANT BR
	JOIN tblBOOKING B on BR.BookingID = B.BookingID
	JOIN tblRESTAURANT R on BR.RestID = R.RestID
	JOIN tblCUISINE C on R.CuisineID = C.CuisineID
	WHERE YEAR(B.BookingDate) = YEAR(GetDate())
	AND C.CuisineName = 'Italian'
	AND R.RestID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblRESTAURANT
ADD CalcNumItalianBookings AS (dbo.fn_Num_RestBookings(RestID)

-- 8. Write the SQL to create a computed column to count the total number of travelers staying at each hotel with a rating of 3 YTD.
CREATE FUNCTION fn_Num_Travelers_Hotel(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = (SELECT COUNT(TravelerID)
FROM tblTRAVELER T
	JOIN tblBOOKING B on T.TravelerID = B.TravelerID
	JOIN tblBOOKING_HOTEL BH on B.BookingID = BH.BookingID
	JOIN tblHOTEL H on BH.HotelID = H.HotelID
	WHERE YEAR(B.BookingDate) = YEAR(GetDate())
	AND H.HotelRating = 3
	AND H.HotelID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblHOTEL
ADD CalcNumCurrHotelTravelers AS (dbo.fn_Num_Travelers_Hotel(HotelID))
