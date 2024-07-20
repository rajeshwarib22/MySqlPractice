DROP DATABASE IF EXISTS synthetictargeting;
CREATE DATABASE synthetictargeting;
USE synthetictargeting;

CREATE TABLE tgtRegistry(
tgtNumber VARCHAR(50),
tgtDescription TEXT,
tgtDTG DATE,
tgtAGE INT GENERATED ALWAYS AS (DATEDIFF(tgtDTG,'2023-09-01')) STORED,
tgtReportedBy ENUM('AIR','GROUND','SATELLITE','INTEL'),
tgtSurveillance ENUM('CONTINUOUS','INTERMITTENT','NONE'),
remarks TEXT,
CONSTRAINT PK_reg PRIMARY KEY(tgtNumber)
);

CREATE TABLE tgtFeatures(
tgtNumber VARCHAR(50),
tgtProtection ENUM('FORTIFIED','HARDENED','REINFORCED','SOFT'),
tgtMobility ENUM('STATIC','SEMI_STATIC','MOBILE','HIGHLY_MOBILE'),
tgtRestriction ENUM('UNRESTRICTED','RESTRICTED','PROHIBITED'),
tgtStatus ENUM('ACTIVE','INACTIVE'),
CONSTRAINT PK_fea PRIMARY KEY(tgtNumber),
CONSTRAINT FK_fea FOREIGN KEY(tgtNumber) REFERENCES tgtRegistry(tgtNumber)
);

CREATE TABLE tgtGeometry(
tgtNumber VARCHAR(50),
tgtShape ENUM('POINT','AREA'),
tgtLength DECIMAL(10,2),
tgtWidth DECIMAL(10,2),
tgtArea DECIMAL(10,2) GENERATED ALWAYS AS(tgtLength * tgtWidth) STORED,
tgtCoordinates VARCHAR(50),   
CONSTRAINT PK_geo PRIMARY KEY(tgtNumber),
CONSTRAINT FK_geo FOREIGN KEY(tgtNumber) REFERENCES tgtRegistry(tgtNumber)
);




