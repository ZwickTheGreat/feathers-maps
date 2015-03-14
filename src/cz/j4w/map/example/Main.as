package cz.j4w.map.example {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class Main extends Sprite {
		private var starling:Starling;
		
		public function Main():void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function initialize():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			initStarling();
		}
		
		/**
		 * Initialise the Starling sprites
		 */
		private function initStarling():void {
			Starling.multitouchEnabled = true;
			starling = new Starling(MainStarling, stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			starling.simulateMultitouch = true;
			starling.start();
		}
		
		//*************************************************************//
		//********************  Event Listeners  **********************//
		//*************************************************************//
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initialize();
		}
	}
}