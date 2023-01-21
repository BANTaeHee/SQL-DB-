drop table if exists PRODUCT_GROUP;
create table PRODUCT_GROUP
(
	GROUP_ID INT primary key
	, GROUP_NAME VARCHAR(255) not null 
);

drop table if exists PRODUCT;
create table PRODUCT
(
	PRODUCT_ID	SERIAL primary key 
	, PRODUCT_NAME VARCHAR(255) not null
	, PRICE DECIMAL(11,2)
	, GROUP_ID INT not null
	, foreign KEY(GROUP_ID) references PRODUCT_GROUP(GROUP_ID)
);

insert into product_group 
values (1, 'SmartPhone')
		, (2, 'Laptop')
		, (3, 'Tablet');

commit;

select * from product_group;
 
insert into product (product_name, group_id, price) 
values 
	('Xiaomi 12S Ultra', 1, 200)
	,('Pixel 6 Pro', 1, 400)
	,('갤럭시 S22 Ultra', 1, 500)
	,('iPhone 14 Pro', 1, 900)
	,('YOGA Slim7 Pro', 2, 1200)
	,('삼성 2022 갤럭시북2 프로', 2, 700)
	,('LG 울트라PC 15U560', 2, 700)
	,('Apple 2022 맥북 에어', 2, 800)
	,('레노버 TAB M10 H', 3, 150)
	,('삼성전자 갤럭시탭 S8', 3, 200)
	,('Apple 아이패드 10.2', 3, 700);
commit;
select * from product;

-- 집계 함수는 집계의 결과만을 출력함 
select count(*)
from product;

select * from 
product;

-- 분석 함수는 집계의 결과 및 집합(테이블의 내용)을 함께 출력함.
select A.*
	  ,count(*) over() as CNT 
from 
	product A
ORDER by A.product_id 	
;

select A.group_id 
		, count(*) as CNT 
from product A
group by A.group_id 
order by A.group_id 
;

select A.*
		, count(*) over(partition by A.group_id) as CNT  
from product A
order by A.product_id 
;

-- AVG() 
select 
	avg(PRICE)
from 
	product;

-- GROUP BY + AVG()
-- group_NAME 컬럼을 기준으로 PRICE 컬럼의 평균값을 구하시오.

select 
	B.group_name 
	, avg(price) 
from product A
inner join product_group B 
on (A.group_id = B.group_id)
group by B.group_name 
;

-- 분석함수 사용
-- 결과 집합을 그대로 출력 + group_NAME 컬럼을 기준의 평균 출력
select 
	A.product_name 
	,A.price 
	,B.group_name 
	, avg(price) over (partition by B.group_name) as GROUP_NAME_AVG 
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


select 
	A.product_name 
	,A.price 
	,B.group_name 
	, avg(price) over (partition by B.group_name order by B.group_name) 
		as GROUP_NAME_AVG 
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;

-- 누적평균을 구하시오.
select 
	A.product_name 
	,A.price 
	,B.group_name 
	, avg(price) over (partition by B.group_name order by A.price) 
		as CUMULATIVE_AGGREGATE_AVG 
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


-- ROW_NUMBER()

select 
	A.product_name
	, B.group_name
	, A.PRICE
	, row_number() over (partition by B.group_name order by A.PRICE desc) as "row_number()"
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;




-- RANK()
select 
	A.product_name
	, B.group_name
	, A.PRICE
	, RANK() over (partition by B.group_name order by A.PRICE) as "RANK()"
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


-- DENSE_RANK()
select 
	A.product_name
	, B.group_name
	, A.PRICE
	, DENSE_RANK() over (partition by B.group_name order by A.PRICE) as "DENSE_RANK()"
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


-- FIRST_VALUE() 
-- 가장 첫번째 나오는 PRICE 값을 출력하시오. (그룹별 가장 비싼것만 출력하시오)

select 
	A.product_name, B.group_name, A.PRICE
	, first_value (A.price) over
	  (partition by B.group_name order by A.price DESC) 
	  as HIGHEST_PRICE_PER_GROUP
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;

-- LAST_VALUE()  
select 
	A.product_name, B.group_name, A.PRICE
	, last_value (A.PRICE) over
	  (partition by B.group_name order by A.PRICE desc
	   range between unbounded preceding
	   and unbounded following) 
	   as LOWEST_PRICE_PER_GROUP
from product A	   
inner join product_group B 
on (A.group_id = B.group_id)
;


select 
	A.product_name, B.group_name, A.PRICE
	, last_value (A.PRICE) over
	  (partition by B.group_name order by A.PRICE desc) 
	   as LOWEST_PRICE_PER_GROUP
from product A	   
inner join product_group B 
on (A.group_id = B.group_id)
;


select 
	A.product_name, B.group_name, A.PRICE
	, last_value (A.PRICE) over
	  (partition by B.group_name order by A.PRICE desc
	   range between unbounded preceding
	   and current row) 
	   as LOWEST_PRICE_PER_GROUP
from product A	   
inner join product_group B 
on (A.group_id = B.group_id)
;


-- LAG()
select 
	A.product_name 
	, B.group_name 
	, A.price 
	, lag (A.price, 1) over (partition by B.group_name order by A.price) as PREV_PRICE
	, A.price - lag (A.price, 1) over (partition by B.group_name order by A.price) 
	  as CUR_PREV_DIFF
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


select 
	A.product_name 
	, B.group_name 
	, A.price 
	, lag (A.price, 2) over (partition by B.group_name order by A.price) as PREV_PRICE
	, A.price - lag (A.price, 2) over (partition by B.group_name order by A.price) 
	  as CUR_PREV_DIFF
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


-- LEAD()
select 
	A.product_name 
	, B.group_name 
	, A.price 
	, lead (A.price, 1) over (partition by B.group_name order by A.price) as NEXT_PRICE
	, A.price - LEAD (A.price, 1) over (partition by B.group_name order by A.price) 
	  as CUR_NEXT_DIFF
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


select 
	A.product_name 
	, B.group_name 
	, A.price 
	, lead (A.price, 2) over (partition by B.group_name order by A.price) as NEXT_PRICE
	, A.price - LEAD (A.price, 2) over (partition by B.group_name order by A.price) 
	  as CUR_NEXT_DIFF
from product A
inner join product_group B 
on (A.group_id = B.group_id)
;


-- RENTAL 테이블을 이용하여 연, 연월, 연월일, 전체 각각의 기준으로
-- rental_id 기준 렌털이 일어난 횟수를 출력하시오.
/**
 * 		y				m			d			count
 *	  2005				5			24				8		(일기준)
 *	  2005				5			25				137
 *
 *
 *
 *
 *	  null				null		null            16044	(전체)					 
 */
-- 연
-- RENTAL_ID의 개수를 COUNT함
select to_char(rental_date, 'YYYY') Y
		, count(*) 
from rental
group by 1
;

-- 연월
select to_char(rental_date, 'YYYYMM') M
		, count(*) 
from rental 
group by 1
order by 1
;

-- 연월일
select to_char(rental_date, 'YYYYMMDD') D
		, count(*) 
from rental 
group by 1
order by 1
;

-- 전체
select count(*)
from rental;

-- ROLLUP()
select 
	to_char(rental_date, 'YYYY') Y 
	, to_char(rental_date, 'MM') M 
	, to_char(rental_date, 'DD') D
	, COUNT(*)
from rental
group by 
	rollup (
			to_char(rental_date, 'YYYY')
			, to_char(rental_date, 'MM')
			, to_char(rental_date, 'DD')
		  )
;

/**
 * RENTAL과 CUSTOMER 테이블을 이용하여
 * 현재까지 가장 많이 RENTAL을 한 고객의 고객ID, 렌탈 순위, 누적렌탈횟수, 
 * 이름(FIRST NAME, LAST NAME)을 출력하시오.
 *  - ROW_NUMBER()
 */

-- 1) RENTAL 순위를 구한다.
select A.customer_id 
		, row_number () over (order by count(A.rental_id) DESC) as RENTAL_RANK
		, count(A.rental_id) RENTAL_COUNT 
from rental A
group by A.customer_id 
;

-- 2) 가장 많이 RENTAL한 한 1명의 고객만 구한다.
select A.customer_id 
		, row_number () over (order by count(A.rental_id) DESC) as RENTAL_RANK
		, count(A.rental_id) RENTAL_COUNT 
from rental A
group by A.customer_id 
order by RENTAL_RANK
limit 1
;
-- 3) COUSTOMER 테이블과 조인해서 고객의 이름등 출력한다.
select A.customer_id 
		, row_number () over (order by count(A.rental_id) DESC) as RENTAL_RANK
		, count(A.rental_id) RENTAL_COUNT 
		, max(B.first_name) as  first_name
		, max(B.last_name) as  last_name
from rental A,
	customer B
where A.customer_id = B.customer_id 
group by A.customer_id 
order by RENTAL_RANK
limit 1
;

select A.customer_id, A.RENTAL_RANK, A.RENTAL_COUNT, B.first_name, B.last_name
from (
	select A.customer_id 
			, row_number () over (order by count(A.rental_id) DESC) as RENTAL_RANK
			, count(A.rental_id) RENTAL_COUNT 
	from rental A
	group by A.customer_id 
	order by RENTAL_RANK
	limit 1
) A, CUSTOMER B 
where A.customer_id = B.customer_id
;










