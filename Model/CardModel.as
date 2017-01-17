package Model 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	
	
	/**
	 * 卡片模型
	 * @author YaoQiao
	 */
	public class CardModel extends Sprite 
	{
		/**卡片的id,用来识别每一类卡片的唯一id */
		public var id:int;
		/**卡片的编号，用来识别每一张卡片的唯一号码 **/
		public var no:int;
		/**卡片的宽度，默认设置为40 */
		public var W:Number = 40;
		/**卡片的高度，默认设置为40 */
		public var H:Number = 40;
		/**作为卡片在map数组的横向坐标 */
		public var i:int;
		/**作为卡片在map数组的纵向坐标 */
		public var j:int;
		/**作为卡片的匹配目标卡片，即能和当前卡片匹配的卡片 */
		public var TargetCard:CardModel;
		/**卡片匹配时的路径数组 */
		public var Path:Array = new Array();
		/**匹配卡片成功后显示的连线 */
		public var line:Sprite = new Sprite();
		
		/**卡片背景颜色，默认为灰色*/
		private var color:uint = 0xcccccc;
		/**卡片是否被点击标志，默认为否 */
		private var pressed:Boolean;
		/**卡片是否处于提示状态，默认为否 **/
		private var isTiped:Boolean;
		/**卡片的边框 **/
		private var borderBitmap:Bitmap;
		public function CardModel(id:int) 
		{
			super();
			//设置卡片id
			this.id = id;
			init();
		}
	
		/**
		 * 设置卡片在map中对应的坐标索引
		 */
		public function setIndex(a:int,b:int):void
		{
			i = a;
			j = b;
		}
		
		/**
		 * 设置卡片已被点击的状态为true
		 */
		public function Pressed():void
		{
			pressed = true;
		}
		
		/**
		 * 设置卡片被点击的状态为false，并除去已点击卡片的所有阴影效果
		 */
		public function  UnPressed():void
		{
			pressed = false;
			this.border = false;
		}
		
				/**
		 * 设置卡片的边框
		 * @param hasBorder 当参数为true时，则显示边框
		 */
		public function set border(hasBorder:Boolean):void
		{
			if (hasBorder)
			{
				borderBitmap.visible = true;
			}
			else
			{
				borderBitmap.visible = false;
			}
		}
		/**
		 * 设置卡片的提示状态
		 */
		public function set isTip(value:Boolean):void
		{
			this.isTiped = value;
		}
		/**
		 * 获取卡片的提示状态
		 */
		public function get isTip():Boolean
		{
			return this.isTiped;
		}
		/**
		 * 初始化函数，进行一些初始化工作 
		 */
		private function init():void
		{
			/**添加边框，默认为不显示**/
			borderBitmap = new Bitmap();
			borderBitmap.bitmapData = new PicBoder();
			addChild(borderBitmap);
			this.border = false;
			
			/**添加图片 **/
			var pic:Bitmap = chooseBitmap(id);
			addChild(pic);
			
			/**对卡片添加鼠标移动事件侦听器，用来监听鼠标是否移动到卡片上，并做出相应的处理函数 */
			addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
			/**对卡片添加鼠标移除事件侦听器，用来监听鼠标是否移出卡片，并做出相应的处理函数 */
			addEventListener(MouseEvent.MOUSE_OUT, MouseOut);
			
			//设置宽度和高度
			this.W = this.width;
			this.H = this.height;
		}
		
		/**
		 * 根据id号来选择相对应的图片
		 * @param id 根据if号来选择相对应的
		 * @return
		 */
		private function chooseBitmap(id:int):Bitmap
		{
			var result:Bitmap = new Bitmap();
			switch(id)
			{
				case 1:
					result.bitmapData = new PicA();
					break;
				case 2:
					result.bitmapData = new PicB();
					break;
				case 3:
					result.bitmapData = new PicC();
					break;
				case 4:
					result.bitmapData = new PicD();
					break;
				case 5:
					result.bitmapData = new PicE();
					break;
				case 6:
					result.bitmapData = new PicF();
					break;
				case 7:
					result.bitmapData = new PicG();
					break;
				case 8:
					result.bitmapData = new PicH();
					break;
				case 9:
					result.bitmapData = new PicI();
					break;
				case 10:
					result.bitmapData = new PicJ();
					break;
				default:
					break;
			}
			return result;
			
		}
		
		/**
		 * 卡片的鼠标移动侦听事件处理函数，用来处理鼠标移动到的卡片
		 * @param	evt 传入的参数为鼠标事件
		 */
		private function MouseOver(evt:MouseEvent):void
		{
			
			/** 将当前卡片的的边框显示出来*/
			this.border = true;
		}
		
		/**
		 * 卡片的鼠标移出侦听事件处理函数，用来处理鼠标移出卡片的效果
		 */
		private function MouseOut(evt:MouseEvent):void
		{
			/**如果当前卡片的被点击标志位false，则移除当前卡片的所有滤镜效果 */
			if (pressed == false)
			{
				this.border = false;
			}
		}
		
	}


}