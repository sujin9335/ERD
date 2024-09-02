package com.codvill.dao;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserDao {

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

	public JSONObject userList(Map<String, Object> param) {
		JSONObject result = new JSONObject();

		String offset = param.get("offset").toString();
		String listSize = param.get("listSize").toString();
		String searchType = param.get("searchType").toString();

		// 검색어 없을경우 처리
		String search = (String) param.get("search");
		if (searchType == null || searchType.equals("")) {
			searchType = "user_name";
		}

		// 데이터 조회
		String sql = String.format(
				"SELECT " +
					"user_id, " +
					"user_login_id, " +
					"user_name, " +
					"user_mail, " +
					"user_tel, " +
					"user_auth, " +
					"user_use, " +
					"user_lock_cnt, " +
					"user_nickname " +
				"from tbl_user " +
						"WHERE %s LIKE '%%%s%%' " +
						"ORDER BY user_register_date DESC " +
						"LIMIT %s OFFSET %s ",
				searchType, search, listSize, offset);

		List<Map<String, Object>> list = jt.queryForList(sql);

		// 총 갯수
		sql = String.format("select count(*) from tbl_user WHERE %s LIKE '%%%s%%'", searchType, search);
		// System.out.println(sql);
		int total = jt.queryForObject(sql, Integer.class);
		// System.out.println(total);

		// 결과 저장
		result.put("data", list);
		result.put("total", total);

		return result;
	}

	public JSONObject get(Map<String, Object> param) {
		JSONObject result = new JSONObject();
		System.out.println(param);
		String id = param.get("user_id").toString();
		String sql = String.format("select * from tbl_user where user_id='%s'", id);

		Map<String, Object> map = jt.queryForMap(sql);
		result.put("data", map);

		return result;
	}

	public int del(Map<String, Object> param) {
		String id = (String) param.get("user_id");
		String sql = String.format("DELETE FROM tbl_user " +
				"WHERE user_id = '%s'", id);

		int value = -1;
		try {
			value = jt.update(sql);
		} catch (Exception e) {
			System.out.println("file insert 에러 발생");
		}

		return value;
	}

	public void insert(Map<String, Object> param) {
		UUID uuid = UUID.randomUUID();
		String id = uuid.toString();
		String loginId = param.get("user_login_id").toString();
		String pw = (String) param.get("user_pw");
		String name = param.get("user_name").toString();
		String mail = (String) param.get("user_mail");
		String tel = (String) param.get("user_tel");
		String nickname = (String) param.get("user_nickname");
		String auth = "1";
		if (param.get("user_auth") != null) { //일반회원가입시 권한설정
			auth = (String) param.get("user_auth");
		}

		String sql = String
				.format("insert into tbl_user (user_id, user_login_id, user_pw, user_name, user_mail, user_tel, user_auth, user_nickname) " +
						"values ('%s', '%s', '%s', '%s', '%s', '%s', %s, '%s')", id, loginId, pw, name, mail, tel, auth, nickname);

		jt.update(sql);

	}

	public JSONObject checkDuplicate(Map<String, Object> param) {
		JSONObject result = new JSONObject();
		String type = param.get("type").toString();
		String value = param.get("value").toString();

		String sql = String.format("SELECT " +
				"user_login_id " +
				"FROM " +
				"tbl_user " +
				"where %s = '%s'", type, value);

		List<Map<String, Object>> list = jt.queryForList(sql);

		result.put("cnt", list.size());

		return result;
	}

	public int update(Map<String, Object> param, int type) {
		JSONObject result = new JSONObject();
		int value = -1;

		String id = (String) param.get("user_id");
		String pw = (String) param.get("user_pw");
		String name = (String) param.get("user_name");
		String mail = (String) param.get("user_mail");
		String tel = (String) param.get("user_tel");
		String auth = (String) param.get("user_auth");

		if (type == 1) {
			String sql = String.format("UPDATE tbl_user " +
					"SET user_name = '%s', user_mail = '%s', user_tel = '%s', user_auth = %s " +
					"WHERE user_id = %s", name, mail, tel, auth, id);
			try {
				value = jt.update(sql);
			} catch (Exception e) {
				System.out.println("file insert 에러 발생");
			}

		} else {
			String sql = String.format("UPDATE tbl_user " +
					"SET user_name = '%s', user_mail = '%s', user_tel = '%s', user_pw = '%s', user_auth = %s  " +
					"WHERE user_id = %s", name, mail, tel, pw, auth, id);
			try {
				value = jt.update(sql);
			} catch (Exception e) {
				System.out.println("file insert 에러 발생");
			}
		}


		return value;
	}

	public void useChange(Map<String, Object> param) {
		String id = (String) param.get("user_id");
		int value = (Integer) param.get("value");
		String use = value == 0 ? "n" : "y";


		String sql = String.format("UPDATE tbl_user " +
				"SET user_use = '%s' " +
				"WHERE user_id = '%s'", use, id);
		jt.update(sql);
		System.out.println(sql);

		// 로그인 잠금횟수 0으로 초기화
		if (use.equals("y")) {
			sql = String.format("update tbl_user " +
					"set user_lock_cnt = 0 " +
					"where user_id = '%s'", id);
			jt.update(sql);
		}

	}

}
