drop database if exists ec_quiz;
create database ec_quiz;
use ec_quiz;


-- Task 1
-- Create the function stringToWords that accepts any String composed of 5 words and 
-- returns a JSON array containing each word in the String (words are separated by a single 
-- space)

drop function if exists stringToWords;
delimiter //
create function stringToWords(str varchar(500))
	returns json
	not deterministic
	reads sql data
	begin 
	declare wc,i int;
	declare word varchar(50);
	declare res json;

	set wc = (length(str) - length(replace(str,' ','')) + 1);

	set i = 1;
	set res = json_array();
	while i <= wc do 
		set word = trim(substring_index(substring_index(str,' ',i),' ',-1));
		set res = json_array_append(res, '$', word);
		set i = i+1;

	end while;

	return res;
	end//
delimiter ;

select stringToWords('This is Lazrus Group 12') as MSG;



-- Task 2
-- Create the function wordsToCharacters that accepts a single String (word) and returns a 
-- JSON array containing each symbol in the word

drop function if exists wordsToCharacters;
delimiter //
create function wordsToCharacters(str varchar(50))
	returns json
	not deterministic
	reads sql data
	begin 
	declare res json;
	declare charcount, i int;
	declare chars varchar(1);


	set charcount = length(str);

	set i = 1;
	set res = json_array();

	while i <= charcount do 
		set chars = substring(str,i,1);
		set res = json_array_append(res, '$', chars);
		set i = i + 1;
	end while;
		
	return res;
	end//
delimiter ;

select wordsToCharacters('This') as MSG;

-- Task 3
-- Create the function charactersToASCII that accepts a JSON array of characters and 
-- returns a JSON array containing the ASCII code of each symbol

drop function if exists charactersToASCII;
delimiter //
create function charactersToASCII(str varchar(50))
	returns json
	not deterministic
	reads sql data
	begin 
	declare res json;
	declare charcount, i, ascii_val int;
	declare chars varchar(1);


	set charcount = length(str);

	set i = 1;
	set res = json_array();

	while i <= charcount do 
		set chars = substring(str,i,1);
		set ascii_val = ASCII(chars);
		set res = json_array_append(res, '$', ascii_val);
		set i = i + 1;
	end while;
		
	return res;
	end//
delimiter ;

select charactersToASCII('This') as MSG;



-- Task 4
-- Create the function ASCII_ToCypher that accepts a JSON array of ASCII codes and 
-- returns a String (TEXT) containing the concatenated ASCII codes separated by a “-” with 
-- values in reverse order

drop function if exists ASCII_ToCypher;
delimiter //
create function ASCII_ToCypher(jarr json)
	returns text
	not deterministic
	reads sql data
	begin 
	declare res text;
	declare i int;
	declare arrayLength int;

	set arrayLength = json_length(jarr);


	set i = arrayLength - 1;
	set res = '';
	WHILE i >= 0 DO 
        SET res = CONCAT(res, REVERSE(JSON_EXTRACT(jarr, CONCAT('$[', i, ']'))));
        IF i > 0 THEN
            SET res = CONCAT(res, '-'); 
        END IF;
        SET i = i - 1;
    END WHILE;
	return res;
	end//
delimiter ;

select ASCII_ToCypher(json_array(84,104,105,115)) as MSG;


-- Task 5
-- Create the function CypherToValue that accepts a String (TEXT) of hyphen-separated 
-- values and returns the sum of the values in the String if the values were reversed


drop function if exists CypherToValue;
delimiter //
create function CypherToValue(str text)
	returns int
	not deterministic
	reads sql data
	begin 
	declare wc,i int;
	declare word varchar(50);
	declare res int;

	set wc = (length(str) - length(replace(str,'-','')) + 1);

	set i = 1;
	set res = 0 ;
	while i <= wc do 
		set word = trim(substring_index(substring_index(str,'-',i),'-',-1));
		set res = res + reverse(word);
		set i = i+1;

	end while;

	return res;
	end//
delimiter ;

select CypherToValue('511-501-401-48') as MSG;

