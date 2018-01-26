package af.fileupload;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;


public class UploadHandler
{	
	protected HttpServletRequest httpReq;
	protected HttpSession httpSession;
	
	public UploadHandler(HttpServletRequest httpReq)
	{
		this.httpReq = httpReq;
		this.httpSession = httpReq.getSession();
	}
	
	//  上传前的检测
	public void check() throws Exception
	{
		
	}
	
	// 文件已经上传(临时文件的信息在fileItem里), 此函数作后续处理
	// fileinfo : 临时文件的相关信息
	// formitems: 表单里的其他字段
	public JSONObject handleFile ( UploadFileItem fileinfo, List<UploadFormItem> formitems) throws Exception
	{
		return new JSONObject();
	}
}
