use sujin;

create table tbl_board (
	board_id int(30) AUTO_INCREMENT PRIMARY KEY,
	board_title varchar(30) not null,
	board_content varchar(900) not null,
	user_id int(30) not null,
	board_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	board_view int(30) default 0
);

drop table tbl_board ;

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

drop table tbl_file;

create table tbl_user (
	user_id int(30) AUTO_INCREMENT PRIMARY KEY,
	user_login_id varchar(30) not null,
	user_pw varchar(100) not null,
	user_name varchar(30) not null,
	user_mail varchar(50),
	user_tel varchar(50),
	user_auth int(30),
	user_use varchar(2) default 'n',
	user_lock_cnt int(5) default 0,
	user_nickname varchar(30) not null
);

drop table tbl_user;