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
                                        <th class="col-2" scope="col">권한</th>
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
                                        <input class="form-check-input ms-4" type="checkbox" role="switch" onchange="userSwitch()">
                                    </div>
                                    <div class="col-1 pt-2 btnDel">
                                        <button type="button" class="btn btn-info edit" data-bs-toggle="modal"
                                        data-bs-target="#modalUpsert" onclick="modalChange('update')">수정</button>
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
                                    <div class="col-8 text-start px-4 pt-3" id="loginId">
                                        <input class='w-30' type='text'>
                                        <button class="btn btn-danger checkBtn" id="idCheck" onclick="checkDuplicate($(this))">중복체크</button>
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
                                        <input type='password' class='w-80 d-block m-1 pwCheck' id='pwCheck1' placeholder='비밀번호'>
                                        <input type='password' class='w-80 m-1 pwCheck' id='pwCheck2' placeholder='비밀번호 확인'>
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
                                        <button class="btn btn-danger checkBtn" id="nicknameCheck" onclick="checkDuplicate($(this))">중복체크</button>
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
                                            onclick="upsert('insert')">등록</button>
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
                    list();
                }

                function list(search) {

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
                                        "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>" + result.data[i].user_nickname + "</td>" ;
                                    if (result.data[i].user_auth == 0 ) {
                                        listUser += "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>관리자</td>";
                                    } else {
                                        listUser += "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick=get(\"" + result.data[i].user_id + "\")>일반유저</td>";
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
                        url: "/user/get",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            console.log(result);
                            const id = result.data.user_id;
                            const loginId= result.data.user_login_id;
                            const name = result.data.user_name;
                            const nickname = result.data.user_nickname;
                            const mail = result.data.user_mail;
                            const tel = result.data.user_tel;
                            const auth = result.data.user_auth; 
                            const use = result.data.user_use;

                            $("#modalGet #getId").val(id);
                            $("#modalGet #getLoginId").text(loginId);
                            $("#modalGet #getName").text(name);
                            $("#modalGet #getNickname").text(nickname);
                            $("#modalGet #getMail").text(mail);
                            $("#modalGet #getTel").text(tel);
                            $("#modalGet #getAuth").text(auth == 0 ? "관리자" : "일반유저");
                            $("#modalGet #use input").prop("checked", use == 'y' ? false : true);

                        },
                        error: function (error) {
                            alert("서버에러" + error.status + " " + error.responseText);
                            //모달창 닫기
                            $("#modalGet").modal('hide');
                            list();
                        }
                    });
                }

                //계정 잠금 스위치
                function userSwitch() {

                    let param = {};

                    param = {
                        user_id: $("#modalGet #getId").val(),
                        value: $("#modalGet #use input").prop("checked") ? 0 : 1
                    }

                    console.log(param);

                    $.ajax({
                        url: "/user/useChange",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            console.log(result);

                        },
                        error: function (error) {
                            alert("서버에러" + error.status + " " + error.responseText);
                        }
                    });

                }

                //모달 등록, 수정 양식변경
                function modalChange(type) {
                    //초기화
                    $("#modalUpsert #loginId button").text("중복체크").removeClass().addClass("btn btn-danger checkBtn").attr("onclick", "checkDuplicate($(this));");
                    $("#modalUpsert #nickname button").text("중복체크").removeClass().addClass("btn btn-danger checkBtn").attr("onclick", "checkDuplicate($(this));");
                    $("#modalUpsert #loginId input").prop("disabled", false);
                    $("#modalUpsert #nickname input").prop("disabled", false);
                    $("#modalUpsert #id").val("");
                    $("#modalUpsert #loginId input").val("");
                    $("#modalUpsert #pw input").val("");
                    $("#modalUpsert #name input").val("");
                    $("#modalUpsert #nickname input").val("");
                    $("#modalUpsert #tel input").val("");
                    $("#modalUpsert #mail input").val("");
                    $("#modalUpsert #auth").prop('selectedIndex', 0);
                    $("#modalUpsert #pwCheckText").text("문자+숫자+특수문자 6자리 이상입니다").css('color', 'black').removeClass();

                    if(type == 'update') {
                        $("#modalUpsert #id").val($("#modalGet #getId").val());
                        $("#modalUpsert #loginId input").val($("#modalGet #getLoginId").text());
                        $("#modalUpsert #name input").val($("#modalGet #getName").text());
                        $("#modalUpsert #nickname input").val($("#modalGet #getNickname").text());
                        $("#modalUpsert #tel input").val($("#modalGet #getTel").text());
                        $("#modalUpsert #mail input").val($("#modalGet #getMail").text());
                        $("#modalUpsert #auth").val($("#modalGet #getAuth").text() == '관리자' ? 0 : 1);
                    }

                    $('.pwCheck').on('input', function () {
                        // console.log($(this).val());
                        if ($('#pwCheck1').val() != $('#pwCheck2').val()) {
                            $("#pwCheckText").text("비밀번호 불일치").css('color', 'red');
                        } else {
                            $("#pwCheckText").text("비밀번호 일치").css('color', 'green');
                        }

                    });

                }


                //등록, 수정
                function upsert(type) {
                    let param = {};
                    let url = "";

                    //각각 값 변수로 저장
                    const id = $("#modalUpsert #id").val();
                    const loginId = $("#modalUpsert #loginId input").val();
                    const pw = $("#modalUpsert #pw input").val();
                    const name = $("#modalUpsert #name input").val();
                    const nickname = $("#modalUpsert #nickname input").val();
                    const tel = $("#modalUpsert #tel input").val();
                    const mail = $("#modalUpsert #mail input").val();
                    const auth = $("#modalUpsert #auth").val();

                    if($("#loginId button").text() == "중복체크") {
                        alert("아이디 중복체크를 해주세요");
                        return;
                    }

                    if($("#nickname button").text() == "중복체크") {
                        alert("닉네임 중복체크를 해주세요");
                        return;
                    }

                    if ($('#pwCheck1').val() != $('#pwCheck2').val()) {
                        alert("비밀번호가 일치하지 않습니다");
                        return;
                    }

                    if (!/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{4,16}$/.test(pw)) {
                        alert("비밀번호 4~16글자, 영문+숫자+특수문자 사용");
                        return;
                    }

                    if (!/^[A-Za-z가-힣]{1,16}$/.test(name)) {
                        alert("이름은 한글, 영어만 사용가능합니다(특수기호, 공백사용불가");
                        return;
                    }

                    
                    if (!/^01(?:0|1|[6-9])-(?:\d{4})-\d{4}$/.test(tel)) {
                        alert("핸드폰 번호에 문제가 있습니다");
                        return;
                    }

                    if (!/^[\w.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(mail)) {
                        alert("이메일 주소에 문제가 있습니다");
                        return;
                    }

                    if(type == "insert") {
                        url = "/user/insert";
                    }else if(type == "update") {
                        url = "/user/update";
                    }  

                    param = {
                        user_id: id,
                        user_login_id: loginId,
                        user_pw: pw,
                        user_name: name,
                        user_nickname: nickname,
                        user_tel: tel,
                        user_mail: mail,
                        user_auth: auth
                    }

                     

                    $.ajax({
                        url: url,
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            alert("통신성공");
                            // console.log(result);
                            $("#modalUpsert").modal('hide');
                            list();

                        },
                        error: function (error) {
                            alert("서버에러" + error.status + " " + error.responseText);
                        }
                    });

                }

                //아이디 중복체크
                function checkDuplicate(btn) {
                    let param = {};

                    const selectDiv = btn.closest("div"); //버튼이 속한 div

                    const inputValue = selectDiv.find("input").val(); //input값

                    const id = selectDiv.attr("id");//버튼이 속한 div의 id값
                    // console.log(inputValue);
                    // console.log(id);

                    if(id == "loginId") {
                        if(!/^[A-Za-z0-9]{1,8}$/.test(inputValue)) {
                            alert("아이디는 영문, 숫자 1~8자리로 입력해주세요");
                            return;
                        }
                    } else {
                        if(!/^[가-힣A-Za-z]{1,8}$/.test(inputValue)) {
                            alert("닉네임은 한글, 영문 1~8자리로 입력해주세요");
                            return;
                        }
                    }

                    param = {
                        type: id == "loginId" ? "user_login_id" : "user_nickname",
                        value: inputValue
                    }
                    

                    $.ajax({
                        url: "/user/checkDuplicate",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (result) {
                            // alert("통신성공");
                            console.log(result);
                            if(result.cnt == 0) {
                                //체크완료 처리
                                selectDiv.find("button").text("체크해제").removeClass().addClass("btn btn-success").attr("onclick", "clearCheckDuplicate($(this));");
                                selectDiv.find("input").prop("disabled", true);
                            } else {
                                alert("중복된 아이디입니다");
                            }
                        },
                        error: function (error) {
                            alert("서버에러" + error.status + " " + error.responseText);
                        }
                    });

                }

                //체크해제
                function clearCheckDuplicate(btn) {
                    // alert("체크해제");
                    const selectDiv = btn.closest("div"); //버튼이 속한 div

                    const inputValue = selectDiv.find("input").val(); //input값

                    const id = selectDiv.attr("id");//버튼이 속한 div의 id값
                    // console.log(inputValue);
                    // console.log(id);

                    selectDiv.find("button").text("중복체크").removeClass().addClass("btn btn-danger checkBtn").attr("onclick", "checkDuplicate($(this));");
                    selectDiv.find("input").prop("disabled", false);

                }


            </script>

    </body>

    </html>