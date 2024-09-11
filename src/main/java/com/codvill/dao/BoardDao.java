package com.codvill.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

import org.apache.kafka.common.protocol.types.Field.Str;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.codvill.comm.Utils;

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

		int offset = 0;
		

		if(param.get("offset") != null) {
			offset = (Integer)param.get("offset");
		}
		String listSize = Utils.nvl((String)param.get("listSize"), "5");
		String searchType = Utils.nvl((String)param.get("searchType"), "board_title");
		String search = Utils.nvl((String)param.get("search"), "");

		// 총 갯수
		String totalSql =
			"select " +
				"count(*) " +
			"from tbl_board tb " +
			"inner join tbl_user tu " +
			"on tb.user_id = tu.user_id " +
			"WHERE "+ searchType +" LIKE ?";
			
		int total = jt.queryForObject(totalSql, new Object[] {"%" + search + "%"} ,Integer.class);
	
		List<Map<String, Object>> list = new ArrayList<>();
		if(total > 0) {
			// 리스트
			String listSql = 
				"SELECT tb.board_id, tb.board_title, tb.user_id, " +
				"DATE_FORMAT(tb.board_date, '%Y-%m-%d %H:%i') AS board_date, tb.board_view, tu.user_nickname, " +
				"tb.board_date as time, COUNT(tf.file_id) as file_count " +
				"FROM tbl_board tb " +
				"INNER JOIN tbl_user tu ON tb.user_id = tu.user_id " +
				"LEFT JOIN tbl_file tf ON tb.board_id = tf.board_id " +
				"WHERE " + searchType + " LIKE ? " + 
				"GROUP BY tb.board_id, tb.board_title, tb.user_id, tb.board_date, tb.board_view, tu.user_nickname " +
				"ORDER BY time DESC " +
				"LIMIT ? OFFSET ?";
			
			list = jt.queryForList(listSql, "%" + search + "%", Integer.parseInt(listSize), offset);

		}

		result.put("data", list);
		result.put("total", total);

		return result;


	}

	public Map<String, Object> boardGet(Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		String id = Utils.nvl((String)param.get("board_id"), "");

		// get
		String sql = 
			"SELECT board_id, board_title, board_content, tb.user_id, DATE_FORMAT(board_date, '%Y-%m-%d') AS board_date, board_view, tu.user_nickname " +
			"FROM tbl_board tb " +
			"INNER JOIN tbl_user tu " +
			"ON tb.user_id = tu.user_id " +
			"WHERE board_id = ?";

		try {
			result = jt.queryForMap(sql, id);
		} catch (Exception e) {
			System.out.println("일치하는 게시글이 없습니다");
		}
		return result;
	}

	public void boardViewCountAdd(Map<String, Object> param) {

		String id =  Utils.nvl((String)param.get("board_id"), "");
		String sql = "UPDATE tbl_board " +
				"SET board_view = board_view + 1 " +
				"WHERE board_id = ?";
		jt.update(sql, id);

	}

    public List<Map<String, Object>> fileListGet(Map<String, Object> param) {
		List<Map<String, Object>> files = new ArrayList<>();

		String id = Utils.nvl((String)param.get("board_id"), "");
		String sql ="select * " +
				"from tbl_file where board_id=?";
		files = jt.queryForList(sql, id);

		return files;
    }

	public void boardInsert(Map<String, Object> param, String id) { //{"board_title":"2","board_content":"2","user_id":"1"}

		String title = Utils.nvl((String)param.get("board_title"),"");
		String content = Utils.nvl((String)param.get("board_content"),"");
		String userId = Utils.nvl((String)param.get("user_id"),"");

		String sql ="INSERT INTO tbl_board (board_id, board_title, board_content, user_id) " +
				"VALUES (?, ?, ?, ?)";
		jt.update(sql, id, title, content, userId);

	}

	public void boardUpdate(Map<String, Object> param) { //{"user_id":"1","board_title":"2","file_id":["7","8","9"],"board_id":"10","board_content":"2"}

		String title =  Utils.nvl((String)param.get("board_title"),"");
		String content = Utils.nvl((String)param.get("board_content"),"");
		String id =  Utils.nvl((String)param.get("board_id"),"");

		String sql = "UPDATE tbl_board " +
				"SET board_title = ?, board_content = ? " +
				"WHERE board_id = ?";

		jt.update(sql, title, content, id);
	}

	public void boardDel(String id) {

		String sql = "DELETE FROM tbl_board " +
				"WHERE board_id = ?";

		// System.out.println(sql);

		jt.update(sql, id);
	}
	

	public void fileInsert(String fileName, String fileId, String fileExtension, String uploadPath, String board_id) {
		String sql =
				"INSERT INTO tbl_file (file_id, file_name, file_extension, file_path, board_id) " +
						"VALUES (?, ?, ?, ?, ?)";

		jt.update(sql, fileId, fileName, fileExtension, uploadPath, board_id);

	}

	public Map<String, Object> fileGet(String id) {
		Map<String, Object> map = null;
		String sql = "SELECT * " +
				"FROM tbl_file " +
				"WHERE file_id = ? ";

		try {
			map = jt.queryForMap(sql, id);
		} catch (Exception e) {
			System.err.println("파일정보가 없습니다");
		}

		return map;
	}

	// public List<Map<String, Object>> fileList(String board_id) {
	// 	List<Map<String, Object>> list = new ArrayList<>();

	// 	String sql = String.format("SELECT * " +
	// 			"FROM tbl_file " +
	// 			"WHERE board_id = '%s' ", board_id);

	// 	list = jt.queryForList(sql);

	// 	return list;
	// }

	public void delFile(String id) {
		String sql = "DELETE FROM tbl_file " +
				"WHERE file_id = ?";

		jt.update(sql, id);
	}

	// public String boardGetUserId(Map<String, Object> param) {
	// 	String result="-1";
	// 	String boardId = Utils.nvl(param.get("board_id").toString(),"");

	// 	String sql = "SELECT user_id " +
	// 			"FROM tbl_board " +
	// 			"WHERE board_id = ?";
	// 	try {
	// 		result = jt.queryForObject(sql, new Object[]{boardId} ,String.class);
	// 	} catch (Exception e) {
	// 		System.err.println("게시글 유저ID 에러");
	// 	}

	// 	return result;
		
	// }

	

}
