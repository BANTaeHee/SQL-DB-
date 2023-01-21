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
	,('������ S22 Ultra', 1, 500)
	,('iPhone 14 Pro', 1, 900)
	,('YOGA Slim7 Pro', 2, 1200)
	,('�Ｚ 2022 �����ú�2 ����', 2, 700)
	,('LG ��Ʈ��PC 15U560', 2, 700)
	,('Apple 2022 �ƺ� ����', 2, 800)
	,('����� TAB M10 H', 3, 150)
	,('�Ｚ���� �������� S8', 3, 200)
	,('Apple �����е� 10.2', 3, 700);
commit;
select * from product;

-- ���� �Լ��� ������ ������� ����� 
select count(*)
from product;

select * from 
product;

-- �м� �Լ��� ������ ��� �� ����(���̺��� ����)�� �Բ� �����.
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
-- group_NAME �÷��� �������� PRICE �÷��� ��հ��� ���Ͻÿ�.

select 
	B.group_name 
	, avg(price) 
from product A
inner join product_group B 
on (A.group_id = B.group_id)
group by B.group_name 
;

-- �м��Լ� ���
-- ��� ������ �״�� ��� + group_NAME �÷��� ������ ��� ���
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

-- ��������� ���Ͻÿ�.
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
-- ���� ù��° ������ PRICE ���� ����Ͻÿ�. (�׷캰 ���� ��Ѱ͸� ����Ͻÿ�)

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


-- RENTAL ���̺��� �̿��Ͽ� ��, ����, ������, ��ü ������ ��������
-- rental_id ���� ������ �Ͼ Ƚ���� ����Ͻÿ�.
/**
 * 		y				m			d			count
 *	  2005				5			24				8		(�ϱ���)
 *	  2005				5			25				137
 *
 *
 *
 *
 *	  null				null		null            16044	(��ü)					 
 */
-- ��
-- RENTAL_ID�� ������ COUNT��
select to_char(rental_date, 'YYYY') Y
		, count(*) 
from rental
group by 1
;

-- ����
select to_char(rental_date, 'YYYYMM') M
		, count(*) 
from rental 
group by 1
order by 1
;

-- ������
select to_char(rental_date, 'YYYYMMDD') D
		, count(*) 
from rental 
group by 1
order by 1
;

-- ��ü
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
 * RENTAL�� CUSTOMER ���̺��� �̿��Ͽ�
 * ������� ���� ���� RENTAL�� �� ���� ��ID, ��Ż ����, ������ŻȽ��, 
 * �̸�(FIRST NAME, LAST NAME)�� ����Ͻÿ�.
 *  - ROW_NUMBER()
 */

-- 1) RENTAL ������ ���Ѵ�.
select A.customer_id 
		, row_number () over (order by count(A.rental_id) DESC) as RENTAL_RANK
		, count(A.rental_id) RENTAL_COUNT 
from rental A
group by A.customer_id 
;

-- 2) ���� ���� RENTAL�� �� 1���� ���� ���Ѵ�.
select A.customer_id 
		, row_number () over (order by count(A.rental_id) DESC) as RENTAL_RANK
		, count(A.rental_id) RENTAL_COUNT 
from rental A
group by A.customer_id 
order by RENTAL_RANK
limit 1
;
-- 3) COUSTOMER ���̺�� �����ؼ� ���� �̸��� ����Ѵ�.
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










