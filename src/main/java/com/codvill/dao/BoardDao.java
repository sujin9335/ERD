package com.codvill.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDao {

	private static final Logger logger = LoggerFactory.getLogger(BoardDao.class);
	static JdbcTemplate jt;

	@Autowired
	@Resource(name = "dataSource")
	DataSource ds;

	String dbType = "";

	private boolean isLoaded;

	@PostConstruct
	public void init() {
		new Thread(this::loadDatasource).start();
	}

	// 처음 실행시 디비가 제대로 실행되지 않은상태라면
	// 아래 로직을 실행하다 전체 서비스가 중단된다.
	// 이를 막기위해 쓰레드로 동작하게처리함.
	private void loadDatasource() {

		while (!isLoaded) {
			try {
				jt = new JdbcTemplate(ds);
				// dbType = getDbType();
				isLoaded = true;
			} catch (Exception e) {
				isLoaded = false;
				try {
					Thread.sleep(1000L);
				} catch (Exception ignored) {
				}
			}
		}
	}//

	
	public JSONObject boardList(Map<String, Object> param) { //{offset=0, listSize=5, searchType=board_title, search=}
		JSONObject result = new JSONObject();

		String offset = param.get("offset").toString();
		String listSize = param.get("listSize").toString();
		String searchType = param.get("searchType").toString();
		String search = param.get("search").toString();
		if (searchType == null || searchType.equals("")) {
			searchType = "board_title";
		}

		// 리스트
		String sql = String.format(
				"select tb.board_id, tb.board_title, tb.user_id, DATE_FORMAT(tb.board_date, '%%Y-%%m-%%d %%H:%%i') AS board_date, tb.board_view, tu.user_nickname, board_date as time, count(tf.file_id) as file_count " +
				"from tbl_board tb " +
						"inner join tbl_user tu " +
						"on tb.user_id = tu.user_id " +
						"left join tbl_file tf " +
						"on tb.board_id = tf.board_id " +
						"WHERE %s LIKE '%%%s%%' " +
						"GROUP BY tb.board_id, tb.board_title, tb.user_id, tb.board_date, tb.board_view, tu.user_nickname " +
						"ORDER BY time DESC " +
						"LIMIT %s OFFSET %s ",
				searchType, search, listSize, offset);
				System.out.println(sql);

		List<Map<String, Object>> list = jt.queryForList(sql);

		// 총 갯수
		sql = String.format(
			"select " +
				"count(*) " +
			"from tbl_board tb " +
			"inner join tbl_user tu " +
			"on tb.user_id = tu.user_id " +
			"WHERE %s LIKE '%%%s%%'", 
			searchType, search);
		int total = jt.queryForObject(sql, Integer.class);

		result.put("data", list);
		result.put("total", total);

		return result;


	}

	public Map<String, Object> boardGet(Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		String id = param.get("board_id").toString();

		// get
		String sql = String.format(
			"SELECT board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%%Y-%%m-%%d') AS board_date, board_view, tu.user_nickname " +
				"FROM tbl_board tb " +
				"inner join tbl_user tu " +
				"on tb.user_id = tu.user_id " +
				"WHERE board_id = '%s'",
				id);
		result = jt.queryForMap(sql);
		return result;
	}

	public void boardViewCountAdd(Map<String, Object> param) {

		String id = param.get("board_id").toString();
		String sql = String.format("UPDATE tbl_board " +
				"SET board_view = (select board_view from tbl_board where board_id = '%s')+1 " +
				"WHERE board_id = '%s'", 
				id, id);
		jt.update(sql);

	}

    public List<Map<String, Object>> fileListGet(Map<String, Object> param) {
		List<Map<String, Object>> files = new ArrayList<>();

		String id = param.get("board_id").toString();
		String sql = String.format("select * " +
				"from tbl_file where board_id='%s'", 
				id);
		files = jt.queryForList(sql);

		return files;
    }

	public void boardInsert(Map<String, Object> param) {
		UUID uuid = UUID.randomUUID();

		String id = uuid.toString();
		String title = param.get("board_title").toString();
		String content = param.get("board_content").toString();
		String userId = param.get("user_id").toString();

		String sql = String.format("INSERT INTO tbl_board (board_id, board_title, board_content, user_id) " +
				"VALUES ('%s', '%s', '%s', '%s')", id, title, content, userId);
		jt.update(sql);

	}

	public void boardUpdate(Map<String, Object> param) { //{"user_id":"1","board_title":"2","file_id":["7","8","9"],"board_id":"10","board_content":"2"}

		String title =  param.get("board_title").toString();
		String content = param.get("board_content").toString();
		String id =  param.get("board_id").toString();

		String sql = String.format("UPDATE tbl_board " +
				"SET board_title = '%s', board_content = '%s' " +
				"WHERE board_id = '%s'", title, content, id);

		jt.update(sql);
	}

	public int boardDel(Map<String, Object> param) {
		int value = -1;
		String id = param.get("board_id").toString();

		String sql = String.format("DELETE FROM tbl_board " +
				"WHERE board_id = '%s'", id);

		// System.out.println(sql);

		value = jt.update(sql);
		

		return value;
	}

	public String getLast() {
		System.out.println("마지막데이터조회");
		String sql = "SELECT board_id " +
				"FROM tbl_board tb " +
				"ORDER BY board_date DESC " +
				"LIMIT 1";

		return jt.queryForObject(sql, String.class);
	}

	public void fileInsert(String fileName, String fileId, String fileExtension, String uploadPath,
			String board_id) {
		String sql = String.format(
				"INSERT INTO tbl_file (file_id, file_name, file_extension, file_path, board_id) " +
						"VALUES ('%s', '%s', '%s', '%s', '%s')",
				fileId, fileName,  fileExtension, uploadPath, board_id);

		jt.update(sql);

	}

	public Map<String, Object> fileGet(String id) {
		String sql = String.format("SELECT * " +
				"FROM tbl_file " +
				"WHERE file_id = '%s' ", id);

		// System.out.println(sql);

		// jt.queryForList(sql);

		Map<String, Object> map = jt.queryForMap(sql);

		return map;
	}

	public List<Map<String, Object>> fileList(String board_id) {
		List<Map<String, Object>> list = new ArrayList<>();

		String sql = String.format("SELECT * " +
				"FROM tbl_file " +
				"WHERE board_id = '%s' ", board_id);

		list = jt.queryForList(sql);

		return list;
	}

	public void delFile(String id) {
		System.out.println("delFile 작동");

		String sql = String.format("DELETE FROM tbl_file " +
				"WHERE file_id = '%s'", id);

		jt.update(sql);
	}

	public String boardGetUserId(Map<String, Object> param) {
		String result="-1";
		String boardId = param.get("board_id").toString();

		String sql = String.format("SELECT user_id " +
				"FROM tbl_board " +
				"WHERE board_id = '%s'", boardId);
		try {
			result = jt.queryForObject(sql, String.class);
		} catch (Exception e) {
			System.out.println("user없음 발생");
		}

		return result;
		
	}

	

}
