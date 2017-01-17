package View 
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import Model.GameSourceModel;
	
	/**
	 * 游戏排行榜界面
	 * @author YaoQiao
	 */
	public class GameOrderView extends Sprite 
	{
		//排行榜背景
		private var background:Sprite;
		
		//游戏排行数据数组
		private var dataArr:Array;
		//游戏排行榜文本框数组
		private var tfArr:Array;
		//游戏排行榜文本框中的内容
		private var tftextArr:Array;
		//存放游戏排行界面里的所有元素
		private var viewObj:Object;
		//存放所有按钮
		private var btnObj:Object;
		
		//用户姓名
		private var USER_NAME:String;
		//当前用户得分
		private var currentScore:String;
		
		public function GameOrderView() 
		{
			super();
			init();
		}
		
		/**
		 * 设置游戏状态
		 * @param	state
		 */
		public function setGameState(state:String):void
		{
			//根据不同的状态选择不同的界面效果
			switch(state)
			{
				//游戏开始前，查看排行榜
				case "before":
					showBeforeGame();
					break;
				//游戏结束后，显示排行榜
				case "over":
					showOverGame();
					break;
				default:
					break;
			}
			
		}
		
		/**
		 * 返回排行榜界面的所有按钮
		 */
		public function get buttons():Object
		{
			return btnObj;
		}
		/**
		 * 设置排行榜数据
		 * @param	value
		 */
		public function setScoreData(value:Array,username:String = null,score:String = null):void
		{
			this.dataArr = value;
			this.USER_NAME = username;
			this.currentScore = score;
			
			updateData();
		}
		
		private function showOverGame():void
		{
			//需要显示的内容有左边的图片，返回按钮，排行榜数据
			viewObj["restartBtn"].visible = true;
			viewObj["overPic"].visible = true;
			viewObj["exitBtn"].visible = true;
			viewObj["leftTF"].visible = true;
			
			
			//需要隐藏的内容有游戏结束后左边的图片，再玩一次按钮，退出游戏按钮
			viewObj["beforePic"].visible = false;
			viewObj["backBtn"].visible = false;
		}
		/**
		 * 显示游戏开始前的排行榜界面
		 */
		private function showBeforeGame():void
		{
			//需要显示的内容有左边的图片，返回按钮，排行榜数据
			viewObj["beforePic"].visible = true;
			viewObj["backBtn"].visible = true;
			
			//需要隐藏的内容有游戏结束后左边的图片，再玩一次按钮，退出游戏按钮
			viewObj["restartBtn"].visible = false;
			viewObj["overPic"].visible = false;
			viewObj["exitBtn"].visible = false;
			
			
		}
		
		/**
		 * 更新排行榜数据
		 */
		private function updateData():void
		{
			
			var nameArr:Array = new Array();
			var scoreArr:Array = new Array();
			
			nameArr = dataArr[0];
			scoreArr = dataArr[1];
			
			//填充文本框内容数组
			for (var i:int = 0; i < nameArr.length;i++ )
			{
				tftextArr[i] =   (nameArr[i] as String) + " : " + (scoreArr[i] as String);
			}
			
			//显示排行榜数据
			showData();
			
			//显示本关游戏分数
			if (USER_NAME != null)
			{
				if (currentScore == null)
				{
					for (var j :int = 0; j < nameArr.length;j++ )
					{
						if (nameArr[j] == USER_NAME)
						{
							var score:String = scoreArr[j] as String;
							viewObj["leftTF"].text = score;
						}
					}
				}
				else
				{
					viewObj["leftTF"].text = currentScore;
				}
				
			}
			
		}
		
		/**
		 * 显示排行榜数据
		 */
		private function showData():void
		{
			for (var i:int = 0; i < tftextArr.length;i++ )
			{
				(tfArr[i] as TextField).text = tftextArr[i];
				(tfArr[i] as TextField).visible = true;
			}
		}
		 
		/**
		 * 初始化
		 */
		private function init():void
		{
			//数据初始化
			dataArr = new Array();
			viewObj = new Object();
			tfArr = new Array();
			btnObj = new Object();
			tftextArr = new Array();
			
			//添加背景
			background = new GameOrderSprite();
			addChild(background);
			
			//当游戏未开始时的左边图片
			var beforePic:Bitmap = new Bitmap();
			beforePic.bitmapData = new GameOrderFeft1();
			background.addChild(beforePic);
			beforePic.visible = false;
			beforePic.x = 60;
			beforePic.y = 60;
			viewObj["beforePic"] = beforePic;
			
			//当游戏结束时的左边图片
			var overPic:Bitmap = new Bitmap();
			overPic.bitmapData = GameSourceModel.getGameStateByName("over");
			background.addChild(overPic);
			overPic.x = 50;
			overPic.y = 50;
			overPic.visible = false;
			viewObj["overPic"] = overPic;
			
			/********排行榜页面的按钮*****************/
			//重玩按钮
			var restartBtn:SimpleButton = GameSourceModel.getButtonByName("Restart");
			background.addChild(restartBtn);
			restartBtn.x = 60;
			restartBtn.y = 310;
			restartBtn.visible = false;
			viewObj["restartBtn"] = restartBtn;
			btnObj["restartBtn"] = restartBtn;
			
			//退出按钮
			var exitBtn:SimpleButton = new ExitBtn2();
			exitBtn.x = 210;
			exitBtn.y = 310;
			background.addChild(exitBtn);
			exitBtn.visible = false;
			viewObj["exitBtn"] = exitBtn;
			btnObj["exitBtn"] = exitBtn;
			
			//返回按钮
			var backBtn:SimpleButton = GameSourceModel.getButtonByName("Back");
			background.addChild(backBtn);
			backBtn.x = 150;
			backBtn.y = 300;
			backBtn.visible = false;
			viewObj["backBtn"] = backBtn;
			btnObj["backBtn"] = backBtn;
			
			/***********排行榜页面的文本框****************/
			var leftTF:TextField =  GameSourceModel.getTextField();
			leftTF.x = 130; 
			leftTF.y = 227;
			leftTF.visible = false;
			background.addChild(leftTF);
			viewObj["leftTF"] = leftTF;
			
			for (var i:int = 0; i < 7;i++ )
			{
				var tf:TextField  = GameSourceModel.getScoreTF();
				tf.x = 372;
				if (i < 3)
				{
					tf.y = 80 + i * 45;
				}
				if (i == 3)
				{
					tf.y = 210;
				}
				if (i > 3)
				{
					tf.y = 240 + (i % 4) * 30;
				}
				
				tf.visible = false;
				background.addChild(tf);
				tfArr[i] = tf;
				
			}
			
		}
	}

}