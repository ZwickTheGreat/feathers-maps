package cz.j4w.map {
	import feathers.controls.ImageLoader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class MapTile extends ImageLoader {
		protected var buffer:MapTilesBuffer;
		
		public var sourceBackup:Object;
		
		public var mapX:int;
		public var mapY:int;
		public var zoom:int;
		
		public function MapTile(mapX:int, mapY:int, zoom:int, buffer:MapTilesBuffer) {
			super();
			
			this.buffer = buffer;
			this.zoom = zoom;
			this.mapY = mapY;
			this.mapX = mapX;
		}
		
		override public function set source(value:Object):void {
			if (!sourceBackup) {
				buffer.currentlyBuffering.push(this);
				sourceBackup = value;
				return;
			}
			super.source = value;
		}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		override public function hitTest(localPoint:Point):DisplayObject {
			// all tiles are always able to touch
			return this;
		}
		
		//*************************************************************//
		//********************  Event Listeners  **********************//
		//*************************************************************//
		
		override protected function loader_completeHandler(event:flash.events.Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			if (loaderInfo.bytesTotal == 1113) // empty tile
				visible = false;
			else {
				super.loader_completeHandler(event);
				visible = true;
				alpha = 0;
				Starling.juggler.tween(this, .2, {alpha: 1});
			}
		}
	
	}

}