<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<style>
	#header
	{
		width: 80%;
		margin: auto auto;
		pading: 10px
	}
	
	#header .logo
	{
		font-size: 30px;
	}
	
	#header .userinfo
	{
		float: right;
		right： 40px;
		top: 40px;
	}



</style>


<div id = 'header'>

	<label> 作业管理系统 </label>

	<div class='userinfo'>
		未登录
	</div>

</div>

<script>

	var ROLE = <%= my.jsp.JspSession.getString(request, "role", "") %>;
	var USER = <%= my.jsp.JspUtil.currentUser(request) %>;
	
	if("student" != ROLE)
	{
		location.href = "student/login.jsp";
	}
	else
	{
		$(".userinfo").html(USER.displayName);
	}
</script>







