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
insert into order_list values('OP500','p001',null);

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

REM 3.
SELECT C.cust_id, C.cust_name, COUNT(o.order_no) AS num_orders
FROM CUSTOMER C
left outer JOIN ORDERS o ON C.cust_id = o.FK_cust_id
GROUP BY C.cust_id, C.cust_name;


REM 4.
SELECT OL1.pizza_id AS pizza1, OL2.pizza_id AS pizza2
FROM ORDER_LIST OL1
JOIN ORDER_LIST OL2 ON OL1.FK_order_no = OL2.FK_order_no 
WHERE OL1.qty > OL2.qty AND OL1.FK_order_no = 'OP100';

SELECT AVG(qty) FROM ORDER_LIST;
REM 5.
SELECT OL.FK_order_no, P.pizza_type, C.cust_name, OL.qty
FROM ORDER_LIST OL, PIZZA P, CUSTOMER C, Orders O
where OL.pizza_id = P.pizza_id and 
OL.FK_order_no = O.order_no and 
O.FK_cust_id = C.cust_id 
and OL.qty > (SELECT AVG(qty) FROM ORDER_LIST);  
--can we use having avg(qty)<ol.qty?no


REM 6.
SELECT C.cust_id, C.cust_name, O.order_no
FROM CUSTOMER C,ORDERS O WHERE C.cust_id = O.FK_cust_id
AND O.order_no IN (
  SELECT O1.order_no
  FROM ORDERS O1,ORDER_LIST OL1
  WHERE O1.order_no = OL1.FK_order_no
  GROUP BY O1.order_no
  HAVING COUNT(DISTINCT pizza_id) > 1
);


REM 7.
SELECT OL.FK_order_no, P.pizza_type, C.cust_name, OL.qty
FROM ORDER_LIST OL, ORDERS O , CUSTOMER C, PIZZA P
where OL.pizza_id = P.pizza_id and 
OL.FK_order_no = O.order_no and C.cust_id=O.FK_cust_id
and OL.qty > (
  SELECT MAX(AVG(OL2.qty))
  FROM ORDER_LIST OL2
  group by pizza_id
);


REM 8.
SELECT OL.FK_order_no, P.pizza_type, C.cust_name, OL.qty
FROM ORDER_LIST OL, ORDERS O , CUSTOMER C, PIZZA P
where OL.pizza_id = P.pizza_id and 
OL.FK_order_no = O.order_no and C.cust_id=O.FK_cust_id
and OL.qty > (
  SELECT AVG(OL2.qty)
  FROM ORDER_LIST OL2
  WHERE OL2.pizza_id = OL.pizza_id
);


REM 9.
SELECT C.cust_id, C.cust_name
FROM CUSTOMER C
WHERE C.cust_id IN (
    SELECT O.FK_cust_id
    FROM ORDERS O
    JOIN ORDER_LIST OL ON O.order_no = OL.FK_order_no
    JOIN PIZZA P ON OL.pizza_id = P.pizza_id
    GROUP BY O.FK_cust_id
    HAVING COUNT(DISTINCT OL.pizza_id) = (
        SELECT COUNT(*) FROM PIZZA
    )
);


SELECT * FROM (
    SELECT ol.FK_order_no, ol.pizza_id
    FROM ORDER_LIST ol
    JOIN PIZZA p ON ol.pizza_id = p.pizza_id 
    WHERE p.pizza_type = 'Pan'
      AND ol.qty > (
        SELECT AVG(ol2.qty)
        FROM ORDER_LIST ol2
        JOIN PIZZA p2 ON ol2.pizza_id = p2.pizza_id
        WHERE p2.pizza_type = 'Pan'
    )
    UNION
    SELECT ol.FK_order_no, ol.pizza_id
    FROM ORDER_LIST ol
    JOIN PIZZA p ON ol.pizza_id = p.pizza_id
    WHERE p.pizza_type = 'Italian'
      AND ol.qty > (
        SELECT AVG(ol2.qty)
        FROM ORDER_LIST ol2
        JOIN PIZZA p2 ON ol2.pizza_id = p2.pizza_id
        WHERE p2.pizza_type = 'Italian'
    )
);


SELECT * FROM ((SELECT * FROM pizza p,order_list ol
WHERE (p.pizza_id=ol.pizza_id) AND  p.pizza_type != "italian") 
INTERSECT
(SELECT * FROM pizza p,order_list ol
WHERE p.pizza_id = ol.pizza_id AND  p.pizza_type="pan")
);