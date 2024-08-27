package com.codvill.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class GroupDao {

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
	}

	public List<Map<String, Object>> list() {
		String sql = "select * " +
				"from tbl_group ";

		List<Map<String, Object>> list = jt.queryForList(sql);

		// System.out.println(list);

		return list;
	}

	public int insert(Map<String, Object> param) {

		String par_id = (String) param.get("group_par_id");
		if (par_id.equals("#")) {
			par_id = null;
		}
		String name = (String) param.get("group_name");
		String info = (String) param.get("group_info");

		String sql = String.format("insert into tbl_group (group_par_id, group_name, group_info) " +
				"values (%s, '%s', '%s')", par_id, name, info);
		// System.out.println(sql);

		int value = -1;
		try {
			value = jt.update(sql);
		} catch (Exception e) {
			System.out.println("Group insert 에러 발생");
		}

		return value;
	}

	public int update(Map<String, Object> param) {

		String id = (String) param.get("group_id");
		String name = (String) param.get("group_name");
		String info = (String) param.get("group_info");

		String sql = String.format("update tbl_group " +
				"set group_name='%s', group_info='%s' " +
				"where group_id=%s ", name, info, id);
		int value = -1;
		try {
			value = jt.update(sql);
		} catch (Exception e) {
			System.out.println("Group update 에러 발생");
		}

		// System.out.println(sql);
		// System.out.println(value);

		return value;
	}

	public int del(Map<String, Object> param) {

		String id = (String) param.get("group_id");

		String sql = String.format("delete from tbl_group " +
				"where group_id=%s ", id);

		int value = -1;
		try {
			value = jt.update(sql);
		} catch (Exception e) {
			System.out.println("Group update 에러 발생");
		}

		// System.out.println(sql);
		// System.out.println(value);

		return value;
	}

	public Object groupUserList(Map<String, Object> param) {
		JSONObject result = new JSONObject();

		int offset = (Integer) param.get("offset");
		int listSize = (Integer) param.get("listSize");

		// 조건문
		String id = (String) param.get("group_id");

		String searchType = (String) param.get("searchType");

		// 검색어 없을경우 처리
		String search = (String) param.get("search");
		if (searchType == null) {
			searchType = "user_name";
		}
		if (search == null) {
			search = "";
		}

		// 데이터 조회
		String sqlFist = "select " +
				"group_id, " +
				"u.user_id, " +
				"u.user_name, " +
				"u.user_login_id ";

		String sqlLast = String.format(
				"from tbl_group_user_role gur " +
						"inner join tbl_user u " +
						"on gur.user_id = u.user_id " +
						"WHERE group_id=%s && %s LIKE '%%%s%%' " +
						"ORDER BY user_id DESC " +
						"LIMIT %d OFFSET %d ",
				id, searchType, search, listSize, offset);

		String sql = sqlFist + sqlLast;

		List<Map<String, Object>> list = jt.queryForList(sql);
		// System.out.println(list);

		// 총 갯수
		sql = String.format("select count(*) " +
				"from tbl_group_user_role gur " +
				"inner join tbl_user u " +
				"on gur.user_id = u.user_id " +
				"WHERE group_id=%s && %s LIKE '%%%s%%'",
				id, searchType, search);
		// System.out.println(sql);
		int total = jt.queryForObject(sql, Integer.class);
		// System.out.println(total);

		result.put("data", list);
		result.put("total", total);
		System.out.println(result);

		return result;
	}

	public int groupUserDel(Map<String, Object> param) {

		int userId = (Integer) param.get("user_id");
		String groupId = (String) param.get("group_id");

		String sql = String.format("delete from tbl_group_user_role " +
				"where group_id=%s && user_id=%d", groupId, userId);

		int value = -1;
		try {
			value = jt.update(sql);
		} catch (Exception e) {
			System.out.println("GroupUser delete 에러 발생");
		}

		return value;
	}

	public Object regisUserList(Map<String, Object> param) {
		JSONObject result = new JSONObject();

		// param= {groupUserIdArr=[28], searchInput=, searchType=user_name}

		// ArrayList<String> groupUserIdList = (ArrayList<String>)
		// param.get("groupUserIdArr");
		ArrayList<Integer> groupUserIdList = (ArrayList<Integer>) param.get("groupUserIdArr");

		String searchType = (String) param.get("searchType");
		String search = (String) param.get("search");

		// 검색어 없을경우 처리
		if (searchType == null) {
			searchType = "user_name";
		}
		if (search == null) {
			search = "";
		}

		// 제외시킬 id sql문으로 만들기
		StringBuilder exceptId = new StringBuilder();
		// for (String id : groupUserIdList) {
		for (Integer id : groupUserIdList) {
			exceptId.append(id).append(", ");
		}
		if (exceptId.length() > 1) { // append 한적있는지확인
			exceptId.delete(exceptId.length() - 2, exceptId.length());
		}
		// System.out.println(exceptId);

		// 데이터 조회
		String sqlFist = "select " +
				"user_id, " +
				"user_login_id, " +
				"user_name " +
				"FROM tbl_user ";

		String sqlNot = String.format(
				"WHERE %s LIKE '%%%s%%' ",
				searchType, search);

		String sqlLast = "ORDER BY user_id DESC ";

		if (groupUserIdList.size() > 0) {
			sqlNot += String.format("&& user_id NOT IN (%s) ", exceptId);
		}

		String sql = sqlFist + sqlNot + sqlLast;
		// System.out.println(sql);

		List<Map<String, Object>> list = jt.queryForList(sql);
		// System.out.println(list);

		result.put("data", list);

		return result;
	}

	public int groupUserInsert(Map<String, Object> param) {
		int value = -1;

		// {idArr=[27, 24], group_id=1}
		String groupId = (String) param.get("group_id");
		ArrayList<String> userIdList = (ArrayList<String>) param.get("idArr");

		for (String userId : userIdList) {
			String sql = String.format("insert into tbl_group_user_role (group_id, user_id) " +
					"values (%s, %s)", groupId, userId);
			try {
				value = jt.update(sql);
				if (value == -1) {
					break;
				}
			} catch (Exception e) {
				System.out.println("GroupUser Insert 에러 발생");
			}
		}

		// System.out.println(sql);

		return value;
	}

	public ArrayList<Integer> findUserId(Map<String, Object> param) {
		ArrayList<Integer> result = new ArrayList<>();
		String groupId = (String) param.get("group_id");
		String sql = String.format("select user_id from tbl_group_user_role where group_id = %s", groupId);
		List<Map<String, Object>> list = jt.queryForList(sql);

		// System.out.println(list);

		for (Map<String, Object> map : list) {
			result.add((Integer) map.get("user_id"));
		}

		return result;
	}

	public JSONObject moveNod(Map<String, Object> param) {
		JSONObject result = new JSONObject();

		// {group_id=64, group_par_id=62}

		String group_id = (String) param.get("group_id");
		String group_par_id = (String) param.get("group_par_id");
		if (group_par_id.equals("#")) {
			group_par_id = null;
		}

		String sql = String.format("update tbl_group " +
				"set group_par_id=%s " +
				"where group_id=%s ", group_par_id, group_id);
		int value = -1;
		try {
			value = jt.update(sql);
		} catch (Exception e) {
			System.out.println("GroupMove 에러 발생");
		}

		System.out.println(sql);
		System.out.println(value);

		return result;
	}

}
