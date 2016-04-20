package cz.j4w.map {
	import cz.j4w.map.events.MapEvent;
	import feathers.core.FeathersControl;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * Main Starling class. Provides demo Feathers UI for map controll.
	 */
	public class Map extends FeathersControl {
		private var currentTween:Tween;
		private var tweenTransition:Function = Transitions.getTransition(Transitions.EASE_IN_OUT);
		
		protected var mapTilesBuffer:MapTilesBuffer;
		
		protected var mapOptions:MapOptions;
		protected var mapContainer:Sprite;
		protected var markersContainer:Sprite;
		protected var touchSheet:TouchSheet;
		protected var markers:Dictionary;
		
		protected var layers:Array;
		protected var mapViewPort:Rectangle;
		protected var centerBackup:Point;
		
		private var _scaleRatio:int;
		private var _zoom:int;
		
		public function Map(mapOptions:MapOptions) {
			this.mapOptions = mapOptions;
		}
		
		override protected function initialize():void {
			layers = [];
			
			mapTilesBuffer = new MapTilesBuffer();
			markers = new Dictionary();
			centerBackup = new Point();
			mapViewPort = new Rectangle();
			mapContainer = new Sprite();
			markersContainer = new Sprite();
			touchSheet = new TouchSheet(mapContainer, viewPort, mapOptions);
			addChild(touchSheet);
			mapContainer.addChild(markersContainer);
			
			touchSheet.scaleX = touchSheet.scaleY = mapOptions.initialScale || 1;
			
			if (mapOptions.initialCenter)
				setCenter(mapOptions.initialCenter);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, onNativeStageMouseWheel);
		}
		
		override public function dispose():void {
			super.dispose();
			mapTilesBuffer.dispose();
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, onNativeStageMouseWheel);
		}
		
		override protected function draw():void {
			mask = new Quad(scaledActualWidth, scaledActualHeight);
			setCenter(centerBackup);
		}
		
		protected function update():void {
			getBounds(touchSheet, mapViewPort); // calculate mapViewPort before bounds check
			touchSheet.applyBounds();
			getBounds(touchSheet, mapViewPort); // calculate mapViewPort after bounds check
			updateMarkers();
			updateZoomAndScale();
		}
		
		protected function updateMarkers():void {
			var n:int = markersContainer.numChildren;
			var sx:Number = 1 / touchSheet.scaleX;
			for (var i:int = 0; i < n; i++) {
				var marker:DisplayObject = markersContainer.getChildAt(i); // scaling markers always to be 1:1
				marker.scaleX = marker.scaleY = sx;
				marker.visible = mapViewPort.intersects(marker.bounds);
			}
		}
		
		public function addLayer(id:String, options:Object = null):MapLayer {
			if (layers[id]) {
				trace("Layer", id, "already added.")
				return layers[id];
			}
			
			if (!options)
				options = {};
			
			var childIndex:uint = options.index >= 0 ? options.index : mapContainer.numChildren;
			
			var layer:MapLayer = new MapLayer(this, id, options, mapTilesBuffer);
			mapContainer.addChildAt(layer, childIndex);
			mapContainer.addChild(markersContainer); // markers are always on top
			
			layers[id] = layer;
			
			return layer;
		}
		
		public function removeLayer(id:String):void {
			if (layers[id]) {
				var layer:MapLayer = layers[id] as MapLayer;
				layer.removeFromParent(true);
				layers[id] = null;
				delete layers[id];
			}
		}
		
		public function removeAllLayers():void {
			for (var layerId:String in layers) {
				removeLayer(layerId);
			}
		}
		
		public function hasLayer(id:String):Boolean {
			return layers[id];
		}
		
		public function getLayer(id:String):MapLayer {
			return layers[id];
		}
		
		public function addMarker(id:String, x:Number, y:Number, displayObject:DisplayObject, data:Object = null):MapMarker {
			displayObject.name = id;
			displayObject.x = x;
			displayObject.y = y;
			markersContainer.addChild(displayObject);
			
			var mapMarker:MapMarker = createMarker(id, displayObject, data);
			markers[id] = mapMarker;
			return mapMarker;
		}
		
		protected function createMarker(id:String, displayObject:DisplayObject, data:Object):MapMarker {
			return new MapMarker(id, displayObject, data);
		}
		
		public function getMarker(id:String):MapMarker {
			return markers[id] as MapMarker;
		}
		
		public function removeMarker(id:String):MapMarker {
			var mapMarker:MapMarker = markers[id] as MapMarker;
			
			if (mapMarker) {
				var displayObject:DisplayObject = mapMarker.displayObject;
				displayObject.removeFromParent();
				delete markers[id];
			}
			
			return mapMarker;
		}
		
		public function removeAllMarkers():void {
			markersContainer.removeChildren();
			markers = new Dictionary();
		}
		
		public function get viewPort():Rectangle {
			return mapViewPort;
		}
		
		public function get zoom():int {
			return _zoom;
		}
		
		public function get scaleRatio():int {
			return _scaleRatio;
		}
		
		private function updateZoomAndScale():void {
			_scaleRatio = 1;
			var z:int = int(1 / touchSheet.scaleX);
			while (_scaleRatio < z) {
				_scaleRatio <<= 1;
			}
			
			var s:uint = _scaleRatio;
			_zoom = 1;
			while (s > 1) {
				s >>= 1;
				++_zoom;
			}
		}
		
		public function setCenter(point:Point):void {
			setCenterXY(point.x, point.y);
		}
		
		public function getCenter():Point {
			return new Point(mapViewPort.x + mapViewPort.width / 2, mapViewPort.y + mapViewPort.height / 2);
		}
		
		public function setCenterXY(x:Number, y:Number):void {
			update();
			centerBackup.setTo(x, y);
			touchSheet.pivotX = x;
			touchSheet.pivotY = y;
			touchSheet.x = width / 2;
			touchSheet.y = height / 2;
			update();
		}
		
		public function tweenTo(x:Number, y:Number, scale:Number = 1, time:Number = 3):Tween {
			cancelTween();
			
			var center:Point = getCenter();
			
			var tweenObject:Object = {ratio: 0, x: center.x, y: center.y, scale: touchSheet.scaleX};
			var tweenTo:Object = {ratio: 1, x: x, y: y, scale: scale};
			currentTween = Starling.juggler.tween(tweenObject, time, {ratio: 1, onComplete: tweenComplete, onUpdate: tweenUpdate, onUpdateArgs: [tweenObject, tweenTo]}) as Tween;
			
			return currentTween;
		}
		
		public function cancelTween():void {
			if (currentTween) {
				Starling.juggler.remove(currentTween);
				currentTween = null;
			}
		}
		
		public function isTweening():Boolean {
			return currentTween != null;
		}
		
		protected function tweenUpdate(tweenObject:Object, tweenTo:Object):void {
			// scale tween is much slower then position
			
			var ratio:Number = tweenObject.ratio;
			var r1:Number = tweenTransition(ratio);
			var r2:Number = tweenTransition(ratio * 3 <= 1 ? ratio * 3 : 1); // faster ratio
			
			var currentScale:Number = tweenObject.scale + (tweenTo.scale - tweenObject.scale) * r1;
			var currentX:Number = tweenObject.x + (tweenTo.x - tweenObject.x) * r2;
			var currentY:Number = tweenObject.y + (tweenTo.y - tweenObject.y) * r2;
			
			touchSheet.scaleX = touchSheet.scaleY = currentScale;
			setCenterXY(currentX, currentY);
		}
		
		protected function tweenComplete():void {
			Starling.juggler.remove(currentTween);
			currentTween = null;
		}
		
		//*************************************************************//
		//********************  Event Listeners  **********************//
		//*************************************************************//
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			update();
		}
		
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this, TouchPhase.MOVED);
			if (touch)
				cancelTween();
			
			touch = e.getTouch(markersContainer, TouchPhase.ENDED);
			if (touch) {
				var displayObject:DisplayObject = touch.target;
				if (displayObject && displayObject.parent == markersContainer) {
					var marker:MapMarker = getMarker(displayObject.name);
					dispatchEvent(new MapEvent(MapEvent.MARKER_TRIGGERED, false, marker));
				}
			}
		}
		
		private function onNativeStageMouseWheel(e:MouseEvent):void {
			var point:Point = globalToLocal(new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY));
			
			if (bounds.containsPoint(point)) {
				point.x -= width / 2;
				point.y -= height / 2;
				
				var center:Point = getCenter();
				center.x += point.x / touchSheet.scaleX;
				center.y += point.y / touchSheet.scaleY;
				
				var newScale:Number = touchSheet.scaleX / (e.delta > 0 ? 0.5 : 2);
				newScale = Math.max(mapOptions.minimumScale, newScale);
				newScale = Math.min(mapOptions.maximumScale, newScale);
				tweenTo(center.x, center.y, newScale, .3);
			}
		}
		
		private function sortMarkersFunction(d1:DisplayObject, d2:DisplayObject):int {
			return d1.x > d2.x ? 1 : -1;
		}
	
	}
}
