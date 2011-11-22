package
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flashx.textLayout.formats.BlockProgression;
	
	
	public class Main extends MovieClip
	{
		public var enemy:Enemy;
		public var hero:Hero;
		public var bloc:Bloc;
		
		/* Input control */
		public const index_x:int = 0;
		public const index_y:int = 1;
		public var input:Array = new Array(0, 0);
		
		public const move_plus:int = 1;
		public const move_minus:int = -1;
		
		// aproximately 60fps
		public const tick_rate:int = 16;
		
		private var gameTick:Timer;
		
		public function Main()
		{	
			Mouse.hide();
		
			enemy = new Enemy();
			addChild(enemy);
			
			hero = new Hero();
			addChild(hero);
			
			bloc = new Bloc();
			addChild(bloc);
			bloc.x = 300;
			bloc.y = 390;
			
			/* Declare listeners */
			addEventListener( Event.ADDED_TO_STAGE, onAddToStage );
			
			/* Game tick */
			gameTick = new Timer(tick_rate);
			gameTick.addEventListener(TimerEvent.TIMER, gameLoop);
			gameTick.start();
		}
		
		/* Main Game Loop */
		public function gameLoop(timerEvent:TimerEvent):void
		{
			hero.move(input[0], input[1]);
			
			detectCollide(hero);
			
			renderLoop(timerEvent);
			
		}
		
		public function detectCollide(test_object:Object):void
		{
			if (test_object.hitTestObject(bloc) == true)
			{
				// treat collide
				test_object.collide(bloc);
			}
		}
		
		/* Render Loop */
		public function renderLoop(timerEvent:TimerEvent):void
		{
			//hero.gotoAndPlay(3);
			
		}
		
		/* Event listeners */
		public function onAddToStage( event:Event ):void
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyRelease );
		}
		
		
		public function onKeyPress(keyboardEvent:KeyboardEvent):void
		{
				if ( keyboardEvent.keyCode == Keyboard.DOWN )
				{
					input[index_y] = move_plus;
				}
				else if ( keyboardEvent.keyCode == Keyboard.UP )
				{
					input[index_y] = move_minus;
				}
				else if ( keyboardEvent.keyCode == Keyboard.LEFT )
				{
					input[index_x] = move_minus;
				}
				else if ( keyboardEvent.keyCode == Keyboard.RIGHT )
				{
					input[index_x] = move_plus;
				}
		}
		
		public function onKeyRelease(keyboardEvent:KeyboardEvent):void
		{
				if ( keyboardEvent.keyCode == Keyboard.DOWN )
				{
					input[index_y] = 0;
				}
				else if ( keyboardEvent.keyCode == Keyboard.UP )
				{
					input[index_y] = 0;
				}
				else if ( keyboardEvent.keyCode == Keyboard.LEFT )
				{
					input[index_x] = 0;
				}
				else if ( keyboardEvent.keyCode == Keyboard.RIGHT )
				{
					input[index_x] = 0;
				}
		}
	}
}