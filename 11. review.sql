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

insert into account values (1, '이순신', '0111', 'shlee@gmail.com', current_timestamp, null);
commit;

select * from account;

insert into role values(1, 'DBA');
commit;

select * from role;

insert into account_role values (1, 1, CURRENT_TIMESTAMP);
select * from account_role;

-- "account_role_user_id_fkey" 참조키(foreign key) 제약 조건을 위배
insert into account_role values (2, 1, CURRENT_TIMESTAMP);
-- "account_role_role_id_fkey" 참조키(foreign key) 제약 조건을 위배
insert into account_role values (1, 2, CURRENT_TIMESTAMP);
-- 중복된 키 값이 "account_role_pkey" 고유 제약 조건을 위반함
insert into account_role values (1, 1, CURRENT_TIMESTAMP);
-- " 참조키(foreign key) 제약 조건 - "account_role" 테이블 - 을 위반
update account set user_id = 2 where user_id = 1;
-- 참조키(foreign key) 제약 조건 - "account_role" 테이블 - 을 위반
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

-- 테이블 구조 변경 
create table LINKS (
	LINK_ID	SERIAL primary key
	, TITLE VARCHAR(500) not null
	, URL VARCHAR(1024) not null UNIQUE
);

select * from LINKS;

-- ACTIVE 컬럼 추가
alter table LINKS add column ACTIVE BOOLEAN;
-- ACTIVE 컬럼 삭제
alter table LINKS drop column ACTIVE;
-- TITLE 컬럼을 LINK_TITLE 컬럼으로 변경
alter table LINKS rename column TITLE to LINK_TITLE;
-- TARGET 컬럼 추가
alter table LINKS add column TARGET VARCHAR(10);
-- TARGET 컬럼의 DEFAULT 값을 "_BLANK"로 설정
alter table LINKS alter column TARGET set default '_BLANK';

insert into LINKS (LINK_TITLE, URL)
values ('PostgresSql', 'https://www.tutorialspoint.com/postgresql/index.htm');
commit;

select * from links;

-- 한번 만들어진 테이블이라고 하더라도 테이블 이름 변경 가능함
create table vendors
(
	ID serial primary key
	, name varchar not null
);

select * from vendors;

-- suppliers로 변경
alter table vendors rename to suppliers;

select * from suppliers;

-- supplier_groups 테이블 생성
create table supplier_groups
(
	id serial primary key
	, name varchar not null
);

-- suppliers 테이블에 컬럼 추가 후 fk 생성
alter table suppliers add column group_id int not null;
alter table suppliers add foreign key (group_id)
references supplier_groups (id);

-- 뷰 생성
-- 뷰는 실체하는 데이터가 아닌 보기전용
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

-- 참조하고 있는 테이블의 이름 자동으로 변경 반영됨 
alter table supplier_groups rename to groups;

select * from supplier_groups;
select * from groups;


-- 반납일자가 2005년 5월 29일인 렌탈 내역의 film_id를 조회하시오.
select B.film_id 
from rental A
inner join inventory B 
on (A.inventory_id = B.inventory_id)
where A.return_date  between '2005-05-29 00:00:00.000'
and '2005-05-29 23:59:59.999'
;

-- FILE 테이블에서 반납일자가 2005년 5월 29일인 렌탈 내역의 film_id를 조회하여 FILE정보를 출력하시오.
-- 필름 ID, 타이틀 <== 조회된 film_id 기준으로 FILM 테이블을 조회하여 FILM 정보를 출력함
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

-- amount가 9.00를 초과하고 payment_date가 2007년 2월 15일부터
-- 2007년 2월 19일 사이에 결제 내역이 존재하는 고객의 이름을 출력하시오.
-- 고객ID, FIRST_NAME, LAST_NAME
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


-- amount가 9.00를 초과하고 payment_date가 2007년 2월 15일부터
-- 2007년 2월 19일 사이에 결제 내역이 존재하지 않는 고객의 이름을 출력하시오.
-- 고객ID, FIRST_NAME, LAST_NAME
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


-- payment 테이블을 조회하여 amount가 9.00를 초과하고
-- payment_date가 2007년 2월 15일부터 2007년 2월 19일 사이에 결제 내역이
-- 있는 고객의 이름을 출력하시오.
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

-- payment 테이블을 조회하여 amount가 9.00를 초과하고
-- payment_date가 2007년 2월 15일부터 2007년 2월 19일 사이에 있는 
-- 고객 및 그 결제 내역을 조회하시오.
-- CUSTOMET_ID, FIRST_NAME, LAST_NAME, AMOUNT, PAYMENT_DATE, STAFF_NM, RENTAL_DURATION
-- ------------
-- (스칼라 서브쿼리를 사용하여 STAFF의 이름 및 렌탈 기간까지 조회)

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










-- dvd 렌탈 시스템의 관리자는 고객별 매출 순위를 알고 싶습니다.
-- 신규 테이블로 고객의 매출 순위를 관리하고 싶습니다.
-- 테이블 이름 customer_rank이고 
-- 테이블 구성은 customer, payment을 활용해서 구성합니다.
-- ctas 기법을 이용하여 신규테이블을 생성하고 데이터를 입력하시오.
















