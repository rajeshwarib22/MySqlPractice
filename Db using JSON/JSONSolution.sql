drop database if exists random_encrypt;
create database random_encrypt;
use random_encyypt;

-- pre requisite 
-- uppercase letter range
set @min = 65;
set @max = 91;

set @A = round(rand() * (@max - @min) + @min,0);
select @A as 'Random Number Between Max and Min';

select char(@A using utf8mb4) into @C;
select @C as 'Random Uppercase Letter';


-- Task 1
-- Create and populate the table J1 with 3 rows of randomly generated characters

create table J1(
Field int primary key auto_increment,
A char(1),
B char(1),
C char(1),
ABC_ARRAY json generated always as (json_array(a,b,c)) stored,
ABC_STRING varchar(50) generated always as (concat(a,b,c)) stored
); 

desc J1;

truncate table J1;

set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C1;
set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C2;
set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C3;
insert into J1(A,B,C) values (@C1,@C2,@C3);

set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C1;
set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C2;
set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C3;
insert into J1(A,B,C) values (@C1,@C2,@C3);

set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C1;
set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C2;
set @A = round(rand() * (@max - @min) + @min,0);
select char(@A using utf8mb4) into @C3;
insert into J1(A,B,C) values (@C1,@C2,@C3);


-- Task 2
-- display all 3 rows from J1 Table
select * from J1;