package Model 
{
	/**
	 * 游戏常量
	 * @author YaoQiao
	 */
	public class GameConstModel 
	{
		/**游戏登录访问地址 **/
		public static const LOGIN_URL:String = "http://localhost:8888/Game/GameLogin.jsp";
		/**游戏用户注册访问地址 **/
		public static const REGISTER_URL:String = "http://localhost:8888/Game/Regist.jsp";
		/**提交游戏得分访问地址 **/
		public static const SETSCORE_URL:String = "http://localhost:8888/Game/SetScore.jsp";		
		/**获取排行榜访问地址 **/
		public static const GETSCORE_URL:String = "http://localhost:8888/Game/GetScore.jsp";
		
		/**游戏提示最高次数 **/
		public static const GAME_TIP_NUMBER:int = 3;
		/**游戏重列最高次数 **/
		public static const GAME_ORDER_NUMBER:int = 3;
		/**设置游戏中卡片总共的行数 **/
		public static const GAME_ROW:int = 6;
		/**设置游戏中卡片总共的列数 **/
		public static const GAME_COLUM:int = 9;
		/**卡片离舞台左边的距离 **/
		public static const MarginLeft:Number = 5;
		/**卡片离舞台顶端的距离 **/
		public static const MarginTop:Number = 15;
		/**卡片与卡片之间的距离 **/
		public static const MarginCards:Number = 1;
	}

}