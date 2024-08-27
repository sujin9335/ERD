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
    @Autowired
    private MenuInterceptor menuInterceptor;



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
                .excludePathPatterns("/user/idCheck")
                .excludePathPatterns("/user/insert")
                ;

        registry.addInterceptor(menuInterceptor)
                .order(1)
                .addPathPatterns("/user/")
                .addPathPatterns("/group/")
                ;
    }
}
