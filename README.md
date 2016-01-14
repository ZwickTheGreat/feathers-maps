# AS3 Starling/Feathers maps
Google (and more) tiled-based maps developed directly for Starling and Feathers and optimized for mobile devices (Adobe AIR).

<img src="http://i.imgur.com/qnSQads.png" width="250"><img src="http://i.imgur.com/mJRQwCC.png" width="250">

# Basic Google maps usage
```as3
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
			geoMap.addLayer("googleMaps", googleMaps);
```

# Retina support
```as3
			var mapScale:Number = 2; // use 1 for non-retina displays
			GeoUtils.scale = mapScale;
			
			var googleMaps:MapLayerOptions = Maps.GOOGLE_MAPS_SCALED(mapScale); // it simply takes hdpi tiles from google
			googleMaps.notUsedZoomThreshold = 1;
			geoMap.addLayer("googleMaps", googleMaps);
```

# Basic markers support
```as3
			var markerTexture:Texture = Texture.fromEmbeddedAsset(MarkerClass);
			
			for (var i:int = 0; i < 100; i++) {
				var image:Image = new Image(markerTexture);
				image.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
				
				geoMap.addMarkerLongLat("marker" + i, mapOptions.initialCenter.x + .1 - Math.random() * .2, mapOptions.initialCenter.y + .1 - Math.random() * .2, image);
			}
```

