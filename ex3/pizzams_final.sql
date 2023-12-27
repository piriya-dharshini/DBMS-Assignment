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


REM CHANGE
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


REM:1. For each pizza, display the total quantity ordered by the customers.

SELECT pizza_id,sum(qty)
FROM PIZZA JOIN ORDER_LIST 
USING (pizza_id)
GROUP BY pizza_id;

REM:2. Find the pizza type(s) that is not delivered on the ordered day.

SELECT p.pizza_type 
FROM order_list ol 
JOIN pizza p 
ON (p.pizza_id=ol.pizza_id)
JOIN orders ord
ON (ord.order_no=ol.FK_order_no)
WHERE ord.order_date<>ord.delv_date;

REM:3.Display the number of order(s) placed by each customer whether or not
REM:he/she placed the order

SELECT C.cust_id,COUNT(o.order_no) AS num_orders
FROM CUSTOMER C
LEFT OUTER JOIN ORDERS o ON C.cust_id = o.FK_cust_id
GROUP BY c.cust_id;


REM 4.Find the pairs of pizzas such that the ordered quantity of first pizza type is more than the second for the order OP100.

SELECT OL1.pizza_id AS pizza1, OL2.pizza_id AS pizza2
FROM ORDER_LIST OL1
JOIN ORDER_LIST OL2 ON OL1.FK_order_no = OL2.FK_order_no 
WHERE OL1.qty > OL2.qty AND OL1.FK_order_no = 'OP100';

SELECT AVG(qty) FROM ORDER_LIST;

REM :5.Display the details (order number, pizza type, customer name, qty) of the pizza with ordered quantity more than the average ordered quantity of
REM:pizzas.

SELECT o.order_no,p.pizza_type,c.cust_name,ol.qty
FROM order_list ol
JOIN pizza p
ON (p.pizza_id=ol.pizza_id)
JOIN orders o
ON (ol.FK_order_no=o.order_no)
JOIN customer c
ON (o.FK_cust_id=c.cust_id)
WHERE ol.qty>(SELECT avg(qty) 
	      FROM order_list);

REM :6.Find the customer(s) who ordered for more than one pizza type in each
REM:order.
SELECT DISTINCT(c.cust_name),o.order_no
FROM customer c,order_list ol,orders o,pizza p
WHERE c.cust_id=o.FK_cust_id AND o.order_no=ol.FK_order_no
AND o.order_no IN (SELECT DISTINCT(FK_order_no)
	       	   FROM order_list
	           GROUP BY FK_order_no
		   HAVING count(DISTINCT(pizza_id))>1);

	       


REM 7: Display the details (order number, pizza type, customer name, qty) of the pizza with 
REM:ordered quantity more than the average ordered quantity of each pizza type.

SELECT o.order_no,p.pizza_type,c.cust_name,ol.qty
FROM pizza p,orders o,order_list ol,customer c
WHERE p.pizza_id=ol.pizza_id AND o.order_no=ol.FK_order_no AND o.FK_cust_id=c.cust_id
AND ol.qty>ANY (SELECT AVG(qty)
	    FROM order_list
	    GROUP BY pizza_id);


REM 8:Display the details (order number, pizza type, customer name, qty) of the pizza with ordered
REM: quantity more than the average ordered quantity of its pizza type. (Use correlated)

SELECT OL.FK_order_no, P.pizza_type, C.cust_name, OL.qty
FROM ORDER_LIST OL, ORDERS O , CUSTOMER C, PIZZA P
where OL.pizza_id = P.pizza_id and 
OL.FK_order_no = O.order_no and C.cust_id=O.FK_cust_id
and OL.qty > (
  SELECT AVG(OL2.qty)
  FROM ORDER_LIST OL2
  WHERE OL2.pizza_id = OL.pizza_id
);


REM: 9.Display the customer details who placed all pizza types in a single order

SELECT DISTINCT(c.cust_name)
FROM customer c,orders o,order_list ol,pizza p
WHERE p.pizza_id=ol.pizza_id AND ol.FK_order_no=o.order_no AND c.cust_id=o.FK_cust_id
AND ol.FK_order_no=(SELECT FK_order_no
		    FROM order_list
		    GROUP BY FK_order_no
		    HAVING COUNT(DISTINCT(pizza_id))=5);

REM:10.Display the order details that contains the pizza quantity more than the
REM:average quantity of any of Pan or Italian pizza type.

SELECT FK_order_no as order_no
FROM order_list 
GROUP BY (FK_order_no)
HAVING SUM(qty)>(SELECT AVG(QTY) 
		FROM order_list
		WHERE pizza_id='p001')
UNION
SELECT FK_order_no as order_no
FROM order_list 
GROUP BY (FK_order_no)
HAVING SUM(qty)>(SELECT AVG(QTY) 
		FROM order_list
		WHERE pizza_id='p003');

REM:11.Find the order(s) that contains Pan pizza but not the Italian pizza type.

SELECT FK_order_no 
FROM order_list 
WHERE pizza_id='p001'
MINUS 
SELECT FK_order_no 
FROM order_list
WHERE pizza_id='p003';


REM:12.Display the customer(s) who ordered both Italian and Grilled pizza type.

SELECT c.cust_id,c.cust_name 
FROM customer c,orders o,order_list ord
WHERE c.cust_id=o.FK_cust_id and o.order_no=ord.FK_order_no 
and pizza_id='p002'
INTERSECT
SELECT c.cust_id,c.cust_name 
FROM customer c,orders o,order_list ord
WHERE c.cust_id=o.FK_cust_id and o.order_no=ord.FK_order_no 
and pizza_id='p003';

SELECT c.cust_id,c.cust_name,SUM(ol.qty)
FROM orders ord
FULL OUTER JOIN customer c
ON c.cust_id=ord.FK_cust_id
FULL OUTER JOIN order_list ol
ON ord.order_no=ol.FK_order_no
group by c.cust_id,c.cust_name;






