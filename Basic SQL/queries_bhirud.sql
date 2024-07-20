-- Task 3 : This file contains code required to complete queries 1-4


-- Problem 1 : What are the number of days/months/years since Jan 1, 2024, for all viruses detected at NYC Campus
-- that were detected after August 1, 2022. (Assume all months have 30 days)

select 
vr.VirusName,
vr.VirusSeqID,
vr.DetectedAt,
v.Discovery as 'Discovered On',
datediff('2024-01-01', v.Discovery) AS 'Days Elapsed',
round(datediff('2024-01-01', v.Discovery) / 30,2) AS 'Months Elapsed',
round(datediff('2024-01-01', v.Discovery) / 365,2) AS 'Years Elapsed'
from virus_registry vr 
join virus v on v.VirusSeqID = vr.VirusSeqID
where
vr.DetectedAt = 'NYC'
AND v.Discovery > '2022-08-01'; 


-- Problem 2 : List the virus detections at the Pleasantville campus that were within 60 days before or after Christmas 
-- (Dec 25) 2022

select 
vr.VirusName,
vr.VirusSeqID,
vr.DetectedAt,
v.Discovery as 'Discovered On',
abs(datediff('2022-12-25', v.Discovery)) AS 'Days Before/After Chritmas'
from virus_registry vr 
join virus v on v.VirusSeqID = vr.VirusSeqID
where
vr.DetectedAt = 'PV'
AND v.Discovery BETWEEN DATE_SUB('2022-12-25', INTERVAL 60 DAY)
AND DATE_ADD('2022-12-25', INTERVAL 60 DAY); 


-- Problem 3: List all viruses whose PreScript code starts with an:
--  'e' and ends with a 'b'
--  'f' and ends with a 'y'
--  'f' and ends with a 'f'

select 
vr.VirusName,
vr.VirusSeqID,
vc.PreScript
from virus_registry vr 
join virus_codebase vc on vc.VirusSeqID = vr.VirusSeqID
where
vc.PreScript like 'e%b'
or vc.PreScript like 'f%y'
or vc.PreScript like 'f%f';


-- Problem 4 : List all viruses whose PreScript, MainScript, or PostScript contains a 3-digit alpha numeric sequence that 
-- starts with 'e5'

select 
JSON_OBJECT('ID',vr.VirusSeqID,'Name',vr.VirusName,'Location Found',vr.DetectedAt) as 'Virus Registry',
vc.PreScript,
vc.MainScript,
vc.PostScript
from virus_registry vr 
join virus_codebase vc on vc.VirusSeqID = vr.VirusSeqID
where vc.PreScript like 'e5%'
or vc.MainScript like 'e5%'
or vc.PostScript like 'e5%';


-- Task 4: The problem given on Exam sheet. 
-- Create table T1 

drop table if exists T1;
create table T1 (
VirusID VARCHAR(50),
VirudCode JSON,
VirusDiscovery DATE,
VirusFoundAt VARCHAR(50),
DaySinceDiscovery INT GENERATED ALWAYS AS (datediff('2024-02-27', v.VirusDiscovery)) STORED,
CONSTRAINT pk_Vid PRIMARY KEY(VirusID)
);


desc T1;


-- populate the table T1

INSERT INTO T1 (VirusID, VirudCode, VirusDiscovery, VirusFoundAt)
SELECT  
CONCAT(vr.VirusName, '***', vr.VirusSeqID) AS 'VirusID',
JSON_OBJECT('Pre-Script', vc.PreScript, 'Main-Script', vc.MainScript, 'Post-Script', vc.PostScript) AS 'VirusCode',
v.Discovery AS 'VirusDiscovery',
vr.DetectedAt AS 'VirusFoundAt'
FROM 
virus_registry vr 
JOIN 
virus_codebase vc ON vc.VirusSeqID = vr.VirusSeqID
JOIN 
virus v ON v.VirusSeqID = vr.VirusSeqID
WHERE
vr.DetectedAt = 'NYC'
order by VirusID ;


-- to display first 10 rows of T1
select * from T1
limit 10;
