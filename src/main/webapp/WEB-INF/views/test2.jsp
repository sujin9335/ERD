<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <%@include file="include/link_js.jsp" %>
            <style>


            </style>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
            <script src="https://code.highcharts.com/highcharts.js"></script>
            <script src="https://code.highcharts.com/modules/data.js"></script>
            <script src="https://code.highcharts.com/modules/drilldown.js"></script>
            <script src="https://code.highcharts.com/modules/exporting.js"></script>
            <script src="https://code.highcharts.com/modules/export-data.js"></script>
            <script src="https://code.highcharts.com/modules/accessibility.js"></script>
            <script src="https://code.highcharts.com/modules/series-label.js"></script>
    </head>

    <body>
           <!-- 이 요소는 스크린 리더가 읽지 않음 -->
    <span aria-hidden="true">
        🌟 비주얼 아이콘만 표시됨 (스크린 리더 무시)
    </span>

    <!-- 이 요소는 스크린 리더가 읽음 -->
    <span aria-hidden="false">
        🌟 스크린 리더가 읽는 아이콘과 텍스트
    </span>

    <!-- 기본적으로 aria-hidden이 없는 경우 (false와 동일) -->
    <span>
        🌟 스크린 리더가 읽는 기본 아이콘과 텍스트
    </span>
    

    </body>


    </html>