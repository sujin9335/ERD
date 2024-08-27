package com.codvill.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class MenuInterceptor implements HandlerInterceptor{

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        System.out.println("메뉴권한인터셉터 실행");
        int auth= -1;
        Map<String, Object> userInfo = (Map<String, Object>) request.getSession().getAttribute("userInfo");
        auth=Integer.parseInt(userInfo.get("user_auth").toString());
        if(auth != 0){
            System.out.println("권한 없음");
            response.sendRedirect(request.getContextPath()+"/highChart/");
			return false;
		} 

        return true;
    }
}
