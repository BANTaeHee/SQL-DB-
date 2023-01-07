-- 주문 테이블
select * 
from online_order
;

-- 상품 테이블
select 
from item
;

-- 카테고리 테이블
select *
from category
;

-- 유저 테이블 
select *
from user_info
;

-- 상품별 매출액 집계 후, 매출액 높은 순으로 정렬하기
select itemid , sum(gmv) as gmv
from online_order
group by 1 
order by 2 desc
;

-- 상품이름을 상품ID와 나란히 놓아서 상품별 매출액을 출력하시오
select 
	A.item_name
,	A.id
,	sum(gmv) as gmv
from item as A
join online_order as B
on A.id = B.itemid 
group by 1, 2
order by gmv desc 
;

-- 카테고리별 매출액을 출력하시오
select 
	c.id
,	c.cate1 
,	sum(gmv) as gmv 
from online_order oo 
join category c
on oo.itemid = c.id 
group by 1, 2
order by c.id 
;
--성별 매출액을 출력
select 
	ui.gender 
,	sum(gmv) as gmv
, 	count(distinct ui.userid) as user_cnt
from user_info ui 
join online_order oo 
on ui.userid = oo.userid 
group by 1
order by 2 desc 
;
-- 연령별 매출액
select 
	ui.age_band 
,	sum(gmv) as gmv
, 	count(distinct ui.userid) as user_cnt
from user_info ui 
join online_order oo 
on ui.userid = oo.userid
group by 1
order by 2 desc 
;

-- 카테고리별 주요 상품명의 매출을 출력
-- 매출액(거래액) = unitsold * price
select 
	c.cate3 , c.cate2 ,c.cate1 ,i.item_name ,sum(gmv) as gmv
,	sum(unitsold) as unitsold 
,	sum(gmv) / sum(unitsold) as price
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id 
group by 1,2,3,4
order by 1,5 desc 
;

-- 남성이 구매하는 아이템과 카테고리(cate1), 매출액을 출력
select i.item_name , c.cate1 , sum(gmv) as gmv , sum(unitsold) as unitsold
from online_order oo
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id 
join user_info ui on oo.userid = ui.userid 
where ui.gender = 'M'
group by 1,2
;

------------------------------------------
drop table if exists TB_EMP;
create table tb_emp 
(
	EMP_NO INT primary key
,	EMP_NM VARCHAR(50) not null
,	direct_manager_emp_no int
,	foreign KEY(DIRECT_MANAGER_EMP_NO) references TB_EMP(EMP_NO) 
	on delete no action 
);

insert into tb_emp values (1, '김회장', null);
insert into tb_emp values (2, '박사장', 1);
insert into tb_emp values (3, '송전무', 2);
insert into tb_emp values (4, '이상무', 2);
insert into tb_emp values (5, '정이사', 2);
insert into tb_emp values (6, '최부장', 3);
insert into tb_emp values (7, '정차장', 4);
insert into tb_emp values (8, '김과장', 5);
insert into tb_emp values (9, '오대리', 8);
insert into tb_emp values (10, '신사원', 8);

select * from tb_emp te; 

-- 모든 직원을 출력하면서 직속상사의 이름을 출력하시오.
select 
	A.emp_no 
,	A.emp_nm 
,	B.emp_nm as direct_manager_emp_nm 
from tb_emp A
left outer join tb_emp B 
on (A.direct_manager_emp_no = B.emp_no)
;

-- 상영시간이 동일한 필름을 출력하시오
-- TITLE(이름)은 서로 다르지만 상영시간이 동일한 FILM에 대한 정보를 출력하시오
-- TITLE, TITLE, LENGTH
select
	a.title , b.title , a.length
from film a
join film b 
on (a.length = b.length and a.title <> b.title) 
;
----------------------------------------------------
drop table if exists TB_EMP;
drop table if exists TB_DEPT;
create table TB_DEPT
(
	DEPT_NO INT primary key
,	DEPT_NM VARCHAR(100)
);

insert into TB_DEPT values(1, '회장실');
insert into TB_DEPT values(2, '경영지원본부');
insert into TB_DEPT values(3, '영업부');
insert into TB_DEPT values(4, '개발1팀');
insert into TB_DEPT values(5, '개발2팀');
insert into TB_DEPT values(6, '4차산업혁명팀');

select * from tb_dept;


----------------------------------------------------------
-- 아직 부서 배정을 받지 못한 송인턴
drop table if exists TB_EMP;
create table tb_emp 
(
	EMP_NO INT primary key
,	EMP_NM VARCHAR(50) not null
,	dept_no int
,	foreign KEY(dept_no) references TB_dept(dept_NO) 
);

insert into tb_emp values (1, '김회장', 1);
insert into tb_emp values (2, '박사장', 2);
insert into tb_emp values (3, '송전무', 2);
insert into tb_emp values (4, '이상무', 2);
insert into tb_emp values (5, '정이사', 2);
insert into tb_emp values (6, '최부장', 3);
insert into tb_emp values (7, '정차장', 3);
insert into tb_emp values (8, '김과장', 4);
insert into tb_emp values (9, '오대리', 4);
insert into tb_emp values (10, '신사원', 5);
insert into tb_emp values (11, '송인턴', null);

select * from tb_emp; 

select 
	A.emp_no 
,	A.emp_nm
,	A.dept_no
,	B.dept_no
,	B.dept_nm
from tb_emp A
full outer join TB_DEPT B
on (A.dept_no = B.dept_no)
;

-- 오른쪽에만 존재하는 행
-- 직원없는 부서 출력
select 
	A.emp_no 
,	A.emp_nm 
,	A.dept_no 
,	B.dept_no 
,	B.dept_nm 
from tb_emp A
full outer join tb_dept B 
on (A.dept_no = B.dept_no)
where A.emp_nm is null
;

-- 왼쪽에만 존재하는 행
-- 부서없는 직원 출력
select 
	A.emp_no 
,	A.emp_nm
,	A.dept_no
,	B.dept_no
,	B.dept_nm
from tb_emp A
full outer join TB_DEPT B
on (A.dept_no = B.dept_no)
where B.dept_nm is null
;

-------------------------------
drop table if exists T1;
create table T1
(
	COL_1	CHAR(1) primary KEY
);

drop table if exists T2;
create table T2
(
	COL_2	INT primary KEY
);

insert into T1 (COL_1) values ('A');
insert into T1 (COL_1) values ('B');
insert into T1 (COL_1) values ('C');
insert into T2 (COL_2) values ('1');
insert into T2 (COL_2) values ('2');
insert into T2 (COL_2) values ('3');

select * from T1;
select * from T2;

select *
from T1 A
cross join T2 B 
order by A.col_1 , B.col_2 
;



















