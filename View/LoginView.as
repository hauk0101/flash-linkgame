package View 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import Model.GameSourceModel;
	
	/**
	 * 登录界面
	 * @author YaoQiao
	 */
	public class LoginView extends Sprite 
	{
		/**登录界面所有按钮**/
		private var btnObject:Object;
		/**登录时的用户信息 **/
		private var dataObject:Object;
		/**登录时用户名账号 **/
		private var usernameTF:TextField;
		/**登录时用户名密码 **/
		private var pwdTF:TextField;
		
		
		public function LoginView() 
		{
			super();
			init();
		}
		
		/**
		 * 返回登录的用户信息，包括用户名和密码
		 * @return
		 */
		public function getLoginData():Object
		{
			dataObject["userName"] = usernameTF.text;
			dataObject["pwd"] = pwdTF.text;
			return dataObject;
		}
		
		/**
		 * 返回登录界面的所有按钮
		 * @return
		 */
		public function getBtnObject():Object
		{
			return btnObject;
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			//初始化变量
			dataObject = new Object();
			btnObject = new Object();
			
			//添加登录背景框 
			var loginSprite:Sprite = new LoginSprite();
			addChild(loginSprite);
			
			//添加用户名文本框
			usernameTF = GameSourceModel.getInputTF();
			loginSprite.addChild(usernameTF);
			usernameTF.x = 165;
			usernameTF.y = 88;
			//添加用户密码文本框
			pwdTF = GameSourceModel.getInputTF();
			loginSprite.addChild(pwdTF);
			pwdTF.displayAsPassword = true;
			pwdTF.x = 165;
			pwdTF.y = 125;
			//添加登录按钮
			var loginBtn:SimpleButton = GameSourceModel.getButtonByName("loginBtn");
			loginSprite.addChild(loginBtn);
			loginBtn.x = 18;
			loginBtn.y = 160;
			btnObject["loginBtn"] = loginBtn;
			//添加注册按钮
			var registerBtn:SimpleButton = GameSourceModel.getButtonByName("registerBtn");
			loginSprite.addChild(registerBtn);
			registerBtn.x = 131;
			registerBtn.y = 160;
			btnObject["registerBtn"] = registerBtn;
			//添加退出按钮
			var exitBtn:SimpleButton = GameSourceModel.getButtonByName("Exit");
			loginSprite.addChild(exitBtn);
			exitBtn.x = 248;
			exitBtn.y = 160;
			btnObject["exitBtn"] = exitBtn;
		}
	}

}