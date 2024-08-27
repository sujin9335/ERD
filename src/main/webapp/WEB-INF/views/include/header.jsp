<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- user_id=33, user_login_id=sj, user_name=김수진, user_mail=su@d.com, user_tel=010-1234-1234, user_auth=0, user_use=n, user_lock_cnt=0 -->
<%
  Map<String, Object> userInfo = (Map<String, Object>)session.getAttribute("userInfo");

  String id = "";
  String name = "";
  int auth = 0;

  if(userInfo != null) {
    id = userInfo.get("user_id").toString();
    name = userInfo.get("user_name").toString();
    auth = Integer.parseInt(userInfo.get("user_auth").toString());
  }

  request.setAttribute("id", id);
  request.setAttribute("name", name);
  request.setAttribute("auth", auth);


%>

  <div class="container">
    <header
      class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-4 border-bottom">
      <div class="col-md-3 mb-2 mb-md-0">
        <a href="${pageContext.request.contextPath}/highChart/" class="d-inline-flex link-body-emphasis text-decoration-none">
          home
        </a>
      </div>
      
      <ul class="nav col-12 col-md-auto mb-2 justify-content-center mb-md-0" id="menu">
        <li><a href="${pageContext.request.contextPath}/board/"  id="menu_board" class="nav-link px-2">게시판</a></li>
        <c:choose>
          <c:when test="${auth == 0}">
            <li><a href="${pageContext.request.contextPath}/user/" id="menu_user" class="nav-link px-2">유저관리</a></li>
            <li><a href="${pageContext.request.contextPath}/group/" id="menu_group" class="nav-link px-2">그룹관리</a></li>
          </c:when>
        </c:choose>
      </ul>
      

      
      <c:choose>
        <c:when test="${not empty userInfo}">
            
            <!-- 로그아웃 버튼 표시 -->
            <div class="col-md-3 text-end">
                <!-- <div class="btn-group">
                  <ion-icon class="dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" name="apps-outline" style="cursor: pointer;"></ion-icon>
                  <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/mypage/">마이페이지</a></li>
                  </ul>
                </div> -->

                <span>안녕하세요 ${name}님</span>
                <button type="button" class="btn btn-outline-primary me-2"
                onclick="location.href='${pageContext.request.contextPath}/logout/'">Logout</button>
            </div>
        </c:when>
        <c:when test="${empty userInfo}">
            <!-- 로그인 버튼 표시 -->
            <div class="col-md-3 text-end">
                <button type="button" class="btn btn-outline-primary me-2"
                onclick="location.href='${pageContext.request.contextPath}/login/'">Login</button>
            </div>
        </c:when>
      </c:choose>

      
    </header>
  </div>

  <script>

    var currentUrl = window.location.href;

    $(document).ready(function () {
      
      if(currentUrl.includes("user")) {
        $("#menu_user").css('color', 'white');
        $("#menu_user").css('background-color', 'green');
      }
      if(currentUrl.includes("board")) {
        $("#menu_board").css('color', 'white');
        $("#menu_board").css('background-color', 'green');
      }
      if(currentUrl.includes("group")) {
        $("#menu_group").css('color', 'white');
        $("#menu_group").css('background-color', 'green');
      }
      
    });
  </script>