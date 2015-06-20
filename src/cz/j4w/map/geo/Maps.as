package cz.j4w.map.geo {
	import cz.j4w.map.MapLayerOptions;
	/**
	 * This class provides implementation of some tile providers
	 * (mapquest, openstreetmaps, cloudmade, arcgis)
	 */
	public class Maps {
		
		public static function get GOOGLE_MAPS():MapLayerOptions {
			return createMapLayerOptions(["http://mt1.google.com/vt/lyrs=r&x=${x}&y=${y}&z=${z}"]);
		}
		
		public static function GOOGLE_MAPS_SCALED(scale:int):MapLayerOptions {
			var googleMaps:MapLayerOptions = createMapLayerOptions(["http://mt1.google.com/vt/lyrs=r&x=${x}&y=${y}&z=${z}"]);
			googleMaps.urlTemplate += "&scale=" + scale;
			googleMaps.tileSize = 256 * scale;
			return googleMaps;
		}
		
		public static function get GOOGLE_MAPS_HYBRID():MapLayerOptions {
			return createMapLayerOptions(["http://mt1.google.com/vt/lyrs=y&x=${x}&y=${y}&z=${z}"]);
		}
		
		public static function get GOOGLE_MAPS_SATELLITE():MapLayerOptions {
			return createMapLayerOptions(["http://mt1.google.com/vt/lyrs=s&x=${x}&y=${y}&z=${z}"]);
		}
		
		public static function get MAPQUEST():MapLayerOptions {
			return createMapLayerOptions(["http://otile1.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png", "http://otile2.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png", "http://otile3.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png", "http://otile4.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png"]);
		}
		
		public static function get OSM():MapLayerOptions {
			return createMapLayerOptions(["http://a.tile.openstreetmap.org/${z}/${x}/${y}.png", "http://b.tile.openstreetmap.org/${z}/${x}/${y}.png", "http://c.tile.openstreetmap.org/${z}/${x}/${y}.png"]);
		}
		
		public static function get MAPBOX():MapLayerOptions {
			return createMapLayerOptions(["http://a.tiles.mapbox.com/v3/examples.map-vyofok3q/${z}/${x}/${y}.png", "http://b.tiles.mapbox.com/v3/examples.map-vyofok3q/${z}/${x}/${y}.png", "http://c.tiles.mapbox.com/v3/examples.map-vyofok3q/${z}/${x}/${y}.png", "http://d.tiles.mapbox.com/v3/examples.map-vyofok3q/${z}/${x}/${y}.png"]);
		}
		
		public static function get CLOUDMADE():MapLayerOptions {
			return createMapLayerOptions(["http://a.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/998/256/${z}/${x}/${y}.png", "http://b.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/998/256/${z}/${x}/${y}.png", "http://c.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/998/256/${z}/${x}/${y}.png"]);
		}
		
		public static function get ARCGIS_IMAGERY():MapLayerOptions {
			return createMapLayerOptions(["http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/${z}/${y}/${x}.png", "http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/${z}/${y}/${x}.png"]);
		}
		
		public static function get ARCGIS_NATIONAL_GEOGRAPHIC():MapLayerOptions {
			return createMapLayerOptions(["http://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/${z}/${y}/${x}.png", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/${z}/${y}/${x}.png"]);
		}
		
		public static function get ARCGIS_REFERENCE():MapLayerOptions {
			return createMapLayerOptions(["http://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/${z}/${y}/${x}.png", "http://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/${z}/${y}/${x}.png"]);
		}
		
		private static function createMapLayerOptions(templates:Array):MapLayerOptions {
			var result:MapLayerOptions = new MapLayerOptions;
			result.urlTemplate = templates[0]; // TODO: do not use only first url
			result.tileSize = 256;
			return result;
		}
	}
}