package View 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import Model.GameSourceModel;
	
	/**
	 * 单人版游戏界面
	 * @author YaoQiao
	 */
	public class GamePrivateView extends Sprite 
	{
		/**时间条遮罩 **/
		private var timeBarMask:Shape;
		/**当前关卡数**/
		private var levelTF:TextField;
		/**当前分数 **/
		private var scoreTF:TextField;
		/**提示次数 **/
		private var gameTipNum:Bitmap;
		/**重列次数 **/
		private var gameOrderNum:Bitmap;
		/**显示游戏内容(卡片)面板 **/
		private var gameShowPanel:Sprite;
		/**需要更新的所有数据 **/
		private var dataObj:Object;
		/**面板中所有能够操作的按钮**/
		private var buttonsObj:Object;
		/**时间条遮罩的长度 **/
		private var _maskWidth:Number;
		
		//游戏结束时需要隐藏的内容数组
		private var overCoverArr:Array = new Array();
		
		public function GamePrivateView() 
		{
			super();
			init();
		}
		
		/**
		 * 设置要更新的数据
		 * @param	obj
		 */
		public function setData(obj:Object):void
		{
			dataObj = obj;
			//更新数据
			update();
		}
		
		/**
		 * 设置游戏的状态，分为，开始前、暂停、游戏中
		 * @param	state
		 */
		public function setGameState(state:String):void
		{
			var count:int = gameShowPanel.numChildren;
			//先删除游戏面板的所有子对象
			for (var i:int = 0; i < count;i++ )
			{
				gameShowPanel.removeChildAt(0);
			}
			//根据传入的状态添加不同的内容
			switch(state)
			{
				case "before":
					//移除除按钮外的所有内容
					coverOverContent();
					var show:Bitmap = new Bitmap();
					show.bitmapData = new GameStartPicture();
					gameShowPanel.addChild(show);
					timeBarMask.x = -300;
					break;
				case "pause":
					var pauseBmp:Bitmap = new Bitmap();
					pauseBmp.bitmapData = GameSourceModel.getGameStateByName("pause");
					gameShowPanel.addChild(pauseBmp);
					break;
				case "play":
					showContent();
					update();
					break;
				case "over":
					//移除除按钮外的所有内容
					coverOverContent();
					
					var overBmp:Bitmap = new Bitmap();
					overBmp.bitmapData = GameSourceModel.getGameStateByName("over");
					gameShowPanel.addChild(overBmp);
					//添加分数
					var overScoreTF:TextField =  GameSourceModel.getTextField();
					overScoreTF.x = 70; 
					overScoreTF.y = 177;
					overScoreTF.text = dataObj["scoreNum"].toString();
					gameShowPanel.addChild(overScoreTF);
					break;
				case "win":
					var winBmp:Bitmap = new Bitmap();
					winBmp.bitmapData = GameSourceModel.getGameStateByName("win");
					gameShowPanel.addChild(winBmp);
				default:
					break;
			}
		}
		
		/**
		 * 返回可以操作的所有按钮
		 */
		public function get buttons():Object
		{
			return buttonsObj;
		}
		
		/**
		 * 返回游戏内容显示面板
		 */
		public function get gamePanel():Sprite
		{
			return gameShowPanel;
		}
		
		public function get maskWidth():Number
		{
			return _maskWidth;
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			//初始化变量
			dataObj = new Object();
			buttonsObj = new Object();
			
			
			//添加游戏背景
			var background:Bitmap = new Bitmap();
			background.bitmapData = GameSourceModel.getBackgroundByName("background");
			addChild(background);
			
			//添加时间条的提示
			var timeTip:Bitmap = new Bitmap();
			timeTip.bitmapData = GameSourceModel.getTextBmpDataByName("timeTip");
			addChild(timeTip);
			overCoverArr.push(timeTip);
			
			//添加游戏的时间条遮罩
			timeBarMask = new Shape();
			timeBarMask.graphics.clear();
			timeBarMask.graphics.beginFill(0x000000, 0);
			timeBarMask.graphics.drawRect(0, 0, 335, 18);
			timeBarMask.graphics.endFill();
			addChild(timeBarMask);
			timeBarMask.x = 100;
			timeBarMask.y = 20;
			_maskWidth = timeBarMask.width;
			
			//添加游戏时间条
			var timeBar:Bitmap = new Bitmap();
			timeBar.bitmapData = GameSourceModel.getBackgroundByName("timeBar");
			addChild(timeBar);
			timeBar.x = 100;
			timeBar.y = 20;
			//设置timeBar的遮罩
			timeBar.mask = timeBarMask;
			overCoverArr.push(timeBar);
			
			//添加当前关数提示
			var levelNumTip:Bitmap = new Bitmap();
			levelNumTip.bitmapData = GameSourceModel.getTextBmpDataByName("levelTip");;
			addChild(levelNumTip);
			levelNumTip.x = 430;
			levelNumTip.y = 10;
			overCoverArr.push(levelNumTip);
			
			//添加当前关数的数字
			levelTF = GameSourceModel.getTextField();
			addChild(levelTF);
			levelTF.x = 515;
			levelTF.y = 10;
			overCoverArr.push(levelTF);
			
			//添加当前得分的提示
			var scoreNumTip:Bitmap = new Bitmap();
			scoreNumTip.bitmapData = GameSourceModel.getTextBmpDataByName("scoreTip");
			addChild(scoreNumTip);
			scoreNumTip.x = 430;
			scoreNumTip.y = 365;
			overCoverArr.push(scoreNumTip);
			
			//添加当前得分的数字
			scoreTF = GameSourceModel.getTextField();
			addChild(scoreTF);
			scoreTF.x = 495;
			scoreTF.y = 365;
			overCoverArr.push(scoreTF);
			
			//添加游戏内容面板
			gameShowPanel = new Sprite();
			gameShowPanel  = new GameShowPanel();
			addChild(gameShowPanel);
			gameShowPanel.x = 30;
			gameShowPanel.y = 60;
			//设置开始游戏前显示内容
			setGameState("before");
			/************添加可以操作的按钮*******************/
			//添加提示按钮
			var tipBtn:SimpleButton = GameSourceModel.getButtonByName("Tip");
			addChild(tipBtn);
			tipBtn.x = 10;
			tipBtn.y = 350;
			buttonsObj["tipBtn"] = tipBtn;
			overCoverArr.push(tipBtn);
			
			//添加提示数字
			gameTipNum = new Bitmap();
			addChild(gameTipNum);
			gameTipNum.x = 80;
			gameTipNum.y = 358;
			overCoverArr.push(gameTipNum);
			
			//添加重列按钮
			var orderBtn:SimpleButton = GameSourceModel.getButtonByName("Reorder");
			addChild(orderBtn);
			orderBtn.x = 210;
			orderBtn.y = 350;
			buttonsObj["orderBtn"] = orderBtn;
			overCoverArr.push(orderBtn);
			
			//添加重列数字
			gameOrderNum = new Bitmap();
			addChild(gameOrderNum);
			gameOrderNum.x = 280;
			gameOrderNum.y = 358;
			overCoverArr.push(gameOrderNum);
			
			//添加声音开按钮
			var soundOnBtn:SimpleButton = GameSourceModel.getButtonByName("MusicOn");
			addChild(soundOnBtn);
			soundOnBtn.x = 450;
			soundOnBtn.y = 80;
			buttonsObj["soundOnBtn"] = soundOnBtn;
			
			//添加声音关按钮
			var soundOffBtn:SimpleButton = GameSourceModel.getButtonByName("MusicOff");
			addChild(soundOffBtn);
			soundOffBtn.x = 500;
			soundOffBtn.y = 80;
			buttonsObj["soundOffBtn"] = soundOffBtn;
			
			//添加开始按钮
			var startBtn:SimpleButton = GameSourceModel.getButtonByName("Begin");
			addChild(startBtn);
			startBtn.x = 440;
			startBtn.y = 160;
			buttonsObj["startBtn"] = startBtn;
			
			//添加暂停按钮,默认不可见
			var pauseBtn:SimpleButton = GameSourceModel.getButtonByName("Pause");
			addChild(pauseBtn);
			pauseBtn.x = 440;
			pauseBtn.y = startBtn.y;
			pauseBtn.visible = false;
			buttonsObj["pauseBtn"] = pauseBtn;
			
			//添加继续按钮，默认不可见
			var continueBtn:SimpleButton = GameSourceModel.getButtonByName("Continue");
			addChild(continueBtn);
			continueBtn.x = 440;
			continueBtn.y = startBtn.y;
			continueBtn.visible = false;
			buttonsObj["continueBtn"] = continueBtn;
			
			//添加重新开始按钮，默认不可见
			var restartBtn:SimpleButton = GameSourceModel.getButtonByName("Restart2");
			addChild(restartBtn);
			restartBtn.x = 440;
			restartBtn.y = startBtn.y;
			restartBtn.visible = false;
			buttonsObj["restartBtn"] = restartBtn;
			
			//添加下一关按钮，默认不可见
			var nextLevelBtn:SimpleButton = GameSourceModel.getButtonByName("nextLevel");
			addChild(nextLevelBtn);
			nextLevelBtn.x = 440;
			nextLevelBtn.y = startBtn.y;
			nextLevelBtn.visible = false;
			buttonsObj["nextLevelBtn"] = nextLevelBtn;
			
			//添加游戏退出按钮
			var exitBtn:SimpleButton = GameSourceModel.getButtonByName("Exit");
			addChild(exitBtn);
			exitBtn.x = 440;
			exitBtn.y = 260;
			buttonsObj["exitBtn"] = exitBtn;
		}
		
		
		/**
		 * 游戏结束后隐藏部分内容
		 */
		private function coverOverContent():void
		{
			for (var i:int = 0; i < overCoverArr.length;i++ )
			{
				overCoverArr[i].visible = false;
			}
		}
		
		/**
		 * 显示隐藏的部分内容
		 */
		private function showContent():void
		{
			for (var i:int = 0; i < overCoverArr.length;i++ )
			{
				overCoverArr[i].visible = true;
			}
		}
		/**
		 * 更新数据
		 */
		private function update():void
		{
			/**
			 * 需要更新的数据有：
			 * 1.时间条
			 * 2.当前关数
			 * 3.卡片信息
			 * 4.提示次数
			 * 5.重列次数
			 * 6.当前得分
			 */
			
			//更新时间条
			var timeBarX:int = dataObj["maskPosX"];
			updateTimeBar(timeBarX);
			//更新当前关数
			var levelNum:int = dataObj["levelNum"];
			updateLevelNum(levelNum);
			//更新卡片信息
			var cardsArr:Array = dataObj["cardsArr"];
			updateCards(cardsArr);
			//更新提示次数
			var tipNum:int = dataObj["tipNum"];
			updateTipNum(tipNum);
			//更新重列次数
			var orderNum:int = dataObj["orderNum"];
			updateOrder(orderNum);
			//更新当前得分
			var score:int = dataObj["scoreNum"];
			updateScore(score);
		}
		
		//更新时间条
		private function updateTimeBar(xpos:int):void
		{
			timeBarMask.x = xpos;
		}
		//更新当前关数
		private function updateLevelNum(num:int):void
		{
			levelTF.text = num.toString();
		}
		//更新卡片信息
		private function updateCards(arr:Array):void
		{
			if (arr.length == 0) return;
			for (var i:int = 0; i < arr.length;i++ )
			{
				if(arr[i] != null) gameShowPanel.addChild(arr[i]);
				
			}
		}
		//更新提示次数
		private function updateTipNum(num:int):void
		{
			switch(num)
			{
				case 3:
					gameTipNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				case 2:
					gameTipNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				case 1:
					gameTipNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				case 0:
					gameTipNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				default:
					break;
			}
		}
		//更新重列次数
		private function updateOrder(num:int):void
		{
			switch(num)
			{
				case 3:
					gameOrderNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				case 2:
					gameOrderNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				case 1:
					gameOrderNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				case 0:
					gameOrderNum.bitmapData = GameSourceModel.getTipNumberByNum(num);
					break;
				default:
					break;
			}
		}
		//更新当前分数
		private function updateScore(score:int):void
		{
			//得分
			scoreTF.text = score.toString();
		}
	}

}