drop table if exists tb_accnt;
create table tb_accnt
(
	accnt_no int
,	accnt_nm varchar(100) not null
,	balance_amt numeric(15,2) not null
,	primary key (accnt_no)
);

select * from tb_accnt;

insert into tb_accnt values (1, '일반계좌', 15000.45);

select *
from tb_accnt ta
where accnt_no = 1
;

commit;
rollback;

insert into tb_accnt values (2, '비밀계좌', 25000.45);

select *
from tb_accnt ta
where accnt_no = 1
;

commit;


--insert 
drop table if exists TB_LINK;
create table tb_link 
(
	LINK_NO INT primary key
,	URL VARCHAR(255) not null
,	LINK_NM VARCHAR(255) not null
,	DSCRPTN VARCHAR(255) not null
,	LAST_UPDATE_DE DATE
);

commit;

insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values (1, 'www.ezen.co.kr', '이젠아카데미컴퓨터학원', '홈페이지', current_date)
;

commit;
select * from tb_link;

insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values(2, 'www.google.com', '구글', '검색사이트', current_date)
returning *;

commit;
select * from tb_link;

-- insert문 수행 후 insert 한 행에서 LINK_NO 컬럼의 값을 출력하시오.

insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values (3, 'www.daum.net', '다음', '포털사이트', current_date)
returning link_no
;

commit;
select * from tb_link;

-- update 
drop table if exists TB_LINK;
create table tb_link 
(
	LINK_NO INT primary key
,	URL VARCHAR(255) not null
,	LINK_NM VARCHAR(255) not null
,	DSCRPTN VARCHAR(255) not null
,	LAST_UPDATE_DE DATE
);

insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values (1, 'www.ezenac.co.kr', '이젠아카데미컴퓨터학원', '홈페이지', current_date)
;
insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values(2, 'www.google.com', '구글', '검색사이트', current_date)
;
insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values (3, 'www.daum.net', '다음', '포털사이트', current_date)
;

update tb_link
set link_nm = '이젠에이씨씨오점케이알'
where link_no = 1
;

commit;

select * from tb_link tl 
where link_no = 1
;

update tb_link
set link_nm = '구글닷컴'
where link_no = 2
returning *
;

commit;

-- update하면서 update한 행에서 link_no 및 link_nm 컬럼을 출력하시오
update tb_link 
set link_nm = '다음점넷'
where link_no = 3
returning link_no , link_nm 
;

commit;
select * from tb_link
where link_no = 3 
;

---------- update JOIN
drop table if exists tb_prdt_cl;
drop table if exists tb_prdt;

create table tb_prdt_cl
(
	prdt_cl_no INT primary key
,	prdt_cl_nm varchar(50)
,	discount_rate numeric(2, 2)
);

insert into tb_prdt_cl values (1, 'Smart Phone', 0.20);
insert into tb_prdt_cl values (2, 'Tablet', 0.25);

create table tb_prdt
(
	prdt_no int primary key 
,	prdt_nm varchar(50)
,	prc numeric(15)
,	sale_prc numeric(15)
,	prdt_cl_no int
,	foreign key(prdt_cl_no) references tb_prdt_cl(prdt_cl_no)
);
insert into tb_prdt values (1, '갤럭시 S22 Ultra', 1551000, null, 1);
insert into tb_prdt values (2, '갤럭시 S21 Ultra', 1501000, null, 1);
insert into tb_prdt values (3, '갤럭시 탭 S8 Ultra', 1378000, null, 2);
insert into tb_prdt values (4, '갤럭시 탭 S7 FE', 719400, null, 2);

commit;

select * from tb_prdt_cl;
select * from tb_prdt;

update tb_prdt A
set sale_prc = A.PRC - (A.prc * B.discount_rate)
from tb_prdt_cl B
where A.prdt_cl_no = B.prdt_cl_no
;
commit;

select * from tb_prdt ;

---------------------------delete 
drop table if exists TB_LINK;
create table tb_link 
(
	LINK_NO INT primary key
,	URL VARCHAR(255) not null
,	LINK_NM VARCHAR(255) not null
,	DSCRPTN VARCHAR(255) not null
,	LAST_UPDATE_DE DATE
);

insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values (1, 'www.ezenac.co.kr', '이젠아카데미컴퓨터학원', '홈페이지', current_date)
;
insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values(2, 'www.google.com', '구글', '검색사이트', current_date)
;
insert into tb_link (LINK_NO, URL, link_nm, dscrptn, last_update_de)
values (3, 'www.daum.net', '다음', '포털사이트', current_date)
;
commit;
select * from tb_link;

delete 
from tb_link A 
where A.link_nm = '이젠아카데미컴퓨터학원';

rollback;
commit;

delete 
from tb_link A 
where A.link_nm = '구글'
returning *
;

select * from tb_link;

-- delete 한 다음에 delete 된 행의 내용 중 link_no, link_nm 컬럼을 출력하시오
delete
from tb_link A 
where A.link_nm = '다음'
returning A.link_no, A.link_nm 
;

commit;
select * from tb_link;

-------------UPSERT
drop table if exists TB_CUST;
create table tb_cust 
(
	CUST_NO INT
,	CUST_NM VARCHAR(50) unique
,	EMAIL_ADRES VARCHAR(200) not null
,	VALID_YN CHAR(1) not null
,	constraint PK_TB_CUST primary KEY(CUST_NO)
);
commit;

insert into tb_cust values (1, '이순신', 'shlee@gmail.com', 'Y');
insert into tb_cust values (2, '이방원', 'bwlee@gmail.com', 'Y');
commit;

select * from tb_cust;
-- 중복되는 CUST_NM값을 INSERT 하려고 하면 아무것도 하지 말라고 하는 것이다.
insert into tb_cust (CUST_NO,cust_nm, email_adres, valid_yn)
values (3, '이순신', 'shlee@gmail.com', 'Y')
on conflict (cust_nm)
do nothing;

commit;

-- 에러는 발생하지 않으면서 아무것도 하지 않았음을 알 수 있다.
select * from tb_cust;

-- cust_no에 1은 이미 존재하는 행임
-- 중복되는 행이 입력되려고 할 때 update set을 함
insert into tb_cust (CUST_NO, cust_nm, email_adres, valid_yn)
values (1, '이순신', 'shlee7@gmail.co.kr', 'N')
on conflict (CUST_NO)
do update set email_adres = excluded.email_adres
			, valid_yn = excluded.valid_yn 
;
commit;
select * from tb_cust;

---------GROUP BY

-- customer_id 컬럼이 값 기준으로 group by 함
-- 해당 컬럼값 기준으로 중복이 제거된 행이 출력됨
select A.customer_id
from payment A 
group by A.customer_id 
order by A.customer_id 
;

-- customer_id 컬럼별 amount의 합계가 큰 순으로 10건을 출력하시오.
select 
	A.customer_id
,	sum(amount) as amount
from payment A
group by 1
order by 2 desc
limit 10
;

-- FIRST_NAME 및 LAST_NAME도 같이 출력하시오.
select 
	A.customer_id 
,	B.first_name
,	B.last_name
, 	SUM(A.amount) as AMOUNT_SUM
from customer B, payment A
where A.customer_id = B.customer_id
group by A.customer_id, B.first_name, B.last_name 
order by AMOUNT_SUM desc 
limit 10
;

select 
	A.customer_id 
,	MAX(B.first_name) as first_name 
,	MAX(B.last_name) as LAST_NAME
, 	SUM(A.amount) as AMOUNT_SUM
from customer B, payment A
where A.customer_id = B.customer_id
group by A.customer_id, B.first_name, B.last_name 
order by AMOUNT_SUM desc 
limit 10
;

------------ HAVING
-- 200 이상인 결과집합을 추출하시오

select 
	A.customer_id
,	B.first_name
,	B.last_name
, 	SUM(A.amount) as AMOUNT_SUM
from payment A, customer B
where A.customer_id = B.customer_id 
group by 1, 2, 3
having sum(A.amount) >= 200
order by Amount_sum desc
limit 10
;

-- customer_id, first_name, last_name, payment_id의 수가 40이상인
-- 결과집합을 출력하시오
-- 고객 기준 결제횟수가 40번 이상인 고객을 출력하시오. (count()) 

select 
	A.customer_id 
,	B.first_name 
,	B.last_name 
, 	count(A.payment_id) as payment_id_cnt
from payment A, customer B
where A.customer_id = B.customer_id 
group by 1,2,3
having count(A.payment_id) >= 40
order by payment_id_cnt desc
;







































































