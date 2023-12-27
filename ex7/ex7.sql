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
	unit_price number(3)
	);
CREATE TABLE orders(
	order_no varchar(5) PRIMARY KEY,
	FK_cust_id varchar(4),
	FOREIGN KEY(FK_cust_id) REFERENCES customer(cust_id),
	order_date date,
	delv_date date,
	tot_amt int
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

insert into orders values('OP100','c001','28-JUN-2015','28-JUN-2015',0);
insert into orders values('OP200','c002','28-JUN-2015','29-JUN-2015',0);

insert into orders values('OP300','c003','29-JUN-2015','29-JUN-2015',0);
insert into orders values('OP400','c004','29-JUN-2015','29-JUN-2015',0);
insert into orders values('OP500','c001','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP600','c002','29-JUN-2015','29-JUN-2015',0);

insert into orders values('OP700','c005','30-JUN-2015','30-JUN-2015',0);
insert into orders values('OP800','c006','30-JUN-2015','30-JUN-2015',0);


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

REM:Using stored procedures to calculate the total amount in orders table

CREATE OR REPLACE PROCEDURE add_tamt
IS
BEGIN
  FOR i IN (SELECT order_no FROM orders) LOOP
    UPDATE orders 
	SET tot_amt=(SELECT SUM(unit_price*qty) FROM 
		     order_list ol
                     JOIN pizza p
                     ON ol.pizza_id=p.pizza_id
                     GROUP BY ol.FK_order_no
                     HAVING FK_order_no=i.order_no)
	WHERE order_no=i.order_no;
  END LOOP;
END;
/

BEGIN
  add_tamt;
END;
/
SELECT * FROM orders;
REM:1 Ensure that the pizza can be delivered on same day or on the next day
REM:only.


CREATE OR REPLACE TRIGGER check_delivery_date
BEFORE INSERT OR UPDATE ON orders
FOR EACH ROW
BEGIN
  IF :NEW.delv_date NOT IN (:NEW.order_date, :NEW.order_date + 1) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Delivery date must be the same day or the next day.');
  END IF;
END;
/

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP900', 'c001', SYSDATE, SYSDATE + 2, 0);

REM:2. Update the total_amt in ORDERS while entering an order in
REM:ORDER_LIST.

CREATE OR REPLACE TRIGGER update_total_amt_row
BEFORE INSERT ON order_list
FOR EACH ROW
BEGIN
  UPDATE orders o
  SET tot_amt = (
    SELECT SUM(p.unit_price * :NEW.qty)
    FROM pizza p
    JOIN order_list ol ON p.pizza_id = ol.pizza_id
    WHERE ol.FK_order_no = :NEW.FK_order_no
  )
  WHERE order_no = :NEW.FK_order_no;
END;
/
INSERT INTO order_list 
VALUES ('OP400', 'p003', 3);


SELECT * FROM orders WHERE order_no = 'OP400';



REM:3 To give preference to all customers in delivery of pizzas’, a threshold is
REM:set on the number of orders per day per customer. Ensure that a
REM:customer can not place more than 5 orders per day.

CREATE OR REPLACE TRIGGER check_order_limit
BEFORE INSERT ON orders
FOR EACH ROW
DECLARE
  v_order_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_order_count
  FROM orders
  WHERE FK_cust_id = :NEW.FK_cust_id
    AND TRUNC(order_date) = TRUNC(SYSDATE);

  IF v_order_count >= 5 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Customer cannot place more than 5 orders per day.');
  END IF;
END;
/

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP901', 'c001', SYSDATE, SYSDATE + 1, 0);

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP902', 'c001', SYSDATE, SYSDATE + 1, 0);

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP903', 'c001', SYSDATE, SYSDATE + 1, 0);

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP904', 'c001', SYSDATE, SYSDATE + 1, 0);

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP905', 'c001', SYSDATE, SYSDATE + 1, 0);

INSERT INTO orders (order_no, FK_cust_id, order_date, delv_date, tot_amt)
VALUES ('OP906', 'c001', SYSDATE, SYSDATE + 1, 0);

DROP TABLE XPIZZA;
CREATE TABLE xpizza(
		pizza_id varchar2(4) PRIMARY KEY,
	        pizza_type varchar2(40),
	        unit_price int
	);

CREATE OR REPLACE TRIGGER del_record
BEFORE DELETE ON pizza	
FOR EACH ROW	
BEGIN
	IF DELETING THEN
		INSERT INTO xpizza values(:old.pizza_id,:old.pizza_type,:old.unit_price);
	END IF;
END;
/

DELETE FROM pizza
where pizza_type='italian';

select * from xpizza;

CREATE OR REPLACE TRIGGER order_delvdate
BEFORE INSERT on orders
FOR EACH ROW
BEGIN
	IF :NEW.delv_date<:NEW.order_Date then
		raise_application_error(-20004,'ordered date is less than delivery date');
	END IF;
END;
/

INSERT INTO orders values('OP907','c004',SYSDATE,SYSDATE-1,0);



