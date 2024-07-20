DROP DATABASE IF EXISTS cyberwidgetDB;
CREATE DATABASE cyberwidgetDB;
USE cyberwidgetDB;



drop function if exists buildRedWidget;
delimiter //
create function buildRedWidget()
	returns json
	not deterministic
	reads sql data
	begin
	declare res json;
	declare widget_id varchar(10);
	declare widget_type varchar(20);
	declare widget_color varchar(20);
	declare widget_bytes int;
	declare widget_access varchar(20);
	declare widget_life_span int;


	set res = json_object();
	set widget_id = concat('R-', lpad(floor(rand() * 1000), 3, '0'), char(floor(97 + rand() * 26)), char(floor(97 + rand() * 26)));


	set widget_type = case rand() * 3
        when 0 then 'Anti-Virus'
        when 1 then 'Anti-Worm'
        when 2 then 'Anti-Trojan'
        else 'Anti-Virus' end;

   set widget_color = 'RED';
	

	set widget_bytes = floor(1028 + rand() * (4096 - 1028 + 1));

	set widget_access = case rand() * 2
        when 0 then 'COMPLETE'
        when 1 then 'PARTIAL'
        else 'COMPLETE' end;

	set widget_life_span = FLOOR(1 + RAND() * 4);


	SET res = JSON_OBJECT(
        'WidgetIDNumber', widget_id,
        'WidgetType', widget_type,
        'WidgetColor', widget_color,
        'WidgetBytes', widget_bytes,
        'WidgetAccess', widget_access,
        'WidgetLifeSpan', widget_life_span
    );

	return res;
	end//
delimiter ;


drop procedure if exists cyberwidgetDBBuilder;
delimiter //
create procedure cyberwidgetDBBuilder()
begin
declare result json;



drop table if exists widgetregistry; 
create table widgetregistry(
WID varchar(10),
WColor enum('RED','BLUE','GREEN','WHITE'),
constraint pk_wid primary key(WID)
);

desc widgetregistry;


drop table if exists widgets;
create table widgets(
WID varchar(10),
WType enum('Anti-Virus','Anti-Worm','Anti-Torjan'),
WColor enum('RED','BLUE','GREEN','WHITE'),
WBytes int,
WAccess enum('COMPLETE','PARTIAL'),
WLifeSpan int,
constraint pk_wid1 primary key(WID),
constraint fk_wid foreign key(WID) references widgetregistry(WID)
);

desc widgets;


select buildRedWidget() as  Red_CyberWidget;




end //
delimiter ;

call cyberwidgetDBBuilder();


