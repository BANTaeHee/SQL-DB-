-- 카테고리별, 연도별 매출을 추출하시오.
select category , yyyy, sum(gmv) total_gmv 
from gmv_trend
group by category, yyyy
;

select category , yyyy, sum(gmv) total_gmv 
from gmv_trend
where category = '컴퓨터 및 주변기기'
group by 1, 2
;

select category, mm, sum(gmv) as gmv 
from gmv_trend
group by 1, 2
;

select category , mm, platform_type , sum(gmv) as gmv 
from gmv_trend
group by category, mm, platform_type 
;

select sum(gmv) as gmv, min(yyyy), max(yyyy), avg(gmv)
from gmv_trend;


-- 매출이 높은 주요 카테고리만 추출하시오.
select category , sum(gmv) as gmv 
from gmv_trend
group by 1
having sum(gmv) >= 50000000
;




-- 매출이 높은(10000000) 주요 카테고리만 추출하시오. 이 중에 2020년에 해당하는 것을 추출하시오
select category , sum(gmv) as gmv 
from gmv_trend
where yyyy ====
group by 1
having sum(gmv) >= 10000000
;

-- 매출이 높은 순으로 카테고리를 작성하시오
select *
frome gmv_trend
order by category, yyyy, mm, platform_type
;

-- 매출이 높은 순으로 카테고리 정렬하시오
select category  ,sum(gmv) as gmv
from gmv_trend g
group by 1
order by gmv dessc
;


select category , yyyy, sum(gmv) as gmv 
from gmv_trend
group by 1, 2
order by 1 desc, 3 desc 
;

-------------------------------------

-- 고객 중 결제 내역이 있는 고객의 고객정보 및 결제내역을 출력하시오.
-- ANSI 표준 방식의 (INNER) JOIN
select
	A.customer_id
,	A.first_name 
,	A.last_name 
,	B.amount 
,	B.payment_date 
from customer A
join payment B 
on A.customer_id = B.customer_id  
order by B.payment_date 
;

-- 고객 중 customer_id가 2인 고객의 고객정보와 결제내역을 출력하시오.
select
	A.customer_id
,	A.first_name 
,	A.last_name 
,	B.amount 
,	B.payment_date
from customer A, payment B 
where A.customer_id = B.customer_id
and A.customer_id = 2
order by B.payment_date
;

-- 고객 중 customer_id가 2인 고객의 고객정보와 결제내역을 출력하시오
-- 해당 결제를 수행한 스텝의 정보까지 출력하시오
-- 스텝 ID, 스텝의 First_name, last_name
select 
	A.customer_id
,	A.first_name as CUSTOMER_FIRST_NAME
,	A.last_name as CUSTOMER_LAST_NAME
,	B.amount 
,	B.payment_date
,	c.staff_id
, 	c.first_name as STAFF_FIRST_NAME
,	c.last_name as STAFF_LAST_NAME
from customer A
inner join payment B
on (A.customer_id = B.customer_id)
inner join staff C 
on (B.staff_id = C.staff_id) 
where A.customer_id = 2
order by B.payment_id 
;

select 
	A.customer_id
,	A.first_name as CUSTOMER_FIRST_NAME
,	A.last_name as CUSTOMER_LAST_NAME
,	B.amount 
,	B.payment_date
,	c.staff_id
, 	c.first_name as STAFF_FIRST_NAME
,	c.last_name as STAFF_LAST_NAME
from customer A
	,payment B
	,staff C
where A.customer_id = 2
and A.customer_id = B.customer_id 
and B.staff_id = C.staff_id 
order by B.payment_date 
;

----------------------------------------------------
-- FILM 테이블, INVENTORY 테이블
-- 왼쪽 (film)은 다나오고, 오른쪽 (inventory)는 매칭되는 것만 나오게 되는 것.
select 
	A.film_id 
,	A.title
,	B.inventory_id 
from film A
LEFT outer join inventory B
on (A.film_id = B.film_id)
-- where B.inventory_id is NULL
order by A.title 
;

-- RIGHT OUTER JOIN
-- film 테이블의 내용은 모두 나옴, inventory 테이블의 내용은 매칭되는 것만 나옴
select 
	A.film_id
,	A.title
,	B.inventory_id 
from inventory B
right join film A
on (A.film_id = B.film_id)
where B.inventory_id is null 
order by A.title 
;



















