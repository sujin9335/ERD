package com.codvill.controller;

import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.codvill.service.UserService;


@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserService us;
    
    @GetMapping("/")
    public String user() {
        return "/user";
    }
    
    @PostMapping("/list")
    @ResponseBody
    public Object list(@RequestBody Map<String, Object> param) {
        System.out.println("리스트 실행");
        JSONObject obj=new JSONObject();
        obj=(JSONObject) us.list(param);
        System.out.println(param);

        // System.out.println(obj);
        return obj;
    }

    @PostMapping("/get")
    @ResponseBody
    public Object get(@RequestBody Map<String, Object> param) {
        System.out.println("GET 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) us.get(param);

        return obj;

    }

    @PostMapping("/del")
    @ResponseBody
    public Object del(@RequestBody Map<String, Object> param) {
        System.out.println("DEL 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) us.del(param);

        return obj;

    }

    @PostMapping("/insert")
    @ResponseBody
    public Object insert(@RequestBody Map<String, Object> param) {
        System.out.println("Insert 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) us.insert(param);

        return obj;

    }

    @PostMapping("/idCheck")
    @ResponseBody
    public Object idCheck(@RequestBody Map<String, Object> param) {
        System.out.println("ID체크 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        obj=(JSONObject) us.idCheck(param);

        return obj;

    }

    @PostMapping("/update")
    @ResponseBody
    public Object update(@RequestBody Map<String, Object> param) {
        System.out.println("Update 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        
        obj=(JSONObject) us.update(param);

        return obj;

    }

    @PostMapping("/useChange")
    @ResponseBody
    public Object useChange(@RequestBody Map<String, Object> param) {
        System.out.println("useChange 실행");
        JSONObject obj=new JSONObject();
        System.out.println(param);
        
        obj=(JSONObject) us.useChange(param);

        return obj;

    }

}
