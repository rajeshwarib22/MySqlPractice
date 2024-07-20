-- Task 1 :
-- To create database for viralgrey
DROP DATABASE IF EXISTS viralgrey;
CREATE DATABASE viralgrey;
USE viralgrey;



create table virus_registry(
VirusName varchar(50),
VirusSeqID varchar(50),
DetectedAt enum('NYC','PV','WP'),
constraint pk_vrsid primary key(VirusSeqID) 
);

desc virus_registry;
SELECT 'virus_registry table is created' AS MSG;

create table virus(
VirusSeqID varchar(50),
Discovery date,
Creator enum('State_Actor','Individual','Unknown'),
constraint pk_vsid primary key(VirusSeqID),
constraint fk_vsid foreign key(VirusSeqID) references virus_registry(VirusSeqID)
);

desc virus;
SELECT 'virus table is created' AS MSG;

create table virus_components(
VirusSeqID varchar(50),
Payload varchar(50),
VTrigger varchar(50),
constraint pk_vcsid primary key(VirusSeqID),
constraint fk_vcsid foreign key(VirusSeqID) references virus(VirusSeqID)
);

desc virus_components;
SELECT 'virus_components table is created' AS MSG;

create table virus_stealth(
VirusSeqID varchar(50),
Encryption enum('YES','NO'),
Obfuscation enum('YES','NO'),
constraint pk_vssid primary key(VirusSeqID),
constraint fk_vssid foreign key(VirusSeqID) references virus(VirusSeqID)
);

desc virus_stealth;
SELECT 'virus_stealth table is created' AS MSG;

create table virus_target(
VirusSeqID varchar(50),
TargetOS enum('Windows','Linux','PLC'),
EmbeddedIn enum('File','Macro','Boot_Sector'),
constraint pk_vtsid primary key(VirusSeqID),
constraint fk_vtsid foreign key(VirusSeqID) references virus(VirusSeqID)
);

desc virus_target;
SELECT 'virus_target table is created' AS MSG;

create table virus_replication(
VirusSeqID varchar(50),
Replication varchar(50),
PopulationGrowth enum('HIGH','LOW'),
IsDropper enum('YES','NO'),
constraint pk_vrsid primary key(VirusSeqID),
constraint fk_vrsid foreign key(VirusSeqID) references virus(VirusSeqID)
);

desc virus_replication;
SELECT 'virus_replication table is created' AS MSG;

create table virus_codebase(
VirusSeqID varchar(50),
PreScript varchar(100),
MainScript varchar(100),
PostScript varchar(100),
Script text,
constraint pk_vcsid1 primary key(VirusSeqID),
constraint fk_vcsid1 foreign key(VirusSeqID) references virus(VirusSeqID)
);

desc virus_codebase;
SELECT 'virus_codebase table is created' AS MSG;



SELECT 'viralgrey database is created' AS MSG;

-- Task 2 : populate the database