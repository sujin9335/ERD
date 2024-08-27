package com.codvill.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.codvill.dao.GroupDao;

import net.minidev.json.JSONArray;

@Service
public class GroupService {
    
    @Autowired
    GroupDao gd;

    public Object list() {

        List<Map<String, Object>> list=gd.list();
        List<Map<String, Object>> result=new ArrayList();

        //그룹 jstree 형식으로 변환 { "id" : "J08", "parent" : "S22", "text" : "홍문어", "info": "홍문어에 대한 정보입니다." }
        for (Map<String,Object> temp : list) {
            Map<String, Object> map=new HashMap<>();
            map.put("id", temp.get("group_id"));
            if(temp.get("group_par_id") == null) {
                map.put("parent", "#");
            }else {
                map.put("parent", temp.get("group_par_id"));
            }
            map.put("text", temp.get("group_name"));
            map.put("info", temp.get("group_info"));
            // map.put("data-icon", "/img/group.png");
            result.add(map);
        }

        //어레이 리스트 JSONArray로변환
        JSONArray jsonArray = new JSONArray();
        for (Map<String, Object> map : result) {
            JSONObject jsonObject = new JSONObject(map);
            jsonArray.add(jsonObject);
        }


        return jsonArray;
    }

    public Object insert(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultGroup = 0;
        resultGroup=gd.insert(param);
        obj.put("resultGroup", resultGroup);

        return obj;
    }

    public Object update(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultGroup = 0;
        resultGroup = gd.update(param);
        obj.put("resultGroup", resultGroup);

        return obj;
    }

    public Object del(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultGroup = 0;
        resultGroup = gd.del(param);
        obj.put("resultGroup", resultGroup);

        return obj;
    }

    public Object groupUserList(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        obj=(JSONObject) gd.groupUserList(param);

        return obj;
    }

    public Object groupUserDel(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultGroup = 0;
        resultGroup = gd.groupUserDel(param);
        obj.put("resultGroup", resultGroup);

        return obj;
    }

    public Object regisUserList(Map<String, Object> param) {
        JSONObject obj=new JSONObject();

        ArrayList<Integer> regisUserId=new ArrayList<>();
        regisUserId=gd.findUserId(param);

        param.put("groupUserIdArr", regisUserId);
        obj=(JSONObject) gd.regisUserList(param);
        System.out.println(param);

        return obj;
    }

    public Object groupUserInsert(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        int resultGroup = 0;
        resultGroup = gd.groupUserInsert(param);
        obj.put("resultGroup", resultGroup);

        return obj;
    }

    public JSONObject moveNode(Map<String, Object> param) {
        JSONObject obj=new JSONObject();
        obj=(JSONObject) gd.moveNod(param);

        return obj;
    }
}
