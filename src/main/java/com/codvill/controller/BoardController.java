package com.codvill.controller;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.codvill.comm.Utils;
import com.codvill.service.BoardService;


@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    BoardService bs;

    // @Value("${project.uploadpath}") //파일 업로드 경로
    // private String uploadPath;
 
    @GetMapping("/")
    public String board(){
        return "/board";
    }

    // @GetMapping("/form")
    // public String form () {
    //     return "/form";
    // }
    
    

    @PostMapping("/list")
    @ResponseBody
    public ResponseEntity<Object> list(@RequestBody Map<String, Object> param) {
        System.out.println("list 작동");
        System.out.println(param);

        try {
            JSONObject obj =new JSONObject();
            obj = bs.boardList(param);
            
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류입니다");
        }
        
    }

    @PostMapping("/get")
    @ResponseBody
    public ResponseEntity<Object> get(@RequestBody Map<String, Object> param) {
        System.out.println("get 작동");
        System.out.println(param);

        try {
            JSONObject obj =new JSONObject();
            obj = bs.boardGet(param);
            return ResponseEntity.ok(obj);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류입니다");
        }

    }


    @PostMapping("/insert")
    @ResponseBody
    public ResponseEntity<Object> insert(@RequestParam("files") MultipartFile[] files, @RequestParam("param") String param) {
        System.out.println("insert 작동");
        System.out.println(param);
        try {
            JSONParser parser = new JSONParser();
            JSONObject pramObj = new JSONObject();
            pramObj = (JSONObject) parser.parse(param);

            bs.boardInsert(pramObj, files);

            return ResponseEntity.ok("게시글 등록완료");
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류입니다");
        }

        
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Object> update(@RequestParam("files") MultipartFile[] files, @RequestParam("param") String param, HttpSession session) {
        System.out.println("update 작동");
        System.out.println(param);

        //세션 불러오기
        Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
        String userId= Utils.nvl(userInfo.get("user_id").toString(), "");
        String userAuth= Utils.nvl(userInfo.get("user_auth").toString(), "");

        try {
            //param 형식변경
            JSONParser parser = new JSONParser();
            JSONObject pramObj = new JSONObject();
            pramObj = (JSONObject) parser.parse(param);

            bs.boardUpdate(pramObj, files, userId, userAuth);


            return ResponseEntity.ok("게시글 수정완료");
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류입니다");
        }
        
        
    }

    @PostMapping("/del")
    @ResponseBody
    public ResponseEntity<Object> del(@RequestBody Map<String, Object> param, HttpSession session) {
        System.out.println("del 작동");
        System.out.println(param);

        //세션 불러오기
        Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
        String userId= Utils.nvl(userInfo.get("user_id").toString(), "");
        String userAuth= Utils.nvl(userInfo.get("user_auth").toString(), "");

        try {
            bs.boardDel(param, userId, userAuth);

            return ResponseEntity.ok("게시글 삭제완료");
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류입니다");
        }

    }

    
    //파일 다운로드
    @GetMapping("/fileDown/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> fileDown(@PathVariable("id")String id) {
        System.out.println("fileDown 작동");
        System.out.println(id);
        JSONObject data = new JSONObject();
        
        System.out.println(data);

        return bs.fileDown(id);
    }

   
    
    
}
