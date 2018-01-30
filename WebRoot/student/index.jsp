<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>学生首页</title>
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
#main-panel {
	width: 80%;
	margin: 10px auto auto auto;
	border: 1px solid #CCC;
	border-radius: 4px;
	padding: 8px;
	min-height: 360px;
}

/* 课程TAB页列表 */
.courses {
	display: inline-block;
}

.courses  .item {
	display: inline-block;
	background-color: #ddd;
	color: blue;
	padding: 4px 10px;
	border: 1px solid #ccc;
	cursor: default;
}

/* 高亮色 */
.courses  .item-selected {
	background-color: #fff;
}

/* 操作按钮 */
.buttons {
	display: inline-block;
	margin-left: 100px;
}

.buttons .m-button {
	background-color: #FFF;
	border: 0px solid #CCC;
	border-radius: 2px;
	padding: 4px;
}

.buttons .m-button:hover {
	color: blue;
}

/* 作业列表 */
.assignments {
	border: 1px solid #ccc;
	border-radius: 2px;
	min-height: 300px;
	padding: 10px;
}

.assignments .item {
	margin: 2px;
	border: 1px solid #ccc;
	border-radius: 4px;
	padding: 4px;
	cursor: pointer; /* 鼠标开关 */
}
/* 鼠标移上来后变色 */
.assignments .item:hover
{
	background-color: #add;
	color: #fff;
}
</style>
</head>

<body>
	<jsp:include page="header.jsp"></jsp:include>

	<div id='main-panel'>

		<div class='courses'></div>

		<!-- 作业列表 -->
		<div class='exercise-list'>
			<table class='table'>
				<thead>
					<tr>
						<th> 题目 </th>
						<th> 日期 </th>
						<th> 状态 </th>
						<th> 得分 </th>
					</tr>
				</thead>
				
				<tbody>
				
				</tbody>
			</table>

		</div>
	</div>

</body>
<script>

  	var COURSES = {};
  	COURSES.panel = $("#main-panel .courses");
  	COURSES.course = 0;
  	
  	// 加载学生的课程
  	COURSES.load = function()
  	{
  		var req = {};
  		Af.rest("CourseList.api", req, function(ans){
  			COURSES.show_item_list(ans.result);
  		});
  	}
  	
  	// 显示课程列表
  	COURSES.show_item_list = function(items)
  	{
  		var target = this.panel;
  		for (var i=0; i<items.length; i++)
  		{
  			var it = items[i];
  			var str = "<div class='item' id1='##1' onclick='COURSES.clicked(this)'>"
  				+ it.title 
  				+ "</div>";
  			str = str.replace(/##1/g, it.id);
  			target.append (str);
  		}
  		// 默认选中第一项
  		$(".item", this.panel)[0].click();
  	}
  	
  	// 当课程被点击时
  	COURSES.clicked = function ( dom )
  	{
  		// 取出课程ID
  		var id = $(dom).attr("id1");
  		
  		// 高亮切换
  		$(dom).siblings().removeClass("item-selected");
  		$(dom).addClass("item-selected");
  		
  		// 显示该课程下的作业列表
  		this.course = id;
  		EXER.load( id );
  		
  		
  	}
  	
////////////////// exercise //////////////////
  	var EXER = {};
  	EXER.panel = $(".assignments");
  	
  	//显示课程下的所有作业
  	EXER.load = function(course)
  	{
  		var req = {};
  		req.course = course;
  		req.student = USER.id;
  		Af.rest("ExerciseList.api",req,function(ans){
  			if(ans.errorCode != 0){ toastr.error(ans.reason); return;}
  			Af.trace("errorCode:" + ans.errorCode + "ans.result:" + ans.result);
  			EXER.show_item_list(ans.result);
  		});
  	}
  	
  	//显示所有题目
  	EXER.show_item_list = function(items)
  	{
  		var target = $(".exercise-list tbody");
  		target.html("");
  		
  		for(var i=0; i<items.length; i++)
  		{
  			var it = items[i];
  			var str = "<tr class='item' id1='##1' id2='##2' onclick='EXER.clicked(this)'>"
  				+ "<td>" + it.title + "</td>"
  				+ "<td>" + it.timeCreated.substr(0,11) + "</td>"
  				+ "<td>" + MAIN.status(it.status) + "</td>"
  				//+ "<td>" + it.score + "</td>"
  				+ "<td> ##3 </td>"
  				+ "</tr>";
  				 
  			str = str.replace(/##1/g,it.id).replace(/##2/g, it.assignment);
  			
  			//如果作业未提交，分数显示为“-”
  	 		if(it.status == 0 || it.status == 1)
  			{
  				str = str.replace(/##3/g,"-");
  			}else
  			{
  				str = str.replace(/##3/g, it.score);
  			}
  			
  			target.append(str);
  		}
  	}
  	//当一个题目被点击的时候
  	EXER.clicked = function(dom)
  	{
  		var exercise = $(dom).attr("id1");
  		var assignment = $(dom).attr("id2");
  		location.href = "student/ExerciseView.jsp?exercise=" + exercise + "&assignment=" + assignment;
  	}
  	
  	///////////////////////////////////////////////
	var MAIN = {};
	MAIN.panel = $("#main-panel");
	
	MAIN.status = function(s)
	{
		if(s==0) return "-";
		if(s==1) return "已提交";
		if(s==100) return "OK";
	}
	
	
	//初始化
	MAIN.panel.ready(function(){
 		// 显示课程
 		COURSES.load();
	});
</script>
</html>
