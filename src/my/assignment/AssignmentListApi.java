package my.assignment;

import java.util.List;

import my.ApiUtility;
import my.course.CourseListApi;
import my.db.Teacher;
import my.dbutil.DBUtil;
import my.dbutil.SqlWhere;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import af.restful.AfRestfulApi;

public class AssignmentListApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(AssignmentListApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("....... AssignmentListApi .........");

		int errorCode = 0;
		String reason = "OK";
		
		// 身份认定与权限检查
		Teacher user = (Teacher) httpSession.getAttribute("user");
			//此处的httpSession是从父类中继承来的，可查看父类代码；
		if(user == null)
			ApiUtility.reply(-1, "请以老师的身份登录");
		
		/* 查询 */
		JSONArray result = new JSONArray();
		try
		{
			JSONObject jsReq = new JSONObject(reqText);
			int course = jsReq.getInt("course");
			
			//根据课程ID查询相关的题目；
			SqlWhere where = new SqlWhere();
			where.addExact("course", course);
			String sql = "FROM Assignment " + where;
			logger.debug("SQL: " + sql);
			List rows = DBUtil.list(sql, false);
			result = new JSONArray(rows);
			
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
