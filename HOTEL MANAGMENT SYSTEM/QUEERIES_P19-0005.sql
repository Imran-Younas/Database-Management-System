USE HOTEL_MANAGMENT_SYSTEM;

/* ------ Querry# 01  ------ */

SELECT * FROM HOTELS;



SELECT TOP 5 * 
FROM HOTELS
ORDER BY HOTEL_RATING DESC;

/* ------ Querry# 02  ------ */
SELECT * FROM HOTELS;
SELECT * FROM HOTEL_AMENITY;



SELECT H.Hotel_ID, H.HOTEL_NAME, COUNT(HM.AMENITY_ID) AS TOTAL_AMENITY
FROM HOTELS AS H, HOTEL_AMENITY AS HM
WHERE H.Hotel_ID = HM.Hotel_ID
GROUP BY H.Hotel_ID, H.HOTEL_NAME
HAVING COUNT(HM.AMENITY_ID) >= 3;


/* ------ Querry# 03   ------ */

SELECT * FROM CUSTOMER;
SELECT * FROM RESERVATION;



SELECT 
	C.Customer_ID, C.First_Name, C.Last_Name, C.Phone, COUNT(R.Reservation_ID) AS Number_of_Reservations
FROM
	CUSTOMER AS C, RESERVATION R 
WHERE 
	C.Customer_ID = R.Customer_ID
GROUP BY 
	C.Customer_ID, C.First_Name, C.Last_Name, C.EMAIL, C.Phone;


/* ------ Querry# 04   ------ */

 SELECT * FROM ROOM;
 SELECT * FROM HOTELS;




 SELECT R.HOTEL_ID, H.HOTEL_NAME, H.HOTEL_LOCATION, SUM(R.PRICE_$) AS TOTAL_Revenue
 FROM HOTELS AS H, ROOM AS R  
 WHERE R.HOTEL_ID = H.Hotel_ID
 GROUP BY R.Hotel_ID, H.HOTEL_NAME, H.HOTEL_LOCATION;


 /* ------ Querry# 05   ------ */

SELECT DISTINCT H.Hotel_ID, H.HOTEL_NAME
FROM HOTELS H
JOIN ROOM R ON H.Hotel_ID = R.HOTEL_ID
WHERE NOT EXISTS (
    SELECT 1
    FROM RESERVATION RV
    WHERE RV.Hotel_ID = H.Hotel_ID
    AND RV.CheckInDate <= '2023-08-01' 
    AND RV.CheckOutDate >= '2023-08-10' 
);


 /* ------ Querry# 06   ------ */

 SELECT * FROM CUSTOMER;
 SELECT * FROM ROOM;
 SELECT * FROM RESERVATION;




 SELECT TOP 1 C.Customer_ID, C.First_Name, C.Last_Name, C.EMAIL, C.Phone, SUM(R.PRICE_$) AS
 HIGHEST_TOTAL_BOOKING_AMOUNT_$
 FROM CUSTOMER AS C, ROOM AS R, RESERVATION AS RE
 WHERE C.Customer_ID = RE.Customer_ID AND R.ROOM_ID = RE.Room_ID
 GROUP BY C.Customer_ID, C.First_Name, C.Last_Name, C.EMAIL, C.Phone
 ORDER BY SUM(PRICE_$) DESC;


  /* ------ Querry# 07   ------ */

SELECT DISTINCT H.Hotel_ID, H.HOTEL_NAME
FROM HOTELS H
JOIN ROOM R ON H.Hotel_ID = R.HOTEL_ID
WHERE NOT EXISTS (
    SELECT 1
    FROM RESERVATION RV
    WHERE RV.Hotel_ID = H.Hotel_ID
    AND (RV.CheckInDate <= '2023-08-01'  
    AND RV.CheckOutDate >= '2023-08-10') 
);

  /* ------ Querry# 08   ------ */

SELECT H.Hotel_ID, H.HOTEL_NAME, AVG(H.HOTEL_RATING) AS AVERAGE_RATING
FROM HOTELS H
JOIN RESERVATION R ON H.Hotel_ID = R.Hotel_ID
JOIN (
    SELECT Customer_ID
    FROM RESERVATION
    GROUP BY Customer_ID
    HAVING COUNT(Reservation_ID) >= 3
) C ON R.Customer_ID = C.Customer_ID
GROUP BY H.Hotel_ID, H.HOTEL_NAME;


/* ------ Querry# 09   ------ */

SELECT C.Customer_ID, C.First_Name, C.Last_Name
FROM CUSTOMER C
WHERE NOT EXISTS (
    SELECT H.Hotel_ID
    FROM HOTELS H
    WHERE NOT EXISTS (
        SELECT 1
        FROM RESERVATION R
        WHERE R.Customer_ID = C.Customer_ID
        AND R.Hotel_ID = H.Hotel_ID
    )
);

/* ------ Querry# 10   ------ */

SELECT H.Hotel_ID, H.HOTEL_NAME
FROM HOTELS H
WHERE H.Hotel_ID IN (
    SELECT DISTINCT R.Hotel_ID
    FROM ROOM R
    WHERE NOT EXISTS (
        SELECT 1
        FROM RESERVATION RS
        WHERE RS.Hotel_ID = R.Hotel_ID
        AND (
            (RS.CheckInDate <= '2023-02-01' AND RS.CheckOutDate >= '2023-02-04')

        )
    )
)
AND H.HOTEL_RATING > (
    SELECT AVG(HOTEL_RATING) AS AvgRating
    FROM HOTELS
);


  /* ------ Querry# 11   ------ */

Create Procedure ShowUpdatePrice @HOTEL_ID varchar(15)
AS
begin
UPDATE ROOM SET PRICE_$ = (PRICE_$*1.1) WHERE HOTEL_ID = @HOTEL_ID
end

EXEC ShowUpdatePrice @HOTEL_ID='HOTEL-0001'


  /* ------ Querry# 12   ------ */


CREATE VIEW CustomerReservationDetails AS
SELECT R.Reservation_ID, R.Hotel_ID,R.Room_ID, R.Customer_ID,R.CheckInDate,R.CheckOutDate,C.First_Name + ' ' + C.Last_Name as FULL_NAME 
FROM Reservation as R Join Customer as C On R.Customer_ID=C.Customer_ID;

Select * From CustomerReservationDetails;

  /* ------ Querry# 13   ------ */

Go 
ALTER TABLE Room 
Add Room_Availability varchar(30) Default 'Available';

CREATE TRIGGER Availability
ON Reservation
AFTER INSERT , UPDATE
AS
BEGIN
UPDATE Room
SET Room_Availability = 'Occupied'
FROM Room as Ro INNER JOIN Reservation as R 
ON R.Hotel_ID = Ro.Hotel_ID AND R.Room_ID = Ro.Room_ID 
END;


  /* ------ Querry# 14   ------ */

SELECT C.Customer_Id,R.Hotel_Id,R.Room_Id  From CUSTOMER as C Join RESERVATION as R ON
C.Customer_Id=R.Customer_Id
WHERE Room_ID IN (SELECT *
                        FROM (SELECT Room_ID
                              FROM RESERVATION
                              GROUP BY Room_ID
                              HAVING COUNT(Room_ID) > 1)
                        AS A);


  /* ------ Querry# 15   ------ */


Select Left(First_Name,1) + '' + LEFT(Last_Name,1) as NameInitials from CUSTOMER;


