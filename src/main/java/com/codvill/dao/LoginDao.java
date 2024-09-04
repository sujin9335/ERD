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

    //유저정보 찾기
    public Map<String, Object> loginCheck(String id, String shaPw) {
        Map<String, Object> map=null;

        //1) 아이디로 검색
        StringBuffer sql=new StringBuffer();
        sql.append("SELECT " +
                    "user_id, " +
                    "user_login_id, " +
                    "user_pw, " +
                    "user_name, " +
                    "user_mail, " +
                    "user_tel, " +
                    "user_auth, " +
                    "user_use, " +
                    "user_lock_cnt " +
                "FROM tbl_user " +
                    "where user_login_id = ? ");
        
        //2) 처리결과 
        try {
            map=jt.queryForMap(sql.toString(), id);
        } catch (Exception e) {
            System.err.println("일치하는 계정이 없습니다");
            // e.printStackTrace();
        }

        //3) 비밀번호 일치여부 확인안되면 {id:true} 반환
        if(map != null) {
            if(!map.get("user_pw").equals(shaPw)) {
                map.put("id", true);
            }
        }

        return map;


        
    }

    public void updateLockCnt(String id, int cnt) {

        //카운트 증가
        String sql = "update tbl_user set user_lock_cnt = (nvl(user_lock_cnt, 0) + 1) where user_login_id = ?";
        jt.update(sql, id);

        if(cnt == 5) {
            //계정 락
            sql = "update tbl_user set user_use = 'y' where user_login_id = ?";
            jt.update(sql, id);
        }


    }

    public void resetLockCnt(String id) {

        String sql="update tbl_user " +
                    "set user_lock_cnt = 0 " +
                    "where user_login_id = ? ";
           
        jt.update(sql, id);

    }
    
}
