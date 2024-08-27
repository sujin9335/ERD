<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <%@include file="include/link_js.jsp" %>
            <style>


            </style>
            <link rel="stylesheet" href="/css/main.css">
            <script src="https://code.highcharts.com/highcharts.js"></script>
            <script src="https://code.highcharts.com/modules/data.js"></script>
            <script src="https://code.highcharts.com/modules/drilldown.js"></script>
            <script src="https://code.highcharts.com/modules/exporting.js"></script>
            <script src="https://code.highcharts.com/modules/export-data.js"></script>
            <script src="https://code.highcharts.com/modules/accessibility.js"></script>
    </head>

    <body>
        <%@include file="include/header.jsp" %>
            <div class="container text-center">
                <div class="row">
                    <div class="col">
                        <h2>home</h2>
                    </div>
                </div>
            </div>

            <div class="container" id="main">
                <div id="line"></div>
                <div id="bar"></div>
                <div id="pie"></div>
                <div id="pieDrill"></div>
            </div>

            <!-- 클릭이벤트 모달 -->
            <div class="modal fade" id="userRegisModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
                aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">
                        <div class="modal-body">

                            <!-- 유저  -->
                            <div class="container" id="userCon">
                                <!-- <div class="container"> -->
                                <!-- 검색 -->
                                <div class="col px-5 my-2">
                                    <div class="d-flex" role="search">
                                        <select id="searchType">
                                            <option value="user_name">이름</option>
                                        </select>
                                        <input class="form-control" type="search" placeholder="검색" aria-label="Search"
                                            id="search">
                                        <button class="btn btn-outline-success col-2"
                                            onclick="groupUserList(true);">검색</button>
                                        <button class="btn btn-outline-success col-2"
                                            onclick="clearSearch()">초기화</button>
                                        <div>
                                        </div>
                                    </div>
                                </div>
                                <!-- 리스트 -->
                                <div class="container-fluid py-5 text-start">
                                    <div id="total"></div>
                                    <table class="table text-center" id="tab">
                                        <thead>
                                            <tr>
                                                <th class="col" scope="col">이름</th>
                                                <th class="col" scope="col">아이디</th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                    </table>
                                </div>
                                <div class="container text-center">
                                    <div class="row">
                                        <div class="col">
                                            <div style="display: flex; justify-content: center;" id="pag">
                                                <!-- 페이징 -->
                                            </div>
                                        </div>
                                    </div>
                                    <div class="container">
                                        <div class="row">
                                            <div class="col text-end">
                                                <button type="button" class="btn btn-dark"
                                                    data-bs-dismiss="modal">닫기</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <script>

                //검색조건boolean
                var searchBool = false;

                var page_current = 1; //현재 보고있는 페이지
                var limit = 5; //몇개씩 볼건지

                //검색어 저장
                var searchInput = "";

                //pie 선택 데이터
                var selecData = "";


                window.onload = function () {
                    line();
                    bar();
                    pie();
                    pieDrill();
                };


                async function line() { //비동기 함수선언

                    const chartData = await processData("line"); //await 사용하여 processData() 기다림
                    // const clcikData = await clickData(); //await 사용하여 processData() 기다림

                    // console.log("반환 chartData");
                    // console.log(chartData);


                    Highcharts.chart('line', {
                        credits: {
                            enabled: false  // 우측 하단 로고 제거
                        },

                        title: {
                            text: '게시글 날짜별 등록 갯수'
                        },
                        tooltip: {
                            valueSuffix: '개'
                        },

                        yAxis: {
                            title: {
                                text: '게시글 수',
                                align: 'high',
                                offset: 0,
                                rotation: 0,
                                y: -10
                            }
                        },
                        xAxis: {
                            type: 'category'
                        },
                        legend: {
                            enabled: false // 범례를 숨깁니다 (맨밑 데이터 설명)
                        },

                        exporting: {
                            enabled: false // 우측 상단 메뉴를 비활성화합니다
                        },

                        series: [{

                            name: '게시글',
                            data: chartData

                        }],
                        //클릭 이벤트 발생
                        plotOptions: {
                            series: {
                                cursor: 'pointer',
                                className: 'popup-on-click',
                                marker: {
                                    lineWidth: 1
                                },
                                point: {
                                    events: {
                                        click: async function () { //클릭이벤트 발생 함수
                                            if (this.series.options.className.indexOf('popup-on-click') !== -1) {
                                                // console.log(clcikData);

                                                const data = await clickData(this.name);

                                                var print = "";
                                                // console.log(data);
                                                if (data.length > 0) {
                                                    data.forEach(function (item) {
                                                        print += "ID: " + item.name + ", 게시글수: " + item.y + "<br/>";
                                                    });
                                                } else {
                                                    print = "게시글 없음";
                                                }
                                                console.log(print);

                                                const chart = this.series.chart;
                                                const text = print; //출력될 내용

                                                const anchorX = this.plotX + this.series.xAxis.pos;
                                                const anchorY = this.plotY + this.series.yAxis.pos;
                                                const align = anchorX < chart.chartWidth - 200 ? 'left' : 'right';
                                                const x = align === 'left' ? anchorX + 10 : anchorX - 10;
                                                const y = anchorY - 30;

                                                if (!chart.sticky) {
                                                    chart.sticky = chart.renderer
                                                        .label(text, x, y, 'callout', anchorX, anchorY)
                                                        .attr({
                                                            align,
                                                            fill: 'rgba(0, 0, 0, 0.75)',
                                                            padding: 10,
                                                            zIndex: 7 // Above series, below tooltip
                                                        })
                                                        .css({
                                                            color: 'white'
                                                        })
                                                        .on('click', function () {
                                                            this.destroy();
                                                        })
                                                        .add();
                                                } else {
                                                    chart.sticky
                                                        .attr({ align, text })
                                                        .animate({ anchorX, anchorY, x, y }, { duration: 250 });
                                                }
                                            }
                                        }
                                    },
                                    allowPointSelect: true //Clickable points option
                                }
                            }
                        }

                    });

                }

                //클릭데이터
                async function clickData(name) {
                    return new Promise(function (resolve, reject) {
                        var param = {
                            date: name
                        };
                        $.ajax({
                            url: "/highChart/lineClick",
                            type: "POST",
                            dataType: "json",
                            contentType: "application/json",
                            data: JSON.stringify(param),
                            success: function (result) {
                                // alert("통신성공");
                                console.log(result);

                                // 처리된 데이터 반환
                                resolve(result);

                            },
                            error: function () {
                                alert("통신에러");
                            }
                        });
                    });


                }

                // function lineClick() {
                //     if (this.series.options.className.indexOf('popup-on-click') !== -1) {
                //         const chart = this.series.chart;
                //         const text = "<b>게시글 수: " + this.y + "</b><br/>" + this.name;

                //         const anchorX = this.plotX + this.series.xAxis.pos;
                //         const anchorY = this.plotY + this.series.yAxis.pos;
                //         const align = anchorX < chart.chartWidth - 200 ? 'left' : 'right';
                //         const x = align === 'left' ? anchorX + 10 : anchorX - 10;
                //         const y = anchorY - 30;

                //         if (!chart.sticky) {
                //             chart.sticky = chart.renderer
                //                 .label(text, x, y, 'callout', anchorX, anchorY)
                //                 .attr({
                //                     align,
                //                     fill: 'rgba(0, 0, 0, 0.75)',
                //                     padding: 10,
                //                     zIndex: 7 // Above series, below tooltip
                //                 })
                //                 .css({
                //                     color: 'white'
                //                 })
                //                 .on('click', function () {
                //                     this.destroy();
                //                 })
                //                 .add();
                //         } else {
                //             chart.sticky
                //                 .attr({ align, text })
                //                 .animate({ anchorX, anchorY, x, y }, { duration: 250 });
                //         }
                //     }
                // }

                //게시글 날짜별 등록갯수 가져옴
                function processData(type) {
                    return new Promise(function (resolve, reject) {

                        $.ajax({
                            url: "/highChart/line",
                            type: "POST",
                            contentType: "application/json",
                            success: function (result) {
                                // alert("통신성공");
                                console.log(result);
                                const chartData = []

                                for (let i = 0; i < result.length; i++) {
                                    var chartDataObj = {};
                                    if (type == "bar") {
                                        chartDataObj = { name: result[i].total_date, y: result[i].total, drilldown: result[i].total_date };
                                    } else {
                                        chartDataObj = { name: result[i].total_date, y: result[i].total };
                                    }

                                    // 데이터 배열에 추가

                                    chartData.push(chartDataObj);

                                }

                                console.log("데이터 chartData");
                                console.log(chartData);

                                // 처리된 데이터 반환
                                resolve(chartData);

                            },
                            error: function () {
                                alert("통신에러");
                            }
                        });
                    });
                }

                async function bar() {

                    const chartData = await processData("bar"); //await 사용하여 processData() 기다림
                    const drillData = await barDrillData(); //await 사용하여 processData() 기다림

                    Highcharts.chart('bar', {
                        credits: {
                            enabled: false  // 우측 하단 로고 제거
                        },
                        chart: {
                            type: 'column'

                        },
                        title: {
                            text: '게시글 날짜별 등록 갯수'
                        },
                        tooltip: {
                            valueSuffix: '개',
                            xDateFormat: '%Y-%m-%d'
                        },
                        xAxis: {
                            type: 'category'
                        },
                        yAxis: {
                            title: {
                                text: '게시글 수',
                                align: 'high',
                                offset: 0,
                                rotation: 0,
                                y: -10
                            }
                        },

                        exporting: {
                            enabled: false // 우측 상단 메뉴를 비활성화합니다
                        },

                        legend: {
                            enabled: false // 범례를 숨깁니다 (맨밑 데이터 설명)
                        },

                        series: [{
                            name: '게시글',
                            data: chartData
                        }],
                        drilldown: {
                            breadcrumbs: {
                                position: {
                                    align: 'right'
                                }
                            },
                            series: drillData
                        }
                    });

                }

                //드릴 아웃 데이터
                async function barDrillData() {
                    return new Promise(function (resolve, reject) {

                        $.ajax({
                            url: "/highChart/barDrill",
                            type: "POST",
                            contentType: "application/json",
                            success: function (result) {
                                // alert("통신성공");
                                console.log(result);
                                //{name: 2, id:2024-7-17, data: 1}

                                const chartData = []

                                Object.entries(result).forEach(function (entry) {
                                    var key = entry[0];   // 첫 번째 요소는 키
                                    var value = entry[1]; // 두 번째 요소는 값

                                    var obj = {
                                        name: key,
                                        id: key,
                                        data: value
                                    }

                                    chartData.push(obj);

                                    // for (let i = 0; i < value.length; i++) {
                                    //     console.log(key+" 드릴데이터");
                                    //     console.log(value[i].name);
                                    // }


                                });

                                console.log("데이터 chartData");
                                console.log(chartData);



                                // 처리된 데이터 반환
                                resolve(chartData);

                            },
                            error: function () {
                                alert("통신에러");
                            }
                        });
                    });


                }



                async function pie() {

                    const chartData = await groupUserData();

                    // const chartData = [
                    //     { name: '그룹 A', y: 45, hidden: 12 },
                    //     { name: '그룹 B', y: 32, hidden: 13 },
                    //     { name: '그룹 C', y: 23, hidden: 14 }
                    // ];

                    Highcharts.chart('pie', {
                        credits: {
                            enabled: false  // 우측 하단 로고 제거
                        },
                        chart: {
                            type: 'pie'
                        },
                        title: {
                            text: '그룹별 사용자 비율'
                        },
                        tooltip: {
                            valueSuffix: '명'
                        },

                        plotOptions: {
                            series: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                dataLabels: [{
                                    enabled: true,
                                    distance: 20
                                }, {
                                    enabled: true,
                                    distance: -40,
                                    format: '{point.percentage:.1f}%',
                                    style: {
                                        fontSize: '1.2em',
                                        textOutline: 'none',
                                        opacity: 0.7
                                    }
                                }],
                                point: {
                                    events: {
                                        click: function (event) {
                                            selecData = this.hidden;
                                            openUserRegisModal();
                                            // alert(this.hidden);
                                        }
                                    }
                                }

                            }
                        },
                        exporting: {
                            enabled: false // 우측 상단 메뉴를 비활성화합니다
                        },
                        series: [
                            {
                                name: '유저',
                                colorByPoint: true,
                                data: chartData
                            }
                        ]
                    });
                }

                function groupUserData() {
                    return new Promise(function (resolve, reject) {

                        $.ajax({
                            url: "/highChart/pie",
                            type: "POST",
                            contentType: "application/json",
                            success: function (result) {
                                // alert("통신성공");

                                console.log("pie data");
                                console.log(result);

                                const chartData = result.data;

                                // 처리된 데이터 반환
                                resolve(chartData);

                            },
                            error: function () {
                                alert("통신에러");
                            }
                        });
                    });

                }

                //모달창 보이기 
                function openUserRegisModal() {
                    $('#userRegisModal').modal('show');
                    groupUserList();
                }



                //그룹에 등록된 유저 리스트
                function groupUserList(search) {
                    // alert("여기"+selecData);

                    //총몇개출력 초기화
                    $("#total").empty();

                    var param = {}

                    if (search) {
                        searchBool = true;
                        page_current = 1;
                        searchInput = $("#search").val();
                    }

                    $("#tab tbody").empty();
                    param = {
                        offset: limit * (page_current - 1), //현재 보고있는 페이지
                        listSize: limit, // 가져올 데이터의 개수
                    };

                    if (searchBool) {
                        param.searchType = $("#searchType").val();
                        param.search = searchInput
                    }

                    param.group_id = String(selecData);

                    // console.log("param");
                    // console.log(param);

                    $.ajax({
                        url: "/group/groupUserList",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            console.log(result);

                            //초기화
                            $("#tab tbody").empty();

                            if (result.data.length > 0) {
                                var totalPage = Math.ceil(result.total / limit);

                                paging(page_current, totalPage);

                                $("#total").text("총:" + result.total + "개")
                                if (result.data.length > 0) {
                                    for (var i = 0; i < result.data.length; i++) {

                                        var tmp_tr = "<tr>" +
                                            "<td class='col')>" + result.data[i].user_name + "</td>" +
                                            "<td class='col')>" +
                                            result.data[i].user_login_id +
                                            "</td>" +
                                            "</tr>";

                                        $("#tab tbody").append(tmp_tr);
                                    }
                                }


                            } else { //검색결과 없을경우
                                var tmp_tr = "<tr>" +
                                    "<td colspan='6' scope='row' data-bs-toggle='modal' data-bs-target='#staticBackdrop' >유저가 존재하지 않습니다</td>" +
                                    "</tr>";
                                $("#tab tbody").append(tmp_tr);

                                //페이징 초기화
                                $("#pag").empty();
                            }

                            //등록된 인원 수 저장(삭제시 사용)
                            userLength = result.data.length;

                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }

                //초기화 버튼 실행
                function clearSearch() {
                    page_current = 1;
                    searchBool = false;
                    $("#searchType").val("user_name");
                    $("#search").val("");
                    groupUserList();
                }

                //모달창 닫히면 실행
                $("#userRegisModal").on('hide.bs.modal', function (e) {
                    page_current = 1;
                    searchBool = false;
                    $("#searchType").val("user_name");
                    $("#search").val("");
                });

                async function pieDrill() {

                    const chartData = await groupUserData();
                    const drillData = await pieDrillData();

                    // const chartData = [
                    //     { name: '그룹 A', y: 45, hidden: 12 },
                    //     { name: '그룹 B', y: 32, hidden: 13 },
                    //     { name: '그룹 C', y: 23, hidden: 14 }
                    // ];

                    Highcharts.chart('pieDrill', {
                        credits: {
                            enabled: false  // 우측 하단 로고 제거
                        },
                        chart: {
                            type: 'pie'
                        },
                        title: {
                            text: '그룹별 사용자 비율'
                        },
                        tooltip: {
                            valueSuffix: '명'
                        },

                        plotOptions: {
                            series: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                dataLabels: [{
                                    enabled: true,
                                    distance: 20
                                }, {
                                    enabled: true,
                                    distance: -40,
                                    // format: '{point.percentage:.1f}%',
                                    formatter: function () {
                                        console.log(this)
                                        if (this.point.drilldown) {
                                            return this.point.percentage.toFixed(1)+"%";
                                        } else {
                                            return "ID: "+this.key;
                                        }
                                    },
                                    style: {
                                        fontSize: '1em',
                                        textOutline: 'none',
                                        opacity: 0.7
                                    }
                                }]
                            }
                        },
                        exporting: {
                            enabled: false // 우측 상단 메뉴를 비활성화합니다
                        },
                        series: [
                            {
                                name: '유저',
                                colorByPoint: true,
                                data: chartData
                            }
                        ],
                        drilldown: {
                            breadcrumbs: {
                                position: {
                                    align: 'center'
                                }
                            },
                            series: drillData
                        }
                    });
                }

                //pie드릴 아웃 데이터
                async function pieDrillData() {
                    return new Promise(function (resolve, reject) {

                        $.ajax({
                            url: "/highChart/pieDrill",
                            type: "POST",
                            contentType: "application/json",
                            success: function (result) {
                                // alert("통신성공");
                                console.log(result);
                                //{name: 2, id:2024-7-17, data: 1}

                                const chartData = []

                                Object.entries(result).forEach(function (entry) {
                                    var key = entry[0];   // 첫 번째 요소는 키
                                    var value = entry[1]; // 두 번째 요소는 값

                                    var obj = {
                                        name: "사용자",
                                        id: key,
                                        data: value
                                    }

                                    chartData.push(obj);

                                });

                                console.log("데이터 chartData");
                                console.log(chartData);



                                // 처리된 데이터 반환
                                resolve(chartData);

                            },
                            error: function () {
                                alert("통신에러");
                            }
                        });
                    });


                }



            </script>

    </body>


    </html>