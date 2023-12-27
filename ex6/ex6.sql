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

REM:1 Write a stored procedure to display the total number of pizza's ordered by
REM:the given order number. (Use IN, OUT)
CREATE OR REPLACE PROCEDURE tot_pizza 
(o_no IN order_list.FK_order_no%TYPE,
 tp_no OUT NUMBER)
IS 
BEGIN 
           SELECT SUM(qty)
	   INTO tp_no
     	   FROM order_list
           GROUP BY FK_order_no
	   HAVING FK_order_no=o_no;
END;
/

DECLARE 
	o_no order_list.FK_order_no%TYPE;
	cp_tp_no number;
BEGIN
	o_no:='&order_no';
	tot_pizza(o_no,cp_tp_no);
	dbms_output.put_line('TOTAL PIZZA AMOUNT'||' '||cp_tp_no);
	
END;
/	

REM:2For the given order number, calculate the Discount as follows:
REM:For total amount > 2000 and total amount < 5000: Discount=5%
REM:For total amount > 5000 and total amount < 10000: Discount=10%
REM:For total amount > 10000: Discount=20%
REM:Calculate the total amount (after the discount) and update the same in
REM:orders table. Print the order as shown below: 
REM:************************************************************
REM:Order Number:OP104 Customer Name: Hari
REM:Order Date :29-Jun-2015 Phone: 9001200031
REM:************************************************************
REM:SNo Pizza Type Qty Price Amount
REM:1. Italian 6 200 1200
REM:2. Spanish 5 260 1300
REM:------------------------------------------------------
REM:Total = 11 2500
REM:------------------------------------------------------
REM:Total Amount :Rs.2500
REM:Discount (5%) :Rs. 125
REM:-------------------------- ----
REM:Amount to be paid :Rs.2375
REM:-------------------------- ----
REM:Great Offers! Discount up to 25% on DIWALI Festival Day... 


CREATE OR REPLACE PROCEDURE calc_discount(o_no IN orders.order_no%TYPE) IS
  CURSOR c_orders IS
    SELECT o.order_no, o.FK_cust_id, c.cust_name, o.tot_amt, o.order_date, c.phone
    FROM orders o
    JOIN order_list ord ON o.order_no = ord.FK_order_no
    JOIN pizza p ON ord.pizza_id = p.pizza_id
    JOIN customer c ON o.FK_cust_id = c.cust_id
    WHERE o.order_no = o_no;

  tot_discount NUMBER;
  final_amt NUMBER;
  ct NUMBER := 0;
  v_order_no orders.order_no%TYPE;
  v_cust_id customer.cust_id%TYPE;
  v_cust_name customer.cust_name%TYPE;
  v_total_amount orders.tot_amt%TYPE;
  v_order_date orders.order_date%TYPE;
  v_phone customer.phone%TYPE;
BEGIN
  OPEN c_orders;
  FETCH c_orders INTO v_order_no, v_cust_id, v_cust_name, v_total_amount, v_order_date, v_phone;
  CLOSE c_orders;

  IF v_total_amount > 2000 AND v_total_amount < 5000 THEN
    tot_discount := v_total_amount * 0.05;
    final_amt := v_total_amount + tot_discount;
  ELSIF v_total_amount >= 5000 AND v_total_amount < 10000 THEN
    tot_discount := v_total_amount * 0.1;
    final_amt := v_total_amount + tot_discount;
  ELSE
    tot_discount := v_total_amount * 0.2;
    final_amt := v_total_amount + tot_discount;
  END IF;

  DBMS_OUTPUT.PUT_LINE('Order_number: ' || v_order_no || ' Customer Name: ' || v_cust_name);
  DBMS_OUTPUT.PUT_LINE('Ordered date: ' || TO_CHAR(v_order_date, 'DD-Mon-YYYY') || ' Phone: ' || v_phone);
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('S.NO'||' '||'PIZZA'||' '||'QTY'||' '||'PRICE'||' '||'TOTAL AMOUNT');
  
  FOR rec IN (SELECT p.pizza_type, ol.qty, ord.tot_amt, p.unit_price
              FROM orders ord, order_list ol, pizza p
              WHERE p.pizza_id = ol.pizza_id AND ord.order_no = ol.fk_order_no AND order_no = o_no) 
  LOOP
    ct := ct + 1;
    DBMS_OUTPUT.PUT_LINE(ct || ' ' || rec.pizza_type || ' ' || rec.qty || ' ' || rec.tot_amt || ' ' || rec.unit_price);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Total Amount: ' || v_total_amount);
  DBMS_OUTPUT.PUT_LINE('Discount: ' || tot_discount);
  DBMS_OUTPUT.PUT_LINE('Final Amount: ' || final_amt);
END;
/

DECLARE
     o_no orders.order_no%TYPE;
BEGIN
  o_no := '&o_no';
  calc_discount(o_no);
END;
/

REM:3. Write a stored function to display the customer name who ordered
REM:highest among the total number of pizzas for a given pizza type.

CREATE OR REPLACE FUNCTION highest_ordering_customer(pizza_type IN pizza.pizza_type%TYPE)
RETURN VARCHAR2
IS
  maxqty number := 0;
  v_customer_name customer.cust_name%TYPE;
BEGIN
  for i in (SELECT c.cust_name, p.pizza_id, SUM(ol.qty) as total_qty
            FROM orders o
            JOIN customer c ON o.FK_cust_id = c.cust_id
            JOIN order_list ol ON o.order_no = ol.FK_order_no
            JOIN pizza p ON ol.pizza_id = p.pizza_id
            WHERE p.pizza_type = pizza_type
            GROUP BY c.cust_name, p.pizza_id) 
  loop
    if i.total_qty > maxqty then
      maxqty := i.total_qty;
      v_customer_name := i.cust_name;
    end if;
  end loop;

  RETURN v_customer_name;
END;
/

DECLARE
  top_customer VARCHAR2(50);
  pizza_type varchar(50);
BEGIN 
  pizza_type:='&pizza_type';
  top_customer := highest_ordering_customer(pizza_type);
  DBMS_OUTPUT.PUT_LINE('Customer who ordered the most Italian pizzas: ' || top_customer);
END;
/

REM:4. Implement Question (2) using stored function to return the amount to be
REM:paid and update the same, for the given order number.

CREATE OR REPLACE FUNCTION calculate_final_amount(o_no IN orders.order_no%TYPE)
RETURN NUMBER
IS
  v_total_amount orders.tot_amt%TYPE;
  tot_discount NUMBER;
  final_amt NUMBER;
BEGIN
  SELECT tot_amt
  INTO v_total_amount
  FROM orders
  WHERE order_no = o_no;

  IF v_total_amount > 2000 AND v_total_amount < 5000 THEN
    tot_discount := v_total_amount * 0.05;
  ELSIF v_total_amount >= 5000 AND v_total_amount < 10000 THEN
    tot_discount := v_total_amount * 0.1;
  ELSE
    tot_discount := v_total_amount * 0.2;
  END IF;

  final_amt := v_total_amount + tot_discount;

  UPDATE orders
  SET tot_amt = final_amt
  WHERE order_no = o_no;

  RETURN final_amt;
END;
/
DECLARE
  o_no orders.order_no%TYPE;
  final_amount NUMBER;
BEGIN
  o_no:='&o_no';
  final_amount := calculate_final_amount(o_no);
  DBMS_OUTPUT.PUT_LINE('Order Number: ' || o_no);
  DBMS_OUTPUT.PUT_LINE('Final Amount to be Paid: ' || final_amount);
END;
/



REM:extra procedure based queries
REM:when a record is deleted from pizza relation then that record should be stored in another table

CREATE OR REPLACE TRIGGER del_record
