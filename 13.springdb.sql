-- 사용자 테이블
drop table if exists t_user;
create table t_user
(
	id 		varchar(30) 	not null	primary key
	, pwd	varchar(50)
	, name 	varchar(30)
	, email	varchar(30)
	, birth date
	, sns 	varchar(30)
	, reg_date date
)
;

select * from t_user;

INSERT INTO public.t_user
(id, pwd, "name", email, birth, sns, reg_date)
VALUES('ezen', '0111', 'ezen', 'ezen@gmail.com', '2000-11-01', 'youtube', now());
INSERT INTO public.t_user
(id, pwd, "name", email, birth, sns, reg_date)
VALUES('ezen2', '0111', 'ezen2', 'ezen2@gmail.com', '2001-11-01', 'facebook', now());

delete from t_user ;
rollback;

select now();


UPDATE public.t_user
SET pwd='', "name"='', email='', birth='', sns='', reg_date=''
WHERE id='';

--여기가 세이브 포인트 지점


INSERT INTO public.t_user
(id, pwd, "name", email, birth, sns, reg_date)
VALUES('ezen5', '0111', 'ezen5', 'ezen5@gmail.com', '2001-11-01', 'facebook', now());

savepoint SVPT2;

UPDATE public.t_user
SET pwd='0112', "name"='ezenIT5', email='ezenIT5@gmail.com', birth='2001-12-01', 
sns='', reg_date=now()
WHERE id='ezen5';

rollback to SVPT2;


-- 게시판 테이블
create table if not exists t_board
(
	bno 			serial primary key
	,title			varchar(100)	not null
	,content		text			not null
	,writer			varchar(30)	 	not null
	,view_cnt		int default 0
	,comment_cnt	int default 0
	,reg_date		date default current_timestamp
	,up_date		date default current_timestamp
);


INSERT INTO t_board
(title, "content", writer, view_cnt, comment_cnt, reg_date, up_date)
VALUES('test title', 'test content', 'test writer', 1, 3, now(), now());

select * from t_board;

SELECT bno, title, "content", writer, view_cnt, comment_cnt, reg_date
FROM t_board;

delete from t_board ;

INSERT INTO t_board
(title, "content", writer)
VALUES('test title', 'test content', 'test writer');

select count(*) from t_board; 

-- 데이터 삭제 및 serial 키 재설정 
truncate table t_board restart identity;

select bno , title , "content" , writer , view_cnt , comment_cnt , reg_date 
from t_board
order by reg_date desc, bno desc 
limit 50 offset 0
;

update t_board 
set view_cnt = view_cnt + 1
where bno = 300
;


delete from t_board where bno = 225 and writer = 'ezen';

UPDATE public.t_board
SET title='수요일 낮', "content"='온화한 날씨입니다.', up_date = now() 
WHERE bno= 287 and writer = 'ezen';


---검색
select * from t_board
where true and title like 'Pioneering1%';

select * from t_board
where true and title like 'Pioneering1_';

select * from t_board
where true and title like concat('Pioneering1', '%');

select * from t_board
where true and title like concat('Pioneering1', '_');


select * from t_board
where true and title not like 'Pioneering1%';

select * from t_board
where true and title not like concat('Pioneering1', '_');

select * from t_board 
where true and title in ('Pioneering1', 'Pioneering2', 'Pioneering3');

select * from t_board 
where true and bno in (53, 54, 55, 56);

select * from t_board 
where true and bno not in (53, 54, 55, 56);

select bno , title , "content" , writer , view_cnt , comment_cnt , reg_date 
from t_board 
where true 
and title like concat('%', 'Pioneering1', '%') 
order by reg_date desc, bno desc 
limit 10 offset 0;	


select count(*) 
from t_board
where true 
and title like concat('%', 'Pioneering1', '%');

-- 댓글 테이블 
create table if not exists t_comment 
(
	cno 		serial
	,bno 		int 	not null
	,pcno		int 	
	,comment 	varchar(3000)
	,commenter	varchar(30)
	,reg_date	date  default now()
	,up_date 	date  default now()
	,primary key(cno)
);

INSERT INTO public.t_comment
(bno, "comment", commenter)
VALUES(308, 'hello', 'ezen');

select * from t_comment;

INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');
INSERT INTO public.t_comment (bno, "comment", commenter) VALUES(307, 'hello', 'ezen');

delete from t_comment 
where bno = 308;

select cno, bno , pcno , "comment" , commenter , reg_date , up_date 
from t_comment
where bno = 307
order by reg_date, cno 
;


UPDATE public.t_board
SET comment_cnt=10 
WHERE bno=307;

update t_board 
set comment_cnt = comment_cnt + (-1)
where bno = 307
;

update t_board 
set comment_cnt = comment_cnt + 1
where bno = 308
;

delete from t_comment where cno = 2 and commenter = 'ezen'
;

INSERT INTO t_comment
   (bno, pcno, comment, commenter, reg_date, up_date)
values
   (308, 0, 'ezen it', 'ezen', now(), now());


update t_comment 
set comment = '2023년 새해', up_date = now()
where cno = 11 and commenter = 'ezen'
;







