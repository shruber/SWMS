<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>学生视角：查看作业、提交作业</title>
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
		
		<!-- 作业文件的上传 -->
		<button class='m-button upload-button' onclick='MAIN.upload()'> 上传作业文件 </button>
		<label class='filename'> </label>
		<div class='progressbar'> <div class='percent'></div> </div>
	</div>
	
	<jsp:include page = "simple_upload.jsp"></jsp:include>

</body>

<script>
	var MAIN = {};
	MAIN.panel = $("#main-panel");
	MAIN.assignment = <%= my.jsp.JspUtil.getAssignment(request) %>;
	MAIN.exercise = <%= my.jsp.Jsp.getInt(request, "exercise", 0) %>;
	MAIN.exerciseObj = <%= my.jsp.JspUtil.getExercise(request) %>;
	MAIN.show_assignment = function(it)
	{
		var p = $(".assignment");
		$(".title", p).html(it.title);
		$(".descr", p).html(it.descr);
		
		if(this.exerciseObj.status != 0)
		{
			var storePath = this.exerciseObj.storePath;
			var str = "<a href='" + storePath + "'> 查看 </a>";
			$(".progressbar").html(str);
		}
	}
	
	//上传文件
	MAIN.upload = function()
	{
		this.progress = $(".percent");
		
		SIMPLE_UPLOAD.listener = {
			
			/* 后台URL */
			uploadUrl : "CommonFileUpload?type=exercise&id=" + MAIN.exercise,
			
			/* 检查文件是否允许上传 */
			check : function(file) { return true;},
			
			/* 显示文件信息 */
			ready : function(file) {
				$(".filename").html(file.name);
			},
			
			/* 显示文件上传进度 */
			progress: function(context, percent){
				MAIN.progress.html(percent);
			},
			
			/* 显示文件上传出错提示 */
			error : function(context, error){},
			
			/* 文件上传已经成功 */
			complete: function(message){
				MAIN.progress.html("完成！");
				var ans = JSON.parse(message);
				if(ans.error == 0)
				{
					var storePath = ans.result.storePath;
					var str = "<a href='" + storePath + "'> 查看 </a>";
					$(".progressbar").html(str);
				}
			},
			
			end_of_class: null /* class结束 */
		}
		
		SIMPLE_UPLOAD.user_select_file();		
	}
	
	
	//初始化
	MAIN.panel.ready(function(){
 		MAIN.show_assignment(MAIN.assignment);
 		
	});
</script>
</html>
