package GameEvent 
{
	import flash.events.Event;
	
	/**
	 * 网络连接自定义事件
	 * @author YaoQiao
	 */
	public class NetworkEvent extends Event 
	{
		/**登录成功 **/
		public static const LOGIN_SUCCESS:String = "login sucess";
		/**登录失败 **/
		public static const LOGIN_FAILED:String = "login failed";
		/**服务器故障 **/
		public static const SERVER_FAILED:String = "server failed";
		/**注册成功 **/
		public static const REGISTER_SUCCESS:String = "register sucess";
		/**注册失败 **/
		public static const REGISTER_FAILED:String = "register failed";
		/**提交分数成功 **/
		public static const SETSCORE_SUCCESS:String = "setscore sucess";
		/**提交分数失败 **/
		public static const SETSCORE_FAILED:String = "setscore failed";
		/**加载排行榜数据完成 **/
		public static const RANK_COMPLETE:String = "rank complete";
		
		/**返回游戏排行的数组 **/
		public var rankArray:Array;
		public function NetworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}