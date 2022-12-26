select 1 + 1 as 일더하기일;

create table TB_EMP
(
	EMP_NO CHAR(10)			-- 고정 길이 10자리의 문자열
,	EMP_NM VARCHAR(50)		-- 최대 50자리의 가변 길이 문자열
,	SELF_INTRO TEXT			--길이 제한 없이 가변 길이 문자열
);

drop table TB_EMP;

create table TB_EMP
(
	EMP_NO SERIAL primary key		-- 자동으로 순차적으로 1,2,3,4.....
,	AGE smallint
,	GRADE_POINT NUMERIC(3,2)		-- 0.00 ~ 4.50
,	SAL NUMERIC(9)
,	TOT_ASSET INT
);

insert into TB_EMP (AGE,grade_point,SAL,tot_asset)
values (35, 4.25, 58700000, 1250000000);
insert into TB_EMP (AGE,grade_point,SAL,tot_asset)
values (35, 4.26, 58700001, 1250000001);

select * from tb_emp;
drop table TB_EMP;

create table TB_EMP
(
	BIRTH_DE	DATE
,	JOIN_DT		TIMESTAMP
,   JOIN_DT_WITHOUT_TIMEZONE	TIMESTAMP
,	TASK_BEGIN_TM	TIME
);

insert into tb_emp
values ('2022-09-21', '2022-09-21 125630.123456',
'2022-02-22 125630.123456'at TIME zone 'America/Santiago', '18:00:00');

select * from tb_emp;

show TIMEZONE;

drop table tb_emp ;

/**
 *  :: 타임변환
 * 	- value::type
 */

select CURRENT_DATE as "current_date"		-- 현재날짜 가져오기
,		current_time as "current_time"		-- 현재시간(마이크로세컨드단위까지) 가져오기
,		current_timestamp as "current_time"		-- 현재일시(마이크로세컨드단위까지) 가져오기
,		now() as "now()"	-- 현재일시(마이크로세컨드단위까지) 가져오기
, 		now()::date as "now()::date"		-- 현재날짜 가져오기
,		now()::time as "now()::time"		-- 현재시간 가져오기
;

---------------------------------------------------------------------------------------------------
create table tb_user
(
	used_id char(10) primary key
,	user_nm varchar(50) not null
,	password varchar(50) not null
,	email_address varchar(255) unique not null
, 	create_on timestamp not null
,	last_login timestamp
);

create table tb_role
( 
	role_id char(10) primary key
,	role_nm varchar(255) not null
);

create table tb_user_role
( 
	used_id char(10) not null
,	role_id char(10) not null
, 	primary key (used_id, role_id)
,	foreign key (role_id) references tb_role(role_id)
,	foreign key (used_id) references tb_user(used_id)
);
------------------------------------------------------------
drop table if exists TB_LINK;
create table TB_LINK
(
	Link_ID SERIAL primary key
,	TITLE VARCHAR(512) not null
, 	URL VARCHAR(1024) not Null
);
 
alter table tb_Link add column ACTIVE_YN CHAR(1);
select * from tb_link;

alter table tb_link drop column ACTIVE_YN;

alter table tb_link rename column TITLE to LINK_TITLE;

alter table tb_link add column TARGET VARCHAR(10);

--TARGET 컬럼의 디폴트 값을 '_BLANK'
alter table tb_link alter column target set default '_blank';

insert into tb_link(link_title, url) values('애플', 'https://www.apple.com/');
select * from tb_link;

-- TARGET 컬럼에 저장되는 값은 '_blank', '_parent', '_self', '_top'로만 함
alter table tb_link add CHECK(TARGET in('_blank', '_parent', '_self', '_top'));

insert into tb_link (link_title,url,target)
values('피그마', 'https://www.figma.com/', '체크 제약조건에 없는거');

insert into tb_link (link_title,url,target)
values('피그마', 'https://www.figma.com/', '_self');

insert into tb_link (link_title,url)
values('애플', 'https://www.apple.com/');
select * from tb_link;
--url 컬럼에 UNIQUE 제약조건 추가
alter table tb_link add constraint UNIQUE_URL unique (URL);

insert into tb_link (LINK_TITLE, URL,target)
values('사과','https://www.apple.com/','_self');

delete from tb_link where link_id =1;

------------------------------------------------------------------------



create table TB_ASSET 
( 
	ASSET_NO SERIAL primary key
,	ASSET_NM text not null
,	ASSET_ID VARCHAR not NULL
,	DESCRIPTION text
,	LOC text
,	ACQUIRED_DE DATE not NULL
);

insert into tb_asset (asset_nm,asset_id,loc,acquired_de)
values ('SERVER', '10001', 'SERVER ROOM', '2002-09-21');
insert into tb_asset (asset_nm,asset_id,loc,acquired_de)
values ('UPS', '10002', 'SERVER ROOM', '2002-09-22');
select * from tb_asset;

-- ASSET_NM 컬럼의 데이터 타입을 text => VARCHAR로 변경
alter table tb_asset alter column ASSET_NM type VARCHAR; 		

-- DESCRIPTION, LOC 컬럼의 데이터 타입을 text => VARCHAR로 변경 (두 개를 한번에 바꿈)
alter table tb_asset 
	alter column LOC type VARCHAR
,	alter column DESCRIPTION type VARCHAR
;

-- 오류 발생
alter table tb_asset alter column ASSET_ID type INT;

-- 컬럼의 데이터 타입을 변경 - INTEGER로 변경 -> USING절 이하 추가
alter table tb_asset alter column ASSET_ID type INT using ASSET_ID::INTEGER;

-- ASSET_ID => ASSET_ID_2 변경
alter table tb_asset rename column ASSET_ID to ASSET_ID_2; 


create table TB_INVOICE
(
	INVOICE_NO SERIAL primary key
,	ISSUE_DE TIMESTAMP
,	PRDT_NM VARCHAR(150)
);

insert into tb_invoice (issue_de, prdt_nm) values (CURRENT_TIMESTAMP, '아메리카노');
insert into tb_invoice (issue_de, prdt_nm) values (CURRENT_TIMESTAMP, '카페라떼');
insert into tb_invoice (issue_de, prdt_nm) values (CURRENT_TIMESTAMP, '모카라떼');

select * from tb_invoice;

-- 테이블의 내용 전체 비우기
truncate table tb_invoice;

-- truncate table시 restart identity 옵션을 줌 => SERIAL 값이 초기화 됨
truncate table tb_invoice restart identity;

-- 테이블 제거
drop table tb_invoice;

-- if exists문 사용하여, 존재하지 않으면 제거하지 않아서 SQL에러 발생하지 않음.
drop table if exists TB_INVOICE;

















