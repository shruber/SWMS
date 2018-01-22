<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>教师首页</title>
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

		<!-- 该老师负责的课程列表 -->
		<div class='courses'></div>

		<!-- 操作按钮 -->
		<div class='buttons'>
			<button class='m-button' onclick='DLG_ASSN.show()'>
				<img src='images/add.png' style='width: 22px'> 布置作业
			</button>
		</div>

		<!-- 题目列表 -->
		<div class='assignments'>
		test_assign
		</div>
	</div>

	<!-- 布置作业对话框 -->
	<jsp:include page='dlg_assn.jsp' />
</body>
<script>

  	var COURSES = {};
  	COURSES.panel = $("#main-panel .courses");
  	
  	// 加载老师的课程
  	COURSES.load = function()
  	{
  		var req = {};
  		req.teacher = USER.id; // USER在header.jsp里定义
  		Af.rest ("CourseList.api", req, function(ans){
  			COURSES.show_item_list ( ans.result );
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
  		
  		// 显示该课程下的所有assignment的列表
  		this.course = id;
  		ASSN.load( id );
  		
  		
  	}
  	
////////////////// assignment //////////////////
  	var ASSN = {};
  	
  	// 当点击对话框里的确定按钮时，保存数据到后台（创建一个assignment)
  	//这个函数写在dlg_assn中不行吗，为何要写在此页；测试了一下，写在dlg_assn.jsp页也行，没发现什么错误；
  	DLG_ASSN.callback = function(info)
  	{
  		DLG_ASSN.hide(); 
  		
  		/* 当前选中的 course */
  		var course = $(".courses .item-selected").attr("id1");
  		
  		var req = {};
  		req.course = course;
  		req.title = info.title;
  		req.descr = info.descr;
  		Af.rest ("AssignmentSave.api", req, function(ans){
  			Af.trace( ans );
  			//var it = ans.result;
  			//ASSN.append ( it ); // 直接附加新的记录
  			
  			ASSN.load( COURSES.course ); // 重新加载
  		});
  	}
  	
  	// 显示课程下的所有题目
  	ASSN.load = function( course )
  	{
  		var req = {};
  		req.course = course; // 当前课程的ID
  		Af.rest ("AssignmentList.api", req, function(ans){
  			if( ans.errorCode != 0) {  toastr.error(ans.reason); return; }
  			
  			Af.trace( "课程下题目列表返回的errorCode： " + ans.errorCode );
  			
  			Af.trace( "课程下题目列表： " + ans.result );
  			
  			ASSN.show_item_list ( ans.result );
  			
  		});
  	}
  	
  	// 显示所有题目
  	ASSN.show_item_list = function(items)
  	{
   		var target = $("div.assignments");
   		target.html(""); // 清空原有数据
   		
  		for (var i=0; i<items.length; i++)
  		{
  			var it = items[i];
  			var str = "<div class='item' id1='##1' onclick='ASSN.clicked(this)'>"
  				+ it.title 
  				+ "<label style='float:right'>" + it.timeCreated.substr(0,16) + "</label>"
  				+ "</div>";
  			str = str.replace(/##1/g, it.id);
  			target.append (str);
  		}
  	}
  	
  	ASSN.append = function ( it )//添加模式，即新增一条记录，直接在后边添加，不用每次都查询；
  	{
  		
  	}
  	
	ASSN.clicked = function ( dom )
  	{
  		var id = $(dom).attr("id1");
  		location.href = "teacher/ExerciseList.jsp?assignment=" + id;
  	}
  	

   
  	///////////////////////////////////////////////
	var MAIN = {};
	MAIN.panel = $("#main-panel");
	
	//初始化
	MAIN.panel.ready(function(){
 		// 显示课程
 		COURSES.load();
	});
</script>



</html>
