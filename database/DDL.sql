-- -----------------------------------------------------
-- Disable foreign key checks to prevent constraint errors during inserts
-- -----------------------------------------------------
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;

-- -----------------------------------------------------
-- Drop Existing Tables if They Exist (to prevent conflicts)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Patrons;

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