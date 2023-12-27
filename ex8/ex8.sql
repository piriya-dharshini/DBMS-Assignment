-- Create the table
DROP TABLE RentalProperty;
DROP TABLE Owners cascade constraints;
DROP TABLE customer cascade constraints;
DROP TABLE rentalhistory cascade constraints;
DROP TABLE property cascade constraints;
CREATE TABLE RentalProperty (
    ClientNo VARCHAR2(5),
    Cname VARCHAR2(50),
    PropNo VARCHAR2(5),
    PAddr VARCHAR2(100),
    RntSt DATE,
    RntFnsh DATE,
    Rent NUMBER,
    OwnerNo VARCHAR2(5),
    OName VARCHAR2(50),
    PRIMARY KEY(ClientNo, PropNo)
);

-- Insert data into the table
INSERT INTO RentalProperty (ClientNo, Cname, PropNo, PAddr, RntSt, RntFnsh, Rent, OwnerNo, OName)
VALUES 
    ('CR76', 'John Kay', 'PG4', '6 Lawrence St, Elmont', TO_DATE('2010-07-01', 'YYYY-MM-DD'), TO_DATE('2006-09-01', 'YYYY-MM-DD'), 700, 'CO40', 'Tina Murphy');

INSERT INTO RentalProperty (ClientNo, Cname, PropNo, PAddr, RntSt, RntFnsh, Rent, OwnerNo, OName)
VALUES     
    ('CR76', 'John Kay', 'PG16', '5 Nova Dr, East Meadow', TO_DATE('2006-08-31', 'YYYY-MM-DD'), TO_DATE('2008-09-01', 'YYYY-MM-DD'), 900, 'CO93', 'Tony Shaw');

INSERT INTO RentalProperty (ClientNo, Cname, PropNo, PAddr, RntSt, RntFnsh, Rent, OwnerNo, OName)
VALUES 
    ('CR56', 'Aline Stewart', 'PG4', '6 Lawrence St, Elmont', TO_DATE('2002-09-01', 'YYYY-MM-DD'), TO_DATE('2004-08-01', 'YYYY-MM-DD'), 700, 'CO40', 'Tina Murphy');

INSERT INTO RentalProperty (ClientNo, Cname, PropNo, PAddr, RntSt, RntFnsh, Rent, OwnerNo, OName)
VALUES 
    ('CR56', 'Aline Stewart', 'PG36', '2 Manor Rd, Scarsdale', TO_DATE('2004-06-10', 'YYYY-MM-DD'), TO_DATE('2005-12-01', 'YYYY-MM-DD'), 750, 'CO93', 'Tony Shaw');

INSERT INTO RentalProperty (ClientNo, Cname, PropNo, PAddr, RntSt, RntFnsh, Rent, OwnerNo, OName)
VALUES     
    ('CR56', 'Aline Stewart', 'PG16', '5 Nova Dr, East Meadow', TO_DATE('2006-09-01', 'YYYY-MM-DD'), TO_DATE('2010-09-01', 'YYYY-MM-DD'), 900, 'CO93', 'Tony Shaw');

SELECT
    ClientNo || ', ' ||
    Cname || ', ' ||
    PropNo || ', ' ||
    PAddr || ', ' ||
    TO_CHAR(RntSt, 'YYYY-MM-DD') || ', ' ||
    TO_CHAR(RntFnsh, 'YYYY-MM-DD') || ', ' ||
    Rent || ', ' ||
    OwnerNo || ', ' ||
    OName AS FullRow
FROM RentalProperty;

-- Create the table
CREATE TABLE Owners (
    OwnerNo VARCHAR2(5) PRIMARY KEY,
    OName VARCHAR2(50)
);

-- Insert data into the table
INSERT INTO Owners (OwnerNo, OName)
VALUES ('CO40', 'Tina Murphy');

INSERT INTO Owners (OwnerNo, OName)
VALUES ('CO93', 'Tony Shaw');

-- Display the contents of the table
SELECT * FROM Owners;

-- Create the table
CREATE TABLE Customer (
    ClientNo VARCHAR2(5) PRIMARY KEY,
    CName VARCHAR2(50)
);

-- Insert data into the table
INSERT INTO Customer (ClientNo, CName)
VALUES ('CR76', 'John Kay');

INSERT INTO Customer (ClientNo, CName)
VALUES ('CR56', 'Aline Stewart');

-- Display the contents of the table
SELECT * FROM Customer;

-- Create the table
CREATE TABLE RentalHistory (
    ClientNo VARCHAR2(5),
    PropNo VARCHAR2(5),
    RentStart DATE,
    RentFinish DATE,
    PRIMARY KEY (ClientNo, PropNo),
    FOREIGN KEY (ClientNo) REFERENCES Customer(ClientNo)
);

-- Insert data into the table
INSERT INTO RentalHistory (ClientNo, PropNo, RentStart, RentFinish)
VALUES ('CR76', 'PG4', TO_DATE('7/1/10', 'MM/DD/YY'), TO_DATE('8/31/06', 'MM/DD/YY'));

INSERT INTO RentalHistory (ClientNo, PropNo, RentStart, RentFinish)
VALUES ('CR76', 'PG16', TO_DATE('9/1/06', 'MM/DD/YY'), TO_DATE('9/1/08', 'MM/DD/YY'));

INSERT INTO RentalHistory (ClientNo, PropNo, RentStart, RentFinish)
VALUES ('CR56', 'PG4', TO_DATE('9/1/02', 'MM/DD/YY'), TO_DATE('6/10/04', 'MM/DD/YY'));

INSERT INTO RentalHistory (ClientNo, PropNo, RentStart, RentFinish)
VALUES ('CR56', 'PG36', TO_DATE('1/1/04', 'MM/DD/YY'), TO_DATE('12/1/05', 'MM/DD/YY'));

INSERT INTO RentalHistory (ClientNo, PropNo, RentStart, RentFinish)
VALUES ('CR56', 'PG16', TO_DATE('8/1/06', 'MM/DD/YY'), TO_DATE('9/1/10', 'MM/DD/YY'));

-- Display the contents of the table
SELECT * FROM RentalHistory;

-- Create the table
CREATE TABLE Property (
    PropNo VARCHAR2(5) PRIMARY KEY,
    PAddr VARCHAR2(100),
    Rent INT,
    OwnerNo VARCHAR2(5),
    FOREIGN KEY (OwnerNo) REFERENCES Owners(OwnerNo)
);

-- Insert data into the table
INSERT INTO Property (PropNo, PAddr, Rent, OwnerNo)
VALUES ('PG4', '6 Lawrence St, Elmont', 700, 'CO40');

INSERT INTO Property (PropNo, PAddr, Rent, OwnerNo)
VALUES ('PG16', '5 Nova Dr, East Meadow', 900, 'CO93');

INSERT INTO Property (PropNo, PAddr, Rent, OwnerNo)
VALUES ('PG36', '2 Manor Rd, Scarsdale', 750, 'CO93');

-- Display the contents of the table
SELECT * FROM Property;


-- Display information from joined tables
-- Display information from joined tables
SELECT
    c.ClientNo,
    c.Cname,
    p.PropNo,
    p.PAddr,
    p.Rent,
    rh.RentStart,
    rh.RentFinish,
    o.Oname,
    o.OwnerNo
FROM Property p
JOIN Owners o ON p.OwnerNo = o.OwnerNo
JOIN RentalHistory rh ON p.PropNo = rh.PropNo
JOIN Customer c ON rh.ClientNo = c.ClientNo;


select * from RentalProperty;