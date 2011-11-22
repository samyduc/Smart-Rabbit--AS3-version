package
{
	import flash.display.MovieClip;
	
	public class Document extends MovieClip 
	{
		public var mainScreen:Main;
		
		/* Change it to show the real size of the window*/
		public static const MAX_WIDTH = 550;
		public static const MAX_HEIGTH = 400;
		
		public function Document() 
		{
 			mainScreen = new Main();
			addChild(mainScreen);
		}
	}
}