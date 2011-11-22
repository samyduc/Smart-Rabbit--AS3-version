package
{
	import flash.display.MovieClip;

	public class Enemy extends MovieClip
	{
		
		public function Enemy()
		{
			x = 100;
			y = 100;
		}
		
		public function moveDown():void
		{
			y = y + 3;
		}
		
		
	}
}