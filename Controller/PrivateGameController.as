package Controller 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import Model.CardModel;
	import Model.GameConstModel;
	import Model.GameSoundModel;
	import View.GamePrivateView;
	/**
	 * 单机版游戏控制器
	 * @author YaoQiao
	 */
	public class PrivateGameController 
	{
		/**游戏容器 **/
		private var background:Sprite;
		/**游戏视图 **/
		private var view:GamePrivateView;
		/**游戏声音模型**/
		private var sound:GameSoundModel;
		/**需要更新的数据对象 **/
		private var dataObj:Object;
		/**游戏内容显示面板 **/
		private var gameShowPanel:Sprite;
		/**游戏计时器 **/
		private var gameTimer:Timer;
		/**计数器，用来判断玩家是否在1秒内消除了3个卡片，以此作为奖励时间的标准 **/
		private var matchCardsNum:int;
		
		/**当前关数 **/
		private var levelNum:int;
		/**当前得分 **/
		private var scoreNum:int;
		/**提示次数 **/
		private var tipNum:int;
		/**重列次数 **/
		private var orderNum:int;
		/**遮罩的x位置 **/
		private var maskPosX:Number;
		/**每秒时间条移动的位移 **/
		private var maskSpeed:Number;
		
		/**已标记的卡片 */
		private var oldCard:CardModel;
		/**2维数组表示的卡片地图 */
		private var map:Array;
		/**存放卡片的数组**/
		private var cardsArr:Array;
		/**存放当前处于提示状态的两个卡片 **/
		private var tipCardsArr:Array;
		
		/**
		 * 设置显示容器
		 * @param	display
		 */
		public function PrivateGameController(display:Sprite,view:GamePrivateView,sound:GameSoundModel):void 
		{
			background = display;
			this.view = view;
			this.sound = sound;
			
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			
			//初始化变量
			dataObj = new Object();
			tipCardsArr = new Array();
			cardsArr = new Array();
			levelNum = 1;
			scoreNum = 0;
			maskPosX = 0;
			tipNum = GameConstModel.GAME_TIP_NUMBER;
			orderNum = GameConstModel.GAME_ORDER_NUMBER;
			
			
			//设置计时器，默认为1s，无限次侦听
			gameTimer = new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER,timerHandle);
			//添加相应的按钮侦听
			addListener(view.buttons);
			//设置游戏内容面板
			gameShowPanel = view.gamePanel;
			//设置时间条移动的速度
			maskSpeed = view.maskWidth / 6;			
			
			//添加游戏界面
			background.addChild(view);
		}
		
		/**
		 * 计时器处理函数
		 */
		private function timerHandle(e:TimerEvent):void
		{
			
			maskPosX -= maskSpeed;
	
			updateData();
		}
		
		/**
		 * 添加按钮的侦听
		 * @param	obj
		 */
		private function addListener(obj:Object):void
		{
			var _obj:Object = obj;
			//添加开始按钮的点击侦听
			(_obj["startBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, startHandle);
			//添加暂停按钮的点击侦听
			(_obj["pauseBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, pauseHandle);
			//添加退出按钮的点击侦听
			(_obj["exitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, exitHandle);
			//添加声音开关按钮的点击侦听
			(_obj["soundOnBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, soundOnHandle);
			(_obj["soundOffBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, soundOffHandle);
			//
			
			//更新游戏数据
			function enterFrame(e:Event):void
			{
				
				
				//判断是否连续消除了3组卡片，如果消除了，则奖励1s时间
				if (matchCardsNum > 2)
				{
					rewardTime();
				}
				//判断游戏是否胜利
				if (isWin())
				{
					(_obj["nextLevelBtn"] as SimpleButton).visible = true;
					(_obj["pauseBtn"] as SimpleButton).visible = false;
					
					//设置游戏状态为胜利
					view.setGameState("win");
					gameTimer.stop();
				}
				
				//判断游戏时间是否结束
				if (isTimerOver())
				{
					(_obj["restartBtn"] as SimpleButton).visible = true;
					(_obj["pauseBtn"] as SimpleButton).visible = false;
					tipNum = 0;
					orderNum = 0;
					updateData();
					view.setGameState("over");
					gameTimer.stop();
				}
				
			}
			
			//开始按钮的侦听处理
			function startHandle(e:MouseEvent):void
			{
				//替换显示"开始"和"暂停"按钮
				(_obj["startBtn"] as SimpleButton).visible = false;
				(_obj["pauseBtn"] as SimpleButton).visible = true;
				(_obj["restartBtn"] as SimpleButton).visible = false;
				(_obj["continueBtn"] as SimpleButton).visible = false;
				//添加提示按钮的点击侦听
				(_obj["tipBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,tipHandle);
				//添加重列按钮的点击侦听
				(_obj["orderBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, orderHandle);
				//添加继续按钮的点击侦听
				(_obj["continueBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, continueHandle);
				//添加重新开始按钮的点击侦听
				(_obj["restartBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, restartHandle);
				//添加下一关按钮的点击侦听
				(_obj["nextLevelBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, nextHandle);
				//添加帧侦听，用来更新游戏的数据
				background.addEventListener(Event.ENTER_FRAME,enterFrame);
				//开始游戏内容
				startGame();
				view.setData(dataObj);
				view.setGameState("play");
				maskPosX = 100;
				updateData();
				
				//计时清零，开始
				gameTimer.reset();
				gameTimer.start();
			}
			
			//下一关按钮的侦听处理
			function nextHandle(e:MouseEvent):void
			{
				(_obj["pauseBtn"] as SimpleButton).visible = true;
				(_obj["nextLevelBtn"] as SimpleButton).visible = false;
				
				startGame();
				view.setGameState("play");
				//过关奖励3s
				rewardTime(3);
				//关数加1
				levelNum ++;
				updateData();
				gameTimer.start();
			}
			//重新开始按钮的侦听处理
			function restartHandle(e:MouseEvent):void
			{	
				//替换显示"开始"和"暂停"按钮
				(_obj["startBtn"] as SimpleButton).visible = false;
				(_obj["pauseBtn"] as SimpleButton).visible = true;
				(_obj["restartBtn"] as SimpleButton).visible = false;
				(_obj["continueBtn"] as SimpleButton).visible = false;
				
				//开始游戏内容
				init();
				startGame();
				view.setData(dataObj);
				view.setGameState("play");
				maskPosX = 100;
				updateData();
				
				//计时清零，开始
				gameTimer.reset();
				gameTimer.start();
			}
			//暂停按钮的侦听处理
			function pauseHandle(e:MouseEvent):void
			{
				//添加提示按钮的点击侦听
				(_obj["tipBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK,tipHandle);
				//添加重列按钮的点击侦听
				(_obj["orderBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK, orderHandle);
				(_obj["pauseBtn"] as SimpleButton).visible = false;
				(_obj["continueBtn"] as SimpleButton).visible = true;
				view.setGameState("pause");
				gameTimer.stop();
				
			}
			//继续按钮的侦听处理
			function continueHandle(e:MouseEvent):void
			{
				//添加提示按钮的点击侦听
				(_obj["tipBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,tipHandle);
				//添加重列按钮的点击侦听
				(_obj["orderBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, orderHandle);
				(_obj["pauseBtn"] as SimpleButton).visible = true;
				(_obj["continueBtn"] as SimpleButton).visible = false;
				view.setGameState("play");
				gameTimer.start();
			}
			//退出按钮的侦听处理
			function exitHandle(e:MouseEvent):void
			{
				
				background.removeEventListener(Event.ENTER_FRAME, enterFrame);
				gameTimer.removeEventListener(TimerEvent.TIMER,timerHandle);
				gameTimer.stop();
				if (background.contains(view))
				{
					background.removeChild(view);
				}
				
				sound.playBackgroundState = false;
				
				
				
			}
			//提示按钮的侦听处理
			function tipHandle(e:MouseEvent):void
			{
				if (tipNum < 1) return;
				tipNum --;
				updateData();
				//找出还存在的卡片
				var tempArr:Array = new Array();
				var number:int = 0;
				for (var n:int = 0; n < cardsArr.length;n++ )
				{
					if (cardsArr[n] != null)
					{
						tempArr[number] = cardsArr[n];
						number ++;
					}
				}
				//寻找可消除的卡片
				for (var i:int = 0; i < tempArr.length;i++ )
				{
					oldCard = null;
					oldCard = tempArr[i];
					for (var j:int = 0; j < tempArr.length;j++ )
					{
						if (oldCard == tempArr[j]) continue;
						oldCard.TargetCard = tempArr[j];
						if (isMatched())
						{
							oldCard.border = true;
							oldCard.TargetCard.border = true;
							tipCardsArr.push(oldCard);
							tipCardsArr.push(oldCard.TargetCard);
							oldCard = null;
							return;
						}
					}
					
				}
			}
			//重列按钮的侦听处理
			function orderHandle(e:MouseEvent):void
			{
				if (orderNum < 1) return;
				orderNum --;
				updateData();
				
				//找出还存在的卡片
				var tempArr:Array = new Array();
				var number:int = 0;
				for (var n:int = 0; n < cardsArr.length;n++ )
				{
					if (cardsArr[n] != null)
					{
						tempArr[number] = cardsArr[n];
						number ++;
					}
				}
				
				//打乱排放的顺序
				var random:int = 0;
				var obj:Object = {x:0,y:0,i:0,j:0};
				for (var i:int = 0; i < tempArr.length;i++ )
				{
					//要修改的有x,y以及i,j因为影响的是两个坐标系，但是不能改id
					random = Math.floor(Math.random() * tempArr.length);
					obj.x = tempArr[i].x;
					obj.y = tempArr[i].y;
					obj.i = tempArr[i].i;
					obj.j = tempArr[i].j;
					tempArr[i].x = tempArr[random].x;
					tempArr[i].y = tempArr[random].y;
					tempArr[i].i = tempArr[random].i;
					tempArr[i].j = tempArr[random].j;
					tempArr[random].i = obj.i;
					tempArr[random].j = obj.j;
					tempArr[random].x = obj.x;
					tempArr[random].y = obj.y;
					
				}
			}
			
			//声音开关按钮的侦听处理
			function soundOnHandle(e:MouseEvent):void
			{
				if (sound.playBackgroundState) return;
				sound.playBackgroundState = true;
			}
			function soundOffHandle(e:MouseEvent):void
			{
				if (!sound.playBackgroundState) return;
				sound.playBackgroundState = false;
			}
		}
		
		/**
		 * 奖励时间
		 * @param num 需要加的时间秒数
		 */
		private function rewardTime(num:int = 1):void
		{
			maskPosX += maskSpeed * num;
			updateData();
			
			matchCardsNum = 0;
		}
		/**
		 * 判断游戏是否胜利
		 * @return
		 */
		private function isWin():Boolean
		{
			//遍历存放卡片的数组cardsArr，如果全为空，则证明游戏胜利
			for (var i :int = 0; i < cardsArr.length;i++ )
			{
				if (cardsArr[i] != null) 
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 判断时间是否用完
		 * @return
		 */
		private function isTimerOver():Boolean
		{
			
			if ( maskPosX< 100 - maskSpeed * 6) return true;
			return false;
		}
		

		/**
		 * 更新游戏数据
		 */
		private function updateData():void
		{
			dataObj["levelNum"] = levelNum;
			dataObj["scoreNum"] = scoreNum;
			dataObj["tipNum"] = tipNum;
			dataObj["orderNum"] = orderNum;
			dataObj["maskPosX"] = maskPosX;
			dataObj["cardsArr"] = cardsArr;
			
			
			//更新显示面板里的数据
			view.setData(dataObj);
		}
		
/***************************************游戏关键代码，代码层的逻辑处理************************************/		
		/**
		 * 游戏开始函数，初始化卡片地图map
		 */
		private function startGame():void
		{
			/**初始化map数组，在其左右上下再添加新的一排元素，以此作为卡片最外层可匹配的通路 */
			map = new Array(GameConstModel.GAME_ROW + 2);
			
			/**创建卡片数字的二维数组，并初始化其内容如下所示
			 *   1 2 3 4 5 6 7 8 9 
			 *   1 2 3 4 5 6 7 8 9 
			 * 	 1 2 3 4 5 6 7 8 9 
			 *   1 2 3 4 5 6 7 8 9 
			 *   1 2 3 4 5 6 7 8 9 
			 *   1 2 3 4 5 6 7 8 9  
			 * */
			var numArray:Array = new Array();
			for (var i:uint = 0; i < GameConstModel.GAME_ROW;i++ ) {
				numArray[i] = new Array();
				var num:uint = 0;
				for (var j:uint = 0; j < GameConstModel.GAME_COLUM;j++ ) {
					numArray[i][j] = ++num;
				}
			}
			
			/** 将卡片数组的数字顺序打乱*/
			for (i = 0; i < GameConstModel.GAME_ROW;i++ ) {
				for (j = 0; j < GameConstModel.GAME_COLUM;j++ ) {
					var Rani:uint = Math.floor(Math.random() * GameConstModel.GAME_ROW);
					var Ranj:uint = Math.floor(Math.random() * GameConstModel.GAME_COLUM);
					
					var temp:uint = numArray[i][j];
					numArray[i][j] = numArray[Rani][Ranj];
					numArray[Rani][Ranj] = temp;
				}
			}
			
			/**创建map二维数组 */
			for (i = 0; i < GameConstModel.GAME_ROW + 2;i++ ) {
				map[i] = new Array(GameConstModel.GAME_COLUM + 2);
				for (j = 0; j < GameConstModel.GAME_COLUM + 2;j++ ) {
					if (i == 0 || j == 0 || i == GameConstModel.GAME_ROW + 1 || j == GameConstModel.GAME_COLUM + 1) {
						map[i][j] = 0;
					}else
					{
						map[i][j] = 1;
					}
				}
			}
			
			
			/**将创建好的卡片数字二维数组numArray转变成实际游戏中的卡片，存放在卡片数组中并显示到舞台上 */
			
			var number:int = 0;
			for (i = 0; i < GameConstModel.GAME_ROW;i++ ) {
				for (j = 0; j < GameConstModel.GAME_COLUM;j ++ ) {
					var card:CardModel = new CardModel(numArray[i][j]);
					card.x = GameConstModel.MarginLeft + j * (card.W + GameConstModel.MarginCards);
					card.y = GameConstModel.MarginTop + i * (card.H + GameConstModel.MarginCards);
					card.no = number;
					card.setIndex(i + 1, j + 1);
					card.addEventListener(MouseEvent.CLICK, onClick);
					cardsArr[number] = card;
					number ++;
				}
			}
			
			//将卡片数组放入更新的数据对象中
			dataObj["cardsArr"] = cardsArr;
			//播放GO声音
			sound.playGoSound();
		}
		
		/**
		 * 鼠标点击卡片时的相对应的处理函数
		 */
		private function onClick(evt:MouseEvent):void
		{
			/**尝试创建 */
			try {
				var currentCard:CardModel = CardModel(evt.target.parent);
			}catch (error:Error) {
				currentCard = CardModel(evt.target);
			}
			//消除处于提示状态的卡片的border
			if (tipCardsArr.length > 0)
			{
				for (var i:int = 0; i < tipCardsArr.length;i++ )
				{
					tipCardsArr[i].border = false;
				}
			}
			if (oldCard == null) {
				oldCard = currentCard;
				oldCard.Pressed();
			}else
			{
				oldCard.TargetCard = currentCard;
				
				/** 判断当前点击的卡片与之前点击的卡片是否能够匹配*/
				if (isMatched())
				{
					
					gameShowPanel.addChild(oldCard.line);
					oldCard.line.graphics.clear();
					oldCard.line.graphics.lineStyle(2);
					
					var node:Object = oldCard.Path.shift();
					oldCard.line.graphics.moveTo(GameConstModel.MarginLeft + node.y * oldCard.W - oldCard.W / 2, GameConstModel.MarginTop + node.x * oldCard.H - oldCard.H / 2);
					oldCard.addEventListener(Event.ENTER_FRAME, ToLink);
					oldCard = null;
					
				}else {
					oldCard.UnPressed();
					oldCard = null;
				}
			}
		}
		
		
		/**
		 * 判断两张卡片是否匹配（包括了两张卡片是否一致，而且有消除的路径存在）
		 * @return
		 */
		private function isMatched():Boolean
		{
			/**判断两张卡片id是否一致 */
			if (oldCard == oldCard.TargetCard || oldCard.id != oldCard.TargetCard.id)
			{                                                                                                                                         
				return false;
			}
			
			/**如果两张卡片id一致，才进行下面的寻路判断 */
			var x1:uint = oldCard.i;
			var y1:uint = oldCard.j;
			var x2:uint = oldCard.TargetCard.i;
			var y2:uint = oldCard.TargetCard.j;
			
			var node:Object = new Object();
			var tempPath:Array = new Array();
			
			/**设定寻路是从第0横行开始进行扫描寻路，直到第Colum + 2横行停止 */
			for (var i:uint = 0; i < GameConstModel.GAME_COLUM + 2; i++) {
				var count:uint = 0; 
				tempPath.splice(0);
				
				var step:int = (y1 > i) ? -1 : 1;
				for (var j = y1; j != i; j += step) {
					count += map[x1][j];
					node = {x:x1,y:j};
					tempPath.push(node);
				}

				step = (x1 > x2) ? -1 : 1;
				for (j = x1; j != x2; j += step) {
					count += map[j][i];
					node = {x:j,y:i};
					tempPath.push(node);
				}

				step = (i < y2) ? 1 : -1;
				for (j = i; j != y2; j+= step) {
					count += map[x2][j];
					node = {x:x2,y:j};
					tempPath.push(node);
				}

				if (count == 1) {
					if (oldCard.Path.length == 0 || tempPath.length < oldCard.Path.length) {
						oldCard.Path = tempPath.slice();
					}
				}
			}
			
			for (i = 0; i < GameConstModel.GAME_ROW + 2; i++) {
				count = 0;
				tempPath.splice(0);

				step = (i < x1) ? -1 : 1;
				for (j = x1; j != i; j += step) {
					count += map[j][y1];
					node = {x:j,y:y1};
					tempPath.push(node);
				}
				step = (y2 > y1) ? 1 : -1;
				for (j = y1; j != y2; j += step) {
					count += map[i][j];
					node = {x:i,y:j};
					tempPath.push(node);
				}
				step = (x2 > i) ? 1 : -1;
				for (j = i; j != x2; j += step) {
					count += map[j][y2];
					node = {x:j,y:y2};
					tempPath.push(node);
				}
				if (count == 1) {
					if (oldCard.Path.length == 0 || tempPath.length < oldCard.Path.length) {
						oldCard.Path = tempPath.slice();
					}
				}
			}
			if (oldCard.Path.length > 0) {
				node = { x:x1, y:y1 };
				oldCard.Path.unshift(node);
				node = { x:x2, y:y2 };
				oldCard.Path.push(node);
				return true;
			}
			
			return false;
		}
		
		/**连线的函数 */
		private function ToLink(evt:Event):void
		{
			var card:CardModel = CardModel(evt.target);
			if (card.Path.length > 0)
			{
				var node:Object = card.Path.shift();
				card.line.graphics.lineTo(GameConstModel.MarginLeft + node.y * card.W - card.W / 2,GameConstModel.MarginTop + node.x * card.H - card.H / 2);
			}else {
				map[card.i][card.j] = 0;
				map[card.TargetCard.i][card.TargetCard.j] = 0;
				card.removeEventListener(Event.ENTER_FRAME, ToLink);
				gameShowPanel.removeChild(card);
				gameShowPanel.removeChild(card.line);
				gameShowPanel.removeChild(card.TargetCard);
				
				//将卡片数组中被消除的卡片置空
				cardsArr[card.no] = null;
				cardsArr[card.TargetCard.no] = null;
				
				//每消除一对，增加10分
				scoreNum += 10;
				//每消除一对，已消除的计数+1
				matchCardsNum ++;
				//更新数据
				updateData();
				//播放消除音效
				sound.playClearSound();
			}
		}
	}
}