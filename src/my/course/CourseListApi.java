package my.course;

import java.util.List;

import my.ApiUtility;
import my.dbutil.AfDbUtil;
import my.dbutil.AfSqlWhere;

import org.apache.log4j.Logger;

import af.restful.AfRestfulApi;
import org.json.JSONArray;
import org.json.JSONObject;
/*
 *此API用于显示课程列表； 
 */


public class CourseListApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(CourseListApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("............CourseListApi execute().............");
		
		String orgId = "NA";
		
		int errorCode = 0;
		String reason = "OK";
		
		JSONObject jsReq = new JSONObject(reqText);

		/* 构造查询条件 */
		AfSqlWhere where = new AfSqlWhere();		
		if(jsReq.has("teacher"))//检查jsReq中是否有teacher键：
		{
			//按教师ID查询
			where.addExact("teacher", jsReq.getInt("teacher"));
		}

		JSONArray result = new JSONArray();
		try
		{
			String sql = "FROM Course" + where; //HQL:大写的Course
			logger.debug("SQL: " + sql);
			List rows = AfDbUtil.list(sql, false);
			
			result = new JSONArray(rows);
			
		} catch (Exception e)
		{
			e.printStackTrace();
			return ApiUtility.reply(-1,"数据库错误：" + e.getMessage());
		}
		
		//应答
		JSONObject jsReply = new JSONObject();
		jsReply.put("errorCode", errorCode);
		jsReply.put("reason", reason);
		jsReply.put("result", result);
		return jsReply.toString();

	}

}
