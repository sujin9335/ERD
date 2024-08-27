package com.codvill.controller;

import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.codvill.service.GroupService;

import net.minidev.json.JSONArray;


@Controller
@RequestMapping("/group")
public class GroupController {

    @Autowired
    GroupService gs;
    
    @GetMapping("/")
    public String group() {

        return "/group";
    }

    @PostMapping("/list")
    @ResponseBody
    public Object list() {
        System.out.println("리스트 실행");
        JSONArray jArray=new JSONArray();
        jArray=(JSONArray) gs.list();


        return jArray;
    }

    @PostMapping("/insert")
    @ResponseBody
    public Object insert(@RequestBody Map<String, Object> param) {
        System.out.println("insert 실행");
        JSONObject obj=new JSONObject();
        // System.out.println(param);
        obj=(JSONObject) gs.insert(param);

        return obj;
    }

    @PostMapping("/update")
    @ResponseBody
    public Object update(@RequestBody Map<String, Object> param) {
        System.out.println("update 실행");
        JSONObject obj=new JSONObject();
        // System.out.println(param);
        obj=(JSONObject) gs.update(param);

        return obj;
    }

    @PostMapping("/del")
    @ResponseBody
    public Object del(@RequestBody Map<String, Object> param) {
        System.out.println("del 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) gs.del(param);

        return obj;
    }

    @PostMapping("/groupUserList")
    @ResponseBody
    public Object groupUserList(@RequestBody Map<String, Object> param) {
        System.out.println("groupUserList 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) gs.groupUserList(param);

        return obj;
    }

    @PostMapping("/groupUserDel")
    @ResponseBody
    public Object groupUserDel(@RequestBody Map<String, Object> param) {
        System.out.println("groupUserDel 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) gs.groupUserDel(param);

        return obj;
    }

    @PostMapping("/regisUserList")
    @ResponseBody
    public Object regisUserList(@RequestBody Map<String, Object> param) {
        System.out.println("regisUserList 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) gs.regisUserList(param);

        return obj;
    }

    @PostMapping("/groupUserInsert")
    @ResponseBody
    public Object groupUserInsert(@RequestBody Map<String, Object> param) {
        System.out.println("groupUserInsert 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) gs.groupUserInsert(param);

        return obj;
    }

    @PostMapping("/moveNode")
    @ResponseBody
    public Object moveNode(@RequestBody Map<String, Object> param) {
        System.out.println("moveNode 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) gs.moveNode(param);

        return obj;
    }
}

