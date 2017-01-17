package Controller 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GameEvent.NetworkEvent;
	import Model.GameSoundModel;
	import Model.GameSourceModel;
	import Model.NetworkModel;
	import View.GameConnectView;
	import View.GameOrderView;
	import View.LoginView;
	import View.RegisterView;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import Model.CardModel;
	import Model.GameConstModel;
	import Model.GameSoundModel;
	import View.GamePrivateView;
	/**
	 * 联网游戏控制器
	 * @author YaoQiao
	 */
	public class ConnectGameController 
	{
		/**游戏容器**/
		private var background:Sprite;
		/**登录界面 **/
		private var loginView:LoginView;
		/**注册界面 **/
		private var registerView:RegisterView;
		/**联网游戏界面 **/
		private var view:GameConnectView;
		/**游戏排行榜界面 **/
		private var orderView:GameOrderView;
		/**联网模型 **/
		private var networkModel:NetworkModel;
		/**声音模型**/
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
		
		
		/**登录界面提示文本框 **/
		private var loginTipTF:TextField;
		/**注册界面提示文本框 **/
		private var registerTipTF:TextField;
		
		
		/**存放登录信息对象 **/
		private var loginObj:Object;
		/**存放注册信息对象 **/
		private var registerObj:Object;
		
		/**当前玩家用户名 **/
		private var USER_NAME:String;
		
		/**
		 * 设置显示容器
		 * @param	display
		 */
		public function ConnectGameController(display:Sprite,loginView:LoginView,registerView:RegisterView,gameView:GameConnectView,sound:GameSoundModel):void 
		{
			background = display;
			this.loginView = loginView;
			this.registerView = registerView;
			this.view = gameView;
			this.sound = sound;
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			//初始化数据
			loginObj = new Object();
			registerObj = new Object();
			networkModel = new NetworkModel();
			
			
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

			//设置游戏内容面板
			gameShowPanel = view.gamePanel;
			//设置时间条移动的速度
			maskSpeed = view.maskWidth / 5;	
			
			//登录界面
			background.addChild(loginView);
			loginView.x = 80;
			loginView.y = 80;
			
			loginTipTF = GameSourceModel.getTextField("",18,150);
			loginView.addChild(loginTipTF);
			loginTipTF.x = 200;
			loginTipTF.y = 200;
			loginTipTF.visible = false;
			
			//添加注册界面，默认不显示
			background.addChild(registerView);
			registerView.x = 80;
			registerView.y = 80;
			registerView.visible = false;
			
			registerTipTF = GameSourceModel.getTextField("", 18, 150);
			registerView.addChild(registerTipTF);
			registerTipTF.x = 200;
			registerTipTF.y = 215;
			registerTipTF.visible = false;
			
			//添加游戏界面，默认不显示
			background.addChild(view);
			view.visible = false;
			
			//添加游戏排行榜界面，默认不显示
			orderView = new GameOrderView();
			background.addChild(orderView);
			orderView.visible = false;
			//添加侦听函数
			addListener();
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
		 * 添加侦听函数
		 */
		private function addListener():void
		{
			//添加登录界面的按钮侦听
			var loginbtnObj:Object = loginView.getBtnObject();
			(loginbtnObj["loginBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, loginHandle);
			(loginbtnObj["registerBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, registerViewHandle);
			(loginbtnObj["exitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,exitHandle);
			//添加注册界面的按钮侦听
			var registerbtnObj:Object = registerView.getBtnObject();
			(registerbtnObj["registerBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, registerUserHandle);
			(registerbtnObj["exitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,exitHandle);
			
			//添加联网模块的侦听
			networkModel.addEventListener(NetworkEvent.LOGIN_SUCCESS, loginSucessed);
			networkModel.addEventListener(NetworkEvent.LOGIN_FAILED,loginFailed);
			
			networkModel.addEventListener(NetworkEvent.SERVER_FAILED, serverFailed);
			
			networkModel.addEventListener(NetworkEvent.REGISTER_SUCCESS, registerSucessed);
			networkModel.addEventListener(NetworkEvent.REGISTER_FAILED, registerFailed);
			
			
			//游戏内容部分的侦听
			var _obj:Object = view.buttons;
			//添加开始按钮的点击侦听
			(_obj["startBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, startHandle);
			//添加暂停按钮的点击侦听
			(_obj["pauseBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, pauseHandle);
			//添加退出按钮的点击侦听
			(_obj["exitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, exitGameHandle);
			//添加声音开关按钮的点击侦听
			(_obj["soundOnBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, soundOnHandle);
			(_obj["soundOffBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, soundOffHandle);
			//添加游戏排行按钮的点击侦听
			(_obj["gameOrderBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,gameOrderHandle);
			
			
			
			//游戏排行按钮的处理侦听
			function gameOrderHandle(e:MouseEvent):void
			{
				//显示游戏排行面板
				orderView.visible = true;
				orderView.setGameState("before");
				//添加游戏排行界面的按钮侦听
				var _obj:Object = orderView.buttons;
				(_obj["backBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, backHandle);
				function backHandle(e:MouseEvent):void
				{
					e.target.removeEventListener(MouseEvent.CLICK, backHandle);
					orderView.visible = false;
				}
				
				//发送得到排行榜数据的请求
				networkModel.getScore();
				networkModel.addEventListener(NetworkEvent.RANK_COMPLETE, rankHandle);
				function rankHandle(e:NetworkEvent):void
				{
					e.target.removeEventListener(NetworkEvent.RANK_COMPLETE, rankHandle);
					var arr:Array = e.rankArray;
					orderView.setScoreData(arr);
				}
			}
			
			//开始按钮的侦听处理
			function startHandle(e:MouseEvent):void
			{
				//移除游戏排行榜侦听函数
				(_obj["gameOrderBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK,gameOrderHandle);
				//替换显示"开始"和"暂停"按钮
				(_obj["startBtn"] as SimpleButton).visible = false;
				(_obj["pauseBtn"] as SimpleButton).visible = true;
				
				(_obj["continueBtn"] as SimpleButton).visible = false;
				orderView.visible = false;
				//添加提示按钮的点击侦听
				(_obj["tipBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,tipHandle);
				//添加重列按钮的点击侦听
				(_obj["orderBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, orderHandle);
				//添加继续按钮的点击侦听
				(_obj["continueBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, continueHandle);
				
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
			function exitGameHandle(e:MouseEvent):void
			{
				sound.playBackgroundState = false;
				
				background.removeChild(view);
				
				background.removeEventListener(Event.ENTER_FRAME, enterFrame);
				gameTimer.stop();
				gameTimer = null;
				view = null;
				
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

		//更新游戏数据
		private	function enterFrame(e:Event):void
			{
				var _obj:Object = view.buttons;
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
				
				if (isTimerOver() && background.contains(orderView))
				{
					
					
					(_obj["pauseBtn"] as SimpleButton).visible = false;
					tipNum = 0;
					orderNum = 0;
					updateData();
					view.setGameState("over");
					gameTimer.stop();
					
					//显示结束时的排行榜界面
					overOrderViewHandle();
					background.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
				
			}
/************************************************游戏登录、注册功能逻辑处理******************************************/
		/**
		 * 注册成功处理函数
		 * @param	e
		 */
		private function registerSucessed(e:NetworkEvent):void
		{
			//注册成功进入游戏界面
			background.removeChild(registerView);
			view.visible = true;
			
			sound.playBackgroundState = true;
			sound.playReadySound();
		}
		/**
		 * 注册失败处理函数
		 * @param	e
		 */
		private function registerFailed(e:NetworkEvent):void
		{
			registerTipTF.text = "注意：注册失败，请重新输入信息！";
			registerTipTF.visible = true;
			
			
		}
		/**
		 * 登录失败处理函数
		 * @param	e
		 */
		private function loginFailed(e:NetworkEvent):void
		{
			loginTipTF.text = "注意：用户名或密码不正确！";
			loginTipTF.visible = true;
		}
		/**
		 * 服务器故障处理函数
		 * @param	e
		 */
		private function serverFailed(e:NetworkEvent):void
		{
			loginTipTF.text = "注意：服务器故障！";
			loginTipTF.visible = true;
			
			registerTipTF.text = "注意：服务器故障！";
			registerTipTF.visible = true;
		}
		/**
		 * 登录成功处理函数
		 * @param	e
		 */
		private function loginSucessed(e:NetworkEvent):void
		{
			//登录成功后直接进入游戏界面
			background.removeChild(loginView);
			view.visible = true;
			
			sound.playBackgroundState = true;
			sound.playReadySound();
			
		}
		/**
		 * 退出处理
		 * @param	e
		 */
		private function exitHandle(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.CLICK, exitHandle);
			sound.playBackgroundState = false;
			if (background.contains(loginView))
			{
				//移除登录界面
				background.removeChild(loginView);
			}
			//移除注册界面
			background.removeChild(registerView);
			//移除游戏界面
			background.removeChild(view);
			//移除排行榜界面
			background.removeChild(orderView);
			
		}
		/**
		 * 用户注册处理
		 * @param	e
		 */
		private function registerUserHandle(e:MouseEvent):void
		{
			
			registerObj = registerView.getRegisterData();
			
			var userName:String = registerObj["userName"];
			var pwd:String = registerObj["pwd"];
			var repwd:String = registerObj["repwd"];
			//如果用户名为空，则提示并返回
			if (userName == "")
			{
				registerTipTF.text = "注意：请输入用户名！";
				registerTipTF.visible = true;
				return;
			}
			//如果密码为空，则提示并返回
			if (pwd == "")
			{
				registerTipTF.text = "注意：请输入密码！";
				registerTipTF.visible = true;
				return;
			}
			//如果重复密码为空，则提示并返回
			if (repwd == "")
			{
				registerTipTF.text = "注意：请再次输入密码！";
				registerTipTF.visible = true;
				return;
			}
			//如果重复密码不一致，则提示并返回
			if (repwd != pwd)
			{
				registerTipTF.text = "注意：两次输入密码不一致！";
				registerTipTF.visible = true;
				return;
			}
			networkModel.register(userName, pwd);
			//设置当前用户名
			USER_NAME = userName;
		}
		/**
		 * 登录界面的登录按钮处理
		 * @param	e
		 */
		private function loginHandle(e:MouseEvent):void
		{
			loginObj = loginView.getLoginData();
			
			var userName:String = loginObj["userName"];
			var pwd:String = loginObj["pwd"];
			
			//如果用户名为空，则提示并返回
			if (userName == "")
			{
				loginTipTF.text = "注意：请输入用户名！";
				loginTipTF.visible = true;
				return ;
			}
			//如果密码为空，则提示并返回
			if (pwd == "")
			{
				loginTipTF.text = "注意：请输入密码！";
				loginTipTF.visible = true;
				return;
			}
			networkModel.login(userName, pwd);
			//设置当前用户名
			USER_NAME = userName;
		}
		
		/**
		 * 登录界面的注册按钮处理
		 * @param	e
		 */
		private function registerViewHandle(e:MouseEvent):void
		{
			//移除侦听器
			e.target.removeEventListener(MouseEvent.CLICK, registerViewHandle);
			
			//移除登录界面
			background.removeChild(loginView);
			//显示注册界面
			registerView.visible = true;
		}

		private function overOrderViewHandle():void
		{
				
				//显示游戏排行面板
				orderView.visible = true;
				orderView.setGameState("over");
				//添加游戏排行界面的按钮侦听
				var _obj:Object = orderView.buttons;
				(_obj["restartBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, restart);
				(_obj["exitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, exitHandle);
				
				
				
				var tmpscore:int = 0;
				var newscore:int = 0;
				var arr:Array;
				
				networkModel.addEventListener(NetworkEvent.RANK_COMPLETE, rankHandle);
				//得到排行榜数据
				networkModel.getScore();
				
				function rankHandle(e:NetworkEvent):void
				{
					e.target.removeEventListener(NetworkEvent.RANK_COMPLETE, rankHandle);
					arr = e.rankArray;
					
					var str:String ;
					
					//检查当前用户的成绩是否比记录高，若高于记录则存入数据，否则显示以前数据
					for (var i:int = 0; i < arr[0].length; i++ )
					{
						str = arr[0][i];
						if (str == USER_NAME)
						{
							tmpscore = arr[1][i];
							
						}
					}
					tmpscore = int(tmpscore);
					
					if (tmpscore < view.getScore())
					{
						newscore = view.getScore();
						var tmp:String = newscore.toString();
						networkModel.addEventListener(NetworkEvent.SETSCORE_SUCCESS,setScore);
						networkModel.setScore(USER_NAME,tmp);
					}
					else
					{
						orderView.setScoreData(arr,USER_NAME,view.getScore().toString());
					}
					
				}
				
				
				function setScore(e:NetworkEvent):void
				{
					var str:String;
					for (var i:int = 0; i < arr[0].length; i++ )
					{
						str = arr[0][i];
						if (str == USER_NAME)
						{
							 arr[1][i] = newscore;
						}
					}
					orderView.setScoreData(arr,USER_NAME);
				}
				
				//再玩一次按钮处理函数
				function restart(e:MouseEvent):void
				{
					
					e.target.removeEventListener(MouseEvent.CLICK, restart);
					
					//移除游戏结束面板
					if (background.contains(orderView))
					{
						background.removeChild(orderView);
					}
					if (background.contains(view))
					{
						background.removeChild(view);
					}
					if (background.contains(loginView))
					{
						background.removeChild(loginView);
					}
					if (background.contains(registerView))
					{
						background.removeChild(registerView);
					}
					var _obj:Object = view.buttons;
					//替换显示"开始"和"暂停"按钮
					(_obj["startBtn"] as SimpleButton).visible = false;
					(_obj["pauseBtn"] as SimpleButton).visible = true;
					
					(_obj["continueBtn"] as SimpleButton).visible = false;
					
					//开始游戏内容
					init();
					startGame();
					view.setData(dataObj);
					view.setGameState("play");
					maskPosX = 100;
					updateData();
					loginView.visible = false;
					view.visible = true;
					//计时清零，开始
					gameTimer.reset();
					gameTimer.start();
					background.addEventListener(Event.ENTER_FRAME, enterFrame);
				}
		}
/************************************游戏状态判断部分代码******************************************/
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
			
			if ( maskPosX< 100 - maskSpeed * 5) return true;
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
			
			/**初始化map数组，在其左右上下再添加新的一排元素，以此作为卡片最外层可匹配的通路 */
			map = new Array(GameConstModel.GAME_ROW + 2);
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
				for (j = 0; j < GameConstModel.GAME_COLUM; j ++ ) {
					//声明一个卡片
					var card:CardModel = new CardModel(numArray[i][j]);
					//设置卡片在舞台中的位置
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
				
				//从顶点开始扫描，扫至第一次点击的图片所在的地方
				var step:int = (y1 > i) ? -1 : 1;
				for (var j = y1; j != i; j += step) {
					count += map[x1][j];
					node = {x:x1,y:j};
					tempPath.push(node);
				}

				//从第一个点开始横向扫描
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