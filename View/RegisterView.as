package View 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import Model.GameSourceModel;
	
	/**
	 * 注册界面
	 * @author YaoQiao
	 */
	public class RegisterView extends Sprite 
	{
		
		/**注册界面所有按钮 **/
		private var btnObject:Object;
		/**注册时的用户信息 **/
		private var dataObject:Object;
		/**注册时的用户名账号 **/
		private var usernameTF:TextField;
		/**注册时的用户密码 **/
		private var pwdTF:TextField;
		/**注册时的重复密码 **/
		private var repwdTF:TextField;
		
		public function RegisterView() 
		{
			super();
			init();
		}
		
		/**
		 * 返回用户注册的基本信息，包括用户名，密码，重复密码
		 * @return
		 */
		public function getRegisterData():Object
		{
			dataObject["userName"] = usernameTF.text;
			dataObject["pwd"] = pwdTF.text;
			dataObject["repwd"] = repwdTF.text;
			return dataObject;
		}
		
		/**
		 * 返回用户注册界面的所有按钮 
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
			
			//添加注册背景框
			var registerSprite:Sprite = new RegisterSprite();
			addChild(registerSprite);
			
			//添加用户名文本框
			usernameTF = GameSourceModel.getInputTF();
			registerSprite.addChild(usernameTF);
			usernameTF.x = 170;
			usernameTF.y = 72;
			//添加用户密码文本框
			pwdTF = GameSourceModel.getInputTF();
			registerSprite.addChild(pwdTF);
			pwdTF.x = 170;
			pwdTF.y = 105;
			pwdTF.displayAsPassword = true;
			//添加用户重复密码文本框
			repwdTF = GameSourceModel.getInputTF();
			registerSprite.addChild(repwdTF);
			repwdTF.x = 170;
			repwdTF.y = 140;
			repwdTF.displayAsPassword = true;
			//添加注册按钮
			var registerBtn:SimpleButton = GameSourceModel.getButtonByName("registerBtn");
			registerSprite.addChild(registerBtn);
			registerBtn.x = 40;
			registerBtn.y = 175;
			btnObject["registerBtn"] = registerBtn;
			//添加退出按钮
			var exitBtn:SimpleButton = GameSourceModel.getButtonByName("Exit");
			registerSprite.addChild(exitBtn);
			exitBtn.x = 220;
			exitBtn.y = 175;
			btnObject["exitBtn"] = exitBtn;
		}
	}

}