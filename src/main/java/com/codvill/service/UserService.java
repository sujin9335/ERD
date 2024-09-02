package com.codvill.service;

import java.security.MessageDigest;
import java.util.Map;
import java.util.regex.Pattern;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.codvill.dao.UserDao;

@Service
public class UserService {
    
    @Autowired
    UserDao ud;

    public JSONObject userList(Map<String, Object> param) throws Exception {
        JSONObject obj=new JSONObject();

        try {
            obj=ud.userList(param);
            
        } catch (Exception e) {
            System.err.println("list DB에러: " + e.getMessage());
            throw new Exception("list DB에러", e);
        }

        return obj;
    }

    public JSONObject userGet(Map<String, Object> param) throws Exception {
        JSONObject obj=new JSONObject();
        System.out.println(param);

        try {
            obj=ud.get(param);
        } catch (Exception e) {
            System.err.println("get DB에러: " + e.getMessage());
            throw new Exception("get DB에러", e);
        }

        return obj;
    }

    public Object del(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultUser=0;
        resultUser=ud.del(param);

        obj.put("resultUser", resultUser);
        return obj;
    }

    public JSONObject insert(Map<String, Object> param) throws Exception {
        JSONObject obj=new JSONObject();

        //유효성 검사
        //로그인 id 정규식으로 검사
        if (!Pattern.matches("^[A-Za-z0-9]{1,8}$", param.get("user_login_id").toString())) {
            throw new Exception("로그인 아이디 유효성 검사 실패");
        }
        if (!Pattern.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{4,16}$", param.get("user_pw").toString())) {
            throw new Exception("비밀번호 유효성 검사 실패");
        }
        if (!Pattern.matches("^^[A-Za-z가-힣]{1,16}$", param.get("user_name").toString())) {
            throw new Exception("이름 유효성 검사 실패");
        }
        if (!Pattern.matches("^01(?:0|1|[6-9])-(?:\\d{4})-\\d{4}$", param.get("user_tel").toString())) {
            throw new Exception("핸드폰 유효성 검사 실패");
        }
        if (!Pattern.matches("^[\\w.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", param.get("user_mail").toString())) {
            throw new Exception("메일 유효성 검사 실패");
        }
        if (!Pattern.matches("^[가-힣A-Za-z]{1,8}$", param.get("user_nickname").toString())) {
            throw new Exception("닉네임 유효성 검사 실패");
        }

        //비밀번호 추출
        String pw=(String)param.get("user_pw");
        //비밀번호 해싱후 첨부
        param.put("user_pw", pwHashing(pw));
        System.out.println(param);
        
        try {
            // ud.insert(param);
        } catch (Exception e) {
            System.err.println("insert DB에러: " + e.getMessage());
            throw new Exception("insert DB에러", e);
        }

        ud.insert(param);

        return obj;
    }

    public JSONObject checkDuplicate(Map<String, Object> param) throws Exception {
        JSONObject obj=new JSONObject();

        try {
            obj=ud.checkDuplicate(param);
        } catch (Exception e) {
            System.err.println("idCheck DB에러: " + e.getMessage());
            throw new Exception("idCheck DB에러", e);
        }

        return obj;
    }

    public Object update(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultUser=0;
        int type=1; //비밀번호 업데이트x
        if( !param.get("user_pw").equals("") || param.get("user_pw") != "") {
            type=2; //비밀번호 업데이트
            //비밀번호 추출
            String pw=(String)param.get("user_pw");
            //비밀번호 해싱후 첨부
            param.put("user_pw", pwHashing(pw));
        }
        resultUser = ud.update(param, type);
        obj.put("resultUser", resultUser);

        return obj;
    }

    public void useChange(Map<String, Object> param) {

        try {
            ud.useChange(param);
        } catch (Exception e) {
            System.err.println("useChange DB에러: " + e.getMessage());
            throw new RuntimeException("useChange DB에러", e);
        } 

    }

    public String pwHashing(String pw) {
        
        StringBuffer hexString = new StringBuffer();
        //비밀번호를 byte배열로 변환
        byte[] salt=pw.getBytes();
        
        try {
            //SHA-256로 변환
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            //리셋
            digest.reset();
            //salt추가 (byte[] 값)
            digest.update(salt);
            //비번을 UTF-8 인코딩을 사용해 바이트배열로 변환해서 해시로 만듬
            byte[] hash = digest.digest(pw.getBytes("UTF-8"));
    
            //sha256으로 해싱하면 바이트 배열로 출력이되서 16진수로 변환하는 과정
            for (int i = 0; i < hash.length; i++) {
                //16진수로 변환 0xff 와 hash[i]값 2진수로 비교에서 1만 남겨둠
                String hex = Integer.toHexString(0xff & hash[i]);
                
                //한자리일경우 앞에0붙힘
                if(hex.length() == 1) hexString.append('0');
                
                hexString.append(hex);
            }
            
        } catch (Exception e) {
            e.getStackTrace();
        }

        return hexString.toString();
    }
}
