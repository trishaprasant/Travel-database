-- 1. Insert a row into tblTRAVELER:
CREATE PROCEDURE tprasant_NewTraveler
@F varchar(30),
@L varchar(30),
@DOB Date,
@GenderName varchar(30)
AS
DECLARE @G_ID INT
SET @G_ID = (SELECT GenderID FROM tblGENDER WHERE GenderName = @GenderName)
BEGIN TRANSACTION T3
INSERT INTO tblTRAVELER (FName, LName, DOB, GenderID)
VALUES (@F, @L, @DOB, @G_ID)
COMMIT TRANSACTION T3

EXECUTE tprasant_NewTraveler
@F = 'David',
@L = 'Jiang',
@DOB = 'February 3, 1960',
@GenderName = 'Male'


-- 2. Insert a row into tblRESTAURANT:
CREATE PROCEDURE tprasant_NewRestaurant
@RName varchar(30),
@RestPriceName varchar(30),
@CName varchar(30)
AS
DECLARE @P_ID INT, @C_ID INT
SET @P_ID = (SELECT PriceRangeRestID FROM tblPRICE_RANGE_RESTAURANT WHERE RestPriceRangeName = @RestPriceName)
SET @C_ID = (SELECT CuisineID FROM tblCUISINE WHERE CuisineName = @CName)
BEGIN TRANSACTION T4
INSERT INTO tblRESTAURANT (RestName, PriceRangeRestID, CuisineID)
VALUES (@RName, @PRR_ID, @C_ID)
COMMIT TRANSACTION T4

EXECUTE tprasant_NewRestaurant
@RName = 'Savor Mexicana',
@RestPriceName = 'Budget',
@CName = 'Mexican'

-- 3. Insert a row into tblCITY:
CREATE PROCEDURE alam_ADD_CITY
@CTname varchar(50),
@STname varchar(50),
@Ctryname varchar(50),
@Cntname varchar(50)
AS
DECLARE @CT_ID INT, @S_ID INT, @CTRY_ID INT, @CNT_ID INT

SET @S_ID = (SELECT StateID FROM tblSTATE S
			WHERE S.StateName = @STname)
SET @CTRY_ID = (SELECT CountryID FROM tblCOUNTRY CTRY
			WHERE CTRY.CountryName = @Ctryname)
SET @CNT_ID = (SELECT ContinentID FROM tblCONTINENT CNT
			WHERE CNT. ContinentName = @Cntname)
BEGIN TRAN T5
INSERT INTO tblCITY(CityName, StateID)
VALUES(@CTname, @S_ID)
COMMIT TRAN T5
GO

EXECUTE alam_ADD_CITY
@CTname = 'Albany',
@STname = 'New York',
@Ctryname = 'United States of America',
@Cntname = 'North America'

-- 4. Insert a row into tblFLIGHT:
CREATE PROCEDURE ptyava_ADD_FLIGHT
@Dura varchar(10),
@RouteDescrip varchar(75),
@Price numeric(8)
AS
DECLARE @PR_ID INT, @R_ID INT
SET @R_ID = (SELECT RouteID FROM tblROUTE WHERE RouteDesc = @RouteDescrip)
BEGIN TRANSACTION T6
INSERT INTO tblFLIGHT(Price, RouteID, Duration)
VALUES(@Price, @R_ID, @Dura)
COMMIT TRANSACTION T6

EXECUTE ptyava_ADD_FLIGHT
@Dura = 14,
@RouteDescrip = 'Los Angeles to Wuhan',
@Price = 2000

-- 5. Insert a row into tblBOOKING:
CREATE PROCEDURE ptyava_NewBooking
@BDate Date,
@F varchar(50),
@L varchar(50),
@bday Date
AS
DECLARE @B_ID INT, @T_ID INT, @G_ID INT

SET @T_ID = (SELECT TravelerID FROM tblTRAVELER T
WHERE T.Fname = @F
AND T.Lname = @L
AND T.DOB = @bday)
BEGIN TRAN T7
INSERT INTO tblBOOKING(TravelerID, BookingDate)
VALUES(@T_ID, @BDate)
COMMIT TRAN T7
GO

EXECUTE ptyava_NewBooking
@BDate = 'February 17, 2015',
@F = 'David',
@L = 'Jiang' ,
@bday = 'February 3, 1960'

-- 6. Insert a row into tblATTRACTION:
CREATE PROCEDURE ptyava_ADD_ATTRACTION
@AttraTName varchar(30),
@ATName varchar(30)
AS
DECLARE @A_ID INT, @AT_ID INT
SET @AT_ID = (SELECT AttractionTypeID FROM tblATTRACTION_TYPE AT
WHERE AT.AttractionTypeName = @AttraTName)
BEGIN TRANSACTION T8
INSERT INTO tblATTRACTION(AttractionID, AttractionName, AttractionTypeID)
VALUES(@ATName, @AT_ID)
COMMIT TRANSACTION T8
EXECUTE ptyava_ADD_ATTRACTION
@AttraTName = 'Water Bodies',
@ATName = 'Lake Terry'


-- 7. Insert a row into tblHOTEL:
CREATE PROCEDURE tprasant_NewHotel
@HRate numeric(8,2),
@Hname varchar(50),
@PRHotel varchar(100)
AS
DECLARE @H_ID INT, @P_ID INT

SET @P_ID = (SELECT PriceRangeHotelID FROM tblPRICE_RANGE_HOTEL WHERE HotelPriceRangeName  = @PRHotel)
BEGIN TRANSACTION T1
INSERT INTO tblHOTEL(HotelRating, HotelName, PriceRangeHotelID)
VALUES (@HRate, @Hname,@P_ID)
COMMIT TRANSACTION T1
EXECUTE tprasant_NewHotel
@HRate = '3.5',
@Hname= 'Hilton',
@PRHotel = 'Mid-Range'

-- 8. Insert a row into tblCOUNTRY:
CREATE PROCEDURE tprasant_NewCountry
@ContName varchar(50),
@CountryN varchar(50)
AS
DECLARE @COUN_ID INT, @CON_ID INT
SET @CON_ID = (SELECT ContinentID FROM tblCONTINENT WHERE ContinentName = @ContName)
BEGIN TRANSACTION T2
INSERT INTO tblCOUNTRY(ContinentID, CountryName)
VALUES(@CON_ID, @CountryN)
COMMIT TRANSACTION T2

EXECUTE tprasant_NewCountry
@ContName = 'Asia',
@CountryN = 'China'
