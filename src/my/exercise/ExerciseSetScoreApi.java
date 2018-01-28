package my.exercise;
import my.ApiUtility;
import my.db.Exercise;
import my.db.Teacher;
import my.dbutil.DBUtil;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import af.restful.AfRestfulApi;


public class ExerciseSetScoreApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(ExerciseSetScoreApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("....... ExerciseSetScoreApi .........");

		int errorCode = 0;
		String reason = "OK";
		
		//权限检查 1：看当前登录是否是一个老师
		String role = (String)httpSession.getAttribute("role");
		if(! "teacher".equals(role))
			return ApiUtility.reply(-1, "请以老师的身份登录");
		
		//获得当前老师的信息
		Teacher user = (Teacher)httpSession.getAttribute("user");
		
		/* 查询 */
		JSONArray result = new JSONArray();
		try
		{
			JSONObject jsReq = new JSONObject(reqText);
			int exercise = jsReq.getInt("exercise");  //作业的ID
			int score = jsReq.getInt("score"); //老师给的分数
			
			//查出该作业
			String sql = "FROM Exercise WHERE id=" + exercise; //HQL
			logger.debug("SQL: " + sql);
			Exercise row = (Exercise) DBUtil.get(sql, false);
			
			if(row == null)
				throw new Exception("不存在该作业 id= " + exercise);
			
			//权限检查 2：这个作业（课程）是否由该老师负责
			if(row.getTeachear() != user.getId())
				throw new Exception("该作业不归您负责！");

			row.setScore((short) score);
			DBUtil.update(row);

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
