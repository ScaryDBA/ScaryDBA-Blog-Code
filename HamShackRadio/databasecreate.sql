/*
CREATE DATABASE HamShackRadio
CREATE DATABASE HamShackRadioDev

DROP TABLE dbo.Radio
DROP TABLE dbo.Vendor
DROP TABLE dbo.Band
DROP TABLE dbo.RadioBand
DROP VIEW IF EXISTS dbo.VendorInfo
DROP PROC IF EXISTS dbo.RadioBandInfo

DROP DATABASE HamShackRadio
DROP DATABASE HamShackRadio_grant_SHADOW



*/
USE HamShackRadio;
GO


CREATE TABLE dbo.Radio
(
    RadioID INT IDENTITY(1, 1) NOT NULL
        CONSTRAINT PkRadio PRIMARY KEY CLUSTERED,
    RadioName VARCHAR(50) NOT NULL,
    VendorID INT NOT NULL
);

CREATE TABLE dbo.Vendor
(
    VendorID INT IDENTITY(1, 1) NOT NULL
        CONSTRAINT PkVendor PRIMARY KEY CLUSTERED,
    VendorName VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Band
(
    BandID INT IDENTITY(1, 1) NOT NULL
        CONSTRAINT PkBands PRIMARY KEY CLUSTERED,
    BandName VARCHAR(50) NOT NULL,
    BandRangeBottomKhz DECIMAL(6, 2) NOT NULL,
    BandRangeTopKhz DECIMAL(6, 2) NOT NULL
);

CREATE TABLE dbo.RadioBand
(
    RadioID INT NOT NULL,
    BandID INT NOT NULL,
    Receive BIT NOT NULL,
    Transmit BIT NOT NULL
);

ALTER TABLE dbo.Radio
ADD CONSTRAINT FKVendorRadio
    FOREIGN KEY (VendorID)
    REFERENCES dbo.Vendor (VendorID);

ALTER TABLE dbo.RadioBand
ADD CONSTRAINT PKRadioBand
    PRIMARY KEY CLUSTERED (
                              RadioID,
                              BandID
                          );

ALTER TABLE dbo.RadioBand
ADD CONSTRAINT FKRadioRadioBand
    FOREIGN KEY (RadioID)
    REFERENCES dbo.Radio (RadioID);

ALTER TABLE dbo.RadioBand
ADD CONSTRAINT FKBandRadioBand
    FOREIGN KEY (BandID)
    REFERENCES dbo.Band (BandID);
GO

CREATE OR ALTER PROC dbo.RadioBandInfo
(@RadioID INT)
AS
SELECT r.RadioID,
       r.RadioName,
       r.VendorID,
       rb.RadioID,
       rb.BandID,
       rb.Receive,
       rb.Transmit
FROM dbo.Radio AS r
    JOIN dbo.RadioBand AS rb
        ON rb.RadioID = r.RadioID
WHERE r.RadioID = @RadioID;
GO

CREATE OR ALTER VIEW dbo.VendorInfo
AS
SELECT v.VendorName,
       r.RadioName
FROM dbo.Vendor AS v
    JOIN dbo.Radio AS r
        ON v.VendorID = r.VendorID;
GO

CREATE NONCLUSTERED INDEX RadioNameIdx 
ON dbo.Radio 
(RadioName);
GO


--for later
CREATE TABLE dbo.Customer
(CustomerID INT PRIMARY KEY IDENTITY (1,1),
FirstName VARCHAR(50),
LastName VARCHAR(50)
);
