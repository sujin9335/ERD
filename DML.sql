use sujin;

-- 게시글 
select * from tbl_board tb ;
delete from tbl_board ;


INSERT INTO tbl_board (board_id ,board_title, board_content, user_id)
VALUES ('019feb9a-1d76-4238-805b-da2250a133c6', '<p>임시제목2</p>', '임시내용2', '263d5a3f-82ab-4ff0-817a-77483353983c');

INSERT INTO tbl_board (board_title, board_content, user_id)
VALUES ('임시제목', '임시내용', '319b1008-c52a-42be-8d68-ec909f7fee5a');

INSERT INTO tbl_board (board_title, board_content, user_id)
VALUES ('임시', '임시', '319b1008-c52a-42be-8d68-ec909f7fee5a');

select 
	tb.user_id,
	tu.user_auth 
from tbl_board tb 
inner join tbl_user tu 
on tb.user_id = tu.user_id 
where board_id = 2;



SELECT 
  tb.board_id, 
  tb.board_title, 
  tb.user_id, 
  DATE_FORMAT(tb.board_date, '%Y-%m-%d %H:%i') AS board_date, 
  tb.board_view, 
  tu.user_nickname, 
  tb.board_date AS time,
  count(tf.file_id) as file_count
FROM 
  tbl_board tb 
INNER JOIN 
  tbl_user tu 
ON 
  tb.user_id = tu.user_id 
left outer join 
  tbl_file tf 
on
  tf.board_id = tb.board_id 
WHERE 
  board_title LIKE '%%' 
ORDER BY 
  time DESC;


 
 
 UPDATE tbl_board
				SET board_view = board_view +1 
				WHERE board_id = '05ff2c14-2e97-4253-bded-96192e03d788';
 
 select * from tbl_board tb  where board_id = '05ff2c14-2e97-4253-bded-96192e03d788';

select table_name from information_schema.tables where table_name = 'tbl_board';
select * from tbl_board tb limit 1;

ALTER TABLE tbl_board 
MODIFY COLUMN board_title VARCHAR(100) NOT NULL,
MODIFY COLUMN board_content VARCHAR(4000) NOT NULL;
 

-- 파일
select * from tbl_file tf ;
delete from tbl_file ;

-- 유저
select * from tbl_user tu ;
delete from tbl_user ;

insert into tbl_user (user_id, user_login_id, user_pw, user_name, user_mail, user_tel, user_auth, user_use, user_nickname)
values ('319b1008-c52a-42be-8d68-ec909f7fee5a', 'sj', '3b0cb6318e56ff096de92f7c4a8c682a679946c3f2cfea1fa6e822aaa9eae39c', '수진딸기', 'sujin_78@naver.com', '010-9335-6987', 1, 'y', '딸기');

insert into tbl_user (user_id, user_login_id, user_pw, user_name, user_mail, user_tel, user_auth, user_use, user_nickname)
values ('263d5a3f-82ab-4ff0-817a-77483353983c', 'sj2', '3b0cb6318e56ff096de92f7c4a8c682a679946c3f2cfea1fa6e822aaa9eae39c', '수진바나나', 'sujin_78@naver.com', '010-9335-6987', 0, 'y', '바나나');


commit;