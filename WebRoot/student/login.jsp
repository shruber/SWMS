<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>学生登录</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<jsp:include page="../include.jsp" />
	
	<style>	
		#main-panel
		{
			width:80%;
			margin:10px auto auto auto;
			border:1px solid #CCC;
			border-radius:4px;
			padding: 8px;
			min-height:360px;
		}
		
		#login
		{
			text-align:center;
		}
		
		.m-input
		{
			margin:4px;
			padding:2px;
			border:1px solid #ccc;
		}
	
		.m-button
		{
			margin:4px;
			padding:2px 10px;
			border:1px solid #FFF;
		}
		.login-title
		{
			margin:4px;
			padding:2px 10px;
			border:1px solid #FFF;
		}
	
	</style>
</head>
  
  <body>
  	<div id='main-panel'>
  	<p>作业管理系统</p>
  		<div id='login' onkeydown="MAIN.onEnterDown()">
  		  	<p class='login-title'>学生登录  <a>&nbsp&nbsp</a></p> <br>
  			<input class='m-input username' placeholder='学号' /> <br>
  			<input type='password' class='m-input password' placeholder='密码' /> <br>
  			<button class='m-button' onclick="MAIN.login()" >登录</button>
  			<lable class='note'></lable>
  		</div>
  	</div>

  </body>
<script>
	var MAIN = {};
	MAIN.panel = $("#main-panel");
	
	MAIN.onEnterDown = function()
 	{
		if(window.event.keyCode == 13)
		{ 
			MAIN.login();
		}
	}
	
	MAIN.login = function()
	{
		var req = {};
		req.id = $(".username").val();
		req.password = $(".password").val();
		
		if(req.id == "" || req.password == "")
		{
			toastr.error("学号或密码不能为空"); 
			return;
		}
		
		Af.rest("StudentLogin.api", req, function(ans){
		
			Af.trace(ans);
			Af.trace(typeof(ans.arrorCode));
			Af.trace(typeof(0));
			//error hint 
 			if(ans.errorCode != 0)
			{
				$(".note").html(ans.reason);
				return;
			}
			
			//success
			location.href = "student/index.jsp";
		
		});
	}


	//初始化
	MAIN.panel.ready(function(){
	});
</script>



</html>
