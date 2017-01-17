package Controller 
{
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import Model.GameSoundModel;
	import Model.GameSourceModel;
	import View.GameConnectView;
	import View.GameInitView;
	import View.GamePrivateView;
	import View.HelpView;
	import View.LoginView;
	import View.RegisterView;
	/**
	 * 主游戏控制器
	 * @author YaoQiao
	 */
	public class GameController 
	{
		/**游戏显示容器 **/
		private var gameSprite:Sprite;
		/**游戏开始前的页面 **/
		private var initView:GameInitView;
		/**游戏按钮的提示文本 **/
		private var tipTF:TextField;
		
		/**
		 * 需要设置显示的容器
		 * @param	display
		 */
		public function GameController(display:Sprite):void 
		{
			this.gameSprite = display;
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			//获得游戏开始前背景，“单机版”按钮，“联网版”按钮，“帮助”按钮
			var background:BitmapData = GameSourceModel.getBackgroundByName("cover");
			var danjiBtn:SimpleButton = GameSourceModel.getButtonByName("danjiBtn");
			var lianwangBtn:SimpleButton = GameSourceModel.getButtonByName("LianwangBtn");
			var helpBtn:SimpleButton = GameSourceModel.getButtonByName("Help");
			
			
			
			initView = new GameInitView();
			initView.setButton(background, danjiBtn, lianwangBtn, helpBtn);
			gameSprite.addChild(initView);
			addListen(initView.buttons);
			
			//提示文本
			tipTF = GameSourceModel.getTextField("", 14, 70, 25,0x000000);
			tipTF.background = true;
			tipTF.backgroundColor = 0xFFFFFF;
			tipTF.border = true;
			tipTF.visible = false;
			tipTF.autoSize = "center";
			gameSprite.addChild(tipTF);
		}
		
		/**
		 * 添加页面的三个按钮的侦听
		 * @param	obj
		 */
		private function addListen(obj:Object):void
		{
			var _obj:Object = obj;
			//添加“单机版”按钮的侦听
			(_obj["danjiBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, danjiHandle);
			//添加“联网版”按钮的侦听
			(_obj["lianwangBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, lianwangHandle);
			//添加“查看帮助”按钮的侦听
			(_obj["helpBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, helpHandle);
			
			//添加鼠标滑过之后做出相应提示的侦听
			(_obj["danjiBtn"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, danjiOverHandle);
			(_obj["lianwangBtn"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, lianwangOverHandle);
			(_obj["helpBtn"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, helpOverHandle);
			
			//添加鼠标滑出之后做出相应的侦听
			(_obj["danjiBtn"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT, danjiOutHandle);
			(_obj["lianwangBtn"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT, lianwangOutHandle);
			(_obj["helpBtn"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT, helpOutHandle);
			
			//单机按钮处理函数
			function danjiHandle(e:MouseEvent):void
			{
				var danjiView:GamePrivateView = new GamePrivateView();
				var danjiSound:GameSoundModel = new GameSoundModel();
				var danjiControll:PrivateGameController = new PrivateGameController(gameSprite, danjiView,danjiSound);
				
				
				danjiSound.playBackgroundState = true;
				danjiSound.playReadySound();
				
			}
			
			//联网按钮处理函数
			function lianwangHandle(e:MouseEvent):void
			{
				var loginView:LoginView = new LoginView();
				var registerView:RegisterView = new RegisterView();
				var gameView:GameConnectView = new GameConnectView();
				var sound:GameSoundModel = new GameSoundModel();
				var connectController:ConnectGameController = new ConnectGameController(gameSprite, loginView, registerView, gameView,sound);
				
			}
			
			//查看帮助按钮处理函数
			function helpHandle(e:MouseEvent):void
			{
				var helpView:HelpView = new HelpView();
				gameSprite.addChild(helpView);
			}
			
			//鼠标滑至按钮上做出的处理
			function danjiOverHandle(e:MouseEvent):void
			{
				tipTF.text = "单机游戏";
				tipTF.x =  e.target.x;
				tipTF.y =  e.target.y + e.target.height;
				tipTF.visible = true;
			}
			
			function lianwangOverHandle(e:MouseEvent):void
			{
				tipTF.text = "联网游戏";
				tipTF.x =  e.target.x;
				tipTF.y =  e.target.y + e.target.height;
				tipTF.visible = true;
			}
			
			function helpOverHandle(e:MouseEvent):void
			{
				tipTF.text = "查看帮助";
				tipTF.x =  e.target.x;
				tipTF.y =  e.target.y + e.target.height;
				tipTF.visible = true;
			}
			
			//鼠标滑出按钮上做出的处理
			function danjiOutHandle(e:MouseEvent):void
			{
				tipTF.visible = false;
			}
			
			function lianwangOutHandle(e:MouseEvent):void
			{
				tipTF.visible = false;
			}
			
			function helpOutHandle(e:MouseEvent):void
			{
				tipTF.visible = false;
			}
		}
	}

}