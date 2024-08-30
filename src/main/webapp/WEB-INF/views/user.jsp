<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>

        <%@include file="include/link_js.jsp" %>
            <link rel="stylesheet" href="/css/user.css">
    </head>

    <body>
        <%@include file="include/header.jsp" %>
            <div class="container text-center">
                <div class="row">
                    <div class="col">
                        <h2>유저 관리</h2>
                    </div>
                </div>
            </div>

            <div class="p-5 mb-4 bg-body-tertiary rounded-3" id="main">
                <div class="container text-center">
                    <div class="row">
                        <div class="col px-5">
                            <div class="d-flex" role="search">
                                <select id="searchType" onchange="changeLimitType()">
                                    <option value="user_name">이름</option>
                                    <option value="user_login_id">아이디</option>
                                </select>
                                <input class="form-control" type="search" placeholder="검색" aria-label="Search"
                                    id="search">
                                <button class="btn btn-outline-success col-1" onclick="listUser(true);">검색</button>
                                <button class="btn btn-outline-success col-1" onclick="resetSearch()">초기화</button>
                                <div>
                                </div>
                                <div class="col-lg-2">
                                    <select id="limitPage" onchange="changeLimitType()">
                                        <option value="5">5개씩 보기</option>
                                        <option value="10">10개씩 보기</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="container-fluid py-5 text-start">
                            <div id="total"></div>
                            <table class="table text-center" id="tab">
                                <thead>
                                    <tr>
                                        <th class="col-1" scope="col">번호</th>
                                        <th class="col-3" scope="col">이름</th>
                                        <th class="col-3" scope="col">ID</th>
                                        <th class="col-3" scope="col">닉네임</th>
                                        <th class="col-2" scope="col">잠금해제</th>
                                    </tr>
                                </thead>
                                <tbody>

                                </tbody>
                            </table>
                        </div>

                        <div class="container text-center">
                            <div class="row">
                                <div class="col">
                                    <div style="display: flex; justify-content: center;" id="paging">
                                        <!-- <nav aria-label="Page navigation example">
                                <ul class="pagination">
                                    <li class="page-item">
                                        <a class="page-link" href="#" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav> -->
                                    </div>
                                </div>

                            </div>
                            <div class="container">
                                <div class="row">
                                    <div class="col text-end">
                                        <button type="button" class="btn btn-secondary" data-bs-toggle="modal"
                                            data-bs-target="#modalUpsert" onclick="modalChange('insert')">유저 등록</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 상세모달 -->
            <div class="modal fade" id="modalGet" data-bs-backdrop="static" data-bs-keyboard="false"
                tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">

                        <div class="modal-body">
                            <div class="container text-center border">
                                <div class="row">

                                    <div class="col-2 pt-3">
                                        <h3>아이디</h3>
                                    </div>
                                    <div class="col-8 text-start px-4 pt-3" id="getLoginId">
                                        admin
                                    </div>

                                    <div class="col-1">
                                        <input type='hidden' id="getId">
                                    </div>

                                    <div class="col-1">
                                        <!-- <button type="button" class="btn btn-dark" data-bs-dismiss="modal" onclick="closeModal()">닫기</button> -->
                                        <button type="button" class="btn btn-dark"
                                            data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>이름</h3>
                                    </div>
                                    <div class="col-10 text-start p-4 " id="getName">
                                        김수진
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>닉네임</h3>
                                    </div>
                                    <div class="col-10 text-start p-4 " id="getNickname">
                                        딸기
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>핸드폰번호</h3>
                                    </div>
                                    <div class="col-10 text-start p-4" id="getTel">
                                        010-9335-6987
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>이메일</h3>
                                    </div>
                                    <div class="col-10 text-start p-4" id="getMail">
                                        sujin_78@naver.com
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>권한</h3>
                                    </div>
                                    <div class="col-3 text-start p-4" id="getAuth">
                                        일반유저
                                    </div>
                                    <div class="col-2 pt-3 del">
                                        <h3>잠금해제</h3>
                                    </div>
                                    <div class="col-3 text-start p-4 form-switch del" id="use">
                                        <input class="form-check-input ms-4" type="checkbox" role="switch"
                                            id="flexSwitchCheckDefault">
                                    </div>
                                    <div class="col-1 pt-2 btnDel">
                                        <button type="button" class="btn btn-info edit"
                                            onclick="editUpdate()">수정</button>
                                    </div>
                                    <div id="chBtn" class="col-1 pt-2 btnDel">
                                        <button type="button" class="btn btn-warning"
                                            onclick="del()">삭제</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 등록 수정 모달 -->
            <div class="modal fade" id="modalUpsert" data-bs-backdrop="static" data-bs-keyboard="false"
                tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">

                        <div class="modal-body">
                            <div class="container text-center border">
                                <div class="row">

                                    <div class="col-2 pt-3">
                                        <h3>아이디</h3>
                                    </div>
                                    <div class="col-8 text-start px-4 pt-3" id="login_id">
                                        <input class='w-30' type='text'>
                                        <button class="btn btn-danger" id="idCheck" onclick="checkDuplicate('id');">중복체크</button>
                                    </div>

                                    <div class="col-1">
                                        <input type='hidden' id="id">
                                    </div>

                                    <div class="col-1">
                                        <button type="button" class="btn btn-dark"
                                            data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3 pw">
                                        <h3>비밀번호</h3>
                                    </div>
                                    <div class="col-10 text-start px-4 pt-3" id="pw">
                                        <input type='password' class='w-80 d-block m-1' id='pwCheck1' placeholder='비밀번호'>
                                        <input type='password' class='w-80 m-1' id='pwCheck2' placeholder='비밀번호 확인'>
                                        <div id="pwCheckText">문자+숫자+특수문자 6자리 이상입니다</div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3 ">
                                        <h3>이름</h3>
                                    </div>
                                    <div class="col-10 text-start p-4 " id="name">
                                        <input class='w-70' type='text'>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>닉네임</h3>
                                    </div>
                                    <div class="col-10 text-start p-4 " id="nickname">
                                        <input class='w-70' type='text'>
                                        <button class="btn btn-danger" id="nicknameCheck" onclick="checkDuplicate('nickname');">중복체크</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>핸드폰번호</h3>
                                    </div>
                                    <div class="col-10 text-start p-4" id="tel">
                                        <input class='w-100' type='text' placeholder="010-1234-1234 양식으로 써주세요">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>이메일</h3>
                                    </div>
                                    <div class="col-10 text-start p-4" id="mail">
                                        <input class='w-100' type='text'>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>권한</h3>
                                    </div>
                                    <div class="col-9 text-start p-4">
                                        <select class="form-select form-select-sm w-4"
                                            aria-label="Small select example" id="auth">
                                            <option value="1" selected>일반유저</option>
                                            <option value="0">관리자</option>
                                        </select>
                                    </div>
                                    <div class="col-1 pt-2 btnDel">
                                        <button type="button" class="btn btn-info edit"
                                            onclick="insertUser()">등록</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>



            <script>
                //현재 페이지
                let pageCurrent = 1;
                //검색 저장
                let searchSelect = ""; //검색어

                // 리스트 요청
                window.onload = function () {
                    listUser();
                }

                function listUser(search) {

                    //테이블 초기화
                    $("#tab tbody").empty();
                    //페이징 초기화
                    $("#paging").empty();

                    let param = {};

                     //검색으로 리스트 불렀는지 확인
                    if(search) {
                        pageCurrent = 1; //검색누를경우 1페이지로 이동
                        searchSelect = $("#search").val(); //검색어 저장
                    }

                    //몇개씩 볼건지 선택
                    const limitPage = $("#limitPage").val();

                    param = {
                        offset: limitPage * (pageCurrent - 1), //현재 보고있는 페이지
                        listSize: limitPage, // 가져올 데이터의 개수
                        searchType: $("#searchType").val(),
                        search: searchSelect
                    };

                    $.ajax({
                        url: "/user/list",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            console.log(result);
                            
                            if (result.data.length > 0) {
                                // alert("통신성공");

                                var totalPage = Math.ceil(result.total / limitPage); //보여지는 총페이지
                                paging(pageCurrent, totalPage); //페이징 함수

                                //총 갯수 출력
                                $("#total").text("총:" + result.total + "개")
                                //리스트 출력
                                for (let i = 0; i < result.data.length; i++) {
                                    const index = i + 1 + param.offset;
                                    let listUser = "<tr>" +
                                        "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>" + index + "</td>" +
                                        "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>" + result.data[i].user_name + "</td>" +
                                        "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>" + result.data[i].user_login_id + "</td>" +
                                        "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>" + result.data[i].user_nickname + "</td>";
                                    if (result.data[i].user_use == 'y') {
                                        listUser += "<td class='col-2 form-switch' scope='row'><input data-value=" + result.data[i].user_id + " class='form-check-input' type='checkbox' role='switch' id='flexSwitchCheckDefault' ></td>" +
                                            "</tr>";
                                    } else {
                                        listUser += "<td class='col-2 form-switch' scope='row'><input data-value=" + result.data[i].user_id + " class='form-check-input' type='checkbox' role='switch' id='flexSwitchCheckDefault' checked></td>" +
                                            "</tr>";
                                    }
                                    $("#tab tbody").append(listUser);
                                }

                            } else {
                                const msg = "<tr>" +
                                    "<td colspan='6' >유저가 존재하지 않습니다</td>" +
                                    "</tr>";
                                $("#tab tbody").append(msg);

                            }
                            
                        },
                        error: function (error) {
                            alert("서버에러" + error.status + " " + error.responseText);
                        }
                    });

                }

                 //페이지 이동(보고싶은 페이지 ,총페이지)
                function changePage(number, totalPage) {
                    if (number == 0 || number < 0) {
                        alert("첫번째 페이지입니다");
                        return;
                    }

                    if (number > totalPage) {
                        alert("마지막 페이지입니다");
                        return;
                    }
                    $("#search").val(searchSelect);
                    pageCurrent = number;
                    listUser();
                }

                // 5, 10개 씩 보기 변경
                function changeLimitType() {
                    $("#search").val("");
                    searchSelect="";
                    pageCurrent = 1;
                    listUser();
                }

                //검색 초기화
                function resetSearch() {
                    pageCurrent = 1;
                    $("#searchType").prop('selectedIndex', 0);
                    $("#limitPage").prop('selectedIndex', 0);
                    $("#search").val("");
                    searchTypeSelect="";
                    searchSelect="";
                    listUser();
                }

                function get(id) {

                    let param = {};

                    param = {
                        user_id: id
                    };

                    $.ajax({
                        url: "/board/get",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            console.log(result);
                            // const id = result.data.board_id;
                            // const title = result.data.board_title;
                            // const content = result.data.board_content;
                            // const view = result.data.board_view;
                            // const userId = result.data.user_id;
                            // const userNickname = result.data.user_nickname;

                            // $("#modalGet #getId").val(id);
                            // $("#modalGet #getTitle").text(title);
                            // $("#modalGet #getView").text(view);
                            // $("#modalGet #getUserId").val(userId);
                            // $("#modalGet #getNickname").text(userNickname);

                            // // 읽기전용 토스트 에디터
                            // editorCreate(true, content, 'Get'); //읽기전용, 내용
                            

                            // const sessionUserId = "<%= id %>";
                            // const sessionAuth = "<%= auth %>";
                            // // console.log(userId + " " +sessionUserId);
                            // //수정 삭제 관리 .. 관리자는 모두 가능
                            // if (userId != sessionUserId && sessionAuth != 0) {
                            //     $("#modalGet .checkUser").hide();
                            // } else {
                            //     $("#modalGet .checkUser").show();
                            // }

                            // //파일 리스트
                            // $("#modalGet #getFiles").empty(); //초기화
                            // $.each(result.files, function (index, value) {
                            //     const file = "<div class='getFile' data-value='" + value.file_id + "." + value.file_extension+ "' style='cursor:pointer; display: flex; align-items: center;'>" + 
                            //                     "<span onclick=\"location.href='/board/fileDown/" + value.file_id + "." + value.file_extension + "/" + value.file_name +"'\">" + 
                            //                     value.file_name + "." + value.file_extension + 
                            //                     "</span>" +
                            //                     "<button class='deleteFile' style='display: none;'>삭제</button>" +
                            //             "</div>";
                            //     $("#modalGet #getFiles").append(file);
                            // });

                            

                        },
                        error: function (error) {
                            alert("서버에러" + error.status + " " + error.responseText);
                            //모달창 닫기
                            $("#modalGet").modal('hide');
                            list();
                        }
                    });
                    }

                


            </script>

    </body>

    </html>