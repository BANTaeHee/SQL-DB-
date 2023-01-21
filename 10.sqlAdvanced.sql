-- FILM ���̺��� ���̰� ���� �� FILM�� �����Ͻÿ�.

-- 185�� ���̰� ���� �䰪���� �˼� ����.
select max(A.length) as MAX_LENGTH 
from film A
;

-- ���̰� 185�� ��ȭ�� ������ ��ȸ
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

-- �������� (�񱳿����� =)
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

-- ��ȭ���� ��ձ��̰� 115.27���� ���̰� ũ�ų� ����(�̻�) ��ȭ���� ����Ʈ�� ����Ͻÿ�.
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
 * ���� ����
 * 	- SQL�� ������ ���� ������ �ƴ� ������ �����ϴ� ������ ����.
 * 	- ���������� Ȱ�������ν� �پ��� ����� �����Ҽ� ����.
 */

-- RETAL_RATE ���
select 
	avg(rental_rate) 
from film
;

-- RETAL_RATE�� ��պ��� ū RETAL_RATE ������ ���Ͻÿ�.
select 
	film_id 
,	title 
,	rental_rate 
from film
where rental_rate > 2.98
;


-- ��ø ���������� Ȱ��
select 
	film_id 
,	title 
,	rental_rate 
from film
where rental_rate > 
(									-- ��ø ���������� ����
	select 
		avg(rental_rate) 
	from film
);									-- ��ø ���������� ����


-- �ζ��� ���� Ȱ��
-- rental_rate�� ��պ��� ū ������ ��ȭ������ �����Ͻÿ�.
select 
	A.film_id 
	, A.title 
	, A.rental_rate 
from film A
	, (
		select 											-- �ζ��κ��� ����		
			avg(rental_rate) as AVG_RENTAL_RATE 
		from film 
	  ) B												-- �ζ��κ��� ����	
where	A.rental_rate  > B.AVG_RENTAL_RATE 				
;

-- ��Į�� �������� Ȱ��
select 
	A.FILM_ID
	, A.TITLE
	, A.RENTAL_RATE
from 
(											-- �ζ��κ��� ����
	select 
		B.film_id 
		, B.TITLE
		, B.rental_rate
		, (									-- ��Į�� ���������� ����
			select avg(L.rental_rate) 
			from film L
		  ) as AVG_RENTAL_RATE				-- ��Į�� ���������� ����
	from film B 
) A 										-- �ζ��κ��� ����
where A.rental_rate > A.AVG_RENTAL_RATE
;


-- ��ȭ�з��� �󿵽ð��� ���� �� ��ȭ�� ���� �� �󿵽ð��� �����Ͻÿ�.
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

-- ��ȭ�з��� �󿵽ð��� ���� �� ��ȭ�� �󿵽ð��� ������ �ð��� ���� ��ȭ�� ���� �� �󿵽ð��� �����Ͻÿ�.
-- ��ȭ�з��� �󿵽ð��� ���� �� �󿵽ð��� ���Ͻÿ�.

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

-- '= ANY'�� 'IN'�� ������ 
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


-- ��ȭ�з��� �󿵽ð��� ���� �� ��ȭ�� ��� �󿵽ð����� ũ�ų� ���ƾ߸� ���� ������.
-- ��ȭ�з��� �󿵽ð��� ���� �� �󿵽ð��� ����
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


-- ��ޱ��� ��հ��麸�� �󿵽ð��� �� ��ȭ���� �����Ͻÿ�.
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
-- ���߿��� 11�޷� �ʰ��� ���ҳ����� �ִ� ���� �����Ͻÿ�.
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
-- ���߿��� 11�޷� �ʰ��� ���� ���� ���ҳ����� �ִ� ���� �����Ͻÿ�.
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

-- ��� ���� ��ȭ�� �����Ͻÿ�.(except ����)
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

-- except ������ ������� �ʰ� ���� ����� �����Ͻÿ�.
select film_id , title 
from film A 
where not exists (
					select 1
					from inventory B, film C
					where B.film_id = C.film_id 
					and A.film_id = C.film_id 
				 )
;				 
















