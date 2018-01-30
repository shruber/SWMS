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

	#header .logout
	{
		float: right;
		right： 40px;
		top: 40px;
	}

</style>


<div id = 'header'>

	<label> 作业管理系统 </label>
	
	<div class='logout' >
		<a onclick="HEADER.logout()" > &nbsp 退出 </a>
	</div>
	
	<div class='userinfo'>
		未登录
	</div>


</div>

<script>
	var HEADER = {};
	var ROLE = <%= my.jsp.JspSession.getString(request, "role", "") %>;
	var USER = <%= my.jsp.JspUtil.currentUser(request) %>;

	HEADER.div = $("#header");
	
	if("student" != ROLE)
	{
		location.href = "student/login.jsp";
	}
	else
	{
		$(".userinfo").html(USER.displayName);
	}
	
	HEADER.logout = function()
	{
		req = {};
		Af.rest("Logout.api", req, function(ans){
			Af.trace(ans);
			//error hint 
 			if(ans.errorCode != 0)
			{
				toastr.error("退出失败！");
				return;
			}
			
			//success
			location.href = "student/login.jsp";
			});
	};
	
	//初始化
	HEADER.div.ready(function(){
	
	});
</script>







