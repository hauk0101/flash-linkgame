package Model 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * 声音管理模型
	 * @author YaoQiao
	 */
	public class GameSoundModel 
	{
		/**背景音乐播放状态，默认为播放*/
		private var playSoundTmp:Boolean = true;
		/**背景音乐声音控制器 **/
		private var backgroundSoundChanel:SoundChannel;
		/**背景音乐声音对象 **/
		private var backgroundSound:Sound;
		
		
		
		public  function GameSoundModel():void
		{
			init();
		}
	
		/**
		 * 返回当前背景音乐的播放状态
		 */
		public function get playBackgroundState():Boolean
		{
			return playSoundTmp;
		}
		
		/**
		 * 设置当前背景音乐的播放状态
		 */
		public function set playBackgroundState(value:Boolean):void
		{
			playSoundTmp = value;
			playBackgroundSound();
		}
		
		/**
		 * 播放Ready声音
		 */
		public function playReadySound():void
		{
			if (playSoundTmp == false)  return;
			var chanel:SoundChannel = new SoundChannel();
			var sound:Sound = new ReadySounds();
			
			chanel = sound.play();
			chanel.addEventListener(Event.SOUND_COMPLETE,soundComplete);
			function soundComplete(e:Event):void
			{
				chanel.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
				chanel = null;
				sound = null;
			}
		}
		
		/**
		 * 播放Go声音
		 */
		public function playGoSound():void
		{
			if (playSoundTmp == false)  return;
			var chanel:SoundChannel = new SoundChannel();
			var sound:Sound = new GoSounds();
			
			chanel = sound.play();
			chanel.addEventListener(Event.SOUND_COMPLETE,soundComplete);
			function soundComplete(e:Event):void
			{
				chanel.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
				chanel = null;
				sound = null;
			}
		}
		
		/**
		 * 播放消除卡片音效
		 */
		public function playClearSound():void
		{
			if (playSoundTmp == false)  return;
			var chanel:SoundChannel = new SoundChannel();
			var sound:Sound = new ClearSound();
			
			chanel = sound.play();
			chanel.addEventListener(Event.SOUND_COMPLETE,soundComplete);
			function soundComplete(e:Event):void
			{
				chanel.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
				chanel = null;
				sound = null;
			}
		}
		
		/**
		 * 播放背景音乐
		 */
		private function playBackgroundSound():void
		{
			if (playSoundTmp)
			{
				backgroundSoundChanel = backgroundSound.play(0,int.MAX_VALUE);
			}
			else
			{
				backgroundSoundChanel.stop();
			}
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			backgroundSoundChanel = new SoundChannel();
			backgroundSound = new GameBackgroundSound();
		}
	}

}