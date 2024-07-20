USE synthetictargeting;

--  create and populate the synthetictargeting database using the provided 
-- files.
--  • Create the stored procedure as described. Your stored procedure must 
-- retrieve all required data using a cursor
-- Your .sql script should contain only your stored procedure code with any 
-- accompanying functions you create.

-- tgtConsolidation Stored Procedure 5
--  • Create the stored procedure 
-- tgtConsolidation that accepts no 
-- parameters.
--  • The stored procedure creates and displays 
-- the first 20 rows from the table 
-- TgtAggregate.
--  • The TgtAggegate table is a combination of 
-- formatted values from all the other tables 
-- in the synthetictargeting database.
--  TgtDwell is a formatted combination 
-- of the TgtDTG and TgtAge values.
--  • The TgtAggregate table contains only 
-- targets that have an age less than 180 and  
-- a status of Active
--  • The TgtAggregate table maintains 
-- referential integrity with the TgtRegistry


-- procedure to create table TgtAggregate
drop procedure if exists createTable;
delimiter //
create procedure createTable()	
begin
	-- create table TgtAggregate and describe it
	 drop table if exists TgtAggregate;
	 create table TgtAggregate(
    	tgtNumber VARCHAR(50),
    	tgtDwell VARCHAR(50),
    	tgtRestriction VARCHAR(50),
    	tgtStatus VARCHAR(50),
    	tgtCoordinates VARCHAR(50),
    	constraint pk_ta primary key(tgtNumber),
    	CONSTRAINT fk_ta FOREIGN KEY(tgtNumber) REFERENCES tgtRegistry(tgtNumber)
    );

    desc TgtAggregate;
		
end //
delimiter ;


drop procedure if exists tgtConsolidation;
delimiter //
create procedure tgtConsolidation()
begin
    -- Declare variables
    declare i, r int;
    declare a,b,c,d,e varchar(50);
    -- Declare cursor
    DECLARE cur CURSOR FOR 
    SELECT * FROM TgtAggregate LIMIT 20;

    -- procedure that creates TgtAggregate table
   	call createTable();

   	-- populate table TgtAggregate
    insert into TgtAggregate(tgtNumber,tgtDwell,tgtRestriction,tgtStatus,tgtCoordinates)
    select tr.tgtNumber as tgtNumber,
    concat(tr.tgtDTG,' ',tr.tgtAge) as tgtDwell,
    tf.tgtRestriction as tgtRestriction,
    tf.tgtStatus as tgtStatus, 
    concat('X:',substring(tg.tgtCoordinates,1,2),' Y:',substring(tg.tgtCoordinates,4,2)) as tgtCoordinates
    from tgtRegistry tr join
    tgtFeatures tf on tr.tgtNumber = tf.tgtNumber
    join tgtGeometry tg on tr.tgtNumber = tg.tgtNumber
    where tf.tgtStatus = 'ACTIVE' and tr.tgtAge < 180; 

    
    OPEN cur;
    SET i = 0;
    SET r = FOUND_ROWS();

    -- Loop through cursor data and print
    -- WHILE i < r DO 
    --     FETCH cur INTO a, b, c, d, e; 
    --     SELECT a, b, c, d, e;
    --     SET i = i + 1;
    -- END WHILE;

    select * from TgtAggregate limit 20;

    CLOSE cur;

    																		  
   
end//
delimiter ;

call tgtConsolidation();