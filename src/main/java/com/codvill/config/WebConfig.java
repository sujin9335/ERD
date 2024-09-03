package com.codvill.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.codvill.interceptor.LoginInterceptor;
import com.codvill.interceptor.MenuInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer{
    
    @Autowired
    private LoginInterceptor loginInterceptor;



    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .order(0)
                .addPathPatterns("/**") //모든 페이지 인터셉터 실행
                .excludePathPatterns("/login") //로그인 페이지 제외
                .excludePathPatterns("/loginCheck")
                .excludePathPatterns("/css/**")
                .excludePathPatterns("/js/**")
                .excludePathPatterns("/logout")
                .excludePathPatterns("/user/idCheck") //일반회원가입 id중복확인
                .excludePathPatterns("/user/insert") //일반회원가입
                ;

        
    }
}
