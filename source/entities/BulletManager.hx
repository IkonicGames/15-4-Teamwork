
package entities;

import entities.Bullet;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxPool;
import flixel.util.FlxVelocity;

class BulletManager extends FlxTypedGroup<Bullet>
{
	public var maxBullets:Int;
	var bulletPool:FlxPool<Bullet>;

	public function new()
	{
	    super();

	    bulletPool = new FlxPool<Bullet>(Bullet);
	}

	public function shoot(fromX:Float, fromY:Float, toX:Float, toY:Float, speed:Float):Bool
	{
		if(maxBullets > 0 && this.countLiving() >= maxBullets)
			return false;

		var target = FlxPoint.weak(toX, toY);
	    var bullet = bulletPool.get();
	    bullet.setPosition(fromX, fromY);
	    FlxVelocity.moveTowardsPoint(bullet, target, speed);
	    add(bullet);

	    return true;
	}
}