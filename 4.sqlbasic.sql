-- NULLIF 함수
select 
	nullif(1, 1)		as 첫번째		-- 1, 1이 같아 null이 리턴됨.
,	nullif(1, 0)		as 두번째		-- 1, 0이 달라 첫번째 인자인 1이 리턴됨.
,	nullif('A', 'A')	as 세번째		-- 'A', 'A'가 같아 null이 리턴됨.
,	nullif('A', 'B')	as 네번째		-- 'A', 'B'는 달라 첫번째 인자인 'A'가 리턴됨.
;	
	
-- COALESCE 함수
select 
	coalesce (null, 1)		as 첫번째		-- 첫번째 인자가 NULL이라서 NULL이 아닌 두번째 인자인 1을 리턴
,	coalesce (1, 0)			as 두번째		-- 첫번째 인자가 NULL이 아닌 1이라서 첫번째 인자인 1을 리턴함
,	coalesce ('A', 'B')		as 세번째		-- 첫번째 인자가 NULL이 아니라 'A'라서 첫번째 인자인 'A'를 리턴함.
,	coalesce (null, 'B')	as 네번째		-- 첫번째 인자가 NULL이라서 NULL이 아닌 두번째 인자인 'B'를 리턴함
;

-- CAST 함수
-- 문자영 '100'을 INTEGER형으로 변환
select cast ('100' as INTEGER) as CAST_AS_INTEGER
;

-- 오류
-- 문자열 '10C' INTEGER형이 될 수 없으므로 변환 실패
select 
	CAST('10C' as INTEGER) as CAST_AS_INTEGER
;

-- 문자열을 날짜형으로 형변환
select cast ('2023-01-01' as DATE) as "첫번째"
,	   cast('01-OCT-2023' as DATE) as "두번째"
;

-- 오류
-- 유효한 일자가 아니므로 변환 실패함
select CAST('2022-02-30' as DATE) as "첫번째"
;

-- 문자열을 실수형으로 형변환
select cast ('10.2' as DOUBLE PRECISION) as "첫번째"
;

-- 오류
select cast ('십쩜영이' as DOUBLE PRECISION) as 첫번째
;

-- 문자열을 INTERVAL 형으로 형변환
select 
	CAST('15 minute' as INTERVAL) as 첫번째
,	CAST('2 hour' as INTERVAL) as 두번째
,	CAST('1 day' as INTERVAL) as 세번째
,	CAST('2 week' as INTERVAL) as 네번째
,	CAST('3 month' as INTERVAL) as 댜섯번째
;

select now();
-- 문자열을 TIMESTAMP 형식으로 변환, 시간계산
select 
	cast('2022-09-26 10:43:12.084' as TIMESTAMP) - CAST('2 hour' as INTERVAL) as 첫번째
;

-- 문자열 함수
select ascii('A') as "ascii('A')"		-- 문자 'A'의 아스키코드값 리턴 
,	   chr(65) as "chr(65)"				-- 아스키코드 65의 문자를 리턴
,	   concat('A', 'B', 'C') as "concat('A', 'B', 'C')"		-- 문자열 합침
		-- 문자열을 구분자로 구분하면서 합침
,	   concat_ws('|', 'A', 'B', 'C') as "concat_ws('|', 'A', 'B', 'C')"
		-- 구분자가 있는 문자열에서 2번째 문자열을 리턴함
,	   split_part('A|B|C', '|', 2) as "split_part('A|B|C', '|', 2)"
,	   left ('ABC', 1) as "left ('ABC', 1)"		-- 왼쪽에서 1번째 문자 리턴
,	   right ('ABC', 1) as "right ('ABC', 1)" 	-- 오른쪽에 1번째 문자 리턴
,	   LENGTH('ABC') as "LENGTH('ABC')"			-- 문자열 길이 리턴
,	   lower('ABC') as "lower('ABC')"			-- 소문자로 바꿈
,	   upper('ABC') as "upper('ABC')"			-- 대문자로 바꿈
,	   lpad('123', 6, '0') as "lpad('123', 6, '0')"		-- 총 6자리 문자열로 왼쪽에 0을 채움
,	   rpad('123', 6, '0') as "rpad('123', 6, '0')"		-- 총 6자리 문자열로 오른쪽에 0을 채움
,	   ltrim(' 123') as "ltrim(' 123')"			-- 왼쪽에 있는 공백 제거함
,	   rtrim('123 ') as "rtrim('123 ')"			-- 오른쪽에 있는 공백 제거함
,	   trim(' 123 ') as "trim(' 123 ')"			-- 양쪽에 있는 공백 제거함
		-- ABC 문자열에서 B를 찾아서 순서를 리턴함.
,	   position ('B' in 'ABC') as "position ('B' in 'ABC')"
,	   repeat('*',10) as "repeat('*',10)"		-- *를 10번 반복함
,	   reverse('NEZE') as "reverse('NEZE')" 	-- 문자열을 거꾸로 출력함
,	   substring('ABC', 2, 2) as "substring('ABC', 2, 2)"	-- 2번째 문자로부터 2개의 문자를 출력함 
;

-- 날짜 관련 함수
-- AGE 함수 : 첫번째 인자값 - 두번째 인자값으로 시간(세월)의 차이를 리턴
select 
	age('2023-01-11', '2022-09-26') as "age('2023-01-11', '2022-09-26')"
,	age(current_date, '2023-01-11') as "age(current_date, '2023-01-11')"	
,	age(current_timestamp, current_timestamp-cast('2 hour' as interval))
	as "age(current_timestamp, current_timestamp-cast('2 hour' as interval))"
;

-- rental 테이블에서 대여기간이 가장 길었던 렌탈내역을 조회하시오.
select A.rental_id 
	   , A.customer_id 
	   , age(A.return_date, A.rental_date) as DURATION
from rental A
where A.return_date is not NULL
order by DURATION desc 
limit 10
;

-- 현재시간 정보 조회
select 
	current_date as "current_date"			-- 현재일자를 리턴
,	current_time as "current_time"			-- 현재시간을 리턴
	-- 세계표준시간에서 9시간 플러스된 시간이 한국시간이다.
,	current_timestamp as "current_timestamp" 		-- 현재일자와 시간을 리턴
,	localtime(6) as "localtime(6)"			-- 현재시간을 리턴
,	localtimestamp as "localtimestamp"		-- 현재일자와 시간을 리턴
,	now() as "now()"						-- 현재일자와 시간을 리턴 
	-- 현재일자와 시간에 1을 더함
,	now() + interval '1 day' as "now() + interval '1 day'" 	
	-- 현재일자와 시간에서 1일 2시간 30분을 뺴준다.
,	now() - interval '1 day 2 hours 3 minutes' as "now() - interval '1 day 2 hours 3 minutes'"
;	

-- 일자와 시간을 추출하는 함수
select 
	cast (date_part('year', current_timestamp) as varchar)
,	cast (date_part('month', current_timestamp) as varchar)
,	cast (date_part('week', current_timestamp) as varchar)
,	cast (date_part('day', current_timestamp) as varchar)
,	cast (date_part('hour', current_timestamp) as varchar)
,	cast (date_part('minute', current_timestamp) as varchar)
,	cast (date_part('second', current_timestamp) as varchar)
,	cast (extract(year from current_timestamp) as varchar)
,	cast (extract(month from current_timestamp) as varchar)
,	cast (extract(week from current_timestamp) as varchar)
,	cast (extract(day from current_timestamp) as varchar)
,	cast (extract(hour from current_timestamp) as varchar)
,	cast (extract(minute from current_timestamp) as varchar)
,	cast (extract(second from current_timestamp) as varchar)
,	DATE_TRUNC('hour', current_timestamp)
,	DATE_TRUNC('minute', current_timestamp)
,	DATE_TRUNC('second', current_timestamp)
;

-- 문자열을 일자 및 시간형으로 형변환하는 함수
select 
	to_date('20221224', 'YYYYMMDD')
,	to_date('2022-12-24', 'YYYY-MM-DD')
,	to_date('2022/12/24', 'YYYY/MM/DD')
,	to_timestamp('20221224093920', 'YYYYMMDDHH24MISS') 	
,	to_timestamp('2022-12-24 09:39:20.000', 'YYYY-MM-DD HH24:MI:SS') 
,	to_timestamp('2022/12/24 09:39:20.000', 'YYYY/MM/DD HH24:MI:SS')
;


-- 반올림, 올림, 내림, 자름 관련 함수
select 
	round(10.78, 0) as "round(10.78, 0)"		-- 10.78을 0의 자리에서 반올림
,	round(10.78, 1) as "round(10.78, 1)"		-- 10.78을 소수점 첫번째 자리에서 반올림
,	round(10.781, 2) as "round(10.781, 2)"		-- 10.78을 소수점 두번째 자리에서 반올림
,	ceil(12.4) as "ceil(12.4)"					-- 12.4를 0의 자리에서 올림
,	ceil(12.8) as "ceil(12.8)"					-- 12.8를 0의 자리에서 올림
,	ceil(12.1) as "ceil(12.1)"					-- 12.1을 0의 자리에서 올림
,	ceil(12.0) as "ceil(12.0)"					-- 12.0을 0의 자리에서 올림해도 그대로 12가 됨.
,	floor(12.4) as "floor(12.4)"				-- 12.4를 0의 자리에서 내림
,	floor(12.8) as "floor(12.8)"
,	floor(12.1) as "floor(12.1)"
,	floor(12.0) as "floor(12.0)"
,	trunc(10.78, 0) as "trunc(10.78, 0)"		-- 10.78을 0의 자리에서 잘라서 10이 됨.
,	trunc(10.78, 1) as "trunc(10.78, 1)"		-- 10.78을 소수점 첫번째 자리에서 잘라서 10이 됨
,	trunc(10.78, 2) as "trunc(10.78, 2)"		-- 10.78을 소수점 두번째 자리에서 잘라서 10.7이 
;

-- 연산 관련 함수
select 
	ABS(-10) as "ABS(-10)" 			-- 절댓값
,	ABS(10) as "ABS(10)"
,	sign(-3) as "sign(-3)"			-- -3은 음수라서 -1을 리턴
, 	sign(0) as "sign(0)"			-- 0은 0이라서 0을 리턴
,	sign(3) as "sign(3)"			-- 3은 양수라서 1을 리턴
,	div(9,2) as "div(9,2)"			-- 9 냐누기 2의 몫은 4 리턴 
,	mod(9,2) as "mod(9,2)"			-- 9 나누기 2의 나머지 1 리턴
,	log(10, 1000) as "log(10, 1000)"		-- 로그 10의 1000은 3 리턴
,	log(2, 8) as "log(2, 8)"		-- 로그 2의 8은 3 리턴
,	power(2, 3) as "power(2, 3)"	-- 2의 세제곱 8
,	sqrt(2) as "sqrt(2)"			-- 루트 2는 1.4142135623730951
,	sqrt(4) as "sqrt(4)"			-- 루트 4는 2
, 	random() as "random()"			-- 0~1까지의 실수값 랜덤으로 리턴 
, 	pi() as "pi()"					-- PI 값을 리턴
,	degrees(1) as "degrees(1)"		-- 1 라디안 
;














