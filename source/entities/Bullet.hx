
package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;

class Bullet extends FlxSprite
{
	public function new()
	{
	    super();

	    this.loadGraphic(AssetPaths.tinyBlock__png);
	    color = FlxColor.BLACK;
	}

	override public function update():Void
	{
	    super.update();
	    
		if(!this.isOnScreen())
			this.destroy();
	}

	public function shoot(fromX:Float, fromY:Float, toX:Float, toY:Float, speed:Float):Void
	{
		var target = FlxPoint.weak(toX, toY);
		FlxVelocity.moveTowardsPoint(this, target, speed);
	}

}