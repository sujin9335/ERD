
use sujin;
create table tbl_board (
	board_id int(30) AUTO_INCREMENT PRIMARY KEY,
	board_title varchar(30) not null,
	board_content varchar(900) not null,
	user_id int(30) not null,
	board_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	board_view int(30) default 0
);

INSERT INTO tbl_board (board_title, board_content, user_id)
VALUES ('임시제목', '임시내용', 2);

select * from tbl_board tb ;

INSERT INTO tbl_board (board_title, board_content, user_id, board_date)
VALUES ('임시제목', '임시내용', 2, '2024-8-25');

select 
	user_id ,
	count(*) 
from tbl_board tb 
where DATE(board_date) = '2024-7-23'
group by user_id ;

SELECT DATE_FORMAT(board_date, '%Y,%c,%d') AS total_date, COUNT(*) AS total
FROM tbl_board
GROUP BY total_date
ORDER BY total_date;

SELECT DATE(board_date) AS insert_date
FROM tbl_board
GROUP BY insert_date
ORDER BY insert_date;

select board_view, COUNT(*) AS num_inserts
from tbl_board tb 
group by board_view ;

commit;

select board_id, board_title, board_content, user_id, DATE_FORMAT(board_date, '%Y-%m-%d') AS board_date, board_view 
from tbl_board tb 
ORDER BY board_id DESC
;






UPDATE tbl_board
SET board_view = (select board_view from tbl_board where board_id = 1)+1
WHERE board_id = 1 ;

select board_view from tbl_board where board_id = 1;




SELECT board_id, board_title, board_content, user_id, DATE_FORMAT(board_date, '%Y-%m-%d') AS board_date, board_view 
FROM tbl_board
LIMIT 5 OFFSET 3;

select count(*) from tbl_board;

SELECT board_id, board_title, board_content, user_id, DATE_FORMAT(board_date, '%Y-%m-%d') AS board_date, board_view
FROM tbl_board
WHERE board_title LIKE '%ㄴ%'
LIMIT 5 OFFSET 1;


select count(*) from tbl_board WHERE board_title LIKE '%ㄴ%';





create table tbl_file (
	file_id int(30) AUTO_INCREMENT PRIMARY KEY,
	file_name varchar(300) not null,
	file_save_name varchar(50) not null,
	file_extension varchar(30) not null,
	file_path varchar(300) not null,
	board_id int(30),
	FOREIGN KEY (board_id) REFERENCES tbl_board(board_id)
	ON DELETE CASCADE
);

ALTER TABLE tbl_file
MODIFY COLUMN file_name VARCHAR(300);


commit;


SELECT board_id 
FROM tbl_board tb 
ORDER BY board_id DESC
LIMIT 1;

select * from tbl_file;


drop table tbl_file;


delete from tbl_board ;


SELECT * FROM tbl_board tb order by board_id desc;


SELECT * FROM tbl_file WHERE board_id = '109';

-- 유저 테이블
create table tbl_user (
	user_id int(30) AUTO_INCREMENT PRIMARY KEY,
	user_login_id varchar(30) not null,
	user_pw varchar(100) not null,
	user_name varchar(30) not null,
	user_mail varchar(50),
	user_tel varchar(50),
	user_auth int(30),
	user_use varchar(2) default 'n',
	user_lock_cnt int(5) default 0
);

insert into tbl_user (user_login_id, user_pw, user_name, user_mail, user_tel, user_auth)
values ('admin', 'admin', '김수진', 'sujin_78@naver.com', '010-9335-6987', 0);

insert into tbl_user (user_login_id, user_pw, user_name, user_mail, user_tel, user_auth)
values ('su6', 'su1', '수진', 'sujin_78@naver.com', '010-9335-6987', 1);

select * from tbl_user;

commit;

SELECT 
    user_id,
    user_login_id,
    user_pw,
    user_name,
    user_mail,
    user_tel,
    user_auth,
    user_use,
    user_lock_cnt
FROM 
    tbl_user;
   
 select 
 user_login_id
 from
 tbl_user tu 
 where user_login_id = 'su';




-- 그룹 테이블
create table tbl_group (
	group_id int(30) AUTO_INCREMENT PRIMARY KEY,
	group_par_id int(30),
	group_name varchar(30) not null,
	group_info varchar(300) not null,
	FOREIGN KEY (group_par_id) REFERENCES tbl_group(group_id)
	ON DELETE CASCADE
);

drop table tbl_group;
drop table tbl_group_user_role;

select * from tbl_group order by group_id desc;

insert into tbl_group (group_name, group_info) 
values ("회사", "test회사");

insert into tbl_group (group_par_id, group_name, group_info) 
values (1, '본사', 'test회사-본사');

insert into tbl_group (group_par_id, group_name, group_info) 
values (1, '연구', 'test회사-연구');

insert into tbl_group (group_par_id, group_name, group_info) 
values (3, '시험', 'test회사-연구-시험');

insert into tbl_group (group_par_id, group_name, group_info) 
values (2, '관리', 'test회사-본사-관리');

insert into tbl_group (group_par_id, group_name, group_info) 
values (3, '영업', 'test회사-연구-영업');

insert into tbl_group (group_par_id, group_name, group_info) 
values (null, '회사2', 'test회사2');

commit;

create table tbl_group_user_role (
	group_id int(30),
	user_id int(30),
	FOREIGN KEY (group_id) REFERENCES tbl_group(group_id) ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES tbl_user(user_id) ON DELETE CASCADE
);

select * from tbl_group_user_role;

select 
	group_id,
	u.user_id,
	u.user_name,
	u.user_login_id 
from tbl_group_user_role gur
	inner join tbl_user u 
	on gur.user_id = u.user_id 
	WHERE group_id=13 && user_name LIKE '%%' 
	;

select * from tbl_group;
select * from tbl_user;
select * from tbl_group_user_role;

insert into tbl_group_user_role (group_id, user_id)
values (13, 28);

delete from tbl_group_user_role;

SELECT DATE_FORMAT(board_date, '%Y,%c,%d') AS total_date, COUNT(*) AS total
FROM tbl_board
GROUP BY total_date
ORDER BY total_date;

select 
	tg.group_name,
	count(tgur.group_id) as count
from tbl_group tg 
left join tbl_group_user_role tgur 
on tg.group_id = tgur.group_id 
group by tg.group_id ;



select 
	* 
from tbl_group tg 
left join tbl_group_user_role tgur 
on tg.group_id = tgur.group_id ;


select 
	tg.group_name,
	count(tgur.group_id) as count 
from tbl_group_user_role tgur
inner join tbl_group tg
on tg.group_id = tgur.group_id 
group by tgur.group_id ;


select 
	group_id,
	tu.user_login_id 
from tbl_group_user_role tgur 
inner join tbl_user tu 
on tgur.user_id = tu.user_id 
where tgur.group_id = 4;

select 
	tu.user_login_id as name,
	1 as y
from tbl_group_user_role tgur 
inner join tbl_user tu 
on tgur.user_id = tu.user_id 
where tgur.group_id = 4;

select 
	group_id,
	count(group_id) as count 
from tbl_group_user_role tgur
group by group_id ;
	

left join 
on tg.group_id = tgur.group_id ;


SELECT * FROM tbl_user
WHERE user_id NOT IN ();

select user_id, user_login_id, user_name 
FROM tbl_user 
WHERE user_name LIKE '%%' && user_id NOT IN (28) 
ORDER BY user_id desc;


select * from tbl_group_user_role where group_id = 1;


select user_id, user_login_id, user_name FROM tbl_user WHERE user_name LIKE '%%' ORDER BY user_id desc;



SELECT 
	* 
FROM tbl_user
	where user_login_id = 'sj' and user_pw = '3b0cb6318e56ff096de92f7c4a8c682a679946c3f2cfea1fa6e822aaa9eae39c';


select user_lock_cnt from tbl_user where user_login_id = 'sj';
start transaction;
update tbl_user 
set user_lock_cnt = (select user_lock_cnt from tbl_user where user_login_id = 'sj') + 1
where user_login_id = 'sj';

update tbl_user 
set user_lock_cnt = 0
where user_login_id = 'sj';

commit;
select * from tbl_user tu order by user_id desc ;

rollback;

SELECT 
    user_id, 
    user_login_id, 
    user_pw, 
    user_name, 
    user_mail, 
    user_tel, 
    user_auth, 
    user_use, 
    user_lock_cnt
FROM 
    tbl_user;


update tbl_user 
set user_use = 'y'
where user_login_id = 'sj';



select board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%Y-%m-%d %H:%i') AS board_date, board_view, tu.user_login_id 
from tbl_board tb 
inner join tbl_user tu 
on tb.user_id = tu.user_id 
WHERE board_title LIKE '%%%%' 
ORDER BY board_id desc; 
LIMIT 1 OFFSET 5;

SELECT board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%Y-%m-%d') AS board_date, board_view, tu.user_login_id
FROM tbl_board tb

select count(*) from tbl_board tb ;
select * from tbl_board tb ;

select board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%Y-%m-%d %H:%i') AS board_date, board_view, tu.user_login_id
from tbl_board tb 
inner join tbl_user tu
on tb.user_id = tu.user_id
WHERE 'board_title' LIKE '%%%%'
ORDER BY board_id DESC
LIMIT 5 OFFSET 25 ;

delete from tbl_board where user_id = 4; 

commit;

select board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%Y-%m-%d %H:%i') AS board_date, board_view
from tbl_board tb 
inner join tbl_user tu
on tb.user_id = tu.user_id
WHERE 'board_title' LIKE '%%%%'
ORDER BY board_id DESC
LIMIT 5 OFFSET 25 ;







-- 좌표이동 테스트
create table tbl_move (
	move_id int(30) AUTO_INCREMENT PRIMARY KEY,
	move_x int(100) not null,
	move_y int(100) not null
);

insert into tbl_move( move_x, move_y) 
values(300, 400);

commit;


select * from tbl_move;

select board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%%Y-%%m-%%d %%H:%%i') AS board_date, board_view, tu.user_login_id
from tbl_board tb
inner join tbl_user tu
on tb.user_id = tu.user_id
WHERE user_login_id LIKE '%s%'
ORDER BY board_id DESC 
LIMIT 5 OFFSET 0;







select
count(*)
from tbl_board tb
inner join tbl_user tu
on tb.user_id = tu.user_id
WHERE user_login_id LIKE '%s%'



SELECT board_id, board_title, user_id, board_date, board_view, user_nickname 
FROM (    SELECT board_id, board_title, tb.user_id,            
DATE_FORMAT(board_date, '%Y-%m-%d %H:%i') AS board_date,            
board_view, tu.user_nickname,            
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn     
FROM tbl_board tb     
INNER JOIN tbl_user tu ON tb.user_id = tu.user_id     
WHERE board_title LIKE '%%') AS subquery ORDER BY rn DESC LIMIT 5 OFFSET 0



select board_id, board_title, DATE_FORMAT(board_date, '%Y-%m-%d %H:%i') AS board_date, board_view, board_date as time
from tbl_board order by time desc;


select *
from tbl_board order by board_date desc;

select * from tbl_file where board_id='451f5385-4109-4556-8c37-54772e3ffe68';
select * from tbl_file;

SELECT board_id 
				FROM tbl_board tb 
				ORDER BY board_date DESC
				LIMIT 1;
				
ALTER TABLE tbl_board
    MODIFY COLUMN board_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    commit;
