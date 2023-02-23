<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel="icon" href="./images/messenger.png"/>


<style type="text/css">


</style>

</head>
<body>

	<br/>
<!-- header 페이지 삽입  -->
	<jsp:include page="./header/header.jsp"></jsp:include>
	<br/>
	
<!-- navigation -->		
	<ul class="nav nav-tabs">
	  <li class="nav-item">
	    <a class="nav-link active" aria-current="page" href="viewHome">Home</a>
	  </li>
	  <li class="nav-item">
	    <a class="nav-link" href="viewSearchRoom">방 검색</a>
	  </li>
	  <li class="nav-item">
	    <a class="nav-link" href="viewNewRoom">방 생성</a>
	  </li>
	</ul>		
	
<!-- 좌측: 나의 정보 -->	
	<div style="margin-top: 40px; margin-bottom: 100px; margin-left: 50px; float: left;">
			<div class="mb-3">
				<img border="1px" width="200px" alt="프로필사진" src='<spring:url value="/profile/${userVO.profileImg}"></spring:url>'>
			</div>
			<div class="mb-3">
				<label for="exampleFormControlInput1" class="form-label">닉네임</label>
				<input type="text" class="form-control" id="exampleFormControlInput1" value="${userVO.nickName}" readonly="readonly">
			</div>
			<div class="mb-3">
				<label for="exampleFormControlInput2" class="form-label">관심태그</label>
				<input type="tel" class="form-control" id="exampleFormControlInput2" value="${userVO.myTag}" readonly="readonly">
			</div>
			<div class="mb-3">
				<label for="exampleFormControlTextarea3" class="form-label">소개</label>
				<textarea class="form-control" id="exampleFormControlTextarea3" rows="3" readonly="readonly">${userVO.myComment}</textarea>
			</div>
	</div>
	
	
	<div style="margin-top: 40px; margin-bottom: 100px; margin-left: 50px; float: left; overflow: auto; width: 600px;">
		참여 중인 대화방
		<div class="d-grid gap-2" style="width: 500px">
			<c:if test="${myRoomList.size() != 0}">
				<c:forEach var="myRoomVO" items="${myRoomList}">
				
<!-- 	unRead 추가				 -->
					<button type="button" class="btn btn-outline-secondary position-relative" onclick="location.href='viewRoom?roomId=${myRoomVO.roomId}&newMsg=${myRoomVO.newMsg}'">
						${myRoomVO.roomName}
					  <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
					    ${myRoomVO.newMsg}
					    <span class="visually-hidden">unread messages</span>
					  </span>
					</button>
					
					
					
				</c:forEach>
			</c:if>
			<c:if test="${myRoomList.size() == 0}">
				<div class="d-grid gap-2" style="border: solid 1px black; width: 500px;">
					대화방이 존재하지 않습니다.
				</div>
			</c:if>
			
		</div>
	
	</div>
	
	
	
	
	
	
	
	
	
<!-- footer삽입 -->
<script type="text/javascript">


//자동새로고침 함수!

onload = () => {
	
// 	setInterval(() => {
// 		location.href='viewHome';
		
// 	}, 3 * 1000)
	
}



</script>
	

</body>
</html>