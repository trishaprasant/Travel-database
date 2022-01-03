-- 1. Write the code to enforce the business rule that Travelers under the age of 25 cannot book any amenity with type 'Car Rental'.
-- Definition: This business rule ensures that individuals younger than 25 cannot rent cars since that is the legal age of car rentals.
CREATE FUNCTION fn_NoCarRentals()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblTRAVELER T
JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
JOIN tblBOOKING_HOTEL BH ON B.BookingID = BH.BookingID
JOIN tblHOTEL H ON BH.HotelID = H.HotelID
JOIN tblHOTEL_AMENITY HA ON H.HotelID = HA.HotelID
JOIN tblAMENITY A ON HA.AmenityID = A.AmenityID
JOIN tblAMENITY_TYPE AT on A.AmenityTypeID = AT.AmenityTypeID
WHERE AT.AmenityTypeName = 'Car Rental'
AND T.DOB > DateAdd(Year, -25, GetDate()))

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblAMENITY_TYPE
ADD CONSTRAINT CK_NoCarRentalUnder25
CHECK (dbo.fn_NoCarRentals() = 0)
GO

-- 2. Write the code to enforce the business rule that no bookings may be made to Taipei before December 31th, 2022.
-- Definition: This business rule ensures that individuals cannot book a trip to Taipei before the end next year since there
-- are travelling restrictions due to COVID-19.
CREATE FUNCTION fn_NoTaipeiBeforeDec2022()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblCITY C
JOIN tblAIRPORT AP ON C.CityID = AP.CityID
JOIN tblFLIGHT F ON AP.FlightID = F.FlightID
JOIN tblBOOKING_FLIGHT BF ON F.FlightID = BF.FlightID
JOIN tblBOOKING B ON BF.BookingID = B.BookingID
WHERE C.CityName = 'Taipei'
AND B.BookingDate < '2022-12-31'

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblBOOKING
ADD CONSTRAINT CK_NoTaipei2022
CHECK (dbo.fn_NoTaipeiBeforeDec2022() = 0)
GO

-- 3. Write the SQL to enforce the following business rule: 'No attractions of type 'Factories' may be opened in the city of Seattle after 2030.'
-- Definition: This business rule ensures that Seattle won't become overpopulated and emit more greenhouse gases into the atmosphere.
CREATE FUNCTION fn_NoAttractions_SeattleAfter2030()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblCITY C
JOIN tblAIRPORT AP ON C.CityID = AP.CityID
JOIN tblFLIGHT F ON AP.FlightID = F.FlightID
JOIN tblBOOKING_FLIGHT BF ON F.FlightID = BF.FlightID
JOIN tblBOOKING B ON BF.BookingID = B.BookingID
JOIN tblBOOKING_ATTRACTION BA ON B.BookingID = BA.BookingID
JOIN tblATTRACTION A ON BA.AttractionID = A.AttractionID
JOIN tblATTRACTION_TYPE AT ON A.AttractionTypeID = AT.AttractionTypeID
WHERE C.CityName = 'Seattle'
AND AT.AttractionTypeName = 'Factories'
AND YEAR(GetDate()) > 2030)

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblATTRACTION
ADD CONSTRAINT CK_NoAttractionsSeattle
CHECK (dbo.fn_NoAttractions_SeattleAfter2030() = 0)
GO

-- 4. Write the SQL to enforce the following business rule: 'No one under the age of 18 may make a booking in the city of Cabo San Lucas.'
-- Definition: This business rule ensures that only adults are making bookings to Mexico, to ensure that customers are able to pay for the
-- services at hotels and other attractions in the city.
CREATE FUNCTION fn_NoBookings_CaboSanLucas18()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblCITY C
JOIN tblAIRPORT AP ON C.CityID = AP.CityID
JOIN tblFLIGHT F ON AP.FlightID = F.FlightID
JOIN tblBOOKING_FLIGHT BF ON F.FlightID = BF.FlightID
JOIN tblBOOKING B ON BF.BookingID = B.BookingID
JOIN tblTRAVELER T ON B.TravlelerID = T.TravlerID
WHERE C.CityName = 'Cabo San Lucas'
AND T.DOB > DateADD(Year, -18, GetDate()))

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblATTRACTION
ADD CONSTRAINT CK_NoAttractionsSeattle
CHECK (dbo.fn_NoBookings_CaboSanLucas18()= 0)
GO


-- 5. Write the code to enforce the business rule that no hotels in Dubai with an amenity of 'private beach' may have a minimum price of $100 or less.
-- Definition: This business rule ensures that luxury hotels are charging customers a reasonable amount for their amenities, and hotels in Dubai
-- with private beaches do not cost less than $100.
CREATE FUNCTION fn_DubaiHotelLess100()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblBOOKING B
JOIN tblBOOKING_HOTEL BH ON B.BookingID = BH.BookingID
JOIN tblHOTEL H ON BH.HotelID = H.HotelID
JOIN tblHOTEL_AMENITY HA ON H.HotelID = HA.HotelID
JOIN tblAMENITY AY ON H.AmenityID = AY.AmenityID
JOIN tblBOOKING_FLIGHT BF ON B.BookingID = BF.BookingID
JOIN tblFLIGHT F ON BF.FlightID = F.FlightID
JOIN tblAIRPORT A ON F.FlightID = A.FlightID
JOIN tblCITY C ON A.CityID = C.CityID
JOIN tblPRICE_RANGE_HOTEL PRH ON H.PriceRangeHotelID = PRH.PriceRangeHotelID
WHERE C.CityName = 'Dubai'
AND A.AmenityName = 'Private Beach'
AND PRH.HotelMinPrice <= 100)

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblHOTEL
ADD CONSTRAINT CK_NoDubaiHotelLess100
CHECK (dbo.fn_DubaiHotelLess100() = 0)
GO

-- 6. Write the business rule to enforce the business rule that no flights can be booked from or to Vatican City.
-- Definition: This business rule exists because there are no airports in Vatican City.
CREATE FUNCTION fn_NoVaticanFlights()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblCOUNTRY CNY
JOIN tblSTATE S ON CNY.CountryID = S.CountryID
JOIN tblCITY C ON S.StateID = C.StateID
JOIN tblAIRPORT AP ON C.CityID = AP.CityID
JOIN tblFLIGHT F ON AP.FlightID = F.FlightID
JOIN tblROUTE R on F.RouteID = R.RouteID
JOIN tblBOOKING_FLIGHT BF ON F.FlightID = BF.FlightID
JOIN tblBOOKING B ON BF.BookingID = B.BookingID
WHERE R.RouteDesc LIKE '%Vatican%')

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblBOOKING
ADD CONSTRAINT CK_NoVatican
CHECK (dbo.fn_NoVaticanFlights() = 0)
GO

-- 7. No one older than the age of 70 may make a booking with an attraction type description of 'Strenuous'
-- Definition: This ensures that the elderly don't take part in activities that they will not be able to healthily perform.
CREATE FUNCTION fn_NoOlder70Attractions()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblTRAVELER T
JOIN tblBOOKING B on T.TravelerID = B.TravelerID
JOIN tblBOOKING_ATTRACTION BA on B.BookingID = BA.BookingID
	JOIN tblATTRACTION A on BA.AttractionID = A.AttractionID
	JOIN tblATTRACTION_TYPE AT A.AttractionTypeID = AT.AttractionType
WHERE AT.AttractionTypeDesc = 'Strenuous'
AND T.DOB < DateAdd(Year, -70, GetDate()))

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblATTRACTION
ADD CONSTRAINT CK_NoAttractionsOlder70
CHECK (dbo.fn_NoOlder70Attractions() = 0)
GO


-- 8. No hotel with a rating lower than '2 star' may have a restaurant with a min price greater than $45.
-- Definition: This business rule exists because 1 and 2 star hotels do not have prices that are greater
-- than $45, since that is not a reasonable price for food items at a low rated hotel.
CREATE FUNCTION fn_NoHotelRestaurant_MaxPrice()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
FROM tblHOTEL H
	JOIN tblBOOKING_HOTEL BH on H.HotelID = BH.HotelID
	JOIN tblBOOKING B ON BH.BookingID = B.BookingID
	JOIN tblBOOKING_RESTAURANT BR ON B.BookingID = BR.BookingID
	JOIN tblRESTAURANT R ON BR.RestID = R.RestID
	JOIN tblPRICE_RANGE_RESTAURANT PRR ON R.PriceRangeRestID = PRR.PriceRangeRestID
JOIN tblCUISINE C ON R.CuisineID = C.CuisineID
		JOIN tblREVIEW RW ON B.BookingID = RW.BookingID
		JOIN tblRATING RTG ON RW.RatingID = RTG.RatingID
	WHERE RTG.RatingNumber < 2
	AND PRR.RestMaxPrice > 45.99

SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblRESTAURANT
ADD CONSTRAINT CK_NoRestMaxPrice
CHECK (dbo.fn_NoHotelRestaurant_MaxPrice() = 0)
GO
