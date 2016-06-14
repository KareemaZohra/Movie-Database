drop table news;
drop table person;
drop table item;
drop table artist;

--data definition

create table artist(
	artist_name varchar(20),
	country varchar(20),
	gender varchar(20),
	short_description varchar(50),
	primary key(artist_name)
);


create table item(
	item_id number(10) not null,
	item_name varchar(20),
	type varchar(10),
	country varchar(20),
	rating number(10) check(rating>0 and rating<6),
	language varchar(20),
	artist_name varchar(20),
	releasedate Date,
	producer varchar(20),
	resolution number(10) not null,
	primary key(item_id),
	foreign key(artist_name) references artist(artist_name)
);


create table person(
	user_id number(10) not null,
	name varchar(20) unique,
	country varchar(20),
	constraint user_pk primary key(user_id)
);

create table news(
	news_id number(10) not null,
	item_id number(10) not null,
	content varchar(30),
	artist_name varchar(20) not null,
	date_publish Date,
	primary key(news_id),
	foreign key(item_id) references item(item_id),
	foreign key(artist_name) references artist(artist_name)
);
commit;

--insertion of attributes in the table

insert into artist(artist_name,country,gender,short_description) values('Tom','USA','Male','Action hero');
insert into artist values('prity','India','Female','heroine');
insert into artist values('karina','India','Female','jolly');
insert into artist values('amir','India','Male','ethical hero');
insert into artist values('taylor','UK','Female','pop singer');
savepoint cont_1;

insert into item(item_id,item_name,type,country,rating,language,artist_name,releasedate,producer,resolution) values (1,'april','movie','USA',4,'English','Tom','28-JUN-14','omuk',1080);
insert into item values (2,'alien','drama','mumbai',3,'hindi','prity','15-JAN-2005','shankar',720);
insert into item values (3,'heroine','movie','delhi',4,'hindi','karina','20-SEP-2012','yashraj',320);
insert into item values (4,'3idiots','movie','mumbai',5,'hindi','amir','28-AUG-2010','karan johar',1080);
insert into item values (5,'love story','song','UK',5,'English','taylor','22-MAY-2008','taylor',512);
savepoint cont_2;

insert into person(user_id,name,country) values(1,'kareema','bangladesh');
insert into person values(2,'muna','bangladesh');
insert into person values(3,'dany','australia');
insert into person values(4,'hisham','pakistan');
insert into person values(5,'jay','india');

insert into news(news_id,item_id,content,artist_name,date_publish) values(1,1,'action movie released','Tom','28-JUN-14'); 
insert into news values(2,2,'new movie alien!','prity','10-JAN-2005');
insert into news values(3,3,'feminist movie','karina','22-AUG-2012');
insert into news values(4,4,'fun and inspiring','amir','10-FEB-2010');
insert into news values(5,5,'new song album of taylor!','taylor','20-MAY-2008');

commit;
