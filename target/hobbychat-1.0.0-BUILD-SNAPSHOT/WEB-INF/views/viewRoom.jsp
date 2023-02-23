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
<title>대화방</title>
<link rel="icon" href="./images/messenger.png"/>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<!-- sockJS -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>

<style type="text/css">


.chattingList {
	height: 300px;
	padding: 15px;
	overflow: auto;
}

a {
	color: black;
	text-decoration: none; /* 밑줄 */
}

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
	
<!-- 좌측: 실시간 채팅 접속자 목록 -->	
	<div style="margin-top: 40px; margin-bottom: 100px; margin-left: 50px; float: left;">
		<ul class="list-group" id="ConnectingUser">

		</ul>
	</div>
	
	
<!-- 중앙: 채팅창  -->	
	<div class="container" style="margin-top: 40px; margin-bottom: 100px; margin-left: 50px; float: left; overflow: auto; width: 800px;">
		
		<h3 class="page-header">대화창</h3>		
		
		<table class="table table-bordered">
			<tr>
				<td>
					<input type="text" class="form-control" value="${chatRoomVO.roomName}">
				</td>
				<td>
					<button type="button" class="btn btn-default" id="btnDisconnect">창 닫기</button>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				${index}
					<div id="${msgList.size()}" class="chattingList">
						<c:if test="${msgList.size() != 0}">
							<c:forEach var="i" begin="0" end="${msgList.size()-1}">
							
								<c:if test="${i == 0}">
									<fmt:formatDate value="${msgList.get(i).writeDate}" type="both" pattern="yyyy-MM-dd [E]" var="start"/>
									<div style="margin-bottom:3px;" align="center">	
										<span style="font-size:16px; color:#777;">${start}</span>
									</div>	
								</c:if>
								<c:if test="${i != 0}">
									<fmt:formatDate value="${msgList.get(i-1).writeDate}" type="both" pattern="yyyy-MM-dd [E]" var="before"/>
									<fmt:formatDate value="${msgList.get(i).writeDate}" type="both" pattern="yyyy-MM-dd [E]" var="now"/>
									<c:if test="${before != now}">
										<div style="margin-bottom:3px;" align="center">	
											<span style="font-size:16px; color:#777;">${now}</span>
										</div>	
									</c:if>
								</c:if>
								
								<c:if test="${i != index}">
									<div style="margin-bottom:3px;">	
										[${msgList.get(i).nickName}] ${msgList.get(i).msg} 
									 	<span style="font-size:11px;color:#777;"><fmt:formatDate value="${msgList.get(i).writeDate}" pattern="a h:mm"/></span>
									 </div>					
								</c:if>
								<c:if test="${i == index}">
									<div style="margin-bottom:3px;" id="newMsgIndex">	
										[${msgList.get(i).nickName}] ${msgList.get(i).msg} 
									 	<span style="font-size:11px;color:#777;"><fmt:formatDate value="${msgList.get(i).writeDate}" pattern="a h:mm"/></span>
									 </div>					
								</c:if>
							
							
							</c:forEach>
<%-- 							<c:forEach var="msgVO" items="${msgList}"> --%>
<%-- 								<div style="margin-bottom:3px;" id="${msgVO.msgId}">	 --%>
<%-- 									[${msgVO.nickName}] ${msgVO.msg}  --%>
<%-- 								 	<span style="font-size:11px;color:#777;"><fmt:formatDate value="${msgVO.writeDate}" pattern="a h:mm"/></span> --%>
<!-- 								 </div>					 -->
<%-- 		 					</c:forEach> --%>
						</c:if>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2"><input type="text" name="msg" id="msg" placeholder="대화 내용을 입력하세요." class="form-control" disabled></td>
			</tr>
		</table>
		<input type="hidden" name="user" id="user" value="${userVO.userId}">
		<input type="hidden" id="roomId" value="${chatRoomVO.roomId}">
		<input type="hidden" id="newMsgIndexHidden" value="${index}">
	</div>

<!-- 우측: 채팅 참여자 목록 -->
	<div style="margin-top: 40px; margin-bottom: 100px; margin-left: 10px; float: left;">
		<button class="btn btn-outline-secondary" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">
			대화방 정보
		</button>
	</div>
	
	<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRight" aria-labelledby="offcanvasRightLabel">
	  <div class="offcanvas-header">
	    <h4 class="offcanvas-title" id="offcanvasRightLabel">${chatRoomVO.roomName}</h4>
	    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
	  </div>
	  <div class="offcanvas-body" style="overflow: auto;">
	  	${chatRoomVO.userCnt} 명 참여중
	  	<ul class="list-group list-group-flush">
	  		
	  		<c:forEach var="userOne" items="${userList}">
				<li class="list-group-item">
						<img width="50px" class="rounded" alt="프로필" src='<spring:url value="/profile/${userOne.profileImg}"></spring:url>'>
					&nbsp; ${userOne.nickName}
				</li>
	  		</c:forEach>
		</ul>
	  </div>
	  <div>
	  <a href="#" style="color: black; text-decoration: none; font-size: 18px;">
	  	<img width="48px" alt="퇴장" src="./images/logout.png" align="left">&nbsp;퇴장하기
	  </a>
	  </div>
	</div>	
	
	
	
<script type="text/javascript">


//전역변수 설정 
var socket  = null;   // 웹소켓
var root = null;      // 컨텍스트 경로 위해 
console.log(root)


$(document).ready(function(){

	let newMsgIndexHidden = document.getElementById("newMsgIndexHidden").value
	let chattingList = document.querySelector('.chattingList')
	// 새 메세지가 존재한다면 
	if (newMsgIndexHidden < chattingList.id) {
		
		//	대화방페이지 들어오면 대화창 스크롤이 새 메세지 시작위치로 이동
		let newMsgIndex = document.getElementById("newMsgIndex")
		newMsgIndex.scrollIntoView()	
// 		newMsgIndex.scrollIntoView({behavior: 'smooth'})	
		
	}
		

	
// <웹소켓 관련> -------------------------------------------------------------------------------------


//	웹소켓 연결
    var sock = new SockJS("<c:url value="/echo-ws"/>");
    socket = sock;

   	sock.onopen = function() {
       console.log('info: connection opened.');
       
       // userId에는 특수문자 # 와 / 가 들어가지 못하므로 구분가능.
       // 접속자유저id#/new메세지시작인덱스/채팅방id
       socket.send($('#user').val() + '#/' + newMsgIndexHidden + '/' + $('#roomId').val());
       
       $('#msg').attr('disabled', false);
       $('#msg').focus();
   	}
	
// 데이터를 전달 받았을때 
    sock.onmessage = function (evt) {
		console.log('message 옴')
        let data = evt.data;
		console.log("데이터 :" + data)
	
		if (data.substring(0, 14) == "connectingList") {
			$("#ConnectingUser").html(data.substring(14));
			
		} else {
			let index = evt.data.indexOf("/");
			let speaker = evt.data.substring(0, index);
			let txt = evt.data.substring(index + 1);
			
			print(speaker, txt);
			
			$('.chattingList').scrollTop($('.chattingList').prop('scrollHeight'));
		}
        
    };

// 웹소켓 종료
    sock.onclose = function() {
      	console.log('connect close');
    }

// 웹소켓 에러발생시
    sock.onerror = function (err) {
    	console.log('Errors : ' , err);
   	};


//	메세지 전송 시
	$('#msg').keydown(function() {
	 if (event.keyCode == 13) {		// 엔터키 누르면 메세지 전송
		 
		 // WebSocket의 send() :서버로 메세지 전송
		 
		 // userId에는 특수문자/ 가 들어가지 못하므로 구분가능.
		 // 발신유저id/메세지/채팅방id
		 socket.send($('#user').val() + '/' + $(this).val() + '/' + $('#roomId').val());
		 $('#msg').val('');
		 $('#msg').focus();
		 
	 }
	});

//	창 닫기 클릭 시, 웹소켓 종료
	$('#btnDisconnect').click(function() {
	 sock.close();
	 location.href = 'viewHome';
	});
	
});
	
// 발신자닉네임 & 대화내용 
function print(speaker, txt) {
	 let temp = '';
	 temp += '<div style="margin-bottom:3px;">';
	 temp += '[' + speaker + '] ';
	 temp += txt;
	 temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
	 temp += '</div>';
	 
	 $('.chattingList').append(temp);
	}

//접속과 종료 통지는 불필요하다. 채팅방 최초 입장과 완전 퇴장 시 메세지가 필요하다..

/*
// 다른 client 접속 통지		
		 function print2(user) {
			 let temp = '';
			 temp += '<div style="margin-bottom:3px;">';
			 temp += "'" + user + "' 님이 접속했습니다." ;
			 temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
			 temp += '</div>';
			 
			 $('.chattingList').append(temp);
		 }
		 
// 다른 client 접속 종료 통지
		 function print3(user) {
			 let temp = '';
			 temp += '<div style="margin-bottom:3px;">';
			 temp += "'" + user + "' 님이 종료했습니다." ;
			 temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
			 temp += '</div>';
			 
			 $('.chattingList').append(temp);
		 }
*/
// ------------------------------------------------------------------------------------------------------------------




// 컨텍스트경로 얻는 함수
function getContextPath() {
	let hostIndex = location.href.indexOf(location.host) + location.host.length
	let contextPath = location.href.substring(hostIndex, location.href.indexOf('/', hostIndex + 1))
	return contextPath
}


</script>
	

</body>
</html>