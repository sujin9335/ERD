package com.codvill.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.codvill.comm.Comm;
import com.codvill.dao.LoginDao;

@Service
public class LoginService {

    @Autowired
    LoginDao ld;

    public Map<String, Object>loginCheck(String id, String pw) {
        Map<String, Object> map=new HashMap<>();
        String shaPw=Comm.pwHashing(pw);

        map=ld.loginCheck(id, shaPw);

        // System.out.println(list);

        return map;
    }

    public void updateLockCnt(String id) {
        ld.updateLockCnt(id);


    }

    public void resetLockCnt(String id) {
        ld.resetLockCnt(id);
    }
    
}
