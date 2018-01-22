package my.exercise;

import java.util.List;

import my.ApiUtility;
import my.course.CourseListApi;
import my.db.Teacher;
import my.dbutil.AfDbUtil;
import my.dbutil.AfSqlWhere;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import af.restful.AfRestfulApi;

/* 查询某个作业列表：
 * 
 * 老师调用时： 查询某个题目下的所有学生的作业列表 where assignment=nnn
 * 学生调用时： 查询某个课程下的所有自己的作业列表 where course=nnn AND student=sss
*/


public class ExerciseListApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(ExerciseListApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("....... ExerciseListApi .........");

		int errorCode = 0;
		String reason = "OK";
		
		JSONObject jsReq = new JSONObject(reqText);
		
		/* 构造查询条件  */
		AfSqlWhere where = new AfSqlWhere();
		if(jsReq.has("course"))
		{
			//按课程查询
			where.addExact("course", jsReq.getInt("course"));
		}
		if(jsReq.has("assignment"))
		{
			// 按题目查询
			where.addExact("assignment", jsReq.getInt("assignment"));
		}
		if(jsReq.has("student"))
		{
			// 按学生查询
			where.addExact("student", jsReq.getInt("student"));
		}
		
		
		/* 查询 */
		JSONArray result = new JSONArray();
		try
		{
			String sql = "FROM Exercise" + where;//HQL:大写的表名开头字母
			logger.debug("SQL: " + sql);
			List rows = AfDbUtil.list(sql, false);
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
