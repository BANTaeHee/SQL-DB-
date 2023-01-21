-- FILM 테이블에서 길이가 가장 긴 FILM을 추출하시오.

-- 185가 길이가 가장 긴값임을 알수 있음.
select max(A.length) as MAX_LENGTH 
from film A
;

-- 길이가 185인 영화의 정보를 조회
select 
	A.film_id 
,	A.title 
,	A.description 
,	A.release_year 
,	A.length 
from film A
where A.length = 185
order by A.title 
;

-- 서브쿼리 (비교연산자 =)
select 
	A.film_id 
,	A.title 
,	A.description 
,	A.release_year 
,	A.length 
from film A
where A.length = (
		select max(A.length) as MAX_LENGTH 
		from film A
)
order by A.title 
;

-- 영화들의 평균길이가 115.27보다 길이가 크거나 같은(이상) 영화들의 리스트를 출력하시오.
select round(avg(A.length), 2) as AVG_LENGTH 
from film A
;

select 
	A.film_id 
,	A.title 
,	A.description 
,	A.release_year 
,	A.length 
from film A
where A.length >= 115.27
order by A.title 
;


select 
	A.film_id 
,	A.title 
,	A.description 
,	A.release_year 
,	A.length 
from film A
where A.length >= (
		select round(avg(A.length), 2) as AVG_LENGTH 
		from film A
)
order by A.title 
;

/**
 * 서브 쿼리
 * 	- SQL문 내에서 메인 쿼리가 아닌 하위에 존재하는 쿼리를 말함.
 * 	- 서브쿼리를 활용함으로써 다양한 결과를 도출할수 있음.
 */

-- RETAL_RATE 평균
select 
	avg(rental_rate) 
from film
;

-- RETAL_RATE의 평균보다 큰 RETAL_RATE 집합을 구하시오.
select 
	film_id 
,	title 
,	rental_rate 
from film
where rental_rate > 2.98
;


-- 중첩 서브쿼리의 활용
select 
	film_id 
,	title 
,	rental_rate 
from film
where rental_rate > 
(									-- 중첩 서브쿼리의 시작
	select 
		avg(rental_rate) 
	from film
);									-- 중첩 서브쿼리의 종료


-- 인라인 뷰의 활용
-- rental_rate가 평균보다 큰 집합의 영화정보를 추출하시오.
select 
	A.film_id 
	, A.title 
	, A.rental_rate 
from film A
	, (
		select 											-- 인라인뷰의 시작		
			avg(rental_rate) as AVG_RENTAL_RATE 
		from film 
	  ) B												-- 인라인뷰의 종료	
where	A.rental_rate  > B.AVG_RENTAL_RATE 				
;

-- 스칼라 서브쿼리 활용
select 
	A.FILM_ID
	, A.TITLE
	, A.RENTAL_RATE
from 
(											-- 인라인뷰의 시작
	select 
		B.film_id 
		, B.TITLE
		, B.rental_rate
		, (									-- 스칼라 서브쿼리의 시작
			select avg(L.rental_rate) 
			from film L
		  ) as AVG_RENTAL_RATE				-- 스칼라 서브쿼리의 종료
	from film B 
) A 										-- 인라인뷰의 종료
where A.rental_rate > A.AVG_RENTAL_RATE
;


-- 영화분류별 상영시간이 가장 긴 영화의 제목 및 상영시간을 추출하시오.
select B.category_id, max(length) 
from film A
	,film_category B 
where A.film_id = B.film_id 	
group by B.category_id 
;

select film_id ,title , length 
from film
where length >= any 
(
	select max(length) 
	from film A
		,film_category B 
	where A.film_id = B.film_id 	
	group by B.category_id 
)
;

-- 영화분류별 상영시간이 가장 긴 영화의 상영시간과 동일한 시간을 갖는 영화의 제목 및 상영시간을 추출하시오.
-- 영화분류별 상영시간이 가장 긴 상영시간을 구하시오.

select film_id ,title , length 
from film
where length = any 
(
	select max(length) 
	from film A
		,film_category B 
	where A.film_id = B.film_id 	
	group by B.category_id 
)
;

-- '= ANY'는 'IN'과 동일함 
select film_id ,title , length 
from film
where length IN
(
	select max(length) 
	from film A
		,film_category B 
	where A.film_id = B.film_id 	
	group by B.category_id 
)
;


-- 영화분류별 상영시간이 가장 긴 영화의 모든 상영시간보다 크거나 같아야만 조건 성립함.
-- 영화분류별 상영시간이 가장 긴 상영시간을 구함
select film_id ,title , length 
from film
where length >= all  
(
	select max(length) 
	from film A
		,film_category B 
	where A.film_id = B.film_id 	
	group by B.category_id 
)
;

------------------------------
select max(length) 
from film A
	,film_category B
where A.film_id  = B.film_id 
group by B.category_id 
;

select title , length 
from film 
where length >= any 
(
	select max(length) 
	from film A
		,film_category B
	where A.film_id  = B.film_id 
	group by B.category_id 
)
;


select title , length 
from film 
where length >= all 
(
	select max(length) 
	from film A
		,film_category B
	where A.film_id  = B.film_id 
	group by B.category_id 
)
;


-- 등급기준 평균값들보다 상영시간이 긴 영화정보 추출하시오.
select  round(avg(length), 2) 
from film
group by rating 
;

select film_id 
		, title 
		, length 
from film 
where length > all 
(
	select  round(avg(length), 2) 
	from film
	group by rating 
)
order by length 
;


-- EXISTS
-- 고객중에서 11달러 초과한 지불내역이 있는 고객을 추출하시오.
select 
		c.first_name 
		, c.last_name  
		, c.customer_id 
from customer c 
where exists (
				select 1
				from payment p 
				where p.customer_id = c.customer_id
				and p.amount > 11
			)
order by first_name ,last_name 
;

-- not EXISTS
-- 고객중에서 11달러 초과한 적이 없는 지불내역이 있는 고객을 추출하시오.
select 
		c.first_name 
		, c.last_name  
		, c.customer_id 
from customer c 
where not exists (
				select 1
				from payment p 
				where p.customer_id = c.customer_id
				and p.amount > 11
			)
order by first_name ,last_name 
;

-- 재고가 없는 영화를 추출하시오.(except 연산)
select film_id , title 
from film
except
select distinct inventory.film_id 
		,film.title 
from inventory
inner join film 
on film.film_id = inventory.film_id 
order by title
;

-- except 연산을 사용하지 않고 같은 결과를 도출하시오.
select film_id , title 
from film A 
where not exists (
					select 1
					from inventory B, film C
					where B.film_id = C.film_id 
					and A.film_id = C.film_id 
				 )
;				 
















