package af.fileupload;

import java.io.File;

public class UploadFileItem
{
	public String fileName; // 原始文件名
	public File tmpFile; //   临时文件
	public long size = 0; // 文件实际长度
	
	
	public UploadFileItem()
	{		
	}
}
