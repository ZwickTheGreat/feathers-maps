package cz.j4w.map.events {
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class MapEvent extends Event {
		static public const MARKER_TRIGGERED:String = "markerTriggered";
		
		public function MapEvent(type:String, bubbles:Boolean = false, data:Object = null) {
			super(type, bubbles, data);
		}
	
	}

}