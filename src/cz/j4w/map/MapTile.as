package cz.j4w.map {
	import feathers.controls.ImageLoader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class MapTile extends ImageLoader {
		public var mapX:int;
		public var mapY:int;
		public var zoom:int;
		
		public function MapTile(mapX:int, mapY:int, zoom:int) {
			super();
			this.zoom = zoom;
			this.mapY = mapY;
			this.mapX = mapX;
		}
		
		override protected function loader_completeHandler(event:flash.events.Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			if (loaderInfo.bytesTotal == 1113) // empty tile
				visible = false;
			else {
				super.loader_completeHandler(event);
				alpha = 0;
				Starling.juggler.tween(this, .2, {alpha: 1});
			}
		}
	
	}

}