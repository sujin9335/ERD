package com.codvill.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

@Repository
public class HighChartDao {

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

    public List<Map<String, Object>> line() {
        List<Map<String, Object>> list=new ArrayList<>();

        String sql="SELECT DATE_FORMAT(board_date, '%Y-%m-%d') AS total_date, COUNT(*) AS total " +
                    "FROM tbl_board " +
                    "GROUP BY total_date " +
                    "ORDER BY total_date";

        list=jt.queryForList(sql);

        // System.out.println(list.toString());

        return list;
    }

    public JSONObject pie() {
        JSONObject obj=new JSONObject();

		List<Map<String, Object>> list=new ArrayList<>();
        
		String sql="select " +
						"tg.group_name as name, " +
						"tg.group_name as id, " +
						"count(tgur.group_id) as y, " +
						"tg.group_id as hidden, " +
						"CONVERT(tg.group_id, CHAR) as drilldown " +
					"from tbl_group_user_role tgur " +
						"inner join tbl_group tg " +
							"on tg.group_id = tgur.group_id " +
					"group by tgur.group_id";

		list=jt.queryForList(sql);

		// System.out.println("결과");
		// System.out.println(list.toString());

		obj.put("data", list);

        return obj;
    }

	public List<Map<String, Object>> drill(String date) {
		List<Map<String, Object>> list=new ArrayList<>();

        String sql=String.format("select " +
									"tu.user_login_id as name, " +
									"count(*) as y " +
								"from tbl_board tb " +
								"inner join tbl_user tu " +
								"on tb.user_id = tu.user_id " +
								"where DATE(tb.board_date) = '%s' " +
								"group by tb.user_id"
								, date) ;
		// System.out.println(sql);

        list=jt.queryForList(sql);

        // System.out.println(list.toString());

        return list;
	}

	public List<Map<String, Object>> pieList() {
		List<Map<String, Object>> list=new ArrayList<>();

		String sql="select " +
						"group_id, " +
						"count(group_id) as count " +
					"from tbl_group_user_role tgur " +
					"group by group_id ";

		list=jt.queryForList(sql);

		return list;
	}

	public List<Map<String, Object>> pieDrill(int id) {
		List<Map<String, Object>> list=new ArrayList<>();

        String sql=String.format("select " +
									"tu.user_login_id as name," +
									"1 as y " +
								"from tbl_group_user_role tgur " +
								"inner join tbl_user tu " +
								"on tgur.user_id = tu.user_id " +
								"where tgur.group_id = %d" 
								, id) ;
		// System.out.println(sql);

        list=jt.queryForList(sql);

        // System.out.println(list.toString());

        return list;
	}

    
    
}
