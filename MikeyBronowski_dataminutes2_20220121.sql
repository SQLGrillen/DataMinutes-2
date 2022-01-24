/* 
DataMinutes - 2022-01-21
https://datagrillen.com/dataminutes/

Mikey Bronowski
Bronowski.IT
Husband | Dad | SQL DBA | MCT 
Microsoft Data platform MVP | ⚽️💻
He/Him

MikeyBronowski@gmail.com
https://twitter.com/MikeyBronowski

*/

/*

Not what you expect to see 
in SQL Server Management Studio

*/
---------------------------------------------------------
-- create our environment 
use master;
BEN					
drop database if exists dataminutes;
BEN
create database dataminutes;
BEN
print convert(varchar, getdate(), 121);
BEN 4				--<--------------------- what in the world of minutes is that?


---------------------------------------------------------

-- we need some tables
drop table if exists dbo.ansi_sql_synonym_types;
create table dbo.ansi_sql_synonym_types ( 
  [nvarchar] national character varying,
  [char] character,
  [nchar] national character,
  [float] double precision,
  [national] national text
  ,					
);

-- won't work
declare @ansi_sql_synonym_types table ( 
  [nvarchar] national character varying,
  [char] character,
  [nchar] national character,
  [float] double precision,
  [national] national text
  ,						--<--------------------- breaks here
);


execute sp_help "dbo.ansi_sql_synonym_types";

---------------------------------------------------------

-- load some test data 

insert into dbo.ansi_sql_synonym_types 
(nvarchar, ansi_sql_synonym_types.char, dbo.ansi_sql_synonym_types.nchar, make.sure.this.one.float, [national])
select 1,2,3,4,'5';
BEN 5

-- won't work
insert into dbo.ansi_sql_synonym_types 
(nvarchar, ansi_sql_synonym_types.char, mytable.nchar, this.was.my.place.float, national) --<--------------------- breaks here
select 1,2,3,4,'5';
BEN

select * from dbo.ansi_sql_synonym_types ;

--------------------------------------------------------

-- we need some procedures

use dataMinutes;
BEN
create procedure a;1 @ integer, @@ char varying(11) 
as (select 'show me the one:', @, @@);
BEN
create procedure a;2 @ integer, @@ char varying(11) 
as (select 'I want two now', @, @@);
BEN

-- won't work
create procedure e;3 @ integer, @@ char varying(11) 
as (select 'I want two now', @, @@);
BEN

-- run the sprocs
execute a;1		3,		'DataMinutes';
execute a;2		5,		'2022-01-21';

-- see the source
execute sp_helptext "a;1";   --<--------- ooops....

select * from sys.procedures;

execute sp_helptext "a";


-- now check the object explorer ;-)


---------------------------------------------------------
-- dancing with variables
declare @@@ int = 1000;
select @@@;


declare @@@$$@#@$#$ character = 'S';
select @@@$$@#@$#$;


select £, €, $;

select £10, €20, $30;


select £c;

select €b;

select $d;	-- won't work


drop table if exists pseudocolumn;
create table pseudocolumn(
    id int identity,
	guid uniqueidentifier rowguidcol default(newid()),
    usr sysname
 );

insert into pseudocolumn (usr)
select 'Ben'
union
select 'William';

select usr, $rowguid, $identity from pseudocolumn;



---------------------------------------------------------
/*
CTRL + SHIFT + V
*/









drop procedure if exists [a;1];
drop procedure if exists [a;2];
BEN