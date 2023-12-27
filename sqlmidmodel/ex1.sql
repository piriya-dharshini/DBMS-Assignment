drop table musician cascade constraints;
drop table album cascade constraints;
drop table song cascade constraints;
DROP TABLE artist CASCADE CONSTRAINTS;
DROP TABLE sungby CASCADE CONSTRAINTS;
DROP TABLE studio CASCADE CONSTRAINTS;

create table musicican(
	m_id int,
	m_name varchar(255),
	birthplace varchar(255)
);

create table album(
	a_name varchar(255),
	a_id int,
	a_yor date,
	a_no_tracks int,
	studio varchar(255),
	genre varchar(3),
	m_id int
);

create table song(
	a_id int,
	ar_id int,
	t_no int,
	name varchar(20),
	length number(6),
	genre varchar(3)
);

create table artist(
	ar_id int,
	ar_name varchar(30)
);

create table sungby(
	a_id int,
	ar_id int,
	t_no int,
	rec_date date
);

create table studio(
	s_name varchar(255),
	address varchar(255),
	phno int
);


REM:1
alter table album
add constraint chck_genre
CHECK(genre in ('DIV','MOV','POP');

REM:2

alter table song
add constraint chck_genre
CHECK(genre in ('PHI','REL','LOV','DEV','PAT');

REM:3

alter table musician 
add primary key(m_id);

alter table album 
add primary key(a_id);

alter table song 
add primary key(t_no);

alter table artist 
add primary key(ar_id);

alter table sungby
add primary key(a_id,ar_id);

alter table studio
add primary key(s_name);


REM:4

alter table album
add constraint fk_m_id
foreign key(m_id) references musician(m_id);

alter table album
add constraint fk_studio
foreign key(studio) references studio(s_name);

alter table song
add constraint fk_a_id
foreign key(a_id) references album(a_id);

alter table sungby
add constraint fk_a_id1
foreign key(a_id) references album(a_id);

alter table sungby)
add constraint fk_a_id2
foreign key(ar_id) references artist(ar_id);

REM:6
alter table artist
add unique(ar_name);

rem:7
alter table album
modify a_no_tracks not null;

rem:8
alter table song
add constraint chck_length
check(length>7 and genre='PAT');

rem:9
alter table sungby
add constraint chck_rec_Date
check(extract(year from rec_date)>=1945);


rem:10
alter table artist
add gender varchar(255);

rem:11
alter table song
modify name varchar(70);

rem:12
alter table studio
add unique(phno);

rem:13
alter table sungby
modify rec_date not null;

rem:14
alter table song
MODIFY genre 
CHECK(genre in ('PHI','REL','LOV','DEV','PAT','NAT'));


rem:15
alter table song
drop constraint fk_a_id;

alter table song 
add constraint f_a_id
foreign key(a_id) references album(a_id)
on delete cascade;






