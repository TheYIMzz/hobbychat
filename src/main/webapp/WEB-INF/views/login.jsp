<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
<title>Log in</title>
<meta charset="UTF-8">
<!-- <link rel="stylesheet" href="style.css"> -->

<style type="text/css">
	
	body {
	    background-color: #888;
	    background-image: linear-gradient(45deg, #444 25%, transparent 25%, transparent 75%, #444 75%, #444), 
	    					linear-gradient(45deg, #444 25%, transparent 25%, transparent 75%, #444 75%, #444);
	    background-position: 0 0, 25px 25px;
	    background-size: 50px 50px;
	}
	
	.wrapper {
	    text-align: center;
	    margin:auto;
	    margin-top:225px;
	    width: 420px;
	    height: 450px;
	    border:solid 3px;
	    border-radius: 10%;
	    background: pink;
	}
	
	h1 {
	    margin-top: 65px;
	    font-size: 50px;
	}
	
	
	input {
	    text-align: left;
	    width:225px;
	    height:30px;
	    border: none;
	    border-bottom: solid 3px black;
	    background: pink;
	}
	
	input::placeholder {
	    color: black;
	    font-size: 10px;
	}
	
	
	.email {
	    padding-top: 19px;
	}
	
	img {
	    width: 20px;
	    height: 20px;
	}
	
	.password {
	    padding-bottom: 32px;
	    padding-top: 22px;
	}
	
	button {
	    width: 225px;
	    height: 50px;
	    border-radius: 10%;
	    font-size: 18px;
	    font-weight: bold;
	    border-radius: 10%;
	    background: white;
	    
	}

</style>    
        
        
</head>
<body>

<form action="loginOK" method="post">
	<div class="wrapper">
	    <h1>Log In</h1>
	    <div class="email">
	        <img src="images/user1.png">
	        <input text="Id" id="email" placeholder="Id" name="userId"><br>
	    </div>
	    <div class="password">
	        <img src="images/padlock.png">
	        <input text="password" id="password" placeholder="Password" name="password"><br><br>
	    </div>
		<div>
			<button class="button" type="button" onclick="location.href = 'viewSignUp.jsp'">Sign up</button>
		</div>
		<div class="div_button">
	        <button class="button" type="submit">Log In</button>
	    </div>
	</div>
</form>
	
	<!-- 아이디나 비번 비어있으면 alert 창 띄우기  -->
	
	
</body>
</html>
