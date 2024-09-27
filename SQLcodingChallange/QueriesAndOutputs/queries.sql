---- Coding Challenges - PetPals, The Pet Adoption Platform----------

--- TASK 1 -> Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”.

-- SQL Script to create the database schema for the Pet Adoption Platform ”PetPals”.
IF NOT EXISTS (SELECT *
FROM sys.databases
WHERE name = 'PetPals')
BEGIN
    CREATE DATABASE PetPals;
END
GO

-- USING THE DATABASE
USE PetPals;
GO


----------------------------------------------------------------------------------------------------------------------------

--TASK 2 -> Create tables for pets, shelters, donations, adoption events, and participants. 
--TASK 3 -> Define appropriate primary keys, foreign keys, and constraints.  
--TASK 4 -> Ensure the script handles potential errors, such as if the database or tables already exist.

-- Pet Class

-- Check if the Pets table exists, if not create the table
IF NOT EXISTS (SELECT *
FROM sys.tables
WHERE name = 'Pets')
BEGIN
    CREATE TABLE Pets
    (
        PetID INT PRIMARY KEY,
        Name VARCHAR(150),
        Age INT,
        Breed VARCHAR(100),
        Type VARCHAR(50),
        AvailableForAdoption BIT

    );
END
GO
-- Insert sample data into the Pets table
INSERT INTO Pets
    (PetID, Name, Age, Breed, Type, AvailableForAdoption)
VALUES
    (1, 'Sheru', 3, 'Golden Retriever', 'Dog', 1),
    (2, 'Mithu', 2, 'Siamese', 'Cat', 1),
    (3, 'Raja', 1, 'Labrador Retriever', 'Dog', 0),
    (4, 'Golu', 4, 'Persian', 'Cat', 1),
    (5, 'Tiger', 2, 'German Shepherd', 'Dog', 1),
    ( 6, 'Coco', 3, 'Poodle', 'Rabit', 1),
    (7, 'Tommy', 1, 'Bulldog', 'Dog', 0),
    (8, 'Kitty', 2, 'Horses', 'Horse', 1),
    (9, 'Bella', 4, 'Beagle', 'Dog', 1),
    (10, 'Nandini', 2 , 'Inidiaca', 'cow', 5);


----------------------------------------------------------------------------------------------------------------------------

-- Shelter Class
IF NOT EXISTS (SELECT *
FROM sys.tables
WHERE name = 'Shelters')
BEGIN
    CREATE TABLE Shelters
    (
        ShelterID INT PRIMARY KEY,
        Name VARCHAR(150),
        Address VARCHAR(255),
        PhoneNumber VARCHAR(20),
    );
END
GO

-- Insert data into the Shelters table
INSERT INTO Shelters
    (ShelterID, Name, Address, PhoneNumber)
VALUES
    (1, 'Pashu Sewa Kendra', '123 MG Road, Mumbai, Maharashtra', '022-12345678'),
    (2, 'Jeevdaya Sanstha', '456 Brigade Road, Bangalore, Karnataka', '080-23456789'),
    (3, 'Prani Mitra', '789 Park Street, Kolkata, West Bengal', '033-34567890'),
    (4, 'Jeev Raksha', '101 Anna Salai, Chennai, Tamil Nadu', '044-45678901'),
    (5, 'Pashu Raksha', '202 Connaught Place, New Delhi, Delhi', '011-56789012');
GO




----------------------------------------------------------------------------------------------------------------------------
-- Donations Class
IF NOT EXISTS (SELECT *
FROM sys.tables
WHERE name = 'Donations')
BEGIN
    CREATE TABLE Donations
    (
        DonationID INT PRIMARY KEY,
        DonorName VARCHAR(150),
        Amount DECIMAL(10, 2),
        DonationDate DATE
    );
END
GO

-- Insert data into the Donations table
INSERT INTO Donations
    (DonationID, DonorName, Amount, DonationDate)
VALUES
    (1, 'Akash Kumar', 5000.00, '2023-01-15'),
    (2, 'Shreya Sharma', 7500.50, '2023-02-20'),
    (3, 'Vinit Singh', 10000.00, '2023-03-10'),
    (4, 'Adhyatam Patel', 3000.75, '2023-04-05'),
    (5, 'Ayush Joshi', 15000.00, '2023-05-25');


----------------------------------------------------------------------------------------------------------------------------

-- Adoption Events Class
IF NOT EXISTS (SELECT *
FROM sys.tables
WHERE name = 'AdoptionEvents')
BEGIN
    CREATE TABLE AdoptionEvents
    (
        EventID INT PRIMARY KEY,
        EventName VARCHAR(150),
        EventDate DATE,
        Location VARCHAR(255)
    );
END
GO

-- Insert data into the AdoptionEvents table
INSERT INTO AdoptionEvents
    (EventID, EventName, EventDate, Location)
VALUES
    (1, 'Pashu Mels', '2023-01-15', 'Nehru Park, Mumbai, Maharashtra'),
    (2, 'Jeevdaya Mahotsav', '2023-02-20', 'Cubbon Park, Bangalore, Karnataka'),
    (3, 'Prani Utsav', '2023-03-10', 'Eco Park, Kolkata, West Bengal'),
    (4, 'Jeev Raksha Diwas', '2023-04-05', 'Marina Beach, Chennai, Tamil Nadu'),
    (5, 'Pashu Sewa Sammelan', '2023-05-25', 'India Gate, New Delhi, Delhi');





-- Participants Class
IF NOT EXISTS (SELECT *
FROM sys.tables
WHERE name = 'Participants')
BEGIN
    CREATE TABLE Participants
    (
        ParticipantID INT PRIMARY KEY,
        EventID INT,
        PetID INT,
        FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID),
        FOREIGN KEY (PetID) REFERENCES Pets(PetID)
    );
END
GO

-- Insert data into the Participants table
INSERT INTO Participants
    (ParticipantID, EventID, PetID)
VALUES
    (1, 3, 1),
    (2, 5, 2),
    (3, 1, 3),
    (4, 2, 4),
    (5, 4, 5); 
GO



----------------------------------------------------------------------------------------------------------------------------

-- TASK 5 -> SQL query that retrieves a list of available pets (those marked as available for adoption) from the "Pets" table.
-- Include the pet's name, age, breed, and type in the result set.
-- Ensure that the query filters out pets that are not available for adoption. 

SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 1;
GO


----------------------------------------------------------------------------------------------------------------------------

-- TASK 6 -> SQL query that retrieves the names of participants (shelters and adopters) registered 
-- for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query 
-- joins the necessary tables to retrieve the participant names and types

DECLARE @EventID INT = 1;


SELECT
    p.ParticipantID,
    s.Name AS ShelterName,
    d.DonorName AS AdopterName,
    e.EventName
FROM
    Participants p
    LEFT JOIN
    Shelters s ON p.ParticipantID = s.ShelterID
    LEFT JOIN
    Donations d ON p.ParticipantID = d.DonationID
    INNER JOIN
    AdoptionEvents e ON p.EventID = e.EventID
WHERE 
    p.EventID = @EventID;
GO


----------------------------------------------------------------------------------------------------------------------------
-- TASK 7 -> a stored procedure in SQL that allows a shelter to update its information (name and 
-- location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information. 
-- Ensure that the procedure performs the update and handles potential errors, such as an invalid 
-- shelter ID.
CREATE PROCEDURE UpdateShelterInfos
    @ShelterID INT,
    @NewName VARCHAR(150),
    @NewAddress VARCHAR(255)
AS
BEGIN
    -- Start a transaction  (Forr handling potential errors and data consistency)
    BEGIN TRANSACTION;

    -- Check if the shelter ID exists
    IF EXISTS (SELECT 1
    FROM Shelters
    WHERE ShelterID = @ShelterID)
    BEGIN
        -- Perform the update
        UPDATE Shelters
        SET Name = @NewName,
            Address = @NewAddress
        WHERE ShelterID = @ShelterID;

        -- Commit the transaction
        COMMIT TRANSACTION;
        PRINT 'Shelter information updated successfully.';
    END
    ELSE
    BEGIN
        -- Rollback the transaction (if sheltert id is invalid)
        ROLLBACK TRANSACTION;
        PRINT 'Invalid Shelter ID. Please provide a valid Shelter ID.';
    END
END
GO

-- Execute the stored procedure to update shelter information
EXEC UpdateShelterInfos
 @ShelterID = 1, @NewName = 'Pashu Sewa Kendra',
  @NewAddress = '456 New Street, Mumbai, Maharashtra';



----------------------------------------------------------------------------------------------------------------------------

-- TASK 8 ->SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table.
-- The result should include the shelter name and the total donation amount. Ensure that the query handles cases where a shelter has received no donations


-- In the table there is no direct relation between Shelter and Donation
-- I am assuming that the ShelterID in the Shelters table is the same as the DonationID in the Donations table.

SELECT
    s.Name AS ShelterName,
    ISNULL(SUM(d.Amount), 0) AS TotalDonationAmount
FROM
    Shelters s
    LEFT JOIN
    Donations d ON s.ShelterID = d.DonationID
GROUP BY
    s.Name;
GO


----------------------------------------------------------------------------------------------------------------------------
-- TASK 9 -> SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). 
--Include the pet's name, age, breed, and type in the result set

-- There is no OwnerID column in the Pets table,so I am creating a new table called Owners and adding OwnerID column to the Pets table.
CREATE TABLE Owners
(
    OwnerID INT PRIMARY KEY,
    Name VARCHAR(150),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20)
);
GO
--Inserting data into the Owners table
INSERT INTO Owners
    (OwnerID, Name, Address, PhoneNumber)
VALUES
    (1, 'Akash Kumar', '101 Gorakhpur Uttar bradesh', '033-12345678'),
    (2, 'Shreya Sharma', '202 Brigade Road, Bangalore, Karnataka', '080-23456789'),
    (3, 'Vinit Singh', '303Andhero  Mumbai, Maharashtra', '022-34567890'),
    (4, 'Adhyatam Patel', '404 Vijayawada, Chennai, Tamil Nadu', '044-45678901'),
    (5, 'Ayush Joshi', '505 Connaught Place, New Delhi, Delhi', '011-56789012');
GO

--Adding OwnerID column to the Pets table
ALTER TABLE Pets
ADD OwnerID INT;
GO
-- Adding foreign key constraint to the OwnerID column
ALTER TABLE Pets
ADD CONSTRAINT FK_OwnerID FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID);


SELECT Name, Age, Breed, Type
FROM Pets
WHERE OwnerID IS NULL;



----------------------------------------------------------------------------------------------------------------------------
--TASK 10 ->> SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) from the "Donations" table.
--  The result should include the month-year and the corresponding total donation amount. Ensure that the query handles cases where no donations 
-- were made in a specific month-year

SELECT
    -- Using FORMAT function to get the month and year in the desired format
    FORMAT(DonationDate, 'MMMM yyyy') AS MonthYear,
    -- Using ISNULL to handle cases where no donations were made in a specific month-year
    ISNULL(SUM(Amount), 0) AS TotalDonationAmount
FROM
    Donations
GROUP BY
    FORMAT(DonationDate, 'MMMM yyyy');
GO



----------------------------------------------------------------------------------------------------------------------------
--TASK 11 ->>Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years

SELECT DISTINCT Breed
FROM Pets
WHERE (Age BETWEEN 1 AND 3) OR (Age > 5);
GO


----------------------------------------------------------------------------------------------------------------------------

-- TASK 12 -> Retrieve a list of pets and their respective shelters where the pets are currently available for adoption. 

-- There is no direct relation between Pets and Shelters in the schema provided,
-- So I am altering the Pets table to add a ShelterID column and creating a foreign key relationship with the Shelters table.

-- Adding ShelterID column to the Pets table
ALTER TABLE Pets
ADD ShelterID INT;
GO

-- Adding foreign key constraint to the ShelterID column
ALTER TABLE Pets
ADD CONSTRAINT FK_ShelterID FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID);

-- Adding foreign key values to the Pets table
UPDATE Pets
SET ShelterID = 1
WHERE PetID IN (6, 2);

UPDATE Pets
SET ShelterID = 2
WHERE PetID IN (3, 5);

UPDATE Pets
SET ShelterID = 3
WHERE PetID  IN (4,1);

UPDATE Pets
SET ShelterID = 4
WHERE PetID  IN (7, 10);

UPDATE Pets
SET ShelterID = 5
WHERE PetID  IN (8, 9);

SELECT
    p.Name AS PetName,
    p.Breed,
    p.Type,
    s.Name AS ShelterName
FROM
    Pets p
    INNER JOIN
    Shelters s ON p.ShelterID = s.ShelterID
WHERE
    p.AvailableForAdoption = 1;
GO



----------------------------------------------------------------------------------------------------------------------------

-- TASK 13 -> Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai 

DECLARE @City VARCHAR(50) = 'Chennai';

SELECT
    COUNT(p.ParticipantID) AS TotalParticipants
FROM
    Participants p
    INNER JOIN
    AdoptionEvents e ON p.EventID = e.EventID
    INNER JOIN
    Shelters s ON e.Location LIKE '%' + @City + '%';
GO


----------------------------------------------------------------------------------------------------------------------------

-- TASK 14 ->  Retrieve a list of unique breeds for pets with ages between 1 and 5 years.

SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5;

----------------------------------------------------------------------------------------------------------------------------

-- TASK 15 -> Find the pets that have not been adopted by selecting their information from the 'Pet' table

-- There was no Owner ID initially in the Pets table, so I added the OwnerID column  in above Queries to meet the requirements.

-- Adding foreign key values to the Pets table
UPDATE Pets
SET OwnerID = 1
WHERE PetID IN (1, 2);

UPDATE Pets
SET OwnerID = 2
WHERE PetID IN (3, 4);

UPDATE Pets
SET OwnerID = 3
WHERE PetID  = 5;

SELECT *
FROM Pets
WHERE OwnerID IS NULL;

----------------------------------------------------------------------------------------------------------------------------

-- TASK 16 -> Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
-- There is no adoption table in the schema provided. So I used pets and owners table to meet the requirements.
-- I have added the OwnerID column in the Pets table and added the Owners table to meet the requirements.
--Instead of the User table, I have used the Owners table to represent the adopter's information.

SELECT
    p.Name AS PetName,
    o.Name AS AdopterName
FROM
    Pets p
    INNER JOIN
    Owners o ON p.OwnerID = o.OwnerID;
GO


----------------------------------------------------------------------------------------------------------------------------

-- TASK 17 -> Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter

SELECT
    s.Name AS ShelterName,
    COUNT(p.PetID) AS AvailablePetsCount
FROM
    Shelters s
    LEFT JOIN
    Pets p ON s.ShelterID = p.ShelterID
WHERE
    p.AvailableForAdoption = 1
GROUP BY
    s.Name;
GO


----------------------------------------------------------------------------------------------------------------------------

-- TASK 18 ->Find pairs of pets from the same shelter that have the same breed.


-- Using a self-join on the Pets table to find pairs of pets with the same breed from the same shelter
SELECT
    p1.Name AS Pet1Name,
    p2.Name AS Pet2Name,
    p1.Breed
FROM
    Pets p1
    INNER JOIN
    Pets p2 ON p1.ShelterID = p2.ShelterID
        AND p1.Breed = p2.Breed
WHERE
-- Ensuring that the pets are different and not the same pet
    p1.PetID < p2.PetID;
GO
--There is no matching pair of pets with the same breed from the same shelter in the sample data provided.

----------------------------------------------------------------------------------------------------------------------------

-- TASK 19 ->List all possible combinations of shelters and adoption events

-- Using a CROSS JOIN to find all possible combinations of shelters and adoption events
SELECT
    s.Name AS ShelterName,
    e.EventName
FROM
    Shelters s
    CROSS JOIN
    AdoptionEvents e;
GO


----------------------------------------------------------------------------------------------------------------------------

--TASK 20 -> Determine the shelter that has the highest number of adopted pets.

-- There is no direct relation between Shelters and Pets in the schema provided,
-- So I have added shelterID column to the Pets table and created a foreign key relationship with the Shelters table.
-- I have also added OwnerID column to the Pets table to represent the adopted pets.




-- Query to find the shelter with the highest number of adopted pets
SELECT TOP 1
    s.Name AS ShelterName,
    COUNT(p.PetID) AS AdoptedPetsCount
FROM
    Shelters s
    INNER JOIN
    Pets p ON s.ShelterID = p.ShelterID
WHERE
    p.OwnerID IS NOT NULL
GROUP BY
    s.Name
ORDER BY
    COUNT(p.PetID) DESC;
GO
