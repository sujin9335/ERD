<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>

        <%@include file="include/link_js.jsp" %>
            <link rel="stylesheet" href="/css/mypage.css">

    </head>

    <body>
        <%@include file="include/header.jsp" %>
            <div class="container text-center">
                <div class="row">
                    <div class="col">
                        <h2>마이페이지</h2>
                    </div>
                </div>
            </div>

            <div class="container" id="main">
                <div class="row">
                    <div class="col-3 me-5 border hi-700" id="menu">
                        <div class="m-2"><h3>${name}님</h3></div>
                        <div class="border hi-500 p-2 scroll" id="jstree">
                            <button id="norBtn" type="button" class="btn btn-success" onclick="boadChage(1);">정보 수정</button>
                        </div>
                    </div>
                    <div class="col border hi-700" id="content">
                        <!-- 메뉴 -->
                        <div class="border">
                            <nav class="navbar navbar-expand" aria-label="Second navbar example">
                                <div class="container-fluid text-center">
                                    <div class="collapse navbar-collapse " id="navbarsExample02">
                                        정보 수정
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
                                    <button id="updateBtn" onclick="insert('B');">수정</button>
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
                                            onclick="groupUserList(true);">검색</button>
                                        <button class="btn btn-outline-success col-2"
                                            onclick="searchClear()">초기화</button>
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
                                                    onclick="userlist();">유저 등록</button>
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
                                            onclick="insert('A');">저장</button>
                                        <button type="button" class="btn btn-dark" data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>

            </script>


    </body>

    </html>