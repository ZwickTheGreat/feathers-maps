package cz.j4w.map.geo {
	import cz.j4w.map.Map;
	import cz.j4w.map.MapMarker;
	import cz.j4w.map.MapOptions;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	
	/**
	 * Geo maps. Implements position methods with longitude and latitude.
	 * @author Jakub Wagner, J4W
	 */
	public class GeoMap extends Map {
		
		public function GeoMap(mapOptions:MapOptions) {
			var m:Rectangle = mapOptions.movementBounds;
			if (m) {
				// movements bounds are supposed to be lon/lat coords
				m.left = GeoUtils.lon2x(m.left);
				m.top = GeoUtils.lat2y(m.top);
				m.right = GeoUtils.lon2x(m.right);
				m.bottom = GeoUtils.lat2y(m.bottom);
			}
			super(mapOptions);
		}
		
		override protected function initialize():void {
			super.initialize();
			
			if (mapOptions.initialCenter)
				setCenterLongLat(mapOptions.initialCenter.x, mapOptions.initialCenter.y);
		}
		
		public function addMarkerLongLat(id:String, long:Number, lat:Number, displayObject:DisplayObject, data:Object = null):MapMarker {
			return addMarker(id, GeoUtils.lon2x(long), GeoUtils.lat2y(lat), displayObject, data);
		}
		
		public function getCenterLongLat():Point {
			var center:Point = getCenter();
			center.x = GeoUtils.x2lon(center.x);
			center.y = GeoUtils.y2lat(center.y);
			return center;
		}
		
		public function setCenterLongLat(long:Number, lat:Number):void {
			setCenterXY(GeoUtils.lon2x(long), GeoUtils.lat2y(lat));
		}
		
		public function tweenToLongLat(long:Number, lat:Number, scale:Number = 1, time:Number = 3):Tween {
			return tweenTo(GeoUtils.lon2x(long), GeoUtils.lat2y(lat), scale, time);
		}
	
	}

}