package cz.j4w.map.example {
	import cz.j4w.map.MapLayerOptions;
	import cz.j4w.map.MapOptions;
	import cz.j4w.map.events.MapEvent;
	import cz.j4w.map.geo.GeoMap;
	import cz.j4w.map.geo.GeoUtils;
	import cz.j4w.map.geo.Maps;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	/**
	 * Map test.
	 * @author Jakub Wagner, J4W
	 */
	public class MainStarling extends FeathersControl {
		[Embed(source = "marker.png")]
		private var MarkerClass:Class;
		
		private var background:Quad;
		
		public function MainStarling() {
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			Starling.current.showStats = true;
			Starling.current.skipUnchangedFrames = true;
			
			var mapScale:Number = 2; // use 1 for non-retina displays
			GeoUtils.scale = mapScale;
			
			var mapOptions:MapOptions = new MapOptions();
			mapOptions.initialCenter = new Point(14.4777357, 50.1017711);
			mapOptions.initialScale = 1 / 32 / mapScale;
			mapOptions.disableRotation = true;
			
			var geoMap:GeoMap = new GeoMap(mapOptions);
			geoMap.setSize(stage.stageWidth - 100, stage.stageHeight - 100);
			geoMap.x = geoMap.y = 50;
			addChild(geoMap);
			
			var googleMaps:MapLayerOptions = Maps.GOOGLE_MAPS_SCALED(mapScale);
			googleMaps.notUsedZoomThreshold = 1;
			geoMap.addLayer("googleMaps", googleMaps);
			
			var markerTexture:Texture = Texture.fromEmbeddedAsset(MarkerClass);
			
			for (var i:int = 0; i < 100; i++) {
				var image:Image = new Image(markerTexture);
				image.alignPivot(HorizontalAlign.CENTER, VerticalAlign.BOTTOM);
				
				geoMap.addMarkerLongLat("marker" + i, mapOptions.initialCenter.x + .1 - Math.random() * .2, mapOptions.initialCenter.y + .1 - Math.random() * .2, image);
			}
			geoMap.addEventListener(MapEvent.MARKER_TRIGGERED, onGeoMapMarkerTriggered);
		}
		
		private function onGeoMapMarkerTriggered(e:MapEvent):void {
			trace(e.target);
		}
	
	}
}