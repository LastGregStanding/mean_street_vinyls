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
-- Re-enable foreign key checks and commit changes
-- -----------------------------------------------------
SET FOREIGN_KEY_CHECKS=1;
COMMIT;