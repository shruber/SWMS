package my.exercise;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import my.Config;
import my.db.Exercise;
import my.dbutil.DBUtil;
import my.util.CommonUtility;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.json.JSONObject;


import af.fileupload.UploadFileItem;
import af.fileupload.UploadFormItem;
import af.fileupload.UploadHandler;

public class ExerciseUploadHandler extends UploadHandler
{
	static Logger logger = Logger.getLogger(ExerciseUploadHandler.class);
	
	int exercise = 0;

	public ExerciseUploadHandler(HttpServletRequest httpReq)
	{
		super(httpReq);
	}

	@Override
	public void check() throws Exception
	{
		//从url里取出作业ID
		exercise = Integer.valueOf(this.httpReq.getParameter("id"));
	}

	@Override
	public JSONObject handleFile(UploadFileItem fileinfo,
			List<UploadFormItem> formitems) throws Exception
	{
		String sql = "FROM Exercise WHERE id=" + exercise;
		Exercise row = (Exercise) DBUtil.get(sql, false);
		if(row == null)
			throw new Exception("无效的作业ID，" + exercise);
		
		//删除上一次上传的文件
		try
		{
			String path = httpReq.getSession().getServletContext().getRealPath("/");
			File f = new File(path, row.getStorePath());
			FileUtils.deleteQuietly(f);
			
		}catch(Exception e)
		{
			
		}
		
		//转移文件
		File tmpFile = fileinfo.tmpFile;
		String storePath = "files/" + CommonUtility.date2Path2() + fileinfo.fileName;
		
		//重点在于获得WebRoot的绝对路径；
		String path = httpReq.getSession().getServletContext().getRealPath("/");
		logger.debug("Exercise handler WebRootPath: " + path);
		
		File dstFile = new File(path, storePath);

		dstFile.getParentFile().mkdirs();
		
		FileUtils.moveFile(tmpFile, dstFile);
		
		
		
		//更新数据库
		row.setStorePath( storePath );
		row.setStatus( (short) 1);
		DBUtil.update( row );
		logger.debug("文件转移到: " + dstFile);
		
		JSONObject result = new JSONObject();
		result.put("storePath", storePath);
		return result;
	}
	

	
	

}
