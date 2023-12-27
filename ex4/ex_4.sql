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
	order_no varchar(6) PRIMARY KEY,
	FK_cust_id varchar(4),
	FOREIGN KEY(FK_cust_id) REFERENCES customer(cust_id),
	order_date date,
	delv_date date
	);
CREATE TABLE order_list(
	FK_order_no varchar(6),
	FOREIGN KEY(FK_order_no) REFERENCES orders(order_no),
	pizza_id varchar(4),
	PRIMARY KEY(FK_order_no,pizza_id),
	qty number NOT NULL
	);

REm customer(cust_id, cust_name, address, phone)
REM pizza (pizza_id, pizza_type, unit_price)
REM orders(order_no, cust_id, order_date ,delv_date, total_amt)
REM order_list(order_no, pizza_id, qty)


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



REM:1. An user is interested to have list of pizza’s in the range of REM:Rs.200-250. Create a view Pizza_200_250 which keeps the pizza details REM:that has the price in the range of 200 to 250.

Drop view Pizza_200_250;
Drop view Pizza_Type_Order;

CREATE VIEW Pizza_200_250 
AS (SELECT * FROM PIZZA 
WHERE unit_prize BETWEEN 200 AND 250
);

SELECT * FROM Pizza_200_250;

REM:2.Pizza company owner is interested to know the number of pizza types 
REM:ordered in each order. Create a view Pizza_Type_Order that lists the 
REM:number of pizza types ordered in each order.

CREATE VIEW Pizza_Type_Order 
AS (SELECT FK_order_no,count(*) as no_pizzatype 
FROM order_list 
group by FK_order_no )
;

SELECT * FROM Pizza_type_order;

REM:3. To know about the customers of Spanish pizza, create a view
REM:Spanish_Customers that list out the customer id, name, order_no of
REM:customers who ordered Spanish type.

CREATE VIEW Spanish_Customers
AS (SELECT c.cust_id,c.cust_name,o.order_no
FROM pizza p,orders o,customer c,order_list ord
WHERE c.cust_id=o.FK_cust_id AND o.order_no=ord.FK_order_no AND p.pizza_id=ord.pizza_id
AND p.pizza_type='spanish');

select * from spanish_customers;

REM:4. Create a sequence named Order_No_Seq which generates the Order
REM:number starting from 1001, increment by 1, to a maximum of 9999.
REM:Include options of cycle, cache and order. Use this sequence to REM:populate the rows of Order_List table.

DROP SEQUENCE Order_No_Seq;

CREATE SEQUENCE Order_No_Seq
start with 1001
increment by 1
minvalue 1001
maxvalue 9999
cycle
cache 5
order;

INSERT INTO orders VALUES
('OP1001','c002','28-JUN-2015','30-JUN-2015');
SELECT * FROM orders;

INSERT into order_list VALUES
(CONCAT('OP',Order_No_Seq.nextval),'p004',7);

SELECT * FROM order_list;


