package cz.j4w.map {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class MapOptions {
		public var disableMovement:Boolean;
		public var disableRotation:Boolean;
		public var disableZooming:Boolean;
		public var initialCenter:Point;
		public var initialScale:Number
		public var maximumScale:Number;
		public var minimumScale:Number;
		public var movementBounds:Rectangle;
		
		public function MapOptions() {
		
		}
	
	}

}