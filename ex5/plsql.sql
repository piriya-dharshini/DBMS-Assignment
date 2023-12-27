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


REM:1.Check whether the given pizza type is available. If available display its 
REM:unit price. If not, display “The pizza is not available / Invalid pizza type”.

DECLARE 
	unit_p pizza.unit_price%type;
	pizzatype pizza.pizza_type%type;
BEGIN
	pizzatype:='&s_pizzatype';
	SELECT unit_price
	INTO unit_p
	FROM pizza
	WHERE pizza_type=pizzatype;
	DBMS_OUTPUT.PUT_LINE('PIZZA TYPE:'||''||pizzatype||''||'Unit Price'||''||unit_p);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('There is no such pizza type');
END;
/

REM:2. For the given customer name and a range of order date, find whether a 
REM:customer had placed any order, if so display the number of orders placed 
REM:by the customer along with the order number(s).

DECLARE
	c_name customer.cust_name%type:='&s_c_name';
	min_ord_date orders.order_date%type:='&s_min_ord';
	max_ord_date orders.order_date%type:='&s_max_ord';
	cursor c1 is SELECT o.order_no FROM orders o,customer c WHERE c.cust_id=o.FK_cust_id AND c.cust_name=c_name AND order_date BETWEEN min_ord_date AND max_ord_date; 
	counter number(2):=0;
BEGIN
	
	for cur in c1 loop
		dbms_output.put_line('Order_no:'||cur.order_no);
		counter:=counter+1;
	
	end loop;
	dbms_output.put_line('Total number of orders :'||counter);
	
END;
/

REM:3. Display the customer name along with the details of pizza type and its 
REM:quantity ordered for the given order number. Also find the total quantity 
REM:ordered for the given order number as shown below:

DECLARE
	oid orders.order_no%type:='&s_oid';
	v_customer_name customer.cust_name%type;
	cursor c1 is SELECT p.pizza_type,ol.qty
		     FROM pizza p,customer c,orders ord,order_list ol
		     WHERE c.cust_id=ord.FK_cust_id AND p.pizza_id=ol.pizza_id
		     AND ord.order_no=ol.FK_order_no AND ord.order_no=oid;
	Totalqty number(2):=0;
BEGIN
	 SELECT c.cust_name 
	 INTO v_customer_name
         FROM customer c, orders ord 
         WHERE c.cust_id = ord.FK_cust_id 
         AND ord.order_no = oid;
	dbms_output.put_line('Customer name:'||' '||v_customer_name);
	dbms_output.put_line('PIZZA TYPE'||' '||'QTY');
	for cur in c1 loop
		dbms_output.put_line(cur.pizza_type||' 		'||cur.qty);
		Totalqty:=Totalqty+cur.qty;
	end loop;
		
	dbms_output.put_line('Total Qty :'||Totalqty);
END;
/

REM:4. Display the total number of orders that contains one pizza type, two pizza
REM:type and so on.	

DECLARE 
	CURSOR C1 is SELECT COUNT(pizza_id) as pizza_num
		     FROM order_list
		     GROUP BY FK_order_no;
	onetype number(2):=0;
	twotype number(2):=0;
	threetype number(2):=0;
	alltype number(2):=0;
BEGIN 
	for cur_row in c1 loop
		if cur_row.pizza_num = 1 then
			onetype := onetype + 1;
		elsif cur_row.pizza_num = 2 then
			twotype := twotype + 1;
		elsif cur_row.pizza_num = 3 then
			threetype := threetype + 1;
		else
			alltype := alltype + 1;
		end if;
	end loop;
	dbms_output.put_line('Total one type pizza :' || onetype);
	dbms_output.put_line('Total two type pizza :' || twotype);
	dbms_output.put_line('Total three type pizza :' || threetype);
	dbms_output.put_line('Total all type pizza :' || alltype);
end;
		

