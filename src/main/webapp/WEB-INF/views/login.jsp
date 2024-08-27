<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <%@include file="include/link_js.jsp" %>
                <link rel="stylesheet" href="/css/login.css">
                <style>

                </style>

        </head>

        <body>
                <div class="container mt-5">
                    <main class="form-signin w-25 mx-auto">
                        <form method="post" id="login_form" action="/loginCheck" onsubmit="return checkForm()">
                            <h1 class="h3 mb-3 fw-normal">로그인</h1>

                            <div class="form-floating">
                                <input type="text" class="form-control" id="id" value="sj" name="id">
                                <label for="floatingInput">아이디</label>
                            </div>
                            <div class="form-floating">
                                <input type="password" class="form-control" id="pw" value="sujin1!" name="pw">
                                <label for="floatingPassword">비밀번호</label>
                            </div>

                            <button class="btn btn-primary w-100 py-2" type="submit">로그인</button>
                        </form>
                        <button class="btn btn-secondary w-100 py-2 mt-2" type="submit" data-bs-toggle="modal"
                            data-bs-target="#staticBackdrop">회원가입</button>
                        <div class="text-center">
                            <span>관리자의 승인 후 로그인 가능</span>
                        </div>
                    </main>
                </div>

                <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false"
                    tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-custom">
                        <div class="modal-content">

                            <div class="modal-body">
                                <div class="container text-center" id="modal">
                                    <div class="row">

                                        <div class="col-2 pt-3">
                                            <h3>아이디</h3>
                                        </div>
                                        <div class="col-8 text-start px-4 pt-3 in-title" id="login_id">
                                            <input type="text" class="w-80">
                                            <button id="idCh" onclick="checkId();" class="btn btn-danger">중복체크</button>
                                        </div>

                                        <div class="col-1 editDel">
                                            <div id="id" style="display: none;"></div>
                                            <div id="flag" style="display: none;"></div>
                                        </div>

                                        <div class="col-1">
                                            <!-- <button type="button" class="btn btn-dark" data-bs-dismiss="modal" onclick="close_modal()">닫기</button> -->
                                            <button type="button" class="btn btn-dark"
                                                data-bs-dismiss="modal">닫기</button>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-2 pt-3 pw">
                                            <h3>비밀번호</h3>
                                        </div>
                                        <div class="col-10 text-start px-4 pt-3 in-title pw" id="pw">
                                            <input type="password" class="w-80 d-block m-1" id="pw_ch1"
                                                placeholder="비밀번호"><input type="password" class="w-80 m-1" id="pw_ch2"
                                                placeholder="비밀번호 확인">
                                            <p id="pw_comp">비밀번호 4자 이상 16자 이하, 영문, 숫자, 특수문자 사용</p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-2 pt-3">
                                            <h3>이름</h3>
                                        </div>
                                        <div class="col-10 text-start p-4 " id="name">
                                            <input type="text" class="w-100">
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-2 pt-3">
                                            <h3>핸드폰번호</h3>
                                        </div>
                                        <div class="col-10 text-start p-4" id="tel">
                                            <input type="text" class="w-100" placeholder="010-1234-1234 형식으로 써주세요">
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-2 pt-3">
                                            <h3>이메일</h3>
                                        </div>
                                        <div class="col-8 text-start p-4" id="mail">
                                            <input type="text" class="w-100">
                                        </div>
                                        <div class="col-2">
                                            <button onclick="insert();" class="btn btn-info">가입</button>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>


        </body>

        <script>
            //모달창 양식 저장
            var form;

            window.onload = function () {
                form = $("#staticBackdrop").html();
                checkPw();
            }

            //모달창 닫히면 실행
            $('#staticBackdrop').on('hidden.bs.modal', function () {
                $("#staticBackdrop").empty();
                $("#staticBackdrop").append(form);
                checkPw();
            })

            function checkForm() {
                var id = $("#id").val();
                var pw = $("#pw").val();
                if (!strCheck(id, "check", 0, "id")) {
                    $("#id").focus();
                    return false;
                }
                if (!strCheck(pw, "check", 0, "pw")) {
                    $("#pw").focus();
                    return false;
                }

                if (!strCheck(id, "id")) {
                    $("#id").focus();
                    return false;
                }
                if (!strCheck(pw, "pw")) {
                    $("#pw").focus();
                    return false;
                }
            }

            //msg 있을경우 띄워주기
            if ('${msg}' != "") {
                alert('${msg}');
            }

            //아이디 중복확인
            function checkId() {
                var login_id = $("#login_id input").val();
                // alert(login_id);
                if (!strCheck(login_id, "id")) {
                    return;
                }

                var param = {
                    user_login_id: login_id
                }

                $.ajax({
                    url: "/user/idCheck",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(param),
                    success: function (result) {
                        // alert("통신성공");
                        // console.log(result.cnt);

                        if (!result.cnt > 0) {
                            $("#idCh").attr("id", "idCh").text("체크해제").removeClass().addClass("btn btn-success").attr("onclick", "clearCheckId();");
                            $("#login_id input").prop("disabled", true);
                        } else {
                            alert("중복된 아이디 입니다");
                        }

                    },
                    error: function () {
                        alert("통신에러");
                    }
                });
            }

            //중폭체크 풀기
            function clearCheckId() {
                $("#idCh").attr("id", "idCh").attr("onclick", "checkId();").addClass("btn btn-danger").html("중복체크");
                $("#login_id input").prop("disabled", false);
            }

            //비밀번호 체크
            function checkPw() {
                $('#pw_ch2').on('input', function () {
                    // console.log($(this).val());
                    if ($('#pw_ch1').val() != $('#pw_ch2').val()) {
                        $("#pw_comp").text("비밀번호 불일치").css('color', 'red');
                    } else {
                        $("#pw_comp").text("비밀번호 일치").css('color', 'green');
                    }

                });
                $('#pw_ch1').on('input', function () {
                    // console.log($(this).val());
                    if ($('#pw_ch1').val() != $('#pw_ch2').val()) {
                        $("#pw_comp").text("비밀번호 불일치").css('color', 'red');
                    } else {
                        $("#pw_comp").text("비밀번호 일치").css('color', 'green');
                    }

                });
            }

            //회원가입
            function insert() {
                var url = "";
                var param = {};

                //입력값
                var login_id = $("#login_id input").val();
                var name = $("#name input").val();
                var tel = $("#tel input").val();
                var mail = $("#mail input").val();
                var auth = $("#auth").val();
                var pw = $("#pw_ch2").val();

                //아이디
                if ($("#idCh").text().trim() != "체크해제") {
                    $("#login_id input").focus();
                    alert("중복체크 확인");
                    return;
                }
                //비밀번호
                if (!strCheck(pw, "pw")) {
                    $("#pw_ch2").focus();
                    return;
                };

                param = {
                    user_login_id: login_id,
                    user_pw: pw,
                    user_name: name,
                    user_tel: tel,
                    user_mail: mail
                };

                //사전체크
                //이름
                if (!strCheck(name, "name")) {
                    $("#name input").focus();
                    return;
                };
                //폰번호
                if (!strCheck(tel, "tel")) {
                    $("#tel input").focus();
                    return;
                };
                //메일
                if (!strCheck(mail, "mail")) {
                    $("#mail input").focus();
                    return;
                };

                // console.log("param");
                // console.log(param);

                $.ajax({
                    url: "/user/insert",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(param),
                    success: function (result) {
                        // alert("통신성공");
                        // console.log(result);
                        alert("가입완료 되었습니다");
                        $("#staticBackdrop").modal('hide');

                    },
                    error: function () {
                        alert("통신에러");
                    }
                });
            }

        </script>

        </html>