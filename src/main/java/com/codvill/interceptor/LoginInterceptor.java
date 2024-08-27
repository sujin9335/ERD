package com.codvill.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class LoginInterceptor implements HandlerInterceptor{

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        
        System.out.println("로그인인터셉터 실행");
        if(request.getSession() == null){
            System.out.println("세션 없음");
            response.sendRedirect(request.getContextPath() + "/login");
			// request.getRequestDispatcher("/login").forward(request, response);
			return false;
		} else if(request.getSession().getAttribute("userInfo")  == null){
            System.out.println("유저정보 없음");
            response.sendRedirect(request.getContextPath() + "/login");
    		// request.getRequestDispatcher("/login").forward(request, response);
			return false;
        }
        
        return true;
    }
    
}
