drop table if exists DATA_TYPE_TEST;

create table DATA_TYPE_TEST
(
	A_BOOLEAN	BOOLEAN
	, B_CHAR 	CHAR(10)
	, C_VARCHAR VARCHAR(10)
	, D_TEXT 	text
	, E_INT 	INT
	, F_SMALLINT	smallint
	, G_FLOAT	FLOAT
	, H_NUMERIC	NUMERIC(15, 2)
);

insert into data_type_test values
(
	true
	,'ABCDE'
	,'ABCED'
	,'TEXT'
	,1000
	,10
	,10.12345
	,10.25
);

select * from data_type_test;


-- ACCOUNT
drop table if exists ACCOUNT

create table ACCOUNT
(
	USER_ID SERIAL primary key
	, USERNAME VARCHAR (50) unique not null
	, password VARCHAR (50) not null
	, EMAIL VARCHAR(355) unique not null
	, CREATE_ON TIMESTAMP not null
	, LAST_LOGIN TIMESTAMP 
);

drop table if exists role;
create table if not exists role 
(
	role_id	serial primary key
	, role_name varchar(255) unique not null
);

drop table if exists account_role;
create table account_role
(
	user_id integer not null
	, role_id integer not null
	, grant_date timestamp without time zone
	, primary key (user_id, role_id)
	, constraint account_role_role_id_fkey foreign key (role_id)
	  references role (role_id) match simple on update no action on delete no action 
	, constraint account_role_USER_ID_fkey foreign key (user_id)
	  references ACCOUNT (USER_ID) match simple on update no action on delete no action
);

insert into account values (1, '�̼���', '0111', 'shlee@gmail.com', current_timestamp, null);
commit;

select * from account;

insert into role values(1, 'DBA');
commit;

select * from role;

insert into account_role values (1, 1, CURRENT_TIMESTAMP);
select * from account_role;

-- "account_role_user_id_fkey" ����Ű(foreign key) ���� ������ ����
insert into account_role values (2, 1, CURRENT_TIMESTAMP);
-- "account_role_role_id_fkey" ����Ű(foreign key) ���� ������ ����
insert into account_role values (1, 2, CURRENT_TIMESTAMP);
-- �ߺ��� Ű ���� "account_role_pkey" ���� ���� ������ ������
insert into account_role values (1, 1, CURRENT_TIMESTAMP);
-- " ����Ű(foreign key) ���� ���� - "account_role" ���̺� - �� ����
update account set user_id = 2 where user_id = 1;
-- ����Ű(foreign key) ���� ���� - "account_role" ���̺� - �� ����
delete from account where user_id = 1;

-- CTAS (CREATE TABLE AS SELECT) 

select 
	A.film_id 
	, A.title 
	, A.release_year 
	, A.length 
	, A.rating 
from film A
	,film_category B
where A.film_id = B.film_id 
and B.category_id = 1
;

create table ACTION_FILM as
select 
	A.film_id 
	, A.title 
	, A.release_year 
	, A.length 
	, A.rating 
from film A
	,film_category B
where A.film_id = B.film_id 
and B.category_id = 1
;

select * from ACTION_FILM;


create table if not EXISTS ACTION_FILM as
select 
	A.film_id 
	, A.title 
	, A.release_year 
	, A.length 
	, A.rating 
from film A
	,film_category B
where A.film_id = B.film_id 
and B.category_id = 1
;

-- ���̺� ���� ���� 
create table LINKS (
	LINK_ID	SERIAL primary key
	, TITLE VARCHAR(500) not null
	, URL VARCHAR(1024) not null UNIQUE
);

select * from LINKS;

-- ACTIVE �÷� �߰�
alter table LINKS add column ACTIVE BOOLEAN;
-- ACTIVE �÷� ����
alter table LINKS drop column ACTIVE;
-- TITLE �÷��� LINK_TITLE �÷����� ����
alter table LINKS rename column TITLE to LINK_TITLE;
-- TARGET �÷� �߰�
alter table LINKS add column TARGET VARCHAR(10);
-- TARGET �÷��� DEFAULT ���� "_BLANK"�� ����
alter table LINKS alter column TARGET set default '_BLANK';

insert into LINKS (LINK_TITLE, URL)
values ('PostgresSql', 'https://www.tutorialspoint.com/postgresql/index.htm');
commit;

select * from links;

-- �ѹ� ������� ���̺��̶�� �ϴ��� ���̺� �̸� ���� ������
create table vendors
(
	ID serial primary key
	, name varchar not null
);

select * from vendors;

-- suppliers�� ����
alter table vendors rename to suppliers;

select * from suppliers;

-- supplier_groups ���̺� ����
create table supplier_groups
(
	id serial primary key
	, name varchar not null
);

-- suppliers ���̺� �÷� �߰� �� fk ����
alter table suppliers add column group_id int not null;
alter table suppliers add foreign key (group_id)
references supplier_groups (id);

-- �� ����
-- ��� ��ü�ϴ� �����Ͱ� �ƴ� ��������
create view supplier_data as
select 
	s.id 
	, s."name" 
	, g."name" "group_name"
	from 
		suppliers s , supplier_groups g
	where 
		g.id = s.group_id 
;		
	
select * from supplier_data;

-- �����ϰ� �ִ� ���̺��� �̸� �ڵ����� ���� �ݿ��� 
alter table supplier_groups rename to groups;

select * from supplier_groups;
select * from groups;


-- �ݳ����ڰ� 2005�� 5�� 29���� ��Ż ������ film_id�� ��ȸ�Ͻÿ�.
select B.film_id 
from rental A
inner join inventory B 
on (A.inventory_id = B.inventory_id)
where A.return_date  between '2005-05-29 00:00:00.000'
and '2005-05-29 23:59:59.999'
;

-- FILE ���̺��� �ݳ����ڰ� 2005�� 5�� 29���� ��Ż ������ film_id�� ��ȸ�Ͽ� FILE������ ����Ͻÿ�.
-- �ʸ� ID, Ÿ��Ʋ <== ��ȸ�� film_id �������� FILM ���̺��� ��ȸ�Ͽ� FILM ������ �����
select C.film_id , C.title 
from film C 
where C.film_id in 
	(
		select B.film_id 
		from rental A
		inner join inventory B 
		on (A.inventory_id = B.inventory_id)
		where A.return_date  between '2005-05-29 00:00:00.000'
		and '2005-05-29 23:59:59.999'		
	)
;

-- amount�� 9.00�� �ʰ��ϰ� payment_date�� 2007�� 2�� 15�Ϻ���
-- 2007�� 2�� 19�� ���̿� ���� ������ �����ϴ� ���� �̸��� ����Ͻÿ�.
-- ��ID, FIRST_NAME, LAST_NAME
select A.customer_id 
	, A.first_name 
	, A.last_name 
from customer A 
where exists (
		select 1
		from payment X 
		where X.customer_id = A.customer_id
		and X.amount > 9.00
		and X.payment_date between '2007-02-15 00:00:00.000'
		and '2007-02-19 23:59:59.999'
	  )
order by A.first_name 
;


-- amount�� 9.00�� �ʰ��ϰ� payment_date�� 2007�� 2�� 15�Ϻ���
-- 2007�� 2�� 19�� ���̿� ���� ������ �������� �ʴ� ���� �̸��� ����Ͻÿ�.
-- ��ID, FIRST_NAME, LAST_NAME
select A.customer_id 
	, A.first_name 
	, A.last_name 
from customer A 
where not exists (
		select 1
		from payment X 
		where X.customer_id = A.customer_id
		and X.amount > 9.00
		and X.payment_date between '2007-02-15 00:00:00.000'
		and '2007-02-19 23:59:59.999'
	  )
order by A.first_name 
;


-- payment ���̺��� ��ȸ�Ͽ� amount�� 9.00�� �ʰ��ϰ�
-- payment_date�� 2007�� 2�� 15�Ϻ��� 2007�� 2�� 19�� ���̿� ���� ������
-- �ִ� ���� �̸��� ����Ͻÿ�.
-- CUSTOMET_ID, FIRST_NAME, LAST_NAME, AMOUNT, PAYMENT_DATE
-- ------------

select X.customer_id , X.amount , X.payment_date 
from payment X 
where X.amount > 9.00
and X.payment_date between '2007-02-15 00:00:00.000'
		and '2007-02-19 23:59:59.999'
;

select A.customer_id
	, A.FIRST_NAME
	, A.LAST_NAME
	, B.AMOUNT
	, B.PAYMENT_DATE
from 
(
	select X.customer_id , X.amount , X.payment_date 
	from payment X 
	where X.amount > 9.00
	and X.payment_date between '2007-02-15 00:00:00.000'
			and '2007-02-19 23:59:59.999'	
) B
, customer A 
where A.customer_id = B.customer_id
order by A.customer_id
;

-- payment ���̺��� ��ȸ�Ͽ� amount�� 9.00�� �ʰ��ϰ�
-- payment_date�� 2007�� 2�� 15�Ϻ��� 2007�� 2�� 19�� ���̿� �ִ� 
-- �� �� �� ���� ������ ��ȸ�Ͻÿ�.
-- CUSTOMET_ID, FIRST_NAME, LAST_NAME, AMOUNT, PAYMENT_DATE, STAFF_NM, RENTAL_DURATION
-- ------------
-- (��Į�� ���������� ����Ͽ� STAFF�� �̸� �� ��Ż �Ⱓ���� ��ȸ)

select A.customer_id
	, A.FIRST_NAME
	, A.LAST_NAME
	, B.AMOUNT
	, B.PAYMENT_DATE
	, (select L.first_name ||' '|| L.last_name  from staff L where L.staff_id = B.staff_id) 
		as STAFF_NM
	, (select R.rental_date ||'~'|| R.return_date from rental R  where R.rental_id = B.rental_id) 
		as RENTAL_DURATION
from 
(
	select X.customer_id , X.amount , X.payment_date, X.staff_id, X.rental_id
	from payment X 
	where X.amount > 9.00
	and X.payment_date between '2007-02-15 00:00:00.000'
			and '2007-02-19 23:59:59.999'	
) B
, customer A 
where A.customer_id = B.customer_id
order by A.customer_id
;










-- dvd ��Ż �ý����� �����ڴ� ���� ���� ������ �˰� �ͽ��ϴ�.
-- �ű� ���̺�� ���� ���� ������ �����ϰ� �ͽ��ϴ�.
-- ���̺� �̸� customer_rank�̰� 
-- ���̺� ������ customer, payment�� Ȱ���ؼ� �����մϴ�.
-- ctas ����� �̿��Ͽ� �ű����̺��� �����ϰ� �����͸� �Է��Ͻÿ�.
















