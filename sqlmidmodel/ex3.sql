REM:dropping tables

drop table customer cascade constraints;
drop table pizza cascade constraints;
drop table orders cascade constraints;
drop table order_list cascade constraints;

REM:Creating table customer,pizza
REM:order,order_list

CREATE TABLE customer(
	cust_id varchar(4) PRIMARY KEY,
	cust_name varchar(40),
	address varchar(200),
	phone number(10)
	);

CREATE TABLE pizza(
	pizza_id varchar(4) PRIMARY KEY,
	pizza_type varchar(40),
	unit_prize number(3)
	);
CREATE TABLE orders(
	order_no varchar(5) PRIMARY KEY,
	FK_cust_id varchar(4),
	FOREIGN KEY(FK_cust_id) REFERENCES customer(cust_id),
	order_date date,
	delv_date date
	);
CREATE TABLE order_list(
	FK_order_no varchar(5),
	FOREIGN KEY(FK_order_no) REFERENCES orders(order_no),
	FK_pizza_id varchar(4),
	FOREIGN KEY(FK_pizza_id) REFERENCES pizza(pizza_id),
	PRIMARY KEY(FK_order_no,FK_pizza_id),
	qty number NOT NULL
	);

REm customer(cust_id, cust_name, address, phone)
REM pizza (pizza_id, pizza_type, unit_price)
REM orders(order_no, cust_id, order_date ,delv_date, total_amt)
REM order_list(order_no, pizza_id, qty)


REM ------------------------------------------------------------------------------------------

REM customer(cust_id, cust_name,address,phone)
REM ------------------------------------------------------------------------------------------

REM customer(cust_id, cust_name,address,phone)

insert into customer values('c001','Hari','32 RING ROAD,ALWARPET',9001200031);
insert into customer values('c002','Prasanth','42 bull ROAD,numgambakkam',9444120003);
insert into customer values('c003','Neethu','12a RING ROAD,ALWARPET',9840112003);
insert into customer values('c004','Jim','P.H ROAD,Annanagar',9845712993);
insert into customer values('c005','Sindhu','100 feet ROAD,vadapalani',9840166677);
insert into customer values('c006','Brinda','GST ROAD, TAMBARAM', 9876543210);
insert into customer values('c007','Ramkumar','2nd cross street, Perambur',8566944453);



REM pizza (pizza_id, pizza_type, unit_price)

insert into pizza values('p001','pan',130);
insert into pizza values('p002','grilled',230);
insert into pizza values('p003','italian',200);
insert into pizza values('p004','spanish',260);
insert into pizza values('p005','supremo',250);



REM orders(order_no, cust_id, order_date ,delv_date)

insert into orders values('OP100','c001','28-JUN-2015','28-JUN-2015');
insert into orders values('OP200','c002','28-JUN-2015','29-JUN-2015');

insert into orders values('OP300','c003','29-JUN-2015','29-JUN-2015');
insert into orders values('OP400','c004','29-JUN-2015','29-JUN-2015');
insert into orders values('OP500','c001','29-JUN-2015','30-JUN-2015');
insert into orders values('OP600','c002','29-JUN-2015','29-JUN-2015');

insert into orders values('OP700','c005','30-JUN-2015','30-JUN-2015');
insert into orders values('OP800','c006','30-JUN-2015','30-JUN-2015');


REM order_list(order_no, pizza_id, qty)

insert into order_list values('OP100','p001',3);
insert into order_list values('OP100','p002',2);
insert into order_list values('OP100','p003',2);
insert into order_list values('OP100','p004',5);
insert into order_list values('OP100','p005',4);

insert into order_list values('OP200','p003',2);
insert into order_list values('OP200','p001',6);
insert into order_list values('OP200','p004',8);

insert into order_list values('OP300','p003',3);

insert into order_list values('OP400','p001',3);
insert into order_list values('OP400','p004',1);

insert into order_list values('OP500','p003',6);
insert into order_list values('OP500','p004',5);


insert into order_list values('OP600','p002',3);
insert into order_list values('OP600','p003',2);


rem:1

select p.pizza_id,sum(ol.qty) as quantity
from pizza p join order_list ol
on p.pizza_id=ol.fk_pizza_id
group by(p.pizza_id);

rem:2

select distinct(p.pizza_type)
from order_list ol
join orders ord
on ord.order_no=ol.FK_order_no
join pizza p
on p.pizza_id=ol.fk_pizza_id
where ord.order_date<>ord.delv_date;

rem:3
select c.cust_name,c.cust_id,count(ord.order_no) as no_of_orders
from customer c
left outer join orders ord
on c.cust_id=ord.fk_cust_id
group by (c.cust_name,c.cust_id)
order by c.cust_id;

rem:4
select ol1.fk_pizza_id,ol2.fk_pizza_id
from order_list ol1
join order_list ol2
on ol1.fk_order_no=ol2.fk_order_no
where ol1.fk_order_no='OP100' and ol1.qty>ol2.qty;

rem:5
select ol.fk_order_No,p.pizza_id,c.cust_name,ol.qty
from customer c,pizza p,orders ord,order_list ol
where c.cust_id=ord.fk_cust_id and 
      p.pizza_id=ol.fk_pizza_id and
      ord.order_no=ol.fk_order_no and
      ol.qty>(select avg(qty) from order_list);

rem:6
select c.cust_name,ord.order_no
from customer c,orders ord
where c.cust_id=ord.fk_cust_id 
and ord.order_no IN (select distinct(fk_order_no) from order_list
		     group by fk_order_no 
		     having count(distinct(fk_pizza_id))>1);
rem:7
select ord.order_no,p.pizza_type,c.cust_name,ol.qty
from pizza p,customer c,order_list ol,orders ord
where p.pizza_id=ol.fk_pizza_id and c.cust_id=ord.fk_cust_id and ord.order_no=ol.fk_order_no
and ol.qty> ANY (select avg(qty) from order_list
            group by pizza_id);

rem:8

select ord.order_no,p.pizza_type,c.cust_name,ol.qty
from pizza p,customer c,order_list ol,orders ord
where p.pizza_id=ol.fk_pizza_id and c.cust_id=ord.fk_cust_id and ord.order_no=ol.fk_order_no
and ol.qty>(select avg(ol2.qty) from order_list ol2
	    where ol2.fk_pizza_id=ol.fk_pizza_id);
 
rem:9
select distinct(c.cust_name)
from customer c,order_list ol,orders ord
where c.cust_id=ord.fk_cust_id and
      ol.fk_order_no=ord.order_no 
      and ol.fk_order_no=(Select distinct(fk_order_no) from order_list
			  group by fk_order_no 
			  having count(distinct(fk_pizza_id))=5);

rem:10
select fk_order_no 
from order_list
group by fk_order_no 
having sum(qty)>(select avg(qty) 
		 from order_list
		 group by fk_pizza_id
		 having fk_pizza_id='p001')
UNION
select fk_order_no 
from order_list
group by fk_order_no 
having sum(qty)>(select avg(qty) 
		 from order_list
		 group by fk_pizza_id
		 having fk_pizza_id='p003')

select fk_order_no
from order_list
where fk_pizza_id='p001'
minus
select fk_order_no
from order_list
where fk_pizza_id='p003';

select c.cust_id
from customer c,orders ord,order_list ol
where c.cust_id=ord.fk_cust_id and ord.order_no=ol.fk_order_no
and ol.fk_pizza_id='p001'
INTERSECT
select c.cust_id
from customer c,orders ord,order_list ol
where c.cust_id=ord.fk_cust_id and ord.order_no=ol.fk_order_no
and ol.fk_pizza_id='p002';
drop view pizza_200_250;
drop view pizza_type_order;
drop view spanish_customers;

create view Pizza_200_250
as (select * from pizza 
    where unit_price between 200 and 250);
select * from Pizza_200_250;

create view pizza_type_order 
as (select count(fk_pizza_id) as no_pizzatypes
    from order_list
    group by fk_order_no);

select * from pizza_type_order;
drop view spanish_customers;
create view spanish_customers
as (select c.cust_id,c.cust_name,ord.order_no
    from customer c,orders ord,order_list ol 
    where c.cust_id=ord.fk_cust_id and
	  ord.order_no=ol.fk_order_no
	  and ol.fk_pizza_id='p004');
select * from spanish_customers; 