package View 
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import Model.GameSourceModel;
	
	/**
	 * 帮助界面
	 * @author YaoQiao
	 */
	public class HelpView extends Sprite 
	{
		
		public function HelpView() 
		{
			super();
			
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			//添加帮助文字的图片
			var helpBmp:Bitmap = new Bitmap();
			helpBmp.bitmapData = GameSourceModel.getTextBmpDataByName("gameHelp");
			addChild(helpBmp);
			
			
			//添加“返回”按钮
			var backBtn:SimpleButton = new SimpleButton();
			backBtn = GameSourceModel.getButtonByName("Back");
			addChild(backBtn);
			backBtn.x = 460;
			backBtn.y = 360;
			//添加返回按钮侦听
			backBtn.addEventListener(MouseEvent.CLICK,backHandle);
		}
		
		/**
		 * 返回处理函数
		 */
		private function backHandle(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.CLICK, backHandle);
			this.parent.removeChild(this);
		}
	}

}