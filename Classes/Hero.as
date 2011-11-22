package
{
	import flash.display.MovieClip;

	public class Hero extends MovieClip
	{
		private var max_speed_x:Number = 5;
		private var max_speed_y:Number = 15;

		public var speed_x:Number = 0.0;
		private var speed_y:Number = 0.0;
		
		public var previous_x:Number;
		private var previous_y:Number;
		
		private var acceleration_x:Number = 0.2;
		private var acceleration_y:Number = 0.2;
		
		private var weight:Number = 1;
		private var gravity_const:Number = 1;
		
		private var jump_speed:Number = 12;
		private var break_speed:Number = 0.6;
		
		private var action:String;
		private var default_action:String = 'walk';
		private var action_repeat:Boolean = true;
		
		// 1 == right
		private var last_direction:int = 1;
		
		public function Hero()
		{
			/* x and y are inherit from MovieClip */
			x = 200.0;
			y = 200.0;
			
			previous_x = x;
			previous_y = y;
			
			this.stop();
			
			this.scaleX = 0.2;
			this.scaleY = 0.2;
			
			action = default_action;
			this.gotoAndPlay(action);
		}
		
		/* Check position to not allow the sprite to come out of the screen */
		private function checkPositionLimit():void
		{
			if (y > Document.MAX_HEIGTH)
			{
				y = Document.MAX_HEIGTH;
			}
		}
		
		/* Check speed limit */
		private function checkSpeedLimit(speed:Number, max_speed:Number):Number
		{
			// max speed
			if (speed > 0 && speed > max_speed)
			{
				speed = max_speed;
			}
			else if (speed < 0 && speed < max_speed*(-1))
			{
				speed = max_speed*(-1);
			}
			
			return speed;
		}
		
		/* Given a dimension, compute the good new speed */
		/* Gravity parameter is true if gravity must be applied */
		private function computeSpeed(input:int, speed:Number, acceleration:Number, gravity:Boolean):Number
		{
			// given input
			if (input !=0)
			{
				speed += acceleration*input;
			}
			else if (speed != 0)
			{
				// decrease speed given the movement's orientation
				// Warning take care to stop if speed value changes
				if (speed > 0)
				{
					speed -= acceleration + break_speed;
					if (speed < 0)
					{
						speed = 0;
					}
				}
				else
				{
					speed += acceleration + break_speed;
					if (speed > 0)
					{
						speed = 0;
					}
				}
			}
			
			// apply gravity
			if (gravity == true)
			{
				// small hack to avoid to pass through the floor 
				// must be replaced with true collision detection
				if (y < Document.MAX_HEIGTH)
				{
					acceleration += weight*gravity_const;
					speed += acceleration;
				}
			}
			
			return speed;
		}
		
		private function movePhysics(input_x:int, input_y:int):void
		{
			/* Compute speed */
			speed_x = computeSpeed(input_x, speed_x, acceleration_x, false);
			speed_y = computeSpeed(input_y, speed_y, acceleration_y, true);
			
			/* Check limites */
			speed_x = checkSpeedLimit(speed_x, max_speed_x);
			speed_y = checkSpeedLimit(speed_y, max_speed_y);
		}
		
		public function changeAction(new_action:String, repeatable:Boolean=true):void
		{
			this.action = new_action;
			action_repeat = repeatable;
		}
		
		public function move(direction_x:int, direction_y:int):void
		{
			// save old state
			previous_x = x;
			previous_y = y;
			
			movePhysics(direction_x, direction_y);
			
			/* Check jump */
			if (direction_y == -1 && y == Document.MAX_HEIGTH)
			{	
				changeAction('stopJump', false);
				speed_y = jump_speed*(-1);
			}

			x += speed_x;
			y += speed_y;
			
			checkPositionLimit();
			
			/* Movement */
			// not moving
			if (speed_x == 0 && speed_y == 0)
			{
				changeAction('breathe');
			}
			// loose altitude
			else if (speed_y > 0)
			{
				changeAction('walk');
			}
			// walk
			else if (speed_x != 0)
			{
				changeAction('walk');
			}
			
			
			/* Check action */
			if (action != currentLabel)
			{
				if (action_repeat)
				{
					this.gotoAndPlay(action);
				}
				else
				{
					this.gotoAndStop(action);
				}
				
			}
			
			
			if (direction_x != 0 && direction_x != last_direction)
			{
				this.scaleX *= -1;
			}
			
			if (direction_x != 0)
			{
				last_direction = direction_x;
			}
		}
		
		/* Rollback last move
		Can only be done one time */
		public function previousMove():void
		{
			this.x = this.previous_x;
			this.y = this.previous_y;
			
			this.speed_x = 0.0;
			this.speed_y = 0.0;
		}
		
		/* Test collide and revert if necessary */
		public function collide(colliding_object:Object):void
		{
			// collide bottom
			if (colliding_object.y < this.y)
			{
				if (this.height > (colliding_object.y - this.y))
				{
					this.y = this.previous_y;
				
					if (this.speed_y < 0)
					{
						this.speed_y = 0.0;
					}
				}
			}
			else
			{
				// collide below
				if (0 > (colliding_object.y - this.y))
				{
					//this.y -= (this.y - (colliding_object.y - colliding_object.height));
					trace(this.x)
					trace(colliding_object.y)
					// check if not getting off
					if(this.speed_y > 0)
					{
						this.y = colliding_object.y - colliding_object.height;
					}
					
					//this.y -= colliding_object.y - this.y;
					
					////if (this.speed_y > 0)
					//{
						//.speed_y = 0.0;
					//}
				}
			}

			
			// down
			/*if (0 > (colliding_object.y - this.y))
			{
				this.y = this.previous_y;
				
				if (this.speed_y > 0)
				{
					this.speed_y = 0.0;
				}
			}*/
		}
		
		
	}
}