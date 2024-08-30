package com.codvill.service;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.jsp.el.ELException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.codvill.dao.BoardDao;

@Service
public class BoardService {

    @Value("${project.uploadpath}") // 파일 업로드 경로
    private String uploadPath;

    @Autowired
    BoardDao bD;

    public JSONObject boardList(Map<String, Object> param) throws Exception {
        
        try {
            JSONObject obj = bD.boardList(param);
            return obj;
            
        } catch (Exception e) {
            System.err.println("List DB에러: " + e.getMessage());
            throw new Exception("List DB에러" , e);
        }

        //게시판 리스트 정보
    }

    public JSONObject boardGet(Map<String, Object> param) throws Exception {
        JSONObject obj=new JSONObject();


        try {
            //게시글 DB 조회 
            Map<String, Object> get = bD.boardGet(param);
            obj.put("data", get);
        } catch (Exception e) {
            System.err.println("Get DB에러: " + e.getMessage());
            throw new Exception("Get DB에러" , e);
        }

        try {
            //게시글 조회수 증가
            bD.boardViewCountAdd(param);
        } catch (Exception e) {
            System.err.println("Get 게시글 조회수증가 에러: " + e.getMessage());
            throw new Exception("Get  게시글 조회수증가 에러" , e);
        }

        try {
            //파일 리스트 DB조회
            List<Map<String, Object>> files = bD.fileListGet(param);
            obj.put("files", files);
        } catch (Exception e) {
            System.err.println("Get 파일 DB에러: " + e.getMessage());
            throw new Exception("Get 파일 DB에러" , e);
        }

        return obj;
    }

    public void boardInsert(Map<String, Object> param, MultipartFile[] files) throws Exception {

        //게시글 파일 유효성 검사
        boardCheck(param, files);

        try {
            //게시글 DB insert
            bD.boardInsert(param);

        } catch (Exception e) {
            System.err.println("insert board DB에러: " + e.getMessage());
            throw new Exception("Insert board DB에러" , e);
        }
        
        
        //파일저장
        if(files.length > 0) {
            String board_id = "";

            try {
                // insert 된 게시글 id값 가져오기 (파일DB저장 처리용)
                board_id = bD.getLast();
    
            } catch (Exception e) {
                System.err.println("insert board_id DB에러: " + e.getMessage());
                throw new Exception("Insert board_id DB에러" , e);
            }

            //파일 저장, DB저장
            fileSave(files, board_id);
        }
        

    }

    public void boardCheck(Map<String, Object> param, MultipartFile[] files) throws Exception {

        String title = param.get("board_title").toString();
        String content = param.get("board_content").toString();

        if (title == null || title.length() < 1 || title.length() > 10) {
            throw new Exception("제목의 길이는 1자 이상 10자 이하여야 합니다.");
        }

        if (content == null || content.getBytes().length > 800) {
            throw new Exception("내용은 800바이트 이하여야 합니다.");
        }

        long maxSize = 3 * 1024 * 1024; // 3MB in bytes

        for (MultipartFile file : files) {
            if (file.getSize() > maxSize) {
                throw new Exception("파일 크기는 3메가바이트 이하여야 합니다.");
            }
        }



    }

    public void fileSave(MultipartFile[] files, String boardId) throws Exception {
        for (MultipartFile file : files) {
            System.out.println("파일업로드처리");
            System.out.println(file.toString());
            // 파일 저장
            try {

                String originFileName = file.getOriginalFilename();

                // 파일명,확장자명 분리
                String realFileName = originFileName.substring(0, originFileName.lastIndexOf('.'));
                String fileExtension = originFileName.substring(originFileName.lastIndexOf('.') + 1);

                // 저장 파일명UUID = 파일ID
                UUID uuid = UUID.randomUUID();
                String fileSaveName = uuid+"."+fileExtension;
                // String fileName = file.getOriginalFilename();
                System.out.println("Uploaded File Name: " + fileSaveName);

                // 파일저장
                Path filePath = Paths.get(uploadPath, fileSaveName);
                Files.write(filePath, file.getBytes());

                try {
                    // DB저장
                    bD.fileInsert(realFileName, uuid+"", fileExtension, uploadPath, boardId);
                    
                } catch (Exception e) {
                    //DB저장 실패시 방금 저장한 파일 삭제
                    fileDel(fileSaveName);

                    System.err.println("파일 저장 DB에러: " + e.getMessage());
                    throw new Exception("파일 저장 DB에러" , e);
                }


            } catch (IOException e) {
                System.err.println("파일 저장 에러: " + e.getMessage());
                throw new Exception("파일 저장 에러" , e);
            }

        }
    }

    public void boardUpdate(Map<String, Object> param, MultipartFile[] files, String sessionUserId, String sessionAuth) throws Exception { //{"user_id":"1","board_title":"2","file_id":["7","8","9"],"board_id":"10","board_content":"2"}
        
        //게시글 파일 유효성 검사
        boardCheck(param, files);

        //세션 관리자, 유저 확인
        String userId=bD.boardGetUserId(param);
        if(!sessionAuth.equals("0")) {
            if (!userId.equals(sessionUserId)) {
                throw new Exception("유저 불일치");
            }
        }

        try {
            //게시글 업데이트
            bD.boardUpdate(param);

        } catch (Exception e) {
            System.err.println("update board DB에러: " + e.getMessage());
            throw new Exception("Update board DB에러" , e);
        }

        

        //기존 첨부되있던 파일처리
        //==============================
        //파일 삭제된거 관리
        JSONArray fileFullnames=(JSONArray) param.get("file_id");
        
        if (fileFullnames.size() > 0) {
            for (int i = 0; i < fileFullnames.size(); i++) {
                //파일 명, 확장자 분리
                String fileFullname = (String) fileFullnames.get(i);
                String fileId = fileFullname.substring(0, fileFullname.lastIndexOf('.')); // 파일 id
                //파일 DB에서 삭제
                try {
                    bD.delFile(fileId); //DB에서 파일삭제
                } catch (Exception e) {
                    System.err.println("수정 file 기존del DB에러: " + e.getMessage());
                    throw new Exception("수정 file 기존del DB에러" , e); //파일 db삭제 멈추게됨
                }
                //파일 저장소에서 삭제
                try {
                    fileDel(fileFullname);
                } catch (Exception e) {
                    System.err.println("수정 file 기존del 에러: " + e.getMessage());
                    throw new Exception(" 수정file 기존del 에러" , e);
                }
            }
        }
        //==============================

        //새로 첨부된 파일 넣기
        //파일저장
        if(files.length > 0) {
            // insert 된 게시글 id값 가져오기 (파일DB저장 처리용)
            String board_id = param.get("board_id").toString();
            fileSave(files, board_id);
        }


    }

    // public void file


    public void boardDel(Map<String, Object> param, String sessionUserId, String sessionAuth) throws Exception {

        //세션 관리자, 유저 확인
        String userId=bD.boardGetUserId(param);
        if(!sessionAuth.equals("0")) {
            if (!userId.equals(sessionUserId)) {
                throw new Exception("유저 불일치");
            }
        }

        //파일 삭제
        List<String> files=(List<String>) param.get("files");
        if(files.size() > 0) {
            for (String file : files) {
                try {
                    bD.delFile(file); //DB에서 파일삭제
                } catch (Exception e) {
                    System.err.println("삭제 file del DB에러: " + e.getMessage());
                    throw new Exception("삭제 file del DB에러" , e); //파일 db삭제 멈추게됨
                }
                try {
                    fileDel(file);
                } catch (Exception e) {
                    System.err.println("삭제 file del 에러: " + e.getMessage());
                    throw new Exception("삭제 file del 에러" , e);
                }
            }
        }

        try {
            //게시글 삭제
            bD.boardDel(param);
            
        } catch (Exception e) {
            System.err.println("board 삭제 DB에러: " + e.getMessage());
            throw new Exception("board 삭제 DB에러" , e);
        }
        


    }


    public void fileDel(String fileName) {
        //저장된 파일삭제 
        Path filePath = Paths.get(uploadPath, fileName).normalize().toAbsolutePath();
        try {
            if (Files.deleteIfExists(filePath)) {
                System.out.println("File deleted successfully: " + filePath);
            } else {
                System.out.println("File not found: " + filePath);
            }
        } catch (IOException e) {
            System.err.println("파일 삭제 에러: " + e.getMessage());
        }
    }

    

    public ResponseEntity<byte[]> fileDown(String fullSaveName, String name) {
        ResponseEntity<byte[]> entity = null;

        //fullName이 id.확장자 여서 확장자 분리
        String fileExtension = fullSaveName.substring(fullSaveName.lastIndexOf('.') + 1);

        //원래 파일명
        String fileName = name+ "." + fileExtension;

        System.out.println(fullSaveName);
        System.out.println(name);

        // 파일이 저장된 경로 + \
        String savename = uploadPath+"\\"+fullSaveName;
        // String savename = "C:\\upload\\파일2^!78.txt";
        File file = new File(savename);

        byte[] result = null;// 1. data
        

        try {
            result = FileCopyUtils.copyToByteArray(file);

            // 2. header
            HttpHeaders header = new HttpHeaders();

            
            //파일이름 인코더(다운받을때의 파일명)
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8);
            // 다운로드임을 명시
            header.add("Content-Disposition", "attachment; filename=" + encodedFileName);

            // 3. 응답본문
            entity = new ResponseEntity<>(result, header, HttpStatus.OK);// 데이터, 헤더, 상태값
        } catch (NoSuchFileException e) {
            e.printStackTrace();
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", "text/plain; charset=UTF-8");
            entity = new ResponseEntity<>("file not found.".getBytes(), header, HttpStatus.NOT_FOUND);
        } catch (IOException e) {
            e.printStackTrace();
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", "text/plain; charset=UTF-8");
            entity = new ResponseEntity<>("file download error.".getBytes(), header, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            e.printStackTrace();
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", "text/plain; charset=UTF-8");
            entity = new ResponseEntity<>("error.".getBytes(), header, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return entity;
    }

}
