package cz.j4w.map {
	import feathers.controls.ImageLoader;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class MapLayer extends Sprite {
		private var mapTilesBuffer:MapTilesBuffer;
		private var _options:Object;
		protected var map:Map;
		protected var id:String;
		protected var urlTemplate:String;
		protected var tiles:Vector.<ImageLoader>;
		protected var tilesDictionary:Dictionary = new Dictionary(true);
		protected var tileSize:int;
		
		protected var notUsedZoomThreshold:int;
		protected var maximumZoom:int;
		
		public var debugTrace:Boolean = false;
		
		public function MapLayer(map:Map, id:String, options:Object, buffer:MapTilesBuffer) {
			super();
			this._options = options;
			this.id = id;
			this.map = map;
			this.mapTilesBuffer = buffer;
			this.tiles = new Vector.<ImageLoader>();
			
			this.urlTemplate = options.urlTemplate;
			if (!this.urlTemplate) {
				throw new Error("urlTemplate option is required");
			}
			this.notUsedZoomThreshold = options.notUsedZoomThreshold || 0;
			this.blendMode = options.blendMode || BlendMode.NORMAL;
			this.tileSize = options.tileSize || 256;
			this.maximumZoom = options.maximumZoom || 20;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Check tiles and create new ones if needed.
		 */
		protected function checkTiles():void {
			var mapViewPort:Rectangle = map.viewPort;
			
			var zoom:int = map.zoom;
			var scale:int = map.scaleRatio;
			var actualTileSize:Number = tileSize * scale;
			
			var startX:int = Math.floor(mapViewPort.left / actualTileSize);
			var endX:int = Math.ceil(mapViewPort.right / actualTileSize);
			var startY:int = Math.floor(mapViewPort.top / actualTileSize);
			var endY:int = Math.ceil(mapViewPort.bottom / actualTileSize);
			
			var tilesCreated:int = 0;
			for (var i:int = startX; i < endX; i += 1) {
				for (var j:int = startY; j < endY; j += 1) {
					if (createTile(i, j, actualTileSize, zoom, scale))
						tilesCreated++;
				}
			}
			if (debugTrace && tilesCreated)
				trace("Created", tilesCreated, "tiles.")
		}
		
		/**
		 * Check tiles visibility and removes those not visible.
		 */
		protected function checkNotUsedTiles():void {
			var mapViewPort:Rectangle = map.viewPort.clone();
			var zoom:int = map.zoom;
			
			var tilesCount:int = 0;
			var tilesRemoved:int = 0;
			for each (var tile:MapTile in tilesDictionary) {
				tilesCount++;
				// its outside viewport or its not current zoom
				if (!mapViewPort.intersects(tile.bounds) || Math.abs(map.zoom - tile.zoom) > notUsedZoomThreshold) {
					removeTile(tile);
					tilesRemoved++;
				}
			}
			if (debugTrace && tilesRemoved)
				trace("Removed", tilesRemoved, "tiles.")
		}
		
		protected function createTile(x:int, y:int, actualTileSize:Number, zoom:int, scale:int):Boolean {
			var key:String = getKey(x, y, zoom);
			
			if (tilesDictionary[key]) {
				return false;
			}
			
			var url:String = urlTemplate.replace("${z}", maximumZoom - zoom).replace("${x}", x).replace("${y}", y);
			
			var tile:ImageLoader = mapTilesBuffer.create(x, y, zoom);
			tile.source = url;
			tile.setSize(tileSize, tileSize);
			tile.x = x * actualTileSize;
			tile.y = y * actualTileSize;
			tile.scaleX = tile.scaleY = scale;
			addChild(tile);
			
			tilesDictionary[key] = tile;
			
			return true;
		}
		
		protected function removeTile(tile:MapTile):void {
			mapTilesBuffer.release(tile);
			tile.removeFromParent();
			
			var key:String = getKey(tile.mapX, tile.mapY, tile.zoom);
			tilesDictionary[key] = null;
			delete tilesDictionary[key];
		}
		
		[Inline]
		
		protected function getKey(x:int, y:int, zoom:int):String {
			return x + "x" + y + "x" + zoom;
		}
		
		//*************************************************************//
		//********************  Event Listeners  **********************//
		//*************************************************************//
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			checkTiles();
			checkNotUsedTiles();
		}
		
		public function get options():Object {
			return _options;
		}
	
	}

}