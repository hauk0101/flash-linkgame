package View 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * 打开游戏后出现的界面，包括可供用户选择的“单机版”，“联网版”，“查看帮助”的按钮
	 * @author YaoQiao
	 */
	public class GameInitView extends Sprite 
	{
		/**背景**/
		private var background:Bitmap = new Bitmap();
		/**“单机版”按钮 **/
		private var privateBtn:SimpleButton = new SimpleButton();
		/**"联网版"按钮 **/
		private var internetBtn:SimpleButton = new SimpleButton();
		/**"查看帮助"按钮 **/
		private var helpBtn:SimpleButton = new SimpleButton();
		public function GameInitView() 
		{
			super();
			init();
		}
		
		/**
		 * 设置背景，“单机版”按钮，“联网版”按钮，“帮助”按钮
		 */
		public function  setButton(display:BitmapData,danjiBtn:SimpleButton,lianwangBtn:SimpleButton,helpBtn:SimpleButton):void
		{
			this.background.bitmapData = display;
			this.privateBtn = danjiBtn;
			this.internetBtn = lianwangBtn;
			this.helpBtn = helpBtn;
			
			init();
		}
		
		/**
		 * 返回按钮的Object,里面包括3个按钮，用名称作为索引
		 */
		public function get buttons():Object
		{
			var obj:Object = new Object();
			obj["danjiBtn"] = this.privateBtn;
			obj["lianwangBtn"] = this.internetBtn;
			obj["helpBtn"] = this.helpBtn;
			return obj;
		}
		/**
		 * 初始化
		 */
		private function init():void
		{
						
			addChild(background);
			addChild(privateBtn);
			privateBtn.x = 150;
			privateBtn.y = 140;
			
			addChild(internetBtn);
			internetBtn.x = 250;
			internetBtn.y = 140;
			
			addChild(helpBtn);
			helpBtn.x = 350;
			helpBtn.y = 140;
		}
	}

}