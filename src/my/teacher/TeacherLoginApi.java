package my.teacher;

import java.util.List;

import my.ApiUtility;
import my.db.Teacher;
import my.dbutil.AfDbUtil;
import my.dbutil.AfSqlWhere;

import org.apache.log4j.Logger;

import af.restful.AfRestfulApi;
import org.json.JSONArray;
import org.json.JSONObject;
/*
 *teacher login; 
 */
public class TeacherLoginApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(TeacherLoginApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("............TeacherLoginApi execute().............");
		
		String orgId = "NA";
		
		int errorCode = 0;
		String reason = "OK";
		
	
		/* 构造查询条件 */
		JSONArray result = new JSONArray();
		try
		{
			JSONObject jsReq = new JSONObject(reqText);
			String username = jsReq.getString("username").trim();
			String password = jsReq.getString("password").trim();
			
			//检查用户名和密码是否正确；
			AfSqlWhere where = new AfSqlWhere();
			where.addExact("username", username);
			String sql = "FROM Teacher" + where;
			logger.debug("SQL:"+sql);
			
			Teacher row = (Teacher) AfDbUtil.get(sql, false);
			if(row == null)
				throw new Exception("无此用户");
			if(!password.equals(row.getPassword()))
				throw new Exception("密码错误");
			
			//校验成功，把当前用户的数据放在session中；
			httpSession.setAttribute("role", "teacher");
			httpSession.setAttribute("user", row);//此处为了方便，把一行信息都放在session中，正常不该如此；
			
			//session测试
/*			my.db.Teacher t = (my.db.Teacher)httpSession.getAttribute("user");
			org.json.JSONObject j = new org.json.JSONObject(t);
			String user = j.toString();
			System.out.println(user);*/
			
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
