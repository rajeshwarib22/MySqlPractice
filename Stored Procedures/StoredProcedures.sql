use asteroids;


-- Stored Procedure 1 : Create the Stored Procedure showType which accepts an Asteroid Type (T) and an integer 
-- (C)as its parameters and returns the data about the specified number (C) of asteroids of that 
-- type (T) in the format shown below.

drop procedure if exists showType;
delimiter //
create procedure showType(t varchar(50), c int)
begin
	-- Declare variables 
	declare i, r int;
	declare desig,at,country,season varchar(50);
	declare dd date;


	-- Declare cursor
	declare cur cursor for
		select * from registry
		where atype = t 
		limit c;
	-- Perform operation on data collected in cursor
	open cur;
	set r = found_rows();
	set i = 0;
	while i < r do 
		fetch cur into desig, at, country, dd;
		if at = 'Carboneous' then 
			set at = 'CARBON_BASED';
		elseif at = 'Metallic' then 
			set at = 'METAL_BASED';
		elseif at = 'Silicaceous' then 
			set at = 'SILICON_BASED';
		end if;

		if country = 'US' then 
			set country = 'United States';
		elseif country = 'UK' then 
			set country = 'United Kingdom';
		elseif country = 'RUSSIA' then 
			set country = 'Russian Federaion';
		elseif country = 'CHINA' then 
			set country = 'People''s Republic of China' ;
		end if;

		if month(dd) >= 11 OR month(dd) <= 3 THEN
			set season = 'Winter';
		elseif month(dd) >= 4 and month(dd) <= 5 then
			set season = 'Spring';
		elseif month(dd) >= 6 and month(dd) <= 8 then
			set season = 'Summer';
		elseif month(dd) >= 9 and month(dd) <= 10 then
			set season = 'Fall';
		end if;

		select concat(desig,' Type : ', at ,' Asteriod Country: ',country,' Season: ',season,' ',year(dd)) AS F_Data;
		set i = i + 1;
	end while;


end //
delimiter ;

call showType('Carboneous',3);
-- call showType('Metallic',3);
-- call showType('Silicaceous',3);




-- Stored Procedure 2 : to show value which accepts an Asteroid Designation (A) and 
-- calculates the total value of its strategic metals and displays the total value in the format 
-- shown below.

drop procedure if exists showValue;
delimiter //
create procedure showValue(desig varchar(50))
begin
    -- Declare variables
    declare i, r int;
    declare ch, co, tu, ur decimal(10,2);
    declare totalValue decimal(10,2);
    
    -- Declare cursor
    declare cur cursor for 
        select Chromium, Cobalt, Tungsten, Uranium 
        from composition_strategic 
        where Designation = desig;

    -- Perform operation on data collected in cursor
    open cur;
    set totalValue = 0;
    set r = found_rows();
	set i = 0;

    while i < r do
		fetch cur into ch,co,tu,ur;		
		set totalValue = ch * 12.50 + co * 9.25 + tu * 7.75 + ur * 10.00;
		select concat(desig,' has a value of $',totalValue) AS MSG;
		set i = i + 1;
	end while;
    close cur;
end//
delimiter ;

call showValue('C-a3598-j');
-- call showValue('M-b716-p');
-- call showValue('S-f377-j');



-- Stored Procedure 3 : Create the Stored Procedure showEachValue which accepts a JSON Array (of any length) of 
-- Asteroid Designations (A) and calculates the total value of each of their strategic metals and 
-- displays the total values in the format shown below.

drop procedure if exists showEachValue;
delimiter //
create procedure showEachValue(desig_jarr json)
begin
    -- Declare variables
    declare i, r int;
    declare desig varchar(50);
    declare ch, co, tu, ur decimal(10,2);
    declare totalValue decimal(10,2);
    
    set i = 0 ;
    set r = json_length(desig_jarr);

    while i < r do 
    	set totalValue = 0;
    	set desig = json_unquote(json_extract(desig_jarr, concat('$[',i,']')));
    	select Chromium, Cobalt, Tungsten, Uranium
    	into ch,co,tu,ur 
        from composition_strategic 
        where Designation = desig;
		set totalValue = ch * 12.50 + co * 9.25 + tu * 7.75 + ur * 10.00;
		select concat(desig,' has a value of $',totalValue) AS 'Total Stratergic Value';
    	set i = i + 1;
    end while;
end//
delimiter ;

call showEachValue('["C-a3598-j", "M-b716-p", "S-f377-j"]');


-- Stored Procedure 4 :  Create the Stored Procedure specLambda which accepts a JSON array (of any length) of 
-- asteroid designations and creates the table lambdaAnalysis as defined below based on the 
-- analysis procedures listed on the next slide.
--  The lambdaAnalysis table must maintain 
-- JSON Objects
--  referential integrity with the registry table
 
-- create table lambdaAnalysis
drop table if exists lambdaAnalysis;
create table lambdaAnalysis(
Designation VARCHAR(20),
Country enum('United States','United Kingdom','Russian Federaion','People''s Republic of China'),
CountryCode varchar(20) generated always as (upper(concat(substring(Country,1,2),'*',substring(Designation,1,7)))) stored,
Specs json,
TimeLambda json,
MDLambda json,
CONSTRAINT PK_LA PRIMARY KEY(Designation),
CONSTRAINT FK_LA FOREIGN KEY(Designation) REFERENCES registry(Designation)
);

desc lambdaAnalysis;


-- function to get country name 
drop function if exists getCountry;
delimiter //
create function getCountry(desig varchar(50))
	returns varchar(50)
	not deterministic
	reads sql data
	begin
		declare v varchar(50);
		declare res varchar(50);
		
		select country into v  
		from registry
		where Designation = desig;


		if v = 'US' then 
			set res = 'United States';
		elseif v = 'UK' then 
			set res = 'United Kingdom';
		elseif v = 'RUSSIA' then 
			set res = 'Russian Federaion';
		elseif v = 'CHINA' then 
			set res = 'People''s Republic of China' ;
		end if;

		return res;
	end //
delimiter ;


-- function to get specification values and return it as a json object
drop function if exists getSpecs;
delimiter //
create function getSpecs(desig varchar(50))
	returns json
	not deterministic
	reads sql data
	begin
		declare m, den, dia, inc, rot decimal(10,2);
		declare res json;
		
		select diameter,mass,density,inclination,rotation into dia,m,den,inc,rot  
		from specifications
		where Designation = desig;

		set res = json_object(
			'M:',m,
			'DEN:',den,
			'DIA:',dia,
			'INC:',inc,
			'ROT:',rot);
		

		return res;
	end //
delimiter ;


-- function to get Time value and return a json object
drop function if exists getTimeLambda;
delimiter //
create function getTimeLambda(desig varchar(50))
	returns json
	not deterministic
	reads sql data
	begin
		declare dd date;
		declare days,weeks,months,years int;
		declare res json;
		
		select ddate into dd  
		from registry
		where Designation = desig;


		set days = abs(DATEDIFF(dd,'2022-01-01'));
		set weeks = abs(DATEDIFF(dd,'2022-01-01') / 7);
		set months = abs(DATEDIFF(dd,'2022-01-01') / 30);
		set years = abs(DATEDIFF(dd,'2022-01-01') / 365);

		set res = json_object(
        'TIME', json_object(
            'Days', days,
            'Weeks', weeks,
            'Months', months,
            'Years', years
        )
    	);

		return res;
	end //
delimiter ;


-- function to calculate values based on mass and return it as a json object
drop function if exists getMDLambda;
delimiter //
create function getMDLambda(desig varchar(50))
	returns json
	not deterministic
	reads sql data
	begin
		declare m, den, dia, inc, rot decimal(10,2);
		declare A,B,C,D decimal(10,2);
		declare res json;
		
		select diameter,mass,density,inclination,rotation into dia,m,den,inc,rot  
		from specifications
		where Designation = desig;

		if dia > 4 * m then
			set A = 1.25 * m;
		else 
			set A = 2.25*  m;
		end if;

		if den > 1.5 then
			set B = 0.25 * m;
		else
			set B = 0.75 * m;
		end if;

		if inc > 15 then
			set C = 0.05 * m;
		else
			set C = 0.15 * m;
		end if;
		
		if rot > 48 then
			set D = 0.01 * m;
		else
			set D = 0.02 * m;
		end if;
		
		set res = JSON_OBJECT(
        'MDLAMBDA', JSON_OBJECT(
            'A', A,
            'B', B,
            'C', C,
            'D', D
        ));

		return res;
	end //
delimiter ;


-- main procedure to insert data into lambdaAnalysis
drop procedure if exists specLambda;
delimiter //
create procedure specLambda(desig_jarr json)
begin
    -- Declare variables
    declare i, r, j, r1 int;
    declare id,icountry,desig varchar(50);
    declare ispecs,itimeLambda,imdLambda json;
    
    set i = 0 ;
    set r = json_length(desig_jarr);

    while i < r do 
    	set desig = json_unquote(json_extract(desig_jarr, concat('$[',i,']')));
    	set icountry = getCountry(desig);
    	set ispecs = getSpecs(desig);
    	set itimeLambda = getTimeLambda(desig);
    	set imdLambda = getMDLambda(desig);
    	insert into lambdaAnalysis(Designation, Country,Specs,TimeLambda,MDLambda) values (desig, icountry, ispecs,itimeLambda,imdLambda);
    	set i = i + 1;
    end while;
    					 
	select * from lambdaAnalysis;																		  
   
end//
delimiter ;

call specLambda('["C-a3598-j", "C-g2227-m", "M-b716-p", "S-h2335-p","M-e2005-m"]');
