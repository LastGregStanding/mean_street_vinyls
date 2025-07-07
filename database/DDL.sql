-- -----------------------------------------------------
-- Disable foreign key checks to prevent constraint errors during inserts
-- -----------------------------------------------------
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;

-- -----------------------------------------------------
-- Drop Existing Tables if They Exist (to prevent conflicts)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Vinyls;
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Patrons;
DROP TABLE IF EXISTS Rentals;

-- -----------------------------------------------------
-- Create Table: Vinyls
-- -----------------------------------------------------
CREATE TABLE Vinyls (
    vinylID INT AUTO_INCREMENT UNIQUE NOT NULL,
    artistID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    label VARCHAR(100) NOT NULL,
    yearReleased INT NOT NULL,
    PRIMARY KEY (vinylID),
    FOREIGN KEY (artistID) REFERENCES Artists(artistID) ON DELETE CASCADE
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
DROP PROCEDURE IF EXISTS GetVinylsWithArtists;
DELIMITER //
CREATE PROCEDURE GetVinylsWithArtists()
BEGIN
    SELECT Vinyls.vinylID,
           Vinyls.title,
           Vinyls.label,
           Vinyls.yearReleased,
           Artists.artistName
    FROM Vinyls
    LEFT JOIN Artists ON Vinyls.artistID = Artists.artistID
    ORDER BY Vinyls.vinylID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: GetVinyls
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS GetVinyls;
DELIMITER //
CREATE PROCEDURE GetVinyls()
BEGIN
    SELECT vinylID, title, yearReleased FROM Vinyls ORDER BY vinylID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: AddVinyl
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS AddVinyl;
DELIMITER //
CREATE PROCEDURE AddVinyl (
    IN p_title VARCHAR(100),
    IN p_label VARCHAR(100),
    IN p_yearReleased INT,
    IN p_artistID INT
)
BEGIN
    INSERT INTO Vinyls (title, label, yearReleased, artistID)
    VALUES (p_title, p_label, p_yearReleased, p_artistID);
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: DeleteVinyl
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS DeleteVinyl;
DELIMITER //
CREATE PROCEDURE DeleteVinyl(IN p_vinylID INT)
BEGIN
    DELETE FROM Vinyls
    WHERE vinylID = p_vinylID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Create Table: Artists
-- -----------------------------------------------------
CREATE TABLE Artists (
    artistID INT AUTO_INCREMENT UNIQUE NOT NULL,
    artistName VARCHAR(100) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    countryOrigin VARCHAR(100) NOT NULL,
    PRIMARY KEY (artistID)
);

-- -----------------------------------------------------
-- Insert Sample Data: Artists
-- -----------------------------------------------------
INSERT INTO Artists (artistName, genre, countryOrigin) VALUES
    ('Metallica', 'Metal', "USA"),
    ('Van Halen', 'Classic Rock', "USA"),
    ('Beatles', 'Classic Rock', "UK");

-- -----------------------------------------------------
-- Stored Procedure: GetArtists
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS GetArtists;
DELIMITER //
CREATE PROCEDURE GetArtists()
BEGIN
    SELECT artistID, artistName, genre, countryOrigin FROM Artists ORDER BY artistID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: AddArtist
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS AddArtist;
DELIMITER //
CREATE PROCEDURE AddArtist (
    IN p_artistName VARCHAR(100),
    IN p_genre VARCHAR(100),
    IN p_countryOrigin VARCHAR(100)
)
BEGIN
    INSERT INTO Artists (artistName, genre, countryOrigin)
    VALUES (p_artistName, p_genre, p_countryOrigin);
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: DeleteArtist
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS DeleteArtist;
DELIMITER //
CREATE PROCEDURE DeleteArtist(IN p_artistID INT)
BEGIN
    DELETE FROM Artists
    WHERE artistID = p_artistID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Create Table: Patrons
-- -----------------------------------------------------
CREATE TABLE Patrons (
    patronID INT AUTO_INCREMENT UNIQUE NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    membershipDate DATE NOT NULL,
    PRIMARY KEY (patronID)
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
DROP PROCEDURE IF EXISTS GetPatrons;
DELIMITER //
CREATE PROCEDURE GetPatrons()
BEGIN
    SELECT patronID, firstName, lastName, membershipDate FROM Patrons ORDER BY patronID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: AddPatron
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS AddPatron;
DELIMITER //
CREATE PROCEDURE AddPatron (
    IN p_firstName VARCHAR(100),
    IN p_lastName VARCHAR(100),
    IN p_membershipDate DATE
)
BEGIN
    INSERT INTO Patrons (firstName, lastName, membershipDate)
    VALUES (p_firstName, p_lastName, p_membershipDate);
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: DeletePatron
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS DeletePatron;
DELIMITER //
CREATE PROCEDURE DeletePatron(IN p_patronID INT)
BEGIN
    DELETE FROM Patrons
    WHERE patronID = p_patronID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Create Table: Rentals 
-- -----------------------------------------------------
CREATE TABLE Rentals (
    rentalID INT AUTO_INCREMENT UNIQUE NOT NULL,
    vinylID INT NOT NULL,
    patronID INT NOT NULL,
    rentalDate DATE NOT NULL,
    returnDate DATE NULL,
    PRIMARY KEY (rentalID),
    FOREIGN KEY (vinylID) REFERENCES Vinyls(vinylID) ON DELETE CASCADE,
    FOREIGN KEY (patronID) REFERENCES Patrons(patronID) ON DELETE CASCADE
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

DROP PROCEDURE IF EXISTS AddRental;
DELIMITER //
CREATE PROCEDURE AddRental (
    IN p_vinylID INT,
    IN p_patronID INT,
    IN p_rentalDate DATE
)
BEGIN
    INSERT INTO Rentals (vinylID, patronID, rentalDate)
    VALUES (p_vinylID, p_patronID, p_rentalDate);
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: GetRentals
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS GetRentals;
DELIMITER //
CREATE PROCEDURE GetRentals()
BEGIN
    SELECT
        Rentals.rentalID,
        CONCAT(Vinyls.title, ' (', Vinyls.yearReleased, ')') AS vinylTitle,
        CONCAT(Patrons.firstName, ' ', Patrons.lastName, ' (Joined: ', Patrons.membershipDate, ')') AS patronName,
        Rentals.rentalDate,
        Rentals.returnDate
    FROM Rentals
    JOIN Vinyls ON Rentals.vinylID = Vinyls.vinylID
    JOIN Patrons ON Rentals.patronID = Patrons.patronID
    ORDER BY Rentals.rentalID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: GetSpecificRental
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS GetSpecificRental;
DELIMITER //
CREATE PROCEDURE GetSpecificRental(IN p_rentalID INT)
BEGIN
    SELECT
        Rentals.rentalDate,
        Rentals.returnDate
    FROM Rentals
    WHERE rentalID = p_rentalID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: UpdateReturnDate
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS UpdateReturnDate;
DELIMITER //
CREATE PROCEDURE UpdateReturnDate(IN p_rentalID INT, IN p_newReturnDate DATE)
BEGIN
    UPDATE Rentals
    SET returnDate = p_newReturnDate
    WHERE rentalID = p_rentalID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Stored Procedure: DeleteRental
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS DeleteRental;
DELIMITER //
CREATE PROCEDURE DeleteRental(IN p_rentalID INT)
BEGIN
    DELETE FROM Rentals
    WHERE rentalID = p_rentalID;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Re-enable foreign key checks and commit changes
-- -----------------------------------------------------
SET FOREIGN_KEY_CHECKS=1;
COMMIT;