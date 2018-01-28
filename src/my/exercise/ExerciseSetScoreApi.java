package my.exercise;
import my.ApiUtility;
import my.db.Exercise;
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
