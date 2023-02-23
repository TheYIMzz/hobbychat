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
<title>방 검색</title>
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
	    <a class="nav-link" href="viewHome">Home</a>
	  </li>
	  <li class="nav-item">
	    <a class="nav-link active" aria-current="page" href="viewSearchRoom">방 검색</a>
	  </li>
	  <li class="nav-item">
	    <a class="nav-link" href="viewNewRoom">방 생성</a>
	  </li>
	</ul>		
	
<!-- 좌측: 나의 정보 -->	
	<div style="margin-top: 40px; margin-bottom: 100px; margin-left: 50px; float: left;">

	</div>
	
	
	<div style="margin-top: 40px; margin-bottom: 100px; margin-left: 50px; float: left; overflow: auto; ">
	
		<form class="d-flex" role="search" action="roomSearch">
		
		<table>
			<tr>
				<td style="width: 100px">
					<label for="rName">방이름</label>
					<input type="radio" name="set" value="rName" id="rName" onclick="checkOnly(1)"/>
				</td>
				<td style="width: 100px">
					<label for="rTag">방태그</label>
					<input type="radio" name="set" value="rTag" id="rTag" onclick="checkOnly(2)"/>
				</td>
				<td colspan="3" style="width: 400px">
			        <input style="width: 300px;" class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="item" id="item">
			        <button class="btn btn-outline-secondary" type="submit">
			        	<img width="20px" alt="검색" src="./images/search.png">
			        </button>
				</td>
					
			</tr>
		
		</table>
	        
	        
	    </form>
	
		<br><br>
		대화방
		<div class="d-grid gap-2">
			<c:if test="${chatRoomList.chatRoomList.size() == 0}">
				검색조건에 맞는 대화방이 존재하지 않습니다.
			</c:if>
			<c:if test="${chatRoomList.chatRoomList.size() != 0}">
				<c:set var="item" value="${chatRoomList.item}"/>
				<c:set var="currentPage" value="${chatRoomList.currentPage}"/>
				<c:set var="startPage" value="${chatRoomList.startPage}"/>
				<c:set var="endPage" value="${chatRoomList.endPage}"/>
				<c:set var="totalPage" value="${chatRoomList.totalPage}"/>
				<c:set var="chatRoomList" value="${chatRoomList.chatRoomList}"/>
			
				<c:forEach var="chatRoomVO" items="${chatRoomList}">
					
					<div class="card mb-3" style="max-width: 500px;">
					 	<div class="row g-0">
					    <div class="col-md-4">
					      <img src='<spring:url value="/cover/${chatRoomVO.coverImg}"></spring:url>' class="img-fluid rounded-start" alt="커버img">
					    </div>
					    <div class="col-md-8" style="margin-bottom: 10px;">
					      <div class="card-body">
					        <h5 class="card-title">${chatRoomVO.roomName}</h5>
					        <p class="card-text">${chatRoomVO.rComment}</p>
					        <p class="card-text"><small class="text-muted">${chatRoomVO.roomTag}</small></p>
					      </div>
					      <div style="margin-left: 210px;">
							<button type="button" class="btn btn-outline-secondary" onclick="location.href='enterRoom?roomId=${chatRoomVO.roomId}'">
								입장하기
							</button>
					      </div>
					    </div>
					  </div>
					</div>
					
					
				</c:forEach>
			</c:if>
		</div>
	
	
	
	
	</div>
	
	
	
	
	
	
	
	
	
<!-- footer삽입 -->
<script type="text/javascript">


onload = () => {
	


	
}

function checkOnly(obj) {
	
	if (obj == 1) {
		item.value = '';
		item.focus();
		
	} else if (obj == 2) {
		
		item.value = '';
		item.focus();
	}
}

</script>
	

</body>
</html>