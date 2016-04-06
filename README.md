# AS3 Starling/Feathers maps
Updated for beta Starling 2.0

Google (and more) tiled-based maps developed directly for Starling and Feathers and optimized for mobile devices (Adobe AIR).

<img src="http://i.imgur.com/qnSQads.png" width="250"><img src="http://i.imgur.com/mJRQwCC.png" width="250">

# Basic maps usage
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

# HiDPI tiles support
Some map providers supports HiDPI tiles.
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

# Advantage against ANE
You can use all the features (mask, filters, rotations, Sprite3D, etc.) of Starling!
```as3
			// greyscale filter
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter(); 
			colorMatrixFilter.adjustSaturation( -1);
			geoMap.filter = colorMatrixFilter;
			
			// circle mask
			var mask:Canvas = new Canvas();
			mask.drawCircle(0, 0, 120);
			geoMap.mask = mask;
```

# Supported dependencies
Starling 1.7

# Roadmap
Support for Starling 2.0 after it's release.


