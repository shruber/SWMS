<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!-- 简单的单一文件上传 -->
<form style='display:none;'>
   <input type='file' id='simple-file-upload' onchange='SIMPLE_UPLOAD.on_file_selected(this)'/>
</form>

<script>

var SIMPLE_UPLOAD = 
{	
	/* 默认listener : 调用者应重写这几个参数 */
	listener : {
	
		/* 后台URL */
		uploadUrl : "CommonFileUpload",
	
		/* 检查文件是否允许上传 */
		check : function ( file ) { return true; } ,
		
		/* 显示文件信息 */
		ready: function ( file ) { },
		
		/* 显示文件上传进度 */
		progress: function( context, percent) { },
		
		/* 显示文件上传出错提示 */
		error : function(context, error){ },
		
		/* 文件后传已经成功 */
		complete: function ( message ) {  },
		
		end_of_class: null  /* class结束 */	
	},
	
	/* 用户调用这个函数来选择文件 */
	user_select_file : function()
	{
		$("#simple-file-upload").click();
	},
	
	/* 选中处理 */
	on_file_selected : function ( filebutton )
	{
		var files = filebutton.files;	
		if(files == null) return;
		this.start_upload ( files[0]);
		
		// 重置文件输入按钮
		$(filebutton).val("");
	},
	
	/* 启动上传 */
	start_upload : function( file )
	{		
		if( ! this.listener.check (file)) return;
		this.listener.ready ( file );
		
		// file有如下字段: name, size, type ("image/jpeg"), lastModified
		Af.trace("开始上传: " + file.name);
		var context = {};
	    context.file = file;  
	    context.listener = this.listener;
	    
	   	var vFD = new FormData();
		vFD.append('fileupload', file); 
		
	    var oXHR = new XMLHttpRequest();
	    oXHR.context = context;
	    oXHR.upload.context = context;
	    oXHR.upload.addEventListener("progress", this.evt_upload_progress, false);
	    oXHR.addEventListener("load", this.evt_upload_complete, false);
	    oXHR.addEventListener("error", this.evt_upload_failed, false);
	    oXHR.addEventListener("abort", this.evt_upload_cancel, false);
	
		context.vFD = vFD;
	    context.oXHR = oXHR; /* 保存这个上传者对象, 用于调用其abort()函数 */
	    
	    oXHR.open("POST", context.listener.uploadUrl );
	    oXHR.send(vFD);
	},
	
	evt_upload_progress : function (evt) 
	{
	    if (evt.lengthComputable)
	    {
	    	var percent = Math.round(evt.loaded * 100 / evt.total);
	    	Af.trace ("上传进度: " + percent);
	    	this.context.listener.progress ( this.context, percent);
	    }	        
	    else 
	    {
	    	Af.trace("浏览器不支持上传进度的显示！");
	    }
	},
	
	evt_upload_complete : function (evt)
	{
		Af.trace (evt.target.responseText); 
		/*
	    var ans = JSON.parse(evt.target.responseText);	    
	    if(ans.error == 0)
	    	this.context.listener.complete ( ans.result);
	    else
	    	this.context.listener.error (this.context, ans.reason);
	    */
	   this.context.listener.complete ( evt.target.responseText );
	},
 
	evt_upload_failed : function (evt) 
	{
		this.context.listener.error (this.context, "上传失败!");	
	},
	
	evt_upload_cancel : function (evt) 
	{
		this.context.listener.error (this.context, "上传中止!");	
	},
	
	end_of_class: null  /* class结束 */	
};

	
</script>


