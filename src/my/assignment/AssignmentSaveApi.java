package my.assignment;

import java.util.List;

import my.ApiUtility;
import my.db.Assignment;
import my.db.Teacher;
import my.dbutil.AfDbUtil;
import my.dbutil.AfSqlWhere;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import af.restful.AfRestfulApi;

public class AssignmentSaveApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(AssignmentSaveApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("....... AssignmentSaveApi .........");

		int errorCode = 0;
		String reason = "OK";
		
		// 身份认定与权限检查
		Teacher user = (Teacher) httpSession.getAttribute("user");
		if(user == null)
			ApiUtility.reply(-1, "请以老师身份登录!");

		JSONObject result = new JSONObject();
		try
		{
			JSONObject jsReq = new JSONObject(reqText);
			int course = jsReq.getInt("course");
			String title = jsReq.getString("title").trim();
			String descr = jsReq.getString("descr").trim();
			
			Assignment row = new Assignment();
			row.setTeacher( user.getId() );
			row.setCourse( course);
			row.setDescr(descr);
			row.setTitle(title);
			row.setTimeCreated(AfDbUtil.now());
			AfDbUtil.save( row );
			
			result = new JSONObject ( row );	
			
		} catch (Exception e)
		{
			e.printStackTrace();
			return ApiUtility.reply(-1, "数据库错误:" + e.getMessage());
		}

		// 应答
		JSONObject jsReply = new JSONObject();
		jsReply.put("errorCode", errorCode);
		jsReply.put("reason", reason);
		jsReply.put("result", result);
		return jsReply.toString();
	}
}
