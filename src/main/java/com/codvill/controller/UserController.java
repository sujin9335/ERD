package com.codvill.controller;

import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<Object> list(@RequestBody Map<String, Object> param) {
        System.out.println("list 작동");
        System.out.println(param);
        try {
            JSONObject obj=new JSONObject();
            obj=us.userList(param);
            
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }

        

    }

    @PostMapping("/get")
    @ResponseBody
    public ResponseEntity<Object> get(@RequestBody Map<String, Object> param) {
        System.out.println("GET 실행");
        System.out.println(param);

        try {
            JSONObject obj=new JSONObject();
            obj=us.userGet(param);
            
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }


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
    public ResponseEntity<Object> insert(@RequestBody Map<String, Object> param) {
        System.out.println("Insert 실행");
        System.out.println(param);

        try {
            JSONObject obj=new JSONObject();
            obj=us.insert(param);
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }

    }

    @PostMapping("/checkDuplicate")
    @ResponseBody
    public ResponseEntity<Object> checkDuplicate(@RequestBody Map<String, Object> param) {
        System.out.println("중복체크 실행");
        System.out.println(param);

        try {
            JSONObject obj=new JSONObject();
            obj=us.checkDuplicate(param);
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }



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
    public ResponseEntity<Object> useChange(@RequestBody Map<String, Object> param) {
        System.out.println("useChange 실행");
        System.out.println(param);

        try {
            JSONObject obj=new JSONObject();
            us.useChange(param);
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }


    }

}
