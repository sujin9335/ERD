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
    </head>

    <body>
        <%@include file="include/header.jsp" %>
            <div class="container text-center">
                <div class="row">
                    <div class="col">
                        <h2>게시판</h2>
                    </div>
                </div>
            </div>

            <div class="p-5 mb-4 bg-body-tertiary rounded-3" id="main">
                <!-- 검색 -->
                <div class="container text-center">
                    <div class="row">
                        <div class="col px-5">
                            <div class="d-flex" role="search">
                                <select id="searchType">
                                    <option value="board_title">제목</option>
                                    <option value="user_nickname">작성자</option>
                                </select>
                                <input class="form-control" type="search" placeholder="검색" aria-label="Search"
                                    id="search">
                                <button class="btn btn-outline-success col-1" onclick="listBoard(true);">검색</button>
                                <button class="btn btn-outline-success col-1" onclick="resetSearch()">초기화</button>
                                <div>
                                </div>
                                <div class="col-lg-2">
                                    <select id="limitPage" onchange="changeLimit()">
                                        <option value="5">5개씩 보기</option>
                                        <option value="10">10개씩 보기</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- 게시글 리스트 -->
                <div class="container-fluid py-5 w70">
                    <div id="total"></div>
                    <table class="table text-center" id="tab">
                        <thead>
                            <tr>
                                <th class="col-1" scope="col">번호</th>
                                <th class="col-4" scope="col">제목</th>
                                <th class="col-3" scope="col">작성자</th>
                                <th class="col-2" scope="col">조회수</th>
                                <th class="col-2" scope="col">날짜</th>
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
                                    data-bs-target="#modalUpsert" onclick="modalChange('insert')">글쓰기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- 상세모달 -->
            <div class="modal fade" id="modalGet" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
                aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">

                        <div class="modal-body">
                            <div class="container text-center border">
                                <div class="row">

                                    <div class="col-2 pt-3">
                                        <h3>제목</h3>
                                    </div>
                                    <div class="col-7 text-start px-4 pt-3" id="getTitle"></div>
                                    <div class="col-1">
                                        <input type='hidden' id="getId">
                                    </div>
                                    <div class="col-1">
                                        <div>
                                            조회수
                                        </div>
                                        <div id="getView"></div>
                                    </div>
                                    <div class="col-1">
                                        <button type="button" class="btn btn-dark" data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>내용</h3>
                                    </div>
                                    <div class="col-10 text-start p-4 hi300 editorDiv"></div>
                                </div>
                                <div class="row">
                                    <div class="col-2 ">
                                        <h3>작성자</h3>
                                    </div>
                                    <input type="hidden" id="GetUserId">
                                    <div class="col-10 text-start ps-4 pt-2" id="getNickname"></div>
                                </div>
                                <div class="row">
                                    <div class="col-2">
                                        <h3>첨부파일</h3>
                                    </div>
                                    <div class="col-8" id="getFiles"></div>
                                    <div class="col-1 checkUser">
                                        <button type="button" class="btn btn-info" data-bs-toggle="modal"
                                        data-bs-target="#modalUpsert" onclick="modalChange('update')">수정</button>
                                    </div>
                                    <div class="col-1 checkUser">
                                        <button type="button" class="btn btn-warning" onclick="del()">삭제</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- 등록수정모달 -->
            <div class="modal fade" id="modalUpsert" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
                aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-custom">
                    <div class="modal-content">

                        <div class="modal-body">
                            <div class="container text-center border">
                                <div class="row">

                                    <div class="col-2 pt-3">
                                        <h3>제목</h3>
                                    </div>
                                    <div class="col-7 text-start px-4 pt-3" id="title">
                                        <input class='w-100' type='text'>
                                    </div>
                                    <div class="col-1">
                                        <input type='hidden' id="id">
                                    </div>
                                    <div class="col-1">
                                    </div>
                                    <div class="col-1">
                                        <button type="button" class="btn btn-dark" data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 pt-3">
                                        <h3>내용</h3>
                                    </div>
                                    <div class="col-10 text-start p-4 hi300 editorDiv" >
                                        
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2">
                                        <h3>첨부파일</h3>
                                    </div>
                                    <div class="col-8" id="files">
                                        <div class="row">
                                            <div class="col fileList">업로드 된 파일</div>
                                            <div class="col">업로드 할 파일</div>
                                        </div>
                                        <div class="row">
                                            <div class="col fileList" id="uploadFileList"></div>
                                            <div class="col" id="fileList"></div>
                                        </div>

                                        <div ></div>
                                        <input id="fileInput" type="file" multiple style="display: none;">
                                        <button id="fileBtn" type="button" class="btn btn-info" onclick="fileBtnSelect()">파일 선택</button>
                                    </div>
                                    <div class="col-1 checkUser insertReset">
                                    </div>
                                    <div class="col-1 checkUser insertReset insertBtn">
                                        <button type="button" class="btn btn-warning" onclick="upsert()">등록</button>
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
            let searchTypeSelect = ""; //검색타입

            //토스트 에디터 (등록, 수정시 내용을 가져올수있음)
            let textEditor = "";
            //파일arr
            let fileArr = [];
            //삭제할파일 arr
            let deletedFileIdArr = [];

            // 리스트 요청
            window.onload = function () {
                listBoard();
            }

            function listBoard(search) {

                //테이블 초기화
                $("#tab tbody").empty();
                //페이징 초기화
                $("#paging").empty();

                var param = {};

                //검색으로 리스트 불렀는지 확인
                if(search) {
                    pageCurrent = 1; //검색누를경우 1페이지로 이동
                    searchSelect = $("#search").val(); //검색어 저장
                    searchTypeSelect = $("#searchType").val(); //검색타입 저장
                }

                //몇개씩 볼건지 선택
                var limitPage = $("#limitPage").val();

                param = {
                    offset: limitPage * (pageCurrent - 1), //현재 보고있는 페이지
                    listSize: limitPage, // 가져올 데이터의 개수
                    searchType: searchTypeSelect,
                    search: searchSelect
                };

                $.ajax({
                    url: "/board/list",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(param),
                    success: function (result) {
                        
                        if (result.data.length > 0) {
                            // alert("통신성공");
                            console.log(result);

                            var totalPage = Math.ceil(result.total / limitPage); //보여지는 총페이지
                            paging(pageCurrent, totalPage); //페이징 함수

                            //총 갯수 출력
                            $("#total").text("총:" + result.total + "개")
                            //리스트 출력
                            for (var i = 0; i < result.data.length; i++) {
                                var index = i + 1 + param.offset;
                                var listBoard = "<tr>" +
                                    "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick='get(\"" + result.data[i].board_id + "\")'>" + index + "</td>" +
                                    "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick='get(\"" + result.data[i].board_id + "\")'>" + escapeHtml(result.data[i].board_title) + "</td>" +
                                    "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick='get(\"" + result.data[i].board_id + "\")'>" + result.data[i].user_nickname + "</td>" +
                                    "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick='get(\"" + result.data[i].board_id + "\")'>" + result.data[i].board_view + "</td>" +
                                    "<td class='col' data-bs-toggle='modal' data-bs-target='#modalGet' onclick='get(\"" + result.data[i].board_id + "\")'>" + result.data[i].board_date + "</td>" +
                                    "</tr>";
                                $("#tab tbody").append(listBoard);
                            }

                        } else {
                            var msg = "<tr>" +
                                "<td colspan='6' >게시글이 존재하지 않습니다</td>" +
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

                pageCurrent = number;
                listBoard();
            }

            // 5, 10개 씩 보기 변경
            function changeLimit() {
                pageCurrent = 1;
                listBoard();
            }

            //검색 초기화
            function resetSearch() {
                pageCurrent = 1;
                $("#searchType").prop('selectedIndex', 0);
                $("#limitPage").prop('selectedIndex', 0);
                $("#search").val("");
                searchTypeSelect="";
                searchSelect="";
                listBoard();
            }

            //상세
            function get(id) {

                var param = {};

                param = {
                    board_id: id
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
                        var id = result.data.board_id;
                        var title = result.data.board_title;
                        var content = result.data.board_content;
                        var view = result.data.board_view;
                        var userId = result.data.user_id;
                        var userNickname = result.data.user_nickname;

                        $("#modalGet #getId").val(id);
                        $("#modalGet #getTitle").text(title);
                        $("#modalGet #getView").text(view);
                        $("#modalGet #getUserId").val(userId);
                        $("#modalGet #getNickname").text(userNickname);

                        // 읽기전용 토스트 에디터
                        editorCreate(true, content, 'Get'); //읽기전용, 내용
                        

                        var sessionUserId = "<%= id %>";
                        var sessionAuth = "<%= auth %>";
                        // console.log(userId + " " +sessionUserId);
                        //수정 삭제 관리 .. 관리자는 모두 가능
                        if (userId != sessionUserId && sessionAuth != 0) {
                            $("#modalGet .checkUser").hide();
                        } else {
                            $("#modalGet .checkUser").show();
                        }

                        //파일 리스트
                        $("#modalGet #getFiles").empty(); //초기화
                        $.each(result.files, function (index, value) {
                            var file = "<div class='getFile' data-value='" + value.file_id + "' style='cursor:pointer; display: flex; align-items: center;'>" + 
                                            "<span onclick=\"location.href='/board/fileDown/" + value.file_id + "'\">" + 
                                            value.file_name + "." + value.file_extension + 
                                            "</span>" +
                                            "<button class='deleteFile' style='display: none;'>삭제</button>" +
                                    "</div>";
                            $("#modalGet #getFiles").append(file);
                        });

                        
                        //파일 삭제
                        deletedFileIdArr = []; //초기화
                        $(document).off('click', '.deleteFile').on('click', '.deleteFile', function() {
                            $(this).closest('div').remove();
                            let fileId = $(this).closest('div').data('value');
                            deletedFileIdArr.push(fileId);
                            console.log(deletedFileIdArr);

                        });

                        listBoard();


                    },
                    error: function (error) {
                        alert("서버에러" + error.status + " " + error.responseText);
                    }
                });
            }


            //텍스트 에디터 생성(토스트에디터)
            function editorCreate(isViewer, contentText, seletor) {
                var selectId = "#modal" + seletor; //들어갈곳 Id
                $(selectId +' .editorDiv').empty(); //초기화
                textEditor = new toastui.Editor.factory({
                    el: document.querySelector(selectId +' .editorDiv'), // 에디터를 적용할 요소 (컨테이너)
                    height: '400px',                        // 에디터 영역의 높이 값 (OOOpx || auto)
                    initialEditType: 'wysiwyg',
                    initialValue: contentText,
                    viewer: isViewer
                });
            }
            

            //모달 등록, 수정 양식변경
            function modalChange(type) {

                //초기화
                $("#modalUpsert #id input").val(""); //게시판 id
                $("#modalUpsert #title input").val("");
                $("#modalUpsert #files input").val("");
                $("#modalUpsert #content").empty();
                $("#modalUpsert #uploadFileList").empty();
                $("#modalUpsert #fileList").empty();
                fileArr = [];

                // 이벤트 제거
                $('#fileInput').off('change', fileInputEvent);
                // 이벤트 등록
                $('#fileInput').on('change', fileInputEvent);


                if(type == "insert") {
                    //인서트
                    $("#modalUpsert .fileList").hide();
                    editorCreate(false, "", "Upsert");
                } else if(type == "update") {
                    //업데이트
                    $("#modalUpsert .fileList").show();

                    $("#modalUpsert #id").val($("#modalGet #getId").val());
                    $("#modalUpsert #title input").val($("#modalGet #getTitle").text());
                    $("#modalUpsert #uploadFileList").html($("#modalGet #getFiles").html());
                    $(".getFile button").show();
                    var content=$("#modalGet .toastui-editor-contents").html();
                    console.log(content);
                    editorCreate(false, content, "Upsert");

                }

            }

            //파일 입력 이벤트 
            function fileInputEvent() {
                var files = $(this)[0].files;
                
                $('#fileList').empty();
                
                $.each(files, function(index, file) {
                    fileArr.push(file);
                });

                fileArrPrint();
            }

            

            //파일버튼 클릭
            function fileBtnSelect() {
                $("#fileInput").click();
            }
            

            //fileArr 출력
            function fileArrPrint() {
                $('#fileList').empty();
                $.each(fileArr, function(index, file) {
                    var fileNameSize = file.name + ' (' + (file.size / 1024).toFixed(2) + ' KB)';
                    var fileDiv = $('<div></div>').text(fileNameSize);
                    
                    // 삭제 버튼 추가
                    var deleteButton = $('<button></button>').text('삭제').on('click', function() {
                        // 해당 파일을 배열에서 삭제
                        fileArr.splice(index, 1);
                        // 목록을 다시 출력
                        fileArrPrint();
                    });
                    
                    fileDiv.append(deleteButton);
                    $('#fileList').append(fileDiv);
                });
            }


            //인서트, 업데이트
            function upsert() {
                var sessionUserId = "<%= id %>";
                var url = "";//ajax통신 url

                var formData = new FormData(); //파일 전송시 필요
                var param = {};

                //내용추출
                var boardId = $("#modalUpsert #id").val();
                var title = $("#modalUpsert #title input").val().trim();
                var content = textEditor.getMarkdown();
                console.log(content);

                //파일 추출
                var maxSizeBytes = 3 * 1024 * 1024;//파일 최대 사이즈
                for (var i = 0; i < fileArr.length; i++) {
                    if (fileArr[i].size > maxSizeBytes) {
                        alert("파일 사이즈가 3MB를 초과하는 파일이 포함되어 있습니다.");
                        return; // upsert 함수 전체를 종료
                    }
                    formData.append('files', fileArr[i]);
                }
                    

                //유효성 검사
                var bool = confirm("작성 하시겠습니까?");
                if (!bool) {
                    return;
                }
                
                if (!/^\S{1,10}$/.test(title)) {
                    alert("제목은 공백 불가, 10글자 까지입니다");
                    return;
                }

                if (!/\S{1}/.test(content)) {
                    alert("내용은 공백 불가입니다")
                    return;
                }

                //2000바이트 이하 검사
                var encoder = new TextEncoder();
                var encoded = encoder.encode(content);
                console.log(encoded.length);
                if (encoded.length > 2000) {
                    alert("내용은 2000바이트 이하입니다");
                }
                
                param = {
                    user_id: sessionUserId,
                    board_title: title,
                    board_content: content
                };

                //boardId 유무로 인서트 업데이트 구분
                if (boardId) {
                    url = "/board/update"
                    param.board_id = boardId;
                    param.file_id = deletedFileIdArr;
                    
                    // $('#uploadFileList div').each(function (index) {
                    //     var value = $(this).attr('data-value');
                    //     param.file_id.push(value);
                    // });
                } else {
                    url = "/board/insert"
                }

                formData.append("param", JSON.stringify(param));

                $.ajax({
                    url: url,
                    type: "POST",
                    contentType: false, // FormData를 사용하기 때문에 false로 설정
                    processData: false, // FormData를 직렬화하지 않도록 false로 설정
                    enctype: 'multipart/form-data',
                    data: formData,
                    success: function (result) {
                        console.log(result);
                        // if(result.msg) {
                        //     alert(result.msg);
                        // }
                        $("#modalUpsert").modal('hide');
                        listBoard();
                        
                       
                    },
                    error: function (error) {
                        alert("서버에러" + error.status + " " + error.responseText);
                    }
                });

            }

            //게시글 삭제
            function del() {
                var bool = confirm("삭제 하시겠습니까?");

                if (!bool) {
                    return;
                }
                var param = {
                    board_id: $("#getId").val()
                };

                $.ajax({
                    url: "/board/del",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(param),
                    success: function (result) {

                        if(result.msg) {
                            alert(result.msg);
                        }

                        $("#modalGet").modal('hide');
                        listBoard();

                    },
                    error: function () {
                        alert("통신에러");
                    }
                });
            }


        </script>
    </body>

    </html>