package my.jsp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import my.db.Assignment;
import my.dbutil.AfDbUtil;

import org.json.JSONObject;

public class JspUtil
{
	// 获取一道题目的详细内容
	public static JSONObject getAssignment ( HttpServletRequest httpReq) throws Exception
	{
		int assignment = Jsp.getInt(httpReq, "assignment", 0);
		String sql = "FROM Assignment WHERE id=" + assignment;
		Assignment row = (Assignment) AfDbUtil.get(sql, false);
		return new JSONObject(row);
	}
}
