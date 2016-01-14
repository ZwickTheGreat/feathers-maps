package cz.j4w.map.example {
	import cz.j4w.map.geo.GeoMap;
	import cz.j4w.map.geo.Maps;
	import cz.j4w.map.MapLayerOptions;
	import cz.j4w.map.MapOptions;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * Map test.
	 * @author Jakub Wagner, J4W
	 */
	public class MainStarling extends FeathersControl {
		[Embed(source="marker.png")]
		private var MarkerClass:Class;
		
		private var background:Quad;
		
		public function MainStarling() {
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			
			Starling.current.showStats = true;
			
			var mapOptions:MapOptions = new MapOptions();
			mapOptions.initialCenter = new Point(14.4777357, 50.1017711);
			mapOptions.initialScale = 1 / 32;
			mapOptions.disableRotation = true;
			
			var geoMap:GeoMap = new GeoMap(mapOptions);
			geoMap.setSize(stage.stageWidth - 100, stage.stageHeight - 100);
			geoMap.x = geoMap.y = 50;
			addChild(geoMap);
			
			var googleMaps:MapLayerOptions = Maps.GOOGLE_MAPS;
			googleMaps.notUsedZoomThreshold = 1;
			googleMaps.urlTemplate += "&scale=2";
			geoMap.addLayer("googleMaps", googleMaps);
			
			var markerTexture:Texture = Texture.fromEmbeddedAsset(MarkerClass);
			
			for (var i:int = 0; i < 100; i++) {
				var image:Image = new Image(markerTexture);
				image.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
				
				geoMap.addMarkerLongLat("marker" + i, mapOptions.initialCenter.x + .1 - Math.random() * .2, mapOptions.initialCenter.y + .1 - Math.random() * .2, image);
			}
		}
	
	}
}