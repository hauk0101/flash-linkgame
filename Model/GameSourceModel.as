package Model 
{
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * 游戏素材管理类
	 * @author YaoQiao
	 */
	public class GameSourceModel 
	{
		/**
		 * 根据按钮的名字返回相应的按钮
		 * @param	btnName
		 * @return
		 */
		public static function getButtonByName(btnName:String):SimpleButton
		{
			var result:SimpleButton = new SimpleButton();
			switch(btnName)
			{
				
				case "gameOrderBtn":
					result = new GameOrderBtn();
					break;
				case "loginBtn":
					result = new LoginBtn();
					break;
				case "registerBtn":
					result = new RegisterBtn();
					break;
				case "LianwangBtn":
					result = new LianwangBtn();
					break;
				case "nextLevel":
					result = new NextLevelBtn();
					break;
				case "danjiBtn":
					result = new danjiBtn();
					break;
				case "Tip":
					result = new TipBtn();
					break;
				case "Restart":
					result = new RestartBtn();
					break;
				case "Restart2":
					result = new RestartBtn2();
					break;
				case "Reorder":
					result = new ReorderBtn();
					break;
				case "Pause":
					result = new PauseBtn();
					break;
				case "MusicOn":
					result = new MusicOn();
					break;
				case "MusicOff":
					result = new MusicOff();
					break;
				case "Help":
					result = new HelpBtn();
					break;
				case "Go":
					result = new GameGoBtn();
					break;
				case "Exit":
					result = new ExitBtn();
					break;
				case "Continue":
					result = new ContinueBtn();
					break;
				case "Begin":
					result = new BeginBtn();
					break;
				case "Back":
					result = new BackBtn();
					break;
				default:
					break;
				
			}
			return result;
		}
	
		/**
		 * 获得游戏状态相关的图片
		 * 根据图片的名称返回相应的BitmapData
		 * @param	name
		 * @return
		 */
		public static function getGameStateByName(name:String):BitmapData
		{
			var result:BitmapData ;
			switch(name)
			{
				case "pause":
					result = new  GamePause();
					break;
				case "beforeStart":
					result = new GameStartPicture();
					break;
				case "over":
					result = new GameOver();
					break;
				case "win":
					result = new GameWin();
					break;
				case "help":
					result = new GameHelp();
					break;
				default:
					break;
			}
			return result;
		}
		
		/**
		 * 根据相应的数字，获得对应的数字图片
		 * @param	num
		 * @return
		 */
		public static function getTipNumberByNum(num:int):BitmapData
		{
			var result:BitmapData ;
			switch(num)
			{
				case 0:
					result = new Number0();
					break;
				case 1:
					result = new Number1();
					break;	
				case 2:
					result = new Number2();
					break;	
				case 3:
					result = new Number3();
					break;	
				case 4:
					result = new Number4();
					break;	
				case 5:
					result = new Number5();
					break;	
				case 6:
					result = new Number6();
					break;	
				case 7:
					result = new Number7();
					break;	
				case 8:
					result = new Number8();
					break;
				case 9:
					result = new Number9();
					break;
				default:
					break;
			}
			
			return result;
		}
	
		/**
		 * 根据对应的水果名称，返回水果图片
		 * @param	name
		 * @return
		 */
		public static function getFuritCardByName(name:String):BitmapData
		{
			var result:BitmapData;
			switch(name)
			{
				case "yingtao":
					result = new PicA();
					break;
				case "xiangjiao":
					result = new PicB();
					break;
				case "xigua":
					result = new PicC();
					break;
				case "tao":
					result = new PicD();
					break;
				case "shiliu":
					result = new PicE();
					break;
				case "qingpingguo":
					result = new PicF();
					break;
				case "ningmeng":
					result = new PicG();
					break;
				case "mangguo":
					result = new PicH();
					break;
				case "li":
					result = new PicI();
					break;
				case "juzi":
					result = new PicJ();
					break;
				default:
					break;
			}
			return result;
		}
		
		/**
		 * 根据对应的名字，返回相应的文本图片
		 * @param	name
		 * @return
		 */
		public static function getTextBmpDataByName(name:String):BitmapData
		{
			var result:BitmapData ;
			switch(name)
			{
				case "levelTip":
					result = new LevelTip();
					break;
				case "gameHelp":
					result = new GameHelp();
					break;
				case "scoreTip":
					result = new ScoreTip();
					break;
				case "timeTip":
					result = new GameTimeTip();
					break;
				default:
					break;
			}
			return result;
		}
	
		/**
		 * 根据相应的名称，获得相应的背景
		 * @param	name
		 * @return
		 */
		public static function getBackgroundByName(name:String):BitmapData
		{
			var result:BitmapData ;
			switch(name)
			{
				case "timeBar":
					result = new GameTimeBar();
					break;
				case "picBoder":
					result = new PicBoder();
					break;
				case "cover":
					result = new GameCover();
					break;
				case "background":
					result = new GameBackground();
					break;
				default:
					break;
			}
			return result;
		}
	
		
		//测试按钮专用
		public static function getTestBtn(btnName:String):Sprite
		{
			var btn:Sprite = new Sprite();
			var name:String = btnName;
			var txt:TextField = new TextField();
			txt.height = 20;
			txt.text = name;
			txt.mouseEnabled = false;
			//作为测试先简化按钮的设计,在以后可以继续完善
			btn.graphics.clear();
			btn.graphics.beginFill(0x00FFFF);
			btn.graphics.drawRect(0,0,60,20);
			btn.graphics.endFill();
			btn.addChild(txt);		
			return btn;
		}
		
		/**
		 * 返回文本
		 * @param	content 文本内容
		 * @param	size  文本大小
		 * @param	width  文本宽度
		 * @param	height 文本高度
		 * @return
		 */
		public static function getTextField(content:String = "", size:uint = 18, width:Number = 80, height:Number = 30 ,color:uint = 0xFD5C85):TextField
		{
			var text:String = content;
			var fmt:TextFormat = new TextFormat();
			fmt.size = size;
			fmt.color = color;
			fmt.font = "微软雅黑";
			
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.width = width;
			tf.height = height;
			tf.selectable = false;
			tf.text = text;
			tf.defaultTextFormat = fmt;
			
			return tf;
			
		}
		
		/**
		 * 动态文本框，主要用于“用户登录”“用户注册”
		 * @return
		 */
		public static function getInputTF():TextField
		{
			var fmt:TextFormat = new TextFormat();
			fmt.size = 18;
			fmt.font = "微软雅黑";
			
			var tf:TextField = new TextField();
			tf.width = 165;
			tf.height = 28;
			tf.type = TextFieldType.INPUT;
			tf.defaultTextFormat = fmt;
			return tf;
		}
		
		/**
		 * 显示用户得分的文本框
		 * @return
		 */
		public static function getScoreTF():TextField
		{
			var fmt:TextFormat = new TextFormat();
			fmt.size = 18;
			fmt.font = "微软雅黑";
			
			var tf:TextField = new TextField();
			tf.width = 130;
			tf.height = 30;
			tf.defaultTextFormat = fmt;
			return tf;
		}
	}

}