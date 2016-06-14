---------lab-4 select operation and aggregate function starts-------------

select item_name,releasedate from item;
select user_id from person;
select distinct (user_id) from person;

--comparision search

select * from item;
select (rating-1) from item where rating>2;
select * from item;

--and or etc and compound comparision

select item_name from item where rating>2 AND rating<5;

--between

select item_id,item_name from item where rating BETWEEN 2 AND 5;
select item_id,item_name from item where rating NOT BETWEEN 2 AND 4;

--in operation

select item_name from item where type in ('movie','song');

--pattern matching
select user_id,name from person where country like '%bangla%';

--single column ordering
select item_name,language,rating from item order by rating;
--descending order
select item_name,language,rating from item order by rating desc;
--multiple column ordering
select item_id,item_name,language,rating from item order by rating,item_id;


--play with aggregate functions

select rating from item;
select max(rating) from item;
select count(*), sum(rating), avg(rating) from item;

--group by

select rating, count(rating) from item group by rating;

--having clause

select rating, count(rating) from item group by rating having rating>5;

---------lab-4 ends---------------



-------------lab-5 subquery and set operations starts----------------

--subquery
select artist_name,country from artist
where artist_name IN (select artist_name from item where item_name='heroine');

--query
select name,country from person
where name='hisham';

--advance

select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India'
					);

--union all

select gender,country from artist
where artist_name='taylor'
union all
select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India'
					);
--union 

select gender,country from artist
where artist_name='taylor'
union
select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India'
					);
--intersect

select gender,country from artist
where artist_name='taylor'
intersect
select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India'
					);
--minus

select gender,country from artist
where artist_name='taylor'
minus
select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India'
					);

--precedence of set operator

select gender,country from artist
where country='USA'
union
select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India')
intersect
select gender,country from artist
where artist_name='taylor';

--another approach with paranthesis

select gender,country from artist
where country='USA'
union
(select a.gender, a.country 
from artist a
where a.artist_name IN (select i.artist_name from item i, news n
					where i.item_id=n.item_id and a.country='India'
					)
INTERSECT
select gender,country from artist
where artist_name='taylor'
);

-----------lab-5 subquery and set operations ends----------------





---------------lab-6 join operation starts----------------

--normal join operation
select i.item_name , i.language from item i join news n on i.item_id=n.item_id;

-- using clause
select i.item_name , i.language from item i join news using(item_id);

--multiple condition
select i.item_name, i.country, n.content from item i join news n on ((i.item_id=n.item_id) and (i.artist_name=n.artist_name));

--natural join
select i.item_name , i.language from item i natural join news n;

-- cross join
select i.item_name , i.language from item i cross join news n;

--outer joins

select i.item_name , i.language from item i left outer join news n on i.item_id=n.item_id;
select i.item_name , i.language from item i right outer join news n on i.item_id=n.item_id;
select i.item_name , i.language from item i full outer join news n on i.item_id=n.item_id;


-------------lab-6-join operation ends--------------------




----------------lab 7- pl/sql starts-------------------

--pl/sql
set serveroutput on

declare 
	max_rating item.rating%type;

begin
	select max(rating) into max_rating from item;
	dbms_output.put_line('Maximum rated items have the rating: '||max_rating);
end;
/ 

--more

SET  SERVEROUTPUT ON
DECLARE
  movie item.item_name%type;
 news_date news.date_publish%type :='10-FEB-2010';
BEGIN
  SELECT item_name INTO movie
  FROM item, news
  WHERE item.item_id=news.item_id AND
  date_publish = news_date;  
  DBMS_OUTPUT.PUT_LINE('the news of ' || movie || ' released on the date '|| news_date);
END;
/


--conditional

SET SERVEROUTPUT ON
DECLARE
    full_rating item.rating%type;
    name  VARCHAR2(100);
    bonus_point item.rating%type;
	
BEGIN
    name := 'heroine';

    SELECT rating  INTO full_rating
    FROM item
    WHERE item_name like name ;

    IF full_rating < 3  THEN
                 bonus_point := full_rating;
    ELSIF full_rating >= 3 and full_rating <= 4   THEN
               bonus_point :=  full_rating - (full_rating*0.25);
   ELSE
	bonus_point :=  full_rating - (full_rating*0.5); 
    END IF;

DBMS_OUTPUT.PUT_LINE (name || ' movie has rating: '||full_rating||' bonus point: '|| ROUND(bonus_point,2));
EXCEPTION
         WHEN others THEN
	      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/
SHOW errors


---------------lab-7-pl/sql ends------------------------



---------------lab-8-loops, cursor and procedure ,pl/sql, function continues starts-------------

-- while loop

set serveroutput on

declare 

counter number(2):=1;
username person.name%type;
usercountry person.country%type;

begin

while counter<=5

loop 
	
	select name, country into username, usercountry from person where user_id=counter;

	dbms_output.put_line('Record '||counter);
	dbms_output.put_line(username ||' ' ||usercountry);
	dbms_output.put_line('**********************');

	counter :=counter+1;

	end loop;

	exception
	when others then dbms_output.put_line(sqlerrm);
end;
/

--for loop

set serveroutput on

declare 
counter number(2);
username person.name%type;
usercountry person.country%type;

begin

	for counter in 1..5
	loop
	select name, country into username, usercountry from person where user_id=counter;
	dbms_output.put_line('Record '||counter);
	dbms_output.put_line(username ||' ' ||usercountry);
	dbms_output.put_line('**********************');
	end loop;
exception
when others then 
dbms_output.put_line(sqlerrm);
end;
/

--loop

set serveroutput on

declare
counter number(2):=0;
username person.name%type;
usercountry person.country%type;
begin

loop
	
	counter:=counter+1;
	select name, country into username, usercountry from person where user_id=counter;
	dbms_output.put_line(username ||' ' ||usercountry);
	exit when counter>5;

	end loop;
exception
when others then 
dbms_output.put_line(sqlerrm);
end;
/

--cursor

SET SERVEROUTPUT ON
DECLARE
     CURSOR artist_cur IS
  SELECT artist_name,gender FROM artist;
  record artist_cur%ROWTYPE;

BEGIN
OPEN artist_cur;
      LOOP
        FETCH artist_cur INTO record;
        EXIT WHEN artist_cur%ROWCOUNT > 3;
      DBMS_OUTPUT.PUT_LINE ('Artist Name : ' || record.artist_name || ' Gender : ' || record.gender);
      END LOOP;
      CLOSE artist_cur;   
END;
/

--procedure

set serveroutput on;

create or replace procedure get_cust is 
	itemid item.item_id%type;
	item_type item.type%type;

begin
	itemid:=4;
	select type into item_type from item where item_id=itemid;
	dbms_output.put_line('types : '||item_type);
end;
/
show errors

begin
 get_cust;
 end;
 /

--another procedure

set serveroutput on;

create or replace procedure showdate is 
	itemname item.item_name%type;
	itemdate item.releasedate%type;

begin
	itemname:='heroine';
	select releasedate into itemdate from item where item_name=itemname;
	dbms_output.put_line('Album : '|| itemname ||' released on date : ' || itemdate );
end;
/
show errors

begin
 showdate;
 end;
 /

--a procedure for inserting data into person table

alter table person disable constraint user_pk;
alter table person modify user_id number(10);

set serveroutput on;

CREATE OR REPLACE PROCEDURE add_person(
  insertname person.name%TYPE,
  insertcountry person.country%TYPE) IS
BEGIN
  INSERT INTO person(name,country)
  VALUES (insertname,insertcountry);
  COMMIT;
END add_person;
/
SHOW ERRORS


alter table person enable constraint user_pk;

-- functions

create or replace function rateavg return number is
avg_rate item.rating%type;

begin
select avg(rating) into avg_rate from item;
return avg_rate;
end;
/

set serveroutput on
begin
dbms_output.put_line('average rating: '|| rateavg );
end;
/

--complex operation in function

CREATE OR REPLACE FUNCTION get_bonus_point(
  resol  IN item.resolution%TYPE,
  rate IN item.rating%TYPE)
 RETURN NUMBER IS
BEGIN
  RETURN ((NVL(resol,0) / 1000) + (NVL(rate,0) * .25));
END get_bonus_point;
/

SELECT item_id, item_name,
       get_bonus_point(resolution,rating) "Bonus Point"
FROM   item
WHERE item_id=3;
/

-------------lab-8-loops, cursor and procedure ,pl/sql, function continues ends-------------



------------------lab 9 trigger, transaction,date starts------------------

--trigger
create or replace trigger rate_item before insert or update on item
	for each row
	declare
	r_min constant number(8) :=1;
	r_max constant number(8) :=5;

begin
if :new.rating>r_max or :new.rating<r_min then
raise_application_error(-2000,'your rating is too low or high');
end if;
end;
/  

--more on trigger

create or replace trigger tr_rsol
before update or insert on item
for each row
begin
if:new.resolution>1080 then
:new.rating:=5;
elsif:new.resolution>780 and :new.resolution<1080 then
:new.rating:=4;
elsif:new.resolution>512 and :new.resolution<780 then
:new.rating:=3;
elsif:new.resolution>320 and :new.resolution<512 then
:new.rating:=2;
end if;
end tr_rsol;
/

--DISABLE triggers
alter table item disable all triggers;

--ENABLE triggers
alter table item enable all triggers;

---transaction management
--done in data_table.sql

--date

select sysdate from dual;

select current_date from dual;

select systimestamp from dual;

--add months
select add_months(date_publish,1) as one_month from news where news_id=3;
--last day
select last_day(releasedate) from item;
--extract

select news_id,extract(month from date_publish) as months from news;

--extract continues

select item_name,extract(year from releasedate) as year from item;

--------------lab 9 trigger, transaction ends-------------------



-------------------lab 2 DDL and DML---------------------

----ALTER command and DESCRIBE command

--add column
alter table artist add age number(10);
describe artist;

--multiple column add
alter table person add (marital_status varchar(10),city varchar(10),age number(10));
describe person;

--modify
alter table person modify (marital_status varchar(20),age number(5));
describe person;

--drop 
alter table person drop column city;
describe person;

--rename
alter table person rename column marital_status to m_status;
describe person;

---UPDATE
select name,country from person where name='dany';
update person set country='scottland' where name='dany';
select name,country from person where name='dany';

--DELETE
delete from person where name='hisham';
select * from person;

-----------------end of lab 2--------------------



---------------lab-3 key constraints CHECK, DEFAULT---------------
 --done in table_data

---ALTER primary key

--disable primary key
alter table person disable constraint user_pk;

--enable primary key
alter table person enable constraint user_pk;

--drop primary key
alter table person drop constraint user_pk;

--creating primary key using ALTER 
alter table person add constraint user_pk primary key(user_id);

---------------lab 3 ends--------------------------
