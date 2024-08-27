<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>

        <%@include file="include/link_js.jsp" %>
            <link rel="stylesheet" href="/css/group.css">

            <!-- jstree CSS CDN 추가 -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css" />
            
            <!-- jstree JS CDN 추가 -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.dnd.min.js"></script>

    </head>

    <body>
        <%@include file="include/header.jsp" %>
            <div class="container text-center">
                <div class="row">
                    <div class="col">
                        <h2>그룹 관리</h2>
                    </div>
                </div>
            </div>

            <div class="container" id="main">
                <div class="row">
                    <div class="col-3 me-5 border hi-700" id="menu">
                        <div class="my-2">그룹</div>
                        <div class="border hi-500 p-2 scroll" id="jstree">jstree 위치</div>
                        <div class="text-end m-2">
                            <button class="text-end me-2" data-bs-toggle='modal' data-bs-target='#staticBackdrop'
                                onclick="editGroup();">등록</button>
                            <button onclick="del();">삭제</button>
                        </div>
                    </div>
                    <div class="col border hi-700" id="content">
                        <!-- 메뉴 -->
                        <div class="border">
                            <nav class="navbar navbar-expand" aria-label="Second navbar example">
                                <div class="container-fluid">
                                    <div class="collapse navbar-collapse" id="navbarsExample02">
                                        <ul class="navbar-nav me-auto">
                                            <li class="nav-item">
                                                <button id="norBtn" type="button" class="btn btn-success"
                                                    onclick="changeBoard(1);">일반</button>
                                            </li>
                                            <li class="nav-item">
                                                <button id="userBtn" type="button" class="btn btn-outline-dark"
                                                    onclick="changeBoard(2);">사용자</button>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                        </div>
                        <!-- 내용 -->
                        <div class="border">
                            <!-- <div class="container" style="display: none;"> -->
                            <div class="container text-center" id="normalCon">
                                <div class="row row-cols-2">
                                    <div class="col-2 my-2">그룹명</div>
                                    <div class="col-10 my-2">
                                        <input class="form-control" type="text" id="text">
                                    </div>
                                    <div class="col-2">그룹설명</div>
                                    <div class="col-10">
                                        <textarea class="form-control" rows="17" id="info"></textarea>
                                        <input type="hidden" id="id">
                                    </div>
                                </div>
                                <div class="text-end m-2">
                                    <button id="updateBtn" onclick="update();">수정</button>
                                </div>
                            </div>
                            <div class="container" id="userCon" style="display: none;">
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
                                            onclick="listGroupUser(true);">검색</button>
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
                                                <th class="col-4" scope="col">이름</th>
                                                <th class="col-4" scope="col">아이디</th>
                                                <th class="col-4" scope="col">삭제</th>
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
                                                <button type="button" class="btn btn-secondary m-2"
                                                    data-bs-toggle="modal" data-bs-target="#userRegisModal"
                                                    onclick="listUser();">유저 등록</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <!-- ========================= -->

            <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
                aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">

                        <div class="modal-body">
                            <div class="container text-center" id="modal">

                                <div class="container">
                                    <div class="row row-cols-2">
                                        <div class="col-2 my-2">상위그룹</div>
                                        <div class="col-10 my-2">
                                            <select class="form-select" id="groupPar">
                                                <option value="#">최상위</option>
                                            </select>
                                        </div>
                                        <div class="col-2 mb-2">그룹명</div>
                                        <div class="col-10 mb-2">
                                            <input class="form-control" type="text" id="text">
                                        </div>
                                        <div class="col-2">그룹설명</div>
                                        <div class="col-10">
                                            <textarea class="form-control" rows="17" id="info"></textarea>
                                            <input type="hidden" id="id">
                                        </div>
                                    </div>
                                    <div class="text-end m-2">
                                        <button type="button" class="btn btn-info edit"
                                            onclick="insert();">저장</button>
                                        <button type="button" class="btn btn-dark" data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- =@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

            <div class="modal fade" id="userRegisModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
                aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">

                        <div class="modal-body">
                            <div class="container text-center" id="userRegis">

                                <div class="row">
                                    <div class="col px-5">
                                        <div class="d-flex" role="search">
                                            <select id="searchType">
                                                <option value="user_name">이름</option>
                                                <option value="user_login_id">아이디</option>
                                            </select>
                                            <input class="form-control" type="search" placeholder="검색"
                                                aria-label="Search" id="search">
                                            <button class="btn btn-outline-success col-1"
                                                onclick="listUser(search);">검색</button>
                                            <div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="container-fluid py-5 text-start scroll">
                                        <table class="table text-center" id="userTab">
                                            <thead>
                                                <tr>
                                                    <th class="col-2" scope="col">
                                                        <input class="form-check-input" type="checkbox" value=""
                                                            id="checkboxAll">
                                                    </th>
                                                    <th class="col-5" scope="col">아이디</th>
                                                    <th class="col-5" scope="col">이름</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="container text-center">
                                        <div class="container">
                                            <div class="row">
                                                <div class="col text-end">
                                                    <button type="button" class="btn btn-secondary"
                                                        onclick="insertGroupUser();">등록</button>
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
            </div>


            <script>

                //검색조건boolean
                var searchBool = false;

                var page_current = 1; //현재 보고있는 페이지
                var limit = 5; //몇개씩 볼건지

                //검색어 저장
                var searchInput = "";

                //등록된 유저수
                var userLength=0;

                window.onload = function () {
                    list();
                };

                function list(pId) {
                    $('#jstree').jstree("destroy").empty();
                    

                    $.ajax({
                        url: "/group/list",
                        type: "POST",
                        dataType: "json",
                        success: function (result) {
                            // alert("통신성공");
                            // console.log(result);
                            $("#updateBtn").show();

                            if(result.length > 0 ) {

                                //jstree로 result 적용
                                $('#jstree').jstree({
                                    'core': {
                                        'data': result,
                                        "multiple": false,
                                        "check_callback": true, //이거 넣어야 dnd가능
                                    },
                                    "plugins": ["themes", "ui", "types", "wholerow", "dnd"], // HTML 데이터 플러그인 사용
                                    "types": {
                                        "default": {
                                            "icon": '/img/group.png', // 아이콘 변경
                                        }
                                    }
    
                                }).on('ready.jstree', function (e, data) { //모두 로딩되고 후 실행
                                    $('#jstree').jstree('open_all'); //펼치기
                                    if (pId == undefined || pId == 'jstree') { //아이디가 없는경우 or 그룹이 첫생성시
                                        pId = result[0].id;
                                    }
                                    $('#jstree').jstree('select_node', pId); //처음 선택되어있는것
    
                                    // groupUserList();//등록사용자 리스트
                                });
    
                                $('#jstree').on('select_node.jstree', function (e, data) { //그룹 선택 변경시 실행
                                    var nodeId = data.node.id;
                                    var nodeText = data.node.text;
                                    var nodeInfo = data.node.original.info;
                                    $("#text").val(nodeText);
                                    $("#info").val(nodeInfo);
                                    $("#id").val(nodeId);
                                    page_current=1;//페이지 초기화
                                    listGroupUser();//등록사용자 리스트
                                    console.log("선택된노드ID: "+nodeId);
    
                                });

                                $('#jstree').on('move_node.jstree', function (e, data) {

                                var param={};
                                // 노드 이동 시 처리할 로직
                                var movedNodeId = data.node.id; //선택 아이디
                                var parentId = data.node.parent; //이동된 위치의 부모 노드 아이디

                                // 이동된 노드 정보를 콘솔에 로그로 출력
                                console.log("Node moved:", movedNodeId);
                                console.log("New parent:", parentId);

                                param = {
                                    group_id: movedNodeId,
                                    group_par_id: parentId
                                }

                                // 노드이동 처리
                                $.ajax({
                                    url: "/group/moveNode",
                                    type: "POST",
                                    dataType: "json",
                                    contentType: "application/json",
                                    data: JSON.stringify(param),
                                    success: function (result) {
                                        // alert("통신성공");
                                        console.log(result);

                                        

                                    },
                                    error: function () {
                                        alert("통신에러");
                                    }
                                });
                                });
    
                                
                            } else {
                                $("#jstree").text("그룹이 없습니다");
                                $("#updateBtn").hide();
                            }
                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }


                //그룹 등록모달창 구성
                function editGroup() {
                    $("#groupPar").empty();
                    //현재 선택된 jstree의 정보를 가져와줌
                    var selected_node = $("#jstree").jstree("get_selected", true)[0];
                    console.log(selected_node);
                    console.log(selected_node.id);
                    if(selected_node.id != 'jstree') {
                        $("#groupPar").append($('<option>').text(selected_node.text).attr('value', selected_node.id));
                    }
                    $("#groupPar").append($('<option>').text('최상위').attr('value', '#'));


                }

                // function insert(type) {
                //     var param = {};
                //     var url = "";

                //     if (type == 'A') { //저장
                //         url = "/group/insert";
                //         var groupPar = $("#groupPar").val();
                //         var text = $("#modal #text").val().trim();
                //         var info = $("#modal #info").val().trim();


                //         if (!strCheck(text, "comm", 10, "제목")) return;
                //         if (!strCheck(info, "comm", 300, "설명")) return;

                //         param = {
                //             group_name: text,
                //             group_info: info,
                //             group_par_id: groupPar
                //         }

                //     } else if (type == 'B') { //수정
                //         url = "/group/update";
                //         var id = $("#id").val();
                //         var text = $("#content #text").val().trim();
                //         var info = $("#content #info").val().trim();

                //         if (!strCheck(text, "comm", 10, "제목")) return;
                //         if (!strCheck(info, "comm", 300, "설명")) return;

                //         param = {
                //             group_name: text,
                //             group_info: info,
                //             group_id: id
                //         }
                //     }

                //     // console.log(param);
                //     $.ajax({
                //         url: url,
                //         type: "POST",
                //         dataType: "json",
                //         contentType: "application/json",
                //         data: JSON.stringify(param),
                //         success: function (result) {
                //             // alert("통신성공");
                //             // console.log(result);

                //             if (type == 'A') {
                //                 alert("저장 완료되었습니다");
                //             } else if (type == 'B') {
                //                 alert("수정 완료되었습니다");
                //             }

                //             //현재 선택된 jstree의 정보를 가져와줌
                //             var selected_node = $("#jstree").jstree("get_selected", true)[0];

                //             list(selected_node.id);
                //             $("#staticBackdrop").modal('hide');

                //         },
                //         error: function () {
                //             alert("통신에러");
                //         }
                //     });
                // }

                function insert() {
                    var param = {};
                    var url = "";

                    var groupPar = $("#groupPar").val();
                    var text = $("#modal #text").val().trim();
                    var info = $("#modal #info").val().trim();


                    if (!strCheck(text, "comm", 10, "제목")) return;
                    if (!strCheck(info, "comm", 300, "설명")) return;

                    param = {
                        group_name: text,
                        group_info: info,
                        group_par_id: groupPar
                    }
                    

                    // console.log(param);
                    $.ajax({
                        url: "/group/insert",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            // console.log(result);

                            
                            if(result.resultGroup == 1 ) {
                                alert("저장 완료되었습니다");
                            }else {
                                alert("그룹 DB 에러")
                            }

                            //현재 선택된 jstree의 정보를 가져와줌
                            var selected_node = $("#jstree").jstree("get_selected", true)[0];

                            list(selected_node.id);
                            $("#staticBackdrop").modal('hide');

                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }

                function update() {
                    var param = {};
                    var url = "";
                
                    url = "/group/update";
                    var id = $("#id").val();
                    var text = $("#content #text").val().trim();
                    var info = $("#content #info").val().trim();

                    if (!strCheck(text, "comm", 10, "제목")) return;
                    if (!strCheck(info, "comm", 300, "설명")) return;

                    param = {
                        group_name: text,
                        group_info: info,
                        group_id: id
                    }

                    // console.log(param);
                    $.ajax({
                        url: "/group/update",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            // console.log(result);

                            if(result.resultGroup == 1 ) {
                                alert("수정 완료되었습니다");
                            }else {
                                alert("그룹 DB 에러")
                            }

                            //현재 선택된 jstree의 정보를 가져와줌
                            var selected_node = $("#jstree").jstree("get_selected", true)[0];

                            list(selected_node.id);
                            $("#staticBackdrop").modal('hide');

                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }

                

                //모달창 닫히면 실행
                $("#staticBackdrop").on('hide.bs.modal', function (e) {
                    //모달 내용 초기화
                    $("#groupPar").val("");
                    $("#modal #text").val("");
                    $("#modal #info").val("");
                });


                
                //그룹 삭제
                function del() {

                    //경고문구
                    var bool = confirm("삭제 하시겠습니까?");
                    if (!bool) {
                        return;
                    }

                    var param = {};

                    //현재 선택된 jstree의 정보를 가져와줌
                    var selected_node = $("#jstree").jstree("get_selected", true)[0];
                    console.log("선택 Node:", selected_node)

                    // 선택된 노드의 ID 가져오기
                    var selected_node_id = selected_node.id;

                    // 선택된 노드의 자식 노드 DOM 요소 가져오기
                    var child_nodes = $("#jstree").jstree("get_children_dom", selected_node_id);

                    //자식그룹 있으면 return
                    if(child_nodes.length > 0) {
                        alert("하위 그룹이 있습니다");
                        return
                    }
                    //등록된 사용자 있으면 return
                    if(userLength > 0) {
                        alert("그룹에 등록된 사용자가 있습니다");
                        return
                    }
                    

                    param = {
                        group_id: selected_node.id
                    };

                    $.ajax({
                        url: "/group/del",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            // console.log(result);

                            if(result.resultGroup == 1 ) {
                                alert("삭제 완료되었습니다");
                            }else {
                                alert("그룹 DB 에러")
                            }

                            list();

                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });

                }

                

                //일반, 사용자 변경
                function changeBoard(type) {

                    if (type == 1) {
                        $("#userCon").css("display", "none");
                        $("#normalCon").css("display", "block");
                        $("#norBtn").removeClass();
                        $("#norBtn").addClass("btn btn-success");
                        $("#userBtn").removeClass();
                        $("#userBtn").addClass("btn btn-outline-dark");
                    } else {
                        $("#normalCon").css("display", "none");
                        $("#userCon").css("display", "block");
                        $("#userBtn").removeClass();
                        $("#userBtn").addClass("btn btn-success");
                        $("#norBtn").removeClass();
                        $("#norBtn").addClass("btn btn-outline-dark");
                    }

                }


                //그룹에 등록된 유저 리스트
                function listGroupUser(search) {
                    //총몇개출력 초기화
                    $("#total").empty();

                    var param = {};


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

                    //현재 선택된 jstree의 정보를 가져와줌
                    var selected_node = $("#jstree").jstree("get_selected", true)[0];
                    param.group_id = selected_node.id;

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
                                            "<td class='col-4')>" + result.data[i].user_name + "</td>" +
                                            "<td class='col-4')>" +
                                            result.data[i].user_login_id +
                                            "</td>" +
                                            "<td class='col-4')>" +
                                            "<ion-icon style='cursor: pointer;' name='trash-outline' onclick='delGroupUser(" + result.data[i].user_id + ")'></ion-icon>"
                                        "</td>" +
                                            "</tr>";

                                        $("#tab tbody").append(tmp_tr);
                                    }
                                }

                                
                            } else { //검색결과 없을경우
                                var tmp_tr = "<tr>" +
                                    "<td colspan='6'  >유저가 존재하지 않습니다</td>" +
                                    "</tr>";
                                $("#tab tbody").append(tmp_tr);

                                //페이징 초기화
                                $("#pag").empty();
                            }

                            //등록된 인원 수 저장(삭제시 사용)
                            userLength=result.data.length;
                            
                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }

                //검색 초기화
                function clearSearch() {
                    page_current = 1;
                    searchBool = false;
                    $("#searchType").val("user_name");
                    $("#search").val("");
                    listGroupUser();
                }

                //페이지 이동
                function changePage(number, totalPage) {
                    if (number == 0 || number < 0) {
                        alert("첫번째 페이지입니다");
                        return;
                    }

                    if (number > totalPage) {
                        alert("마지막 페이지입니다");
                        return;
                    }

                    page_current = number;
                    listGroupUser();
                }

                //등록된 그룹 유저 삭제
                function delGroupUser(id) {
                    var bool = confirm("삭제 하시겠습니까?");

                    if (!bool) {
                        return;
                    }

                    //현재 선택된 jstree의 정보를 가져와줌
                    var selected_node = $("#jstree").jstree("get_selected", true)[0];

                    var param = {};

                    param = {
                        group_id: selected_node.id,
                        user_id: id
                    }

                    $.ajax({
                        url: "/group/groupUserDel",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            // console.log(result);

                            if(result.resultGroup != 1 ) {
                                alert("그룹 DB 에러")
                            }
                            

                            page_current = 1;
                            listGroupUser();

                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }

                //등록할 유저 리스트
                function listUser(search) {
                    var param = {};

                    //테이블 초기화
                    $("#userTab tbody").empty();

                    var searchInput = "";
                    var searchType = $("#userRegis #searchType").val();

                    if (search) {
                        searchInput = $("#userRegis #search").val();
                    }

                    // console.log("groupUserIdArr");
                    // console.log(groupUserIdArr);

                    //현재 선택된 jstree의 정보를 가져와줌
                    var selected_node = $("#jstree").jstree("get_selected", true)[0];

                    param = {
                        group_id: selected_node.id,
                        search: searchInput,
                        searchType: searchType
                    }

                    $.ajax({
                        url: "/group/regisUserList",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");

                            console.log("유저 목록");
                            console.log(result);

                            if (result.data.length > 0) {

                                if (result.data.length > 0) {
                                    for (var i = 0; i < result.data.length; i++) {
                                        var tmp_tr = "<tr>" +
                                            "<td class='col-2')>" +
                                            "<input class='form-check-input' type='checkbox' value=" + result.data[i].user_id + " >" +
                                            "</td>" +
                                            "<td class='col-5')>" +
                                            result.data[i].user_login_id +
                                            "</td>" +
                                            "<td class='col-5')>" +
                                            result.data[i].user_name +
                                            "</td>" +
                                            "</tr>";

                                        $("#userTab tbody").append(tmp_tr);
                                    }
                                }
                            } else { //검색결과 없을경우
                                var tmp_tr = "<tr>" +
                                    "<td colspan='6' scope='row' data-bs-toggle='modal' data-bs-target='#staticBackdrop' >유저가 존재하지 않습니다</td>" +
                                    "</tr>";
                                $("#userTab tbody").append(tmp_tr);


                            }
                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });

                }

                //유저 등록할 리스트에서 체크박스 전체선택 기능
                $('#checkboxAll').click(function () {
                    // 체크박스 전체 선택 상태 가져오기
                    var isChecked = $(this).prop('checked');

                    // tbody 내의 모든 체크박스를 체크 해제
                    $('#userTab tbody input[type="checkbox"]').prop('checked', isChecked);
                });

                //그룹 유저 등록
                function insertGroupUser() {
                    var bool = confirm("등록 하시겠습니까?");

                    if (!bool) {
                        return;
                    }

                    var param = {};

                    var checkedId = [];

                    $('#userTab tbody input[type="checkbox"]:checked').each(function () {
                        checkedId.push($(this).val());
                    });

                    // console.log(checkedId);

                    //현재 선택된 jstree의 정보를 가져와줌
                    var selected_node = $("#jstree").jstree("get_selected", true)[0];

                    param = {
                        idArr: checkedId,
                        group_id: selected_node.id

                    }

                    $.ajax({
                        url: "/group/groupUserInsert",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");

                            if(result.resultGroup != 1 ) {
                                alert("그룹 DB 에러")
                            }

                            listGroupUser();
                            $("#userRegisModal").modal('hide');

                        },
                        error: function () {
                            alert("통신에러");
                        }
                    });
                }

                //모달창 닫히면 실행
                $("#userRegisModal").on('hide.bs.modal', function (e) {
                    $('#checkboxAll').prop('checked', false);
                    $('#userRegis #search').val("");
                });



            </script>


    </body>

    </html>