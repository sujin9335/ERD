use sujin;

-- 게시글 
select * from tbl_board tb ;
delete * from tbl_board ;


INSERT INTO tbl_board (board_title, board_content, user_id)
VALUES ('<p>임시제목2</p>', '임시내용2', 2);

INSERT INTO tbl_board (board_title, board_content, user_id)
VALUES ('임시제목', '임시내용', 1);

-- 파일
select * from tbl_file tf ;


-- 유저
select * from tbl_user tu ;
delete from tbl_user ;

insert into tbl_user (user_login_id, user_pw, user_name, user_mail, user_tel, user_auth, user_use, user_nickname)
values ('sj', '3b0cb6318e56ff096de92f7c4a8c682a679946c3f2cfea1fa6e822aaa9eae39c', '수진딸기', 'sujin_78@naver.com', '010-9335-6987', 1, 'y', '딸기');

insert into tbl_user (user_login_id, user_pw, user_name, user_mail, user_tel, user_auth, user_use, user_nickname)
values ('sj2', '3b0cb6318e56ff096de92f7c4a8c682a679946c3f2cfea1fa6e822aaa9eae39c', '수진바나나', 'sujin_78@naver.com', '010-9335-6987', 0, 'y', '바나나');