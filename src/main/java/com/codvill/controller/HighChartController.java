package com.codvill.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.codvill.service.HighChartService;

import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

@Controller
@RequestMapping("/highChart")
public class HighChartController {

    @Autowired
    HighChartService hs;

    @GetMapping("/")
    public String highChart() {

        return "chart";
    }


    
    @PostMapping("/line")
    @ResponseBody
    public Object line() {
        JSONArray obj=new JSONArray();
        obj=hs.line();
        
        return obj;
    }

    @PostMapping("/pie")
    @ResponseBody
    public Object pie() {
        JSONObject obj=new JSONObject();
        obj=(JSONObject) hs.pie();
        // System.out.println(obj);

        return obj;
    }

    @PostMapping("/barDrill")
    @ResponseBody
    public Object barDrill() {
        JSONObject obj=new JSONObject();
        obj=(JSONObject) hs.barDrill();

        return obj;
    }

    @PostMapping("/lineClick")
    @ResponseBody
    public Object lineClick(@RequestBody Map<String, Object> param) {
        JSONArray arr=new JSONArray();
        // System.out.println(param);
        arr=(JSONArray) hs.lineClick(param);

        return arr;
    }

    @PostMapping("/pieDrill")
    @ResponseBody
    public Object pieDrill() {
        JSONObject obj=new JSONObject();
        obj=(JSONObject) hs.pieDrill();

        return obj;
    }

}
