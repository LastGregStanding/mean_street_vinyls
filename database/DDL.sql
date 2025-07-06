-- -----------------------------------------------------
-- Drop Existing Tables if They Exist (to prevent conflicts)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Rentals CASCADE;
DROP TABLE IF EXISTS Vinyls CASCADE;
DROP TABLE IF EXISTS Artists CASCADE;
DROP TABLE IF EXISTS Patrons CASCADE;

-- -----------------------------------------------------
-- Create Table: Vinyls
-- -----------------------------------------------------
CREATE TABLE Vinyls (
    vinylID SERIAL PRIMARY KEY,
    artistID INT NOT NULL REFERENCES Artists(artistID) ON DELETE CASCADE,
    title TEXT NOT NULL,
    label TEXT NOT NULL,
    yearReleased INT NOT NULL
);

-- -----------------------------------------------------
-- Insert Sample Data: Vinyls
-- -----------------------------------------------------
INSERT INTO Vinyls (artistID, title, label, yearReleased) VALUES
    (1, 'Ride the Lightning', 'Blackened Recordings', 1984),
    (2, 'Fair Warning', 'Warner Bros. Records', 1981),
    (3, 'Let it Be', 'Apple Records', 1970),
    (3, 'Revolver', 'Parlophone', 1966);

-- -----------------------------------------------------
-- Stored Procedure: GetVinylsWithArtists
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION GetVinylsWithArtists()
RETURNS TABLE (
    vinylID INT,
    title TEXT,
    label TEXT,
    yearReleased INT,
    artistName TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT v.vinylID, v.title, v.label, v.yearReleased, a.artistName
    FROM Vinyls v
    LEFT JOIN Artists a ON v.artistID = a.artistID
    ORDER BY v.vinylID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: GetVinyls
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION GetVinyls()
RETURNS TABLE (
    vinylID INT,
    title TEXT,
    yearReleased INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT vinylID, title, yearReleased
    FROM Vinyls
    ORDER BY vinylID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: AddVinyl
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION AddVinyl(
    p_title TEXT,
    p_label TEXT,
    p_yearReleased INT,
    p_artistID INT
)
RETURNS VOID
AS $$
BEGIN
    INSERT INTO Vinyls (title, label, yearReleased, artistID)
    VALUES (p_title, p_label, p_yearReleased, p_artistID);
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: DeleteVinyl
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION DeleteVinyl(p_vinylID INT)
RETURNS VOID
AS $$
BEGIN
    DELETE FROM Vinyls
    WHERE vinylID = p_vinylID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Create Table: Artists
-- -----------------------------------------------------
CREATE TABLE Artists (
    artistID SERIAL PRIMARY KEY,
    artistName TEXT NOT NULL,
    genre TEXT NOT NULL,
    countryOrigin TEXT NOT NULL
);

-- -----------------------------------------------------
-- Insert Sample Data: Artists
-- -----------------------------------------------------
INSERT INTO Artists (artistName, genre, countryOrigin) VALUES
    ('Metallica', 'Metal', 'USA'),
    ('Van Halen', 'Classic Rock', 'USA'),
    ('Beatles', 'Classic Rock', 'UK');

-- -----------------------------------------------------
-- Stored Procedure: GetArtists
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION GetArtists()
RETURNS TABLE (
    artistID INT,
    artistName TEXT,
    genre TEXT,
    countryOrigin TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT artistID, artistName, genre, countryOrigin
    FROM Artists
    ORDER BY artistID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: AddArtist
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION AddArtist(
    p_artistName TEXT,
    p_genre TEXT,
    p_countryOrigin TEXT
)
RETURNS VOID
AS $$
BEGIN
    INSERT INTO Artists (artistName, genre, countryOrigin)
    VALUES (p_artistName, p_genre, p_countryOrigin);
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: DeleteArtist
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION DeleteArtist(p_artistID INT)
RETURNS VOID
AS $$
BEGIN
    DELETE FROM Artists
    WHERE artistID = p_artistID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Create Table: Patrons
-- -----------------------------------------------------
CREATE TABLE Patrons (
    patronID SERIAL PRIMARY KEY,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    membershipDate DATE NOT NULL
);

-- -----------------------------------------------------
-- Insert Sample Data: Patrons
-- -----------------------------------------------------
INSERT INTO Patrons (firstName, lastName, membershipDate) VALUES
    ('Stephanie', 'Lee', '2023-01-15'),
    ('Bob', 'Elliot', '2022-07-10'),
    ('Charles', 'Brown', '2024-02-01');

-- -----------------------------------------------------
-- Stored Procedure: GetPatrons
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION GetPatrons()
RETURNS TABLE (
    patronID INT,
    firstName TEXT,
    lastName TEXT,
    membershipDate DATE
)
AS $$
BEGIN
    RETURN QUERY
    SELECT patronID, firstName, lastName, membershipDate
    FROM Patrons
    ORDER BY patronID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: AddPatron
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION AddPatron(
    p_firstName TEXT,
    p_lastName TEXT,
    p_membershipDate DATE
)
RETURNS VOID
AS $$
BEGIN
    INSERT INTO Patrons (firstName, lastName, membershipDate)
    VALUES (p_firstName, p_lastName, p_membershipDate);
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: DeletePatron
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION DeletePatron(p_patronID INT)
RETURNS VOID
AS $$
BEGIN
    DELETE FROM Patrons
    WHERE patronID = p_patronID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Create Table: Rentals 
-- -----------------------------------------------------
CREATE TABLE Rentals (
    rentalID SERIAL PRIMARY KEY,
    vinylID INT NOT NULL REFERENCES Vinyls(vinylID) ON DELETE CASCADE,
    patronID INT NOT NULL REFERENCES Patrons(patronID) ON DELETE CASCADE,
    rentalDate DATE NOT NULL,
    returnDate DATE
);

-- -----------------------------------------------------
-- Insert Sample Data: Rentals (Demonstrating M:N Relationship)
-- -----------------------------------------------------
INSERT INTO Rentals (vinylID, patronID, rentalDate, returnDate) VALUES
   (1, 1, '2024-11-28', '2024-12-29'),
   (2, 1, '2024-12-22', '2025-01-02'),
   (3, 2, '2025-01-03', '2025-01-25'),
   (3, 3, '2025-01-29', NULL),  
   (4, 3, '2025-02-01', NULL);  

-- -----------------------------------------------------
-- Stored Procedure: AddRental
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION AddRental(
    p_vinylID INT,
    p_patronID INT,
    p_rentalDate DATE
)
RETURNS VOID
AS $$
BEGIN
    INSERT INTO Rentals (vinylID, patronID, rentalDate)
    VALUES (p_vinylID, p_patronID, p_rentalDate);
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: GetRentals
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION GetRentals()
RETURNS TABLE (
    rentalID INT,
    vinylTitle TEXT,
    patronName TEXT,
    rentalDate DATE,
    returnDate DATE
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.rentalID,
        v.title || ' (' || v.yearReleased || ')' AS vinylTitle,
        p.firstName || ' ' || p.lastName || ' (Joined: ' || p.membershipDate || ')' AS patronName,
        r.rentalDate,
        r.returnDate
    FROM Rentals r
    JOIN Vinyls v ON r.vinylID = v.vinylID
    JOIN Patrons p ON r.patronID = p.patronID
    ORDER BY r.rentalID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: GetSpecificRental
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION GetSpecificRental(p_rentalID INT)
RETURNS TABLE (
    rentalDate DATE,
    returnDate DATE
)
AS $$
BEGIN
    RETURN QUERY
    SELECT rentalDate, returnDate FROM Rentals WHERE rentalID = p_rentalID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: UpdateReturnDate
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION UpdateReturnDate(
    p_rentalID INT,
    p_newReturnDate DATE
)
RETURNS VOID
AS $$
BEGIN
    UPDATE Rentals SET returnDate = p_newReturnDate WHERE rentalID = p_rentalID;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Stored Procedure: DeleteRental
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION DeleteRental(p_rentalID INT)
RETURNS VOID
AS $$
BEGIN
    DELETE FROM Rentals WHERE rentalID = p_rentalID;
END;
$$ LANGUAGE plpgsql;
