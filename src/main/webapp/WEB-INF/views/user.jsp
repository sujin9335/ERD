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
                                <select id="searchType">
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
                                    <select id="limit" onchange="changeLimit()">
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
                                        <th class="col-2" scope="col">이름</th>
                                        <th class="col-2" scope="col">ID</th>
                                        <th class="col-3" scope="col">닉네임</th>
                                        <th class="col-2" scope="col">핸드폰번호</th>
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



                    <div class="modal fade" id="staticBack" data-bs-backdrop="static" data-bs-keyboard="false"
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
                                                admin
                                            </div>

                                            <div class="col-1 editDel">
                                                <div id="id" style="display: none;"></div>
                                                <div id="flag" style="display: none;"></div>
                                            </div>

                                            <div class="col-1">
                                                <!-- <button type="button" class="btn btn-dark" data-bs-dismiss="modal" onclick="closeModal()">닫기</button> -->
                                                <button type="button" class="btn btn-dark"
                                                    data-bs-dismiss="modal">닫기</button>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-2 pt-3 pw" style="display: none;">
                                                <h3>비밀번호</h3>
                                            </div>
                                            <div class="col-10 text-start px-4 pt-3 in-title pw" id="pw"
                                                style="display: none;">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-2 pt-3">
                                                <h3>이름</h3>
                                            </div>
                                            <div class="col-10 text-start p-4 " id="name">
                                                김수진
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-2 pt-3">
                                                <h3>핸드폰번호</h3>
                                            </div>
                                            <div class="col-10 text-start p-4" id="tel">
                                                010-9335-6987
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-2 pt-3">
                                                <h3>이메일</h3>
                                            </div>
                                            <div class="col-10 text-start p-4" id="mail">
                                                sujin_78@naver.com
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-2 pt-3">
                                                <h3>권한</h3>
                                            </div>
                                            <div class="col-3 text-start p-4">
                                                <select class="form-select form-select-sm"
                                                    aria-label="Small select example" id="auth">
                                                    <option value="1" selected>일반유저</option>
                                                    <option value="0">관리자</option>
                                                </select>
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


                </div>

                <script>
                    


                </script>

    </body>

    </html>