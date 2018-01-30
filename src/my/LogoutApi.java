package my;

import my.ApiUtility;

import org.apache.log4j.Logger;
import af.restful.AfRestfulApi;
import org.json.JSONObject;
/*
 *teacher login; 
 */
public class  LogoutApi extends AfRestfulApi
{
	static Logger logger = Logger.getLogger(LogoutApi.class);

	@Override
	public String execute(String reqText) throws Exception
	{
		logger.debug("........... LogoutApi execute().............");
		
		String orgId = "NA";
		
		int errorCode = 0;
		String reason = "OK";
		
		try
		{
			httpSession.setAttribute("role", null);
			httpSession.setAttribute("user", null);
			
		} catch (Exception e)
		{
			e.printStackTrace();
			return ApiUtility.reply(-1,"错误：" + e.getMessage());
		}
		
		//应答
		JSONObject jsReply = new JSONObject();
		jsReply.put("errorCode", errorCode);
		jsReply.put("reason", reason);
		return jsReply.toString();
	}
}
