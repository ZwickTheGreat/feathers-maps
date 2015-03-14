package cz.j4w.map.geo {
	import cz.j4w.map.Map;
	import cz.j4w.map.MapOptions;
	import flash.geom.Point;
	import starling.animation.Tween;
	
	/**
	 * Geo maps. Implements position methods with longitude and latitude.
	 * @author Jakub Wagner, J4W
	 */
	public class GeoMap extends Map {
		
		public function GeoMap(mapOptions:MapOptions) {
			super(mapOptions);
		}
		
		override protected function initialize():void {
			super.initialize();
			
			if (mapOptions.initialCenter)
				setCenterLongLat(mapOptions.initialCenter.x, mapOptions.initialCenter.y);
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