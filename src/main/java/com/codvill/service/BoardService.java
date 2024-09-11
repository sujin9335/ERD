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

import com.codvill.comm.Utils;
import com.codvill.dao.BoardDao;

@Service
public class BoardService {

    @Value("${project.uploadpath}") // 파일 업로드 경로
    private String uploadPath;

    @Autowired
    BoardDao bD;

    public JSONObject boardList(Map<String, Object> param) {
        
        JSONObject obj = bD.boardList(param);
        return obj;
    }

    public JSONObject boardGet(Map<String, Object> param){
        JSONObject obj=new JSONObject();

        //게시글 DB 조회 
        Map<String, Object> get = bD.boardGet(param);
        obj.put("data", get);
        
        //파일 리스트 DB조회
        List<Map<String, Object>> files = bD.fileListGet(param);
        obj.put("files", files);

        //게시글 조회수 증가
        bD.boardViewCountAdd(param);
        
        return obj;
    }

    public void boardInsert(Map<String, Object> param, MultipartFile[] files) {

        //게시글 파일 유효성 검사
        boardCheck(param, files);

        //게시글 id생성
        UUID uuid = UUID.randomUUID();

        //게시글 DB insert
        bD.boardInsert(param, uuid.toString());
        
        //파일저장
        if(files.length > 0) {
            //파일 저장, DB저장
            try {
                fileSave(files, uuid.toString());
            } catch (Exception e) { //에러발생할경우 게시글삭제
                bD.boardDel(uuid.toString());
            }
        }
        

    }

    public void boardCheck(Map<String, Object> param, MultipartFile[] files)  {
        String title = Utils.nvl((String)param.get("board_title"), "");
        String content = Utils.nvl((String)param.get("board_content"), "");

        if (title.length() < 1 || title.length() > 100) {
            throw new RuntimeException("제목은 1자 이상 100자 이하여야 합니다.");
        }else if(content.length() < 1 || content.length() > 4000) {
            throw new RuntimeException("내용은 1자 이상 4000자 이하여야 합니다.");
        }

        long maxSize = 100 * 1024 * 1024; // 100MB
        long totalMaxSize = 500 * 1024 * 1024; // 500MB

        long totlaFileSize = 0;
        for (MultipartFile file : files) {
            if (file.getSize() > maxSize) {
                throw new RuntimeException("파일 사이즈가 100MB를 초과하는 파일이 포함되어 있습니다.");
            }else {
                totlaFileSize += file.getSize();
                if(totlaFileSize > totalMaxSize) {
                    throw new RuntimeException("총 파일 사이즈가 500MB를 초과합니다.");
                }
            }
        }


    }

    // public List<List<String>> fileSave(MultipartFile[] files, String boardId){
    public List<String> fileSave(MultipartFile[] files, String boardId){
        //실패시 삭제할 파일명
        // List<List<String>> list = new ArrayList<List<String>>();
        // List<String> fileNamesList = new ArrayList<String>();
        List<String> fileIdsList = new ArrayList<String>();

        try {
            for (MultipartFile file : files) {
                System.out.println("파일업로드처리");
                // 파일 저장
                String originFileName = file.getOriginalFilename(); //파일의 오리지널 이름

                // 파일명,확장자명 분리
                String realFileName = originFileName.substring(0, originFileName.lastIndexOf('.')); // 파일명
                String fileExtension = originFileName.substring(originFileName.lastIndexOf('.') + 1);   // 확장자명

                // 저장 파일명UUID = 파일ID
                UUID uuid = UUID.randomUUID();
                // String fileName = file.getOriginalFilename();
                // System.out.println("Uploaded File Name: " + fileSaveName);

                // 파일저장
                Path filePath = Paths.get(uploadPath, uuid.toString());
                Files.write(filePath, file.getBytes());

                fileIdsList.add(uuid.toString()); //저장실패시 삭제용

                // DB저장
                bD.fileInsert(realFileName, uuid.toString(), fileExtension, uploadPath, boardId);

            }
        } catch (Exception e) {
            //저장 실패시 저장한 파일,dB 삭제
            filesDel( fileIdsList);
            System.err.println("파일 저장 에러");
            throw new RuntimeException();
        }

        // list.add(fileNamesList);
        // list.add(fileIdsList);

        return fileIdsList;
    }

    public void filesDel(List<String> fileIdsList) {

        // if(fileNamesList.size() > 0) {
        //     for (String fileName : fileNamesList) {
        //         fileDel(fileName);
        //     }
        // }
        // if(fileIdsList.size() > 0) {
        //     for (String fileId : fileIdsList) {
        //         bD.delFile(fileId);
        //     }
        // }
        if(fileIdsList.size() > 0) {
            for (String fileId : fileIdsList) {
                fileDel(fileId);
                bD.delFile(fileId);
            }
        }

        
    }

    public void boardUpdate(Map<String, Object> param, MultipartFile[] files, String sessionUserId, String sessionAuth) { //{"user_id":"1","board_title":"2","file_id":["7","8","9"],"board_id":"10","board_content":"2"}
        
        //게시글 파일 유효성 검사
        boardCheck(param, files);

        //게시글 정보가져오기
        Map<String, Object> boardMap = bD.boardGet(param);

        //세션 관리자, 유저 확인
        String userId=boardMap.get("user_id").toString(); //게시글의 유저ID
        sessionCheck(userId, sessionUserId, sessionAuth);
        

        //게시글 업데이트========================
        bD.boardUpdate(param);

        // List<List<String>> list = new ArrayList<List<String>>(); //실패시 삭제할 파일
        List<String> list = new ArrayList<String>(); //실패시 삭제할 파일
        //새로 첨부된 파일 넣기========================
        if(files.length > 0) {
            // insert 된 게시글 id값 가져오기 (파일DB저장 처리용)
            String board_id = Utils.nvl((String)param.get("board_id"), "");
            try {
                list=fileSave(files, board_id); //저장된 파이명, 파일id 반환
            } catch (Exception e) {
                bD.boardUpdate(boardMap); //게시글 업데이트 롤백
                throw new RuntimeException("새로첨부된 파일 넣기 에러");
            }
        }


        
        //기존 첨부되있던 파일처리(삭제)========================
        JSONArray fileIds=(JSONArray) param.get("file_id");
        if (fileIds == null) { //null 처리
            fileIds = new JSONArray();
        }
        
        if (fileIds.size() > 0) { //삭제 파일 있을시

            List<Map<String, Object>> filesDB = bD.fileListGet(param); //DB에 저장된 파일들
            // List<String> fileIdsDB = new ArrayList<String>(); // 삭제된 파일ID저장
            String fileIdDb="";

            try {
                for (int i = 0; i < fileIds.size(); i++) {
                    //파일 명
                    String fileId = (String) fileIds.get(i);
                    //파일 DB에서 삭제
                    bD.delFile(fileId); //DB에서 파일삭제
                    // fileIdsDB.add(fileId); //삭제된 파일ID저장
                    fileIdDb = fileId;
                    fileDel(fileId); //저장소에서 파일삭제
                    fileIdDb="";//초기화
                }
            
            } catch (Exception e) {

                //게시글 업데이트 롤백
                bD.boardUpdate(boardMap);
                //신규 파일 저장 롤백
                // filesDel(list.get(0), list.get(1));
                filesDel(list);
                //DB에 저장된 파일 롤백
                if(!fileIdDb.equals("")) { //DB삭제된 파일이 있을경우
                    for (Map<String, Object> file : filesDB) { //DB에 저장된 파일들비교 해서 DB롤백
                        fileIdDb.equals(Utils.nvl((String)file.get("file_id"), ""));
                        bD.fileInsert(Utils.nvl((String)file.get("file_name"),""), 
                                        Utils.nvl((String)file.get("file_id"),""), 
                                        Utils.nvl((String)file.get("file_extension"),""), 
                                        Utils.nvl((String)file.get("upload_path"),""), 
                                        Utils.nvl((String)file.get("board_id"),""));
                    }
                }

                //신규로 저장된거 삭제 , 기존파일 롤백

                throw new RuntimeException("기존파일 삭제 에러");
            }
        }
        //==============================

    }

    public void sessionCheck(String userId, String sessionUserId, String sessionAuth) {
        if(!sessionAuth.equals("0")) { //관리자인지
            if (!userId.equals(sessionUserId)) { //유저일치하는지
                throw new RuntimeException("유저 불일치");
            }
        }
    }


    public void boardDel(Map<String, Object> param, String sessionUserId, String sessionAuth)  {

        //게시글 정보가져오기
        Map<String, Object> boardMap = bD.boardGet(param);

        //세션 관리자, 유저 확인
        String userId=Utils.nvl((String)boardMap.get("user_id"),""); //게시글의 유저ID
        sessionCheck(userId, sessionUserId, sessionAuth);
        
        //게시글 삭제
        bD.boardDel(Utils.nvl((String)param.get("board_id"), ""));

        //파일 삭제
        List<String> filesIds=(List<String>) param.get("files");
        if (filesIds == null) {
            filesIds = new ArrayList<>();
        }
        if(filesIds.size() > 0) {// 삭제할 파일 있을경우
            List<Map<String, Object>> filesDB = bD.fileListGet(param); //DB에 저장된 파일들
            String fileIdDb="";

            
            try {
                for (String fileId : filesIds) {
                    bD.delFile(fileId); //DB에서 파일삭제
                    fileIdDb = fileId;
                    fileDel(fileId); //저장소 삭제
                }
                
            } catch (Exception e) {
                bD.boardUpdate(boardMap);//게시글 롤백
                //DB에 저장된 파일 롤백
                if(!fileIdDb.equals("")) { //DB삭제된 파일이 있을경우
                    for (Map<String, Object> file : filesDB) { //DB에 저장된 파일들비교 해서 DB롤백
                        fileIdDb.equals(Utils.nvl((String)file.get("file_id"), ""));
                        bD.fileInsert(Utils.nvl((String)file.get("file_name"),""), 
                                        Utils.nvl((String)file.get("file_id"),""), 
                                        Utils.nvl((String)file.get("file_extension"),""), 
                                        Utils.nvl((String)file.get("upload_path"),""), 
                                        Utils.nvl((String)file.get("board_id"),""));
                    }
                }
            }
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
        } catch (Exception e) {
            throw new RuntimeException("파일 삭제 에러");
        }
    }

    

    public ResponseEntity<byte[]> fileDown(String id) {
        ResponseEntity<byte[]> entity = null;
        Map<String, Object> map = bD.fileGet(id);
        if (map == null) {
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", "text/plain; charset=UTF-8");
            entity = new ResponseEntity<>("file DB not found.".getBytes(), header, HttpStatus.NOT_FOUND);
            return entity;
        }

        String fileExtension=Utils.nvl((String) map.get("file_extension"), "");

        //원래 파일명
        String fileName = Utils.nvl((String) map.get("file_name"),"")+ "."
                + fileExtension;
        //저장 파일명
        // String savefileName = id+"."+fileExtension;
        // System.out.println("savefileName: "+map.toString());


        // 파일이 저장된 경로 + \
        String savename = uploadPath+"\\"+id;
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
