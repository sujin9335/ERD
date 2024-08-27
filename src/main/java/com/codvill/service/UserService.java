package com.codvill.service;

import java.security.MessageDigest;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.codvill.dao.UserDao;

@Service
public class UserService {
    
    @Autowired
    UserDao ud;

    public Object list(Map<String, Object> param) {
        JSONObject obj=new JSONObject();

        obj=(JSONObject) ud.list(param);


        return obj;
    }

    public Object get(Map<String, Object> param) {
        JSONObject obj=new JSONObject();

        obj=(JSONObject) ud.get(param);


        return obj;
    }

    public Object del(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultUser=0;
        resultUser=ud.del(param);

        obj.put("resultUser", resultUser);
        return obj;
    }

    public Object insert(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultUser=0;
        //비밀번호 추출
        String pw=(String)param.get("user_pw");
        //비밀번호 해싱후 첨부
        param.put("user_pw", pwHashing(pw));
        
        resultUser=ud.insert(param);
        obj.put("resultUser", resultUser);

        return obj;
    }

    public Object idCheck(Map<String, Object> param) {
        JSONObject obj=new JSONObject();

        obj=(JSONObject) ud.idCheck(param);


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

    public Object useChange(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultUser=0;
        resultUser=ud.useChange(param);
        obj.put("resultUser", resultUser);

        return obj;
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
