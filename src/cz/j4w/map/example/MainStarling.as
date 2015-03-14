package cz.j4w.map.example {
	import cz.j4w.map.geo.GeoMap;
	import cz.j4w.map.geo.Maps;
	import cz.j4w.map.MapLayerOptions;
	import cz.j4w.map.MapOptions;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Quad;
	
	/**
	 * Map test.
	 * @author Jakub Wagner, J4W
	 */
	public class MainStarling extends FeathersControl {
		private var background:Quad;
		private var quad:Quad;
		
		public function MainStarling() {
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			
			Starling.current.showStats = true;
			
			var mapOptions:MapOptions = new MapOptions();
			mapOptions.initialCenter = new Point(14.4777357, 50.1017711);
			
			var geoMap:GeoMap = new GeoMap(mapOptions);
			geoMap.setSize(stage.stageWidth / 2, stage.stageHeight / 2);
			geoMap.scaleX = geoMap.scaleY = 2;
			addChild(geoMap);
			
			var googleMaps:MapLayerOptions = Maps.GOOGLE_MAPS;
			googleMaps.notUsedZoomThreshold = 1;
			googleMaps.urlTemplate += "&scale=2";
			geoMap.addLayer("googleMaps", googleMaps);			
		}
	
	}
}