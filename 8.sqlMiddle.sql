drop table if exists TB_FILM_GRADE;
create table TB_FILM_GRADE
(
	FILM_GRADE_NO INT primary key
,	TITLE_NM VARCHAR not null
,	RELEASE_YEAR smallint
,	GRADE_RNK INT
);

insert into tb_film_grade values (1, '늑대사냥', 2022, 1);
insert into tb_film_grade values (2, '공조2: 인터내셔날', 2022, 2);
insert into tb_film_grade values (3, '아바타 리마스터링', 2022, 3);


select * from tb_film_grade;

drop table if exists TB_FILM_ATTENDANCE;
create table TB_FILM_ATTENDANCE
(
	FILM_GRADE_NO VARCHAR not null
,	TITLE_NM VARCHAR not null
,	RELEASE_YEAR smallint
,	ATTEDANCE_RANK INT
);

insert into tb_film_attendance values (1, '아바타 리마스터링', 2022, 1);
insert into tb_film_attendance values (2, '헌트', 2022, 2);
insert into tb_film_attendance values (3, '늑대사냥', 2022, 3);

commit;

select A.TITLE_NM, A.RELEASE_YEAR from tb_film_grade A;
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A;

-- 중복된 행을 하나씩만 보여구조 있음
-- 중복된 행의 중복을 제거하고 유일한 값(행)만 보여줌
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_grade A
union
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
;


-- 중복된 행도 모두 보여줌
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_grade A
union ALL
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
;


select A.TITLE_NM as "타이틀명", A.RELEASE_YEAR as "출시년도" from tb_film_grade A
union ALL
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
order by 타이틀명
;

--오류
select A.TITLE_NM as "타이틀명", A.RELEASE_YEAR as "출시년도" from tb_film_grade A
union ALL
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
order by A.TITLE_NM
;


------------------------------------------INTERSECT
drop table if exists TB_FILM_GRADE;
create table TB_FILM_GRADE
(
	FILM_GRADE_NO INT primary key
,	TITLE_NM VARCHAR not null
,	RELEASE_YEAR smallint
,	GRADE_RNK INT
);

insert into tb_film_grade values (1, '늑대사냥', 2022, 1);
insert into tb_film_grade values (2, '공조2: 인터내셔날', 2022, 2);
insert into tb_film_grade values (3, '아바타 리마스터링', 2022, 3);


select * from tb_film_grade;
select * from tb_film_attendance;

drop table if exists TB_FILM_ATTENDANCE;
create table TB_FILM_ATTENDANCE
(
	FILM_GRADE_NO VARCHAR not null
,	TITLE_NM VARCHAR not null
,	RELEASE_YEAR smallint
,	ATTEDANCE_RANK INT
);

insert into tb_film_attendance values (1, '아바타 리마스터링', 2022, 1);
insert into tb_film_attendance values (2, '헌트', 2022, 2);
insert into tb_film_attendance values (3, '늑대사냥', 2022, 3);

commit;


select A.TITLE_NM as "타이틀명", A.RELEASE_YEAR as "출시년도" from tb_film_grade A
INTERSECT
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
order by 타이틀명 desc
;

-- INNERSECT연산과 INNER JOIN의 결과집합은 동일
select A.title_nm
,	   B.release_year
from tb_film_grade A 
inner join tb_film_attendance B 
on (A.title_nm = B.title_nm
	and A.release_year = B.release_year)
order by A.title_nm desc 
;

--------------------------ㄸㅌㅊㄸ
drop table if exists TB_FILM_GRADE;
create table TB_FILM_GRADE
(
	FILM_GRADE_NO INT primary key
,	TITLE_NM VARCHAR not null
,	RELEASE_YEAR smallint
,	GRADE_RNK INT
);

insert into tb_film_grade values (1, '늑대사냥', 2022, 1);
insert into tb_film_grade values (2, '공조2: 인터내셔날', 2022, 2);
insert into tb_film_grade values (3, '아바타 리마스터링', 2022, 3);

select * from tb_film_grade;
select * from tb_film_attendance;

drop table if exists TB_FILM_ATTENDANCE;
create table TB_FILM_ATTENDANCE
(
	FILM_GRADE_NO VARCHAR not null
,	TITLE_NM VARCHAR not null
,	RELEASE_YEAR smallint
,	ATTEDANCE_RANK INT
);

insert into tb_film_attendance values (1, '아바타 리마스터링', 2022, 1);
insert into tb_film_attendance values (2, '헌트', 2022, 2);
insert into tb_film_attendance values (3, '늑대사냥', 2022, 3);

commit;

select * from tb_film_grade ;
select * from tb_film_attendance;

-- 위에서 아래를 뺸다.
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_grade A
EXCEPT
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
;
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
EXCEPT
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_grade A
;


select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
union all
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_attendance A
except
select A.TITLE_NM, A.RELEASE_YEAR from tb_film_grade A
;


-- count()
-- payment 테이블의 건수를 조회하시오
select count(*) as cnt
from payment A
;

select count(*) as cnt from customer;


drop table if exists tb_count_test;
create table tb_count_test
(
	count_test_no int primary key
,	count_test_nm varchar(50) not null
);

commit;
select count(*) cnt
from tb_count_test 
;


--payment 테이블에서 customer_id 별 건수를 구하시오.
select A.customer_id , count(A.customer_id) as cnt
from payment A
group by A.customer_id 
;

select *
from payment
where customer_id = 184
;

select A.customer_id , count(A.customer_id) as cnt
from payment A
group by A.customer_id 
order by cnt desc 
limit 1
;

select A.customer_id
	, count(A.customer_id) as cnt
	, B.first_name 
	, B.last_name 
from payment A, customer B
where A.customer_id = B.customer_id 
group by A.customer_id,	B.first_name , B.last_name 
order by cnt desc 
limit 1
;


select A.customer_id
	, count(A.customer_id) as cnt
	, max(B.first_name) as first_name
	, max(B.last_name)	as last_name 
from payment A, customer B
where A.customer_id = B.customer_id 
group by A.customer_id,	B.first_name , B.last_name 
order by cnt desc 
limit 1
;

select A.customer_id
	, count(A.customer_id) as cnt
	, min(B.first_name) as first_name
	, min(B.last_name)	as last_name 
from payment A, customer B
where A.customer_id = B.customer_id 
group by A.customer_id,	B.first_name , B.last_name 
order by cnt desc 
limit 1
;



-- amount 값 중 유일한 값만을 출력
select distinct A.amount as amount
from payment A
order by amount 
;

-- payment 테이블의 
select count(distinct A.amount) as amount_cnt
from payment A
;

-- payment 테이블에서 customer_id 별 amount 컬럼의 유일값의 개수를 출력하시오
select distinct a.amount
from payment A
where a.customer_id = 1
;

select count(distinct amount)
from payment
where customer_id = 1
;

select A. customer_id
	,	count(distinct A.amount) as amount_cnt
from payment A
group by A.customer_id 
;

-- amount 컬럼의 유일값의 개수가 11 이상인 행들을 출력하시오
select A. customer_id
	,	count(distinct A.amount) as amount_cnt
from payment A
group by A.customer_id 
having count(distinct A.amount) >= 11
order by amount_cnt
;


------- max(), min()

-- payment 테이블에서 최대 amount값과 최소 amount 값을 구하시오

select 
	max(A.amount) as max_amount
,	min(A.amount) as min_amount
from payment A
;

-- payment 테이블에서 customer_id별 최대 amount값과 최소 amount값을 구하시오

select 
	A.customer_id 
,	max(A.amount) as max_amount
,	min(A.amount) as min_amount
from payment A
group by A.customer_id 
order by A.customer_id
;

-- 그 중 최대 amount값이 11.00보다 큰 집합을 출력하시오
select 
	A.customer_id 
,	max(A.amount) as max_amount
,	min(A.amount) as min_amount
from payment A
group by A.customer_id
having max(A.amount) >= 11.00
order by A.customer_id
;


drop table if exists TB_MAX_MIN_TEST;
create table TB_MAX_MIN_TEST
(
	MAX_MIN_TEST_NO char(6) primary key
,	MAX_AMOUNT numeric(15, 2)
,	MIN_AMOUNT numeric(15, 2)
)
;
commit;
insert into TB_MAX_MIN_TEST values ('100001', 100.52, 11.49);
commit;

select * from TB_MAX_MIN_TEST;

select max_min_test_no 
from TB_MAX_MIN_TEST
where MAX_MIN_TEST_NO = '100001'
;
select max(max_min_test_no) as max_min_test_no
from TB_MAX_MIN_TEST
where MAX_MIN_TEST_NO = '100001'
;

select coalesce(MAX(max_min_test_no), '없음') as max_min_test_no
from tb_max_min_test A
where max_min_test_no = '100001'
;

-----------------------AVG(), SUM()
-- payment테이블에서 AMOUNT의 평균값과 AMOUNT의 합계값을 구하시오
-- 단, 소수점 이하 2자리까지 출력하시오
select 
	round(avg(A.amount), 2) as avg_amount
,	round(sum(A.amount), 2) as sum_amount
from payment A
;

-- payment 테이블에서 customer_id 별 amount의 평균값과 amount의 합계값을 구하시오
-- amount 합계값을 기준으로 내림차순 정렬하시오

select 
	A.customer_id 
,	round(avg(A.amount), 2) as avg_amount
,	round(sum(A.amount), 2) as sum_amount
from payment A
group by A.customer_id 
order by sum_amount desc
;

-- amount의 평균값이 5.00 이상인 결과집합을 출력하시오
-- 단, amount의 합계값을 기준으로 내림차순 정렬하시오
select 
	A.customer_id 
,	round(avg(A.amount), 2) as avg_amount
,	round(sum(A.amount), 2) as sum_amount
from payment A 
group by A.customer_id
having avg(A.amount) >= 5.00
order by sum_amount desc
;

--customer_id, first_name, last_name 별 amount의 평균값과 amount 합계값을 구하시오
select 
	A.customer_id 
,	c.first_name 
,	c.last_name 
,	round(avg(A.amount), 2) as avg_amount
,	round(sum(A.amount), 2) as sum_amount
from payment A
join customer c 
on A.customer_id = c.customer_id 
group by A.customer_id, c.first_name , c.last_name 
having avg(A.amount) >= 5.00
order by sum_amount desc
;

drop table if exists tb_avg_sum_test;
create table tb_avg_sum_test
(
	avg_sum_test_no char(6) primary key
,	avg_amount numeric(15, 2)
,	sum_amount numeric(15, 2)
)
;
commit;

insert into tb_avg_sum_test values ('100001', 100.00, 10.00);
insert into tb_avg_sum_test values ('100002', 100.00, 20.00);
insert into tb_avg_sum_test values ('100003', 100.00, 30.00);
insert into tb_avg_sum_test values ('100004', null, 40.00);
insert into tb_avg_sum_test values ('100005', 200.00, null);
insert into tb_avg_sum_test values ('100006', null, null);

commit;

select * from tb_avg_sum_test;

-- 평균을 구할 때 전체 합계를 4로 나눔.\
-- 즉, null인 행은 평균을 구할 떄 대상에 포함되지 않음
-- 합계를 구할때도 null인 행은 합계를 구하는 대상에 포함되지 않았음.
select round(avg(avg_amount), 2) as avg_amount
	,  round(sum(sum_amount), 2) as sum_amount
from  tb_avg_sum_test
;

-- 연산 시 null과 연산을 하려고 하면 결과는 null이 된다.
select avg_amount + sum_amount
from tb_avg_sum_test;

-- 숫자를 문자열로 바꾸기
select DT, cast(DT as varchar) as YYYYMMDD
from online_order oo 
;

-- 문자열 컬럼에서 일부만 잘라내기

select 	DT, left(cast(DT as varchar), 4) as yyyy
	,	substring(cast(DT as varchar), 5,2) as mm
	,	right(cast(dt as varchar),2) as dd 
from online_order oo 
;

-- YYYY-MM-DD 형식으로 이어서 출력해보시오

select 	DT, left(cast(DT as varchar), 4) as yyyy
	,	substring(cast(DT as varchar), 5,2) as mm
	,	right(cast(dt as varchar),2) as dd 
	, 	concat(left(cast(DT as varchar), 4),'-', substring(cast(DT as varchar), 5,2),'-',right(cast(dt as varchar),2) )
from online_order oo 
;

select 	dt 
	,	left(cast(dt as varchar), 4) || '-' ||
		substring(cast(dt as varchar), 5,2) || '-' ||
		right(cast(dt as varchar),2) as yyyymmdd 
from online_order oo 
;

-- null 값인 경우 임의값으로 바꿔주기
select coalesce(ui.gender, 'NA') as gender
	,  coalesce(ui.age_band, 'NA') as age_band
	,  sum(oo.gmv)
from online_order oo 
left join user_info ui 
on oo.userid = ui.userid 
group by 1,2
order by 1,2
;

-- 내가 원하는 값으로 컬럼추가해보기
select distinct case when gender = 'M' then '남성'
					 when gender = 'W' then '여성'
					 else 'NA'
					 end as gender
from user_info ui 
;

-- 연령대 그룹 만들어 출력하시오
-- 20대, 30대, 40대
-- 연령대별 매출액 출력하시오

select distinct case when ui.age_band = '20~24' then '20대'
					 when ui.age_band = '25~29' then '20대'
					 when ui.age_band = '30~34' then '30대'
					 when ui.age_band = '35~39' then '30대'
					 when ui.age_band = '40~44' then '40대'
					 when ui.age_band = '45~49' then '40대'
					 else 'NA'
					 end as age_group
	, sum(gmv) as gmv
from user_info ui 
join online_order oo 
on oo.userid = ui.userid
group by age_group
order by 1
;


