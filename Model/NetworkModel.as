package Model 
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import GameEvent.NetworkEvent;
	/**
	 * 联网模块模型
	 * @author YaoQiao
	 */
	public  class NetworkModel extends EventDispatcher
	{
		
		
		
		/**
		 * 登录游戏
		 * @param	username 用户账号
		 * @param	pwd 用户密码
		 */
		public  function login(username:String,pwd:String):void
		{
			//如果账号或密码为空，则不进行登录操作
			if ((username == null) || (pwd == null))
			{
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			var para:URLVariables = new URLVariables();
			//构建登陆的用户名，密码的数据
			para.username = username;
			para.password = pwd;
			
			//设置访问地址
			request.url = GameConstModel.LOGIN_URL;
			request.data = para;
			request.method = "POST";
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, completeHandle);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandle);
			try
			{
				loader.load(request);
				
			}
			catch (e:IOErrorEvent)
			{
				var event:NetworkEvent = new NetworkEvent(NetworkEvent.SERVER_FAILED);
				dispatchEvent(event);
			}
			//发送服务器故障事件
			function ioErrorHandle(e:IOErrorEvent):void
			{
				var event:NetworkEvent = new NetworkEvent(NetworkEvent.SERVER_FAILED);
				dispatchEvent(event);
			}
			function completeHandle(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, completeHandle);
				
				var result_str:String = e.target.data;
				var result_int:int = int(result_str);
				
				//如果登陆成功，则返回的结果为1,则发送登陆成功事件;否则登录失败，返回结果0，发送登陆失败事件
				if (result_int == 1)
				{
					var event:NetworkEvent = new NetworkEvent(NetworkEvent.LOGIN_SUCCESS);
					dispatchEvent(event);
				}
				else
				{
					var evt:NetworkEvent = new NetworkEvent(NetworkEvent.LOGIN_FAILED);
					dispatchEvent(evt);
				}
				
			}
		}
		
		/**
		 * 注册用户
		 * @param	username
		 * @param	pwd
		 */
		public function register(username:String,pwd:String):void
		{
			//如果账号或密码为空，则不进行注册操作
			if ((username == null) || (pwd == null))
			{
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			var para:URLVariables = new URLVariables();
			//构建注册的用户名，密码的数据
			para.username = username;
			para.password = pwd;
			
			request.url = GameConstModel.REGISTER_URL;
			request.data = para;
			request.method = "POST";
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, completeHandle);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandle);
			try
			{
				loader.load(request);
			}
			catch (e:Error)
			{
				var event:NetworkEvent = new NetworkEvent(NetworkEvent.REGISTER_FAILED);
				dispatchEvent(event);
			}
			//发送服务器故障事件
			function ioErrorHandle(e:IOErrorEvent):void
			{
				var event:NetworkEvent = new NetworkEvent(NetworkEvent.SERVER_FAILED);
				dispatchEvent(event);
			}
			function completeHandle(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, completeHandle);
				
				var result_str:String = e.target.data;
				var result_int:int = int(result_str);
				//如果注册成功，则返回的结果为1,则发送注册成功事件;否则注册失败，返回结果0，发送注册失败事件
				if (result_int == 1)
				{
					var event:NetworkEvent = new NetworkEvent(NetworkEvent.REGISTER_SUCCESS);
					dispatchEvent(event);
				}
				else
				{
					var evt:NetworkEvent = new NetworkEvent(NetworkEvent.REGISTER_FAILED);
					dispatchEvent(evt);
				}
				
			}
		}
		
		/**
		 * 提交分数
		 * @param	username
		 * @param	score
		 */
		public function setScore(username:String,score:String):void
		{
			//如果账号或分数为空，则不进行提交分数操作
			if ((username == null) || (score == null))
			{
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			var para:URLVariables = new URLVariables();
			
			para.username = username;
			para.score = score;
			
			request.url = GameConstModel.SETSCORE_URL;
			request.data = para;
			request.method = "POST";
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, completeHandle);
			
			try
			{
				loader.load(request);
			}
			catch (e:Error)
			{
				var event:NetworkEvent = new NetworkEvent(NetworkEvent.SETSCORE_FAILED);
				dispatchEvent(event);
			}
			function completeHandle(e:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, completeHandle);
				
				var result_str:String = e.target.data;
				var result_int:int = int(result_str);
				
				//如果登陆成功，则返回的结果为1,则发送登陆成功事件;否则登录失败，返回结果0，发送登陆失败事件
				if (result_int == 1)
				{
					var event:NetworkEvent = new NetworkEvent(NetworkEvent.SETSCORE_SUCCESS);
					dispatchEvent(event);
				}
				else
				{
					var evt:NetworkEvent = new NetworkEvent(NetworkEvent.SETSCORE_FAILED);
					dispatchEvent(evt);
				}
				
			}
		}
		
		/**
		 * 获得分数的2维数组,包含用户名称，用户得分
		 * 
		 */
		public  function getScore():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			
			request.url = GameConstModel.GETSCORE_URL;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, completeHandle);
			try
			{
				loader.load(request);
			}
			catch (e:Error)
			{
				trace(e);
			}
			
			function completeHandle(e:Event)
			{
				var str:String = e.target.data;
				var evt:NetworkEvent = new NetworkEvent(NetworkEvent.RANK_COMPLETE);
				evt.rankArray = rankStringToArray(str);
				dispatchEvent(evt);
			}
		}
		
		/**
		 * 将排行字符串转化为数组
		 * @param	value
		 * @return
		 */
		private function rankStringToArray(value:String):Array
		{
			var str:String = new String();
			var temp1:Array = new Array();
			var temp2:Array = new Array();
			var temp3:Array = new Array();
			var result:Array = new Array();
			result[0] = new Array();
			result[1] = new Array();
			str = value;
			temp1 = str.split(";", str.length);
		
			//如果数据为null，则不加入数组
			for (var k:int = 0; k < temp1.length - 1;k++ )
			{
				if (temp1[k] != "null")
				{
					temp2[k] = temp1[k];
				}
			}
			
			for (var i:int = 0; i < temp2.length;i++ )
			{
				
				var s:String = temp2[i];
				temp3 = s.split(",", s.length);
				result[0][i] = temp3[0];
				result[1][i] = temp3[1];
				
			}
			//消除第一个账号名的空格
			result[0][0] = (result[0][0] as String).split("\r\n").join("");
			return result;
		}
}

}