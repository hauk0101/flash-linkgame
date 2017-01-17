package  
{
	import Controller.GameController;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import GameEvent.NetworkEvent;
	import Model.GameSourceModel;
	import Model.NetworkModel;
	/**
	 * 文档类
	 * @author YaoQiao
	 */
	public class Main extends Sprite
	{
		
		public function Main() 
		{
			/**创建一个游戏界面 **/
			var view:Sprite = new Sprite();
			/**创建一个游戏控制器，并将游戏界面作为参数传入 **/
			var controller:GameController = new GameController(view);
			addChild(view);
			/**指定对象在具有焦点时是否显示加亮的边框 **/
			stage.stageFocusRect = false;
			
		
		}
		
		
	}

}