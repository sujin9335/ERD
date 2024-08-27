package com.codvill.controller;

import java.util.Arrays;
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
import org.springframework.web.multipart.MultipartFile;

import com.codvill.service.BoardService;


@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    BoardService bs;

    @Value("${project.uploadpath}") //파일 업로드 경로
    private String uploadPath;
 
    @GetMapping("/")
    public String board(){
        return "/board";
    }

    @GetMapping("/form")
    public String form () {
        return "/form";
    }
    
    

    @PostMapping("/list")
    @ResponseBody
    public Object list(@RequestBody Map<String, Object> param) {
        System.out.println("list 작동");
        System.out.println(param);

        JSONObject obj =new JSONObject();
        obj = bs.boardList(param);
        
        return obj;
    }

    @PostMapping("/get")
    @ResponseBody
    public Object get(@RequestBody Map<String, Object> param) {
        System.out.println("get 작동");
        System.out.println(param);

        JSONObject obj =new JSONObject();
        obj = bs.boardGet(param);
        // JSONObject data = new JSONObject();
        System.out.println(obj);

        return obj;
    }


    @PostMapping("/insert")
    @ResponseBody
    public Object insert(@RequestParam("files") MultipartFile[] files, @RequestParam("param") String param) throws Exception{
        System.out.println("insert 작동");
        System.out.println(param);

        // for (MultipartFile file : files) {
        //     System.out.println("파일목록");
        //     String originFileName = file.getOriginalFilename();
        //     System.out.println("originFileName : " + originFileName);
        // }

        //param 형식변경
        JSONParser parser = new JSONParser();
		JSONObject pramObj = new JSONObject();
        pramObj = (JSONObject) parser.parse(param);

        JSONObject obj = new JSONObject();
        obj = bs.boardInsert(pramObj, files);


        return obj;
    }

    @PostMapping("/update")
    @ResponseBody
    public Object update(@RequestParam("files") MultipartFile[] files, @RequestParam("param") String param, HttpSession session) throws Exception{
        System.out.println("update 작동");

        //세션 불러오기
        Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
        String userId= userInfo.get("user_id").toString();
        String userAuth= userInfo.get("user_auth").toString();

        //param 형식변경
        JSONParser parser = new JSONParser();
		JSONObject pramObj = new JSONObject();
        pramObj = (JSONObject) parser.parse(param);
        System.out.println(pramObj);
        
        //게시글 update
        JSONObject obj = new JSONObject();
        obj=bs.boardUpdate(pramObj, files, userId, userAuth);
        
        return obj;
    }

    @PostMapping("/del")
    @ResponseBody
    public Object del(@RequestBody Map<String, Object> param, HttpSession session) {
        System.out.println("del 작동");
        System.out.println(param);

        //세션 불러오기
        Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
        String userId= userInfo.get("user_id").toString();
        String userAuth= userInfo.get("user_auth").toString();

        // JSONObject data = new JSONObject();
        JSONObject obj = bs.boardDel(param, userId, userAuth);

        return obj;
    }

    
    @PostMapping("/fileUpload")
    @ResponseBody
    public Object fileUpload(@RequestParam("files") MultipartFile[] files, @RequestParam("param") String param) throws Exception{
        System.out.println("파일업로드");
        System.out.println(Arrays.toString(files));

        JSONParser parser = new JSONParser();
		JSONObject jo = new JSONObject();
        jo = (JSONObject) parser.parse(param);

        //게시글 insert
        //bs.boardInsert(jo, files);

        //System.out.println(jo.toString());

        if (files.length == 0) {
            System.out.println("데이터없음");
        }

        System.out.println("파일업로드처리완");
        JSONObject data = new JSONObject();
        // JSONObject objData = (JSONObject) bs.fileUpload(param);
        // System.out.println(objData);

        


        return data;
    }


    //파일 다운로드
    @GetMapping("/fileDown/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> fileDown(@PathVariable("id")String id) {
        System.out.println("fileDown 작동");
        System.out.println(id);

        return bs.fileDown(id);
    }

   
    
    
}
