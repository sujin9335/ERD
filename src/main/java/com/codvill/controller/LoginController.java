package com.codvill.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.codvill.comm.Utils;
import com.codvill.service.LoginService;

import ch.qos.logback.classic.pattern.Util;


@Controller
public class LoginController {
    
    @Autowired
    LoginService ls;

    @GetMapping("/login")
    public String login() {

        return "/login";
    }

    @PostMapping("/loginCheck")
    public String loginCheck(@RequestParam("id") String id, @RequestParam("pw") String pw, Model model, HttpSession session) {
        System.out.println("loginCheck 실행");

        // System.out.println(id+ " " + pw);

        String loginId=Utils.nvl(id, "");
        String loginPw=Utils.nvl(pw, "");

        Map<String, Object> map=ls.loginCheck(loginId, loginPw);
        System.out.println(map);

        if(map == null) { //로그인 실패
            System.out.println("로그인실패");
            model.addAttribute("msg", "아이디 또는 비밀번호가 잘못되었습니다");

        }else {
            if((Integer)map.get("user_lock_cnt") > 4) { //로그인 횟수 5회 이상이면 접속금지
                model.addAttribute("msg", "로그인 실패 5회입니다 관리자 문의하세요");
            }else { 

                if(map.get("id") != null) { //로그인시 비번만 틀렸을경우
                    //로그인 실패 카운트 증가 
                    int cnt=(Integer) map.get("user_lock_cnt")+1; //로그인 실패 횟수
                    model.addAttribute("msg", "비밀번호를 " + cnt + "회 잘못 입력하셨습니다");
                    ls.updateLockCnt(loginId, cnt);
                }else {
                    String user_use=(String) map.get("user_use");
                    if (user_use.equals("n")) {
                        model.addAttribute("msg", "계정 잠금 상태입니다 관리자 문의하세요");
                    }else {

                        ls.resetLockCnt(loginId);

                        System.out.println("로그인성공");
                        Map<String, Object> userInfo=new HashMap<>();
                        userInfo.put("user_id", map.get("user_id"));
                        userInfo.put("user_name", map.get("user_name"));
                        userInfo.put("user_auth", map.get("user_auth"));

                        session.setAttribute("userInfo", userInfo);
                        System.out.println("=====================================");
                        System.out.println(userInfo);
                        System.out.println("=====================================");

                        return "redirect:/board/";

                    }

                }

            }
            
        }
        return "/login";
        
        



    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session.getAttribute("userInfo") != null) {
            session.invalidate();
        }

        return "redirect:/login";
    }

    
}
