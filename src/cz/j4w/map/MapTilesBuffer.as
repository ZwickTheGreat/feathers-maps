package cz.j4w.map {
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * MapTiles loading buffer and pool.
	 * @author Jakub Wagner, J4W
	 */
	public class MapTilesBuffer {
		public var pool:Vector.<MapTile> = new Vector.<MapTile>();
		public var currentlyBuffering:Vector.<MapTile> = new Vector.<MapTile>();
		private var bufferingInterval:uint;
		
		public function MapTilesBuffer() {
			bufferingInterval = setInterval(checkCurrentlyCommiting, 1000 / 15);
		}
		
		private function checkCurrentlyCommiting():void {
			for (var i:int = 0; i < 5; i++) {
				if (currentlyBuffering.length) {
					var mapTile:MapTile = currentlyBuffering.shift();
					if (mapTile.isDisposed || !mapTile.sourceBackup) {
						i--;
						continue;
					}
					mapTile.source = mapTile.sourceBackup;
				}
			}
		}
		
		public function create(mapX:int, mapY:int, zoom:int):MapTile {
			var mapTile:MapTile = pool.pop();
			if (!mapTile) {
				mapTile = new MapTile(mapX, mapY, zoom, this);
			} else {
				mapTile.mapX = mapX;
				mapTile.mapY = mapY;
				mapTile.zoom = zoom;
			}
			return mapTile;
		}
		
		public function release(mapTile:MapTile):void {
			if (mapTile.source)
				mapTile.source = null;
			mapTile.sourceBackup = null;
			mapTile.visible = false;
			pool.push(mapTile);
		}
		
		public function dispose():void {
			var item:MapTile;
			for each (item in pool) {
				if (!item.isDisposed)
					item.dispose();
			}
			for each (item in currentlyBuffering) {
				if (!item.isDisposed)
					item.dispose();
			}
			pool.length = 0;
			currentlyBuffering.length = 0;
			
			clearInterval(bufferingInterval);
		}
	
	}

}