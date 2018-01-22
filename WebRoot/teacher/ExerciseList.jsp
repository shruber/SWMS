<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>教师视角：作业列表</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">

<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
-->

<jsp:include page="../include.jsp" />

<style>
#main-panel {
	width: 80%;
	margin: 10px auto auto auto;
	border: 1px solid #CCC;
	border-radius: 4px;
	padding: 8px;
	min-height: 360px;
}

</style>
</head>

<body>
	<jsp:include page="header.jsp"></jsp:include>

	<div id='main-panel'>
	
		<div class='assignment'>
			<label class='title'> </label>
			<div class='descr'> </div>
		</div>
		
		<hr>
		
		<!-- 作业列表 -->
		<div class='exercise-list'>
			<table class='table'>
				<thead>
					<tr>
						<th> 学号 </th>
						<th> 状态 </th>
						<th> 查看 </th>
					</tr>
				</thead>
				<tbody>
				
				</tbody>
			</table>			
		</div>
	</div>
</body>

<script>
	var MAIN = {};
	MAIN.panel = $("#main-panel");
	//MAIN.assignment = <%= my.jsp.JspUtil.getAssignment(request) %>;
	<% 
		int assignment = request.getAttribute("assignment");
		String sql = "FROM Assignment WHERE id=" + assignment;
		Assignment row = (Assignment) AfDbUtil.get(sql, false);
		return new JSONObject(row);
	 %>
	MAIN.assignment = <%request.getAttribute("assignment")%>;
	
	MAIN.show_assignment = function(it)
	{
		var p = $(".assignment");
		$(".title",p).html(it.title);
		$(".descr",p).html(it.descr);
	}
	//加载同一道题目下的作业列表
	MAIN.load = function()
	{
		var req = {};
		req.assignment = this.assignment.id;//指定assignment的ID
		Af.rest("ExerciseList.api", req, function(ans){
			MAIN.show_item_list(ans.result);
		});	
	}
	
	//显示作业列表
	MAIN.show_item_list = function(items)
	{
		var target = $(".exercise-list tbody");
		
		for(var i=0; i<items.length; i++)
		{
			var it = items[i];
			var str = "<tr class='item' id1='##1' onclick='COURSES.clicked(thos)'>"
				+ "<td>" + it.student + "</td>"
				+ "<td>" + MAIN.status(it.status) + "</td>"
				+ "<td>" + "xxx" + "</td>"
				+ "</tr>";
			str = str.replace(/##1/g, it.id);
			target.append(str);
		}
	}
	
	MAIN.status = function(s)
	{
		if(s==0) return "-";
		if(s==1) return "已提交";
		if(s==100) return "OK";
	}
	
	//初始化
	MAIN.panel.ready(function(){
		MAIN.show_assignment(MAIN.assignment);
		
		MAIN.load();
	
	});	
</script>
</html>