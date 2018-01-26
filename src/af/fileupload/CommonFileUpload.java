package af.fileupload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import my.exercise.ExerciseUploadHandler;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.log4j.Logger;
import org.json.JSONObject;

public class CommonFileUpload extends HttpServlet
{
	static Logger logger = Logger.getLogger(CommonFileUpload.class);
		
	//TODO: 上传临时目录位置, 在BeanFactory中配置
	public static File TMPDIR = new File("c:/tmp");
	

	public CommonFileUpload()
	{		
	}
	
	// 当文件上传完后，交由不同的handler处理
	public UploadHandler createHandler(String type,HttpServletRequest request)
	{
		if("exercise".equals(type))
		{
			return new ExerciseUploadHandler( request);
		}
		
		return new UploadHandler(request);

	}
	
	// URI里带一个参数 , 例, servlet/UploadFileServlet?type=image
	@Override
	protected void doPost(HttpServletRequest request, 
			HttpServletResponse response)
			throws ServletException, IOException
	{
		doUpload(request, response);
	}
	
	public void doUpload(HttpServletRequest request, 
			HttpServletResponse response)
			throws ServletException, IOException
	{
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		request.setCharacterEncoding("UTF-8");
		String type = request.getParameter("type");
		
		// 根据请求的不同，创建不同的处理器Handler
		UploadHandler handler = createHandler(type,request);
		JSONObject result = new JSONObject();
		
		ServletFileUpload upload = new ServletFileUpload();
		
		// 表单内容: fileinfo, 文件内容 ; formitems, 其他文本类型的字段
		UploadFileItem fileinfo = new UploadFileItem();
		List<UploadFormItem> formitems = new ArrayList();
		
		// 上传前的检查
		try{
			handler.check();
		}catch(Exception e)
		{
			logger.warn("上传文件之前的检查出错: " + e.getMessage());
			reply(request, response, -1, e.getMessage(), result);
			return;
		}
		
		// 用ServletFileUpload类来解析请求
		try{
			FileItemIterator iter = upload.getItemIterator(request);
			while (iter.hasNext()) 
			{
				// 表单域 
			    FileItemStream item = iter.next();
			    String fieldName = item.getFieldName();
			    InputStream fieldStream = item.openStream();
			    if (item.isFormField())
			    {
			    	// 普通表单域: 直接读取值			    	
			    	String fieldValue = Streams.asString(fieldStream, "UTF-8");
			    	System.out.println("表单域:" + fieldName + "=" + fieldValue);
			    	formitems.add( new UploadFormItem( fieldName, fieldValue));
			    } 
			    else 
			    {
			    	// 生成唯一的文件名
			    	String fileName = item.getName();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd-HHmmss");
					String datestr = sdf.format(new Date());
					String tmpFileName = datestr + "-" + createGUID() + "." + fileSuffix(fileName);
					
			    	// 原始文件名, 即用户在浏览器里选择的文件名
			    	fileinfo.fileName = fileName;
			    	fileinfo.tmpFile = new File(TMPDIR, tmpFileName);
			    	fileinfo.size = 0;
			    	
			        logger.debug("Web上传文件:" + fileinfo.fileName + " >> " + fileinfo.tmpFile);
				        
			        // 从FieldStream读取数据, 保存到目标文件			        
			        fileinfo.tmpFile.getParentFile().mkdirs();
			        
			        FileOutputStream streamOut = new FileOutputStream(fileinfo.tmpFile);
			        byte[] buf = new byte[8192];
			        while(true)
			        {
			        	int n = fieldStream.read(buf);
			        	if(n<0) break;
			        	if(n==0) continue;			        	
			        	streamOut.write(buf, 0, n);	
			        	
			        	fileinfo.size += n;
			        }
			        fieldStream.close();
			        streamOut.close();
			        
			        // 后续处理			        
			        try
					{
			        	logger.debug("接收完成，进入后续处理:" + fileinfo.tmpFile.getAbsolutePath());
			        	result = handler.handleFile(fileinfo, formitems);
						logger.debug("处理完成:" + fileinfo.tmpFile.getAbsolutePath());
					} 
			        catch (Exception e)
					{
						e.printStackTrace();
						reply(request, response, -1, e.getMessage(), result);
						return;
					}
			    }
			}
		}
		catch(FileUploadException e)
		{
			e.printStackTrace();
			reply(request, response, -1, e.getMessage(), result);
			return;
		}
		
		reply(request, response, 0, "OK", result);	
	}
	
	public void reply(HttpServletRequest request, 
			HttpServletResponse response, 
			int errorCode, String reason, JSONObject result)
	{
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/plain");		
		JSONObject jsReply = new JSONObject();
		jsReply.put("error", errorCode);
		jsReply.put("reason", reason);
		jsReply.put("result", result);
		try{
			PrintWriter writer = response.getWriter();
			writer.write(jsReply.toString());
			writer.close();
		}catch(Exception e){}
	}

	// 工具函数: 生成一个唯一的ID
	private String createGUID ()
	{
		 String s = UUID.randomUUID().toString(); 
	     String s2 = s.substring(0,8)+s.substring(9,13)+s.substring(14,18)+s.substring(19,23)+s.substring(24); 
	     return s2.toUpperCase();
	}
	
	// 工具函数: 得到文件名后缀
	public String fileSuffix(String fileName)
	{
		int p = fileName.lastIndexOf('.');
		if(p >= 0)
		{
			return fileName.substring(p+1).toLowerCase();
		}
		return "";
	}
}
	

