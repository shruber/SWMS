<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<jsp:include page="include.jsp" />
	
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
		
		#main-panel .item
		{
			display:inline-block;
			width:20%;
			margin: 10px;
			height: 100px;
			background-color: #DDD;
			border-radius: 8px;
			padding: 4px;
			text-align:center;
		}
	
	</style>
</head>
  
  <body>
  	<div id='main-panel'>
  		this is a test;  	
  	</div>

  </body>
<script>
	var MAIN = {};
	MAIN.panel = $("#main-panel");

	//加载
	MAIN.load = function()
	{
		var req = {};
		Af.rest("CourseList.api",req,function(ans){
		
			Af.trace(ans);
			MAIN.show_item_list(ans.result);
		});
	}
	
	//显示列表
	MAIN.show_item_list = function(items)
	{
		var target = this.panel;
		target.html("");	//清空面板
		for(var i = 0; i < items.length; i++)
		{
			var it = items[i];
			var str = "<div class='item'>" 
				+ it.title
				+ "</div>";
			target.append(str);
		}
	}
	
	//初始化
	MAIN.panel.ready(function(){
		
		MAIN.load();
	});
</script>



</html>
