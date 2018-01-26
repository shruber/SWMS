package my.assignment;

import java.util.List;

import my.ApiUtility;
import my.db.Assignment;
import my.db.Exercise;
import my.db.Teacher;
import my.dbutil.DBUtil;
import my.dbutil.SqlWhere;

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
			row.setTimeCreated(DBUtil.now());
			DBUtil.save( row );
			
			result = new JSONObject ( row );	
			
			//同时往exercise里填作业，作业的状态为0
			addExerciseList(row);			
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
	
	private void addExerciseList(Assignment a) throws Exception
	{
		//
		String s1 = "SELECT id FROM student";
		List<String> students = DBUtil.list(s1, true);
		
		//
		for(String student : students)
		{
			Exercise row = new Exercise();
			row.setAssignment(a.getId());
			row.setCourse(a.getCourse());
			row.setScore((short)0);
			row.setStatus((short)0);
			row.setStorePath(null);
			row.setStudent(student);
			row.setTeachear(a.getTeacher());
			row.setTimeCreated(DBUtil.now());
			row.setTitle(a.getTitle());
			
			DBUtil.save(row);
		}
	}
	
	
}
