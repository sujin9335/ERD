package com.codvill.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.codvill.dao.HighChartDao;

import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

@Service
public class HighChartService {

    @Autowired
    HighChartDao hd;

    public JSONArray line() {
        JSONArray obj = new JSONArray();

        List<Map<String, Object>> list = hd.line();
        // System.out.println("쿼리결과");
        // System.out.println(list.toString());

        // 게시글 0개인 날짜 포함 return
        if (list.size() > 0) {

            // 시작 날짜 구하기
            String startDateString = (String) list.get(0).get("total_date");
            String[] startDateArr = startDateString.split("-");
            int[] startDateIntArr = new int[startDateArr.length];

            // 문자열을 int로 변환하여 int 배열에 저장
            for (int i = 0; i < startDateArr.length; i++) {
                startDateIntArr[i] = Integer.parseInt(startDateArr[i]);
            }
            // System.out.println("시작날짜");
            // System.out.println(Arrays.toString(startDateIntArr));

            // 종료 날짜 구하기
            String endDateString = (String) list.get(list.size() - 1).get("total_date");
            String[] endDateArr = endDateString.split("-");
            int[] endDateIntArr = new int[endDateArr.length];

            // 문자열을 int로 변환하여 int 배열에 저장
            for (int i = 0; i < endDateArr.length; i++) {
                endDateIntArr[i] = Integer.parseInt(endDateArr[i]);
            }

            // System.out.println(Arrays.toString(endDateIntArr));

            // 날짜 형식 정의
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            // 시작 날짜와 종료 날짜를 설정합니다.
            LocalDate startDate = LocalDate.of(startDateIntArr[0], startDateIntArr[1], startDateIntArr[2]); // 2024년 7월
                                                                                                            // 15일
            LocalDate endDate = LocalDate.of(endDateIntArr[0], endDateIntArr[1], endDateIntArr[2]); // 2024년 7월 25일

            // 날짜 목록을 생성합니다.
            List<LocalDate> dates = new ArrayList<>();
            LocalDate currentDate = startDate;

            while (!currentDate.isAfter(endDate)) {
                dates.add(currentDate);
                currentDate = currentDate.plusDays(1);
            }

            // 날짜 목록을 출력해 list에 없으면 total=0, 있으면 total 데이터를 그대로
            for (LocalDate date : dates) {
                String formattedDate = date.format(formatter);
                Map<String, Object> m = new HashMap<>();
                m.put("total_date", formattedDate);
                m.put("total", 0);

                for (Map<String, Object> map : list) {
                    if (map.get("total_date").equals(formattedDate)) {
                        m.put("total", map.get("total"));
                    }
                }

                obj.add(m);
            }

        }
        System.out.println();
        System.out.println("데이터");

        System.out.println(obj);
        System.out.println();

        return obj;
    }

    public JSONObject pie() {
        JSONObject obj = new JSONObject();
        obj = hd.pie();

        return obj;
    }

    public JSONObject barDrill() {
        JSONObject obj = new JSONObject();

        List<Map<String, Object>> list = hd.line();
        // System.out.println("쿼리결과");
        // System.out.println(list.toString());

        if (list.size() > 0) {

            for (Map<String, Object> map : list) {
                String date = (String) map.get("total_date");
                List<Map<String, Object>> drillData = hd.drill(date);
                obj.put(date, drillData);
            }

        }

        System.out.println(obj);

        return obj;
    }

    public JSONArray lineClick(Map<String, Object> param) {
        JSONArray arr = new JSONArray();
        String date = (String) param.get("date");

        List<Map<String, Object>> clickData = hd.drill(date);

        for (Map<String, Object> map : clickData) {
            JSONObject obj = new JSONObject(map);
            arr.add(obj);
        }

        System.out.println();
        System.out.println("라인클릭데이터");
        // System.out.println(clickData);
        System.out.println(arr);

        return arr;
    }

    public JSONObject pieDrill() {
        JSONObject obj = new JSONObject();

        List<Map<String, Object>> list = hd.pieList();
        // System.out.println("쿼리결과");
        // System.out.println(list.toString());

        if (list.size() > 0) {

            for (Map<String, Object> map : list) {
                int id = (Integer) map.get("group_id");
                List<Map<String, Object>> drillData = hd.pieDrill(id);
                obj.put(id + "", drillData);
            }

        }

        System.out.println(obj);

        return obj;
    }

}
