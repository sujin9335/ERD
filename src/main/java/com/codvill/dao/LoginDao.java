package com.codvill.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class LoginDao {

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

    //아이디와 비밀번호 검색 있으면 list 1반환
    public Map<String, Object> loginCheck(String id, String shaPw) {
        Map<String, Object> map=new HashMap<>();

        String sql=String.format("SELECT " +
                                    "user_id, " +
                                    "user_login_id, " +
                                    "user_name, " +
                                    "user_mail, " +
                                    "user_tel, " +
                                    "user_auth, " +
                                    "user_use, " +
                                    "user_lock_cnt " +
                                "FROM tbl_user " +
                                    "where user_login_id = '%s' and user_pw = '%s' "
                                    , id, shaPw);

        System.out.println(sql);
           
        List<Map<String, Object>> list=jt.queryForList(sql);
        
        if(list.size() == 1) { // 아이디 비번 동일 계정 있음 .. 가입정보 반환
            map=list.get(0);
        }else { // 아이디 비번 일치 계정 없음
            //아이디는 있는지 확인
            String idCheckSql=String.format("SELECT " +
                                                "user_id, " +
                                                "user_login_id, " +
                                                "user_name, " +
                                                "user_mail, " +
                                                "user_tel, " +
                                                "user_auth, " +
                                                "user_use, " +
                                                "user_lock_cnt " +
                                            "FROM tbl_user " +
                                                "where user_login_id = '%s' "
                                                , id);
            List<Map<String, Object>> idList=jt.queryForList(idCheckSql);
            
            if (idList.size() == 1) { //아이디가 있을경우 .. id:true 반환
                map=idList.get(0);
                map.put("id", true);
            } else {
                map=null;
            }

        }

        return map;
    }

    public void updateLockCnt(String id) {
        
        //카운트 몇인지 확인
        String sql=String.format("select user_lock_cnt from tbl_user where user_login_id = '%s'"
                                , id);

        Map<String, Object> map=jt.queryForMap(sql);

        //업데이트될 카운트 값
        int cnt=(Integer) map.get("user_lock_cnt")+1;

        // System.out.println("카운트");
        // System.out.println(cnt);

        sql=String.format("update tbl_user " +
                                "set user_lock_cnt = %d " +
                                "where user_login_id = '%s' "
                                , cnt, id);
           
        int result = jt.update(sql);
        //5회일경우 계정 락
        if(cnt == 5) {
            // System.out.println("5회니?");
            sql=String.format("update tbl_user "+
                                "set user_use = 'y' "+
                                "where user_login_id = '%s' "
                                , id);
           
            result = jt.update(sql);
        }


    }

    public void resetLockCnt(String id) {

        String sql=String.format("update tbl_user " +
                                "set user_lock_cnt = 0 " +
                                "where user_login_id = '%s' "
                                , id);
           
        int result = jt.update(sql);

    }
    
}
