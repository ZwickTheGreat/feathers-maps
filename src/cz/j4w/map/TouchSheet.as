package cz.j4w.map {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Jakub Wagner, J4W
	 */
	public class TouchSheet extends Sprite {
		private var _disableMovement:Boolean;
		private var _disableRotation:Boolean;
		private var _disableZooming:Boolean;
		private var _minimumScale:Number;
		private var _maximumScale:Number;
		private var _movementBounds:Rectangle;
		private var viewPort:Rectangle;
		private var viewportAutoUpdate:Boolean;
		private var originalViewPort:Rectangle;
		
		private var movement:Point = new Point();
		private var decelerationRatio:Number = 0.95;
		private var touching:Boolean;
		
		/**
		 * Image
		 * @param	contents		DisplayObject to insert immiadiatly as a child.
		 * @param	params			Object with params...
		 *
		 * 							disableZooming
		 * 							disableRotation
		 * 							disableMovement
		 * 							movementBounds
		 */
		public function TouchSheet(contents:DisplayObject, viewPort:Rectangle, params:Object = null) {
			this.viewPort = viewPort;
			
			if (!params)
				params = {};
			
			disableZooming = params.disableZooming ? true : false;
			disableRotation = params.disableRotation ? true : false;
			disableMovement = params.disableMovement ? true : false;
			movementBounds = params.movementBounds;
			viewportAutoUpdate = params.hasOwnProperty("viewportAutoUpdate") && params.viewportAutoUpdate ? true : false;
			minimumScale = params.minimumScale;
			maximumScale = params.maximumScale;
			
			if (viewportAutoUpdate) {
				originalViewPort = viewPort.clone();
			}
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			addChild(contents);
		}
		
		private function onTouch(event:TouchEvent):void {
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			if (touches.length == 0) {
				if (event.getTouch(this, TouchPhase.ENDED))
					touching = false;
			} else if (touches.length == 1) {
				// one finger touching -> move
				touches[0].getMovement(parent, movement);
				if (!disableMovement) {
					x += movement.x;
					y += movement.y;
				}
				touching = true;
			} else if (touches.length == 2) {
				// two fingers touching -> rotate and scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				var currentVector:Point = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var currentAngle:Number = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number = currentAngle - previousAngle;
				
				// update pivot point based on previous center
				var previousLocalA:Point = touchA.getPreviousLocation(this);
				var previousLocalB:Point = touchB.getPreviousLocation(this);
				if (!disableMovement && !disableZooming) {
					pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
					pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
					
					// update location based on the current center
					x = (currentPosA.x + currentPosB.x) * 0.5;
					y = (currentPosA.y + currentPosB.y) * 0.5;
				}
				
				// rotate
				if (!disableRotation) {
					rotation += deltaAngle;
				}
				
				// scale
				if (!disableZooming) {
					var sizeDiff:Number = currentVector.length / previousVector.length;
					scaleX *= sizeDiff;
					scaleY *= sizeDiff;
					if (minimumScale && minimumScale > scaleX) {
						scaleX = scaleY = minimumScale;
					}
					if (maximumScale && maximumScale < scaleX) {
						scaleX = scaleY = maximumScale;
					}
				}
			}
			applyBounds();
		}
		
		public function applyBounds():void {
			if (movementBounds) {
				if (viewportAutoUpdate) {
					viewPort.x = -x;
					viewPort.y = -y;
				}
				if (viewPort.left < movementBounds.left) {
					this.x += (viewPort.left - movementBounds.left) * scaleX;
				} else if (viewPort.right > movementBounds.right) {
					this.x += (viewPort.right - movementBounds.right) * scaleX;
				}
				
				if (viewPort.top < movementBounds.top) {
					this.y += (viewPort.top - movementBounds.top) * scaleY;
				} else if (viewPort.bottom > movementBounds.bottom) {
					this.y += (viewPort.bottom - movementBounds.bottom) * scaleY;
				}
			}
		}
		
		public override function dispose():void {
			removeEventListener(TouchEvent.TOUCH, onTouch);
			super.dispose();
		}
		
		public function get movementBounds():Rectangle {
			return _movementBounds;
		}
		
		public function set movementBounds(value:Rectangle):void {
			_movementBounds = value;
			applyBounds();
		}
		
		public function get disableMovement():Boolean {
			return _disableMovement;
		}
		
		public function set disableMovement(value:Boolean):void {
			_disableMovement = value;
		}
		
		public function get disableRotation():Boolean {
			return _disableRotation;
		}
		
		public function set disableRotation(value:Boolean):void {
			_disableRotation = value;
		}
		
		public function get disableZooming():Boolean {
			return _disableZooming;
		}
		
		public function set disableZooming(value:Boolean):void {
			_disableZooming = value;
		}
		
		public function get minimumScale():Number {
			return _minimumScale;
		}
		
		public function set minimumScale(value:Number):void {
			_minimumScale = value;
		}
		
		public function get maximumScale():Number {
			return _maximumScale;
		}
		
		public function set maximumScale(value:Number):void {
			_maximumScale = value;
		}
		
		//*************************************************************//
		//********************  Event Listeners  **********************//
		//*************************************************************//
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!touching) {
				movement.x *= decelerationRatio;
				movement.y *= decelerationRatio;
				x += movement.x;
				y += movement.y;
				applyBounds();
			}
		}
	
	}

}