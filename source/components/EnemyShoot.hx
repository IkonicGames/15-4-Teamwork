
package components;

import entities.Player;
import entities.BulletManager;
import ikutil.IkEntity;
import ikutil.IkComponent;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.addons.editors.tiled.TiledObject;
import haxe.ds.StringMap;

class EnemyShoot extends IkComponent
{
	public static inline var LEFT:Int = -1;
	public static inline var CLOSEST:Int = 0;
	public static inline var RIGHT:Int = 1;

	var bulletSpeed:Float = 100;

	var player:Player;
	var bulletManager:BulletManager;

	var timer:FlxTimer;
	var shootInterval:Float;
	var shootTarget:Int;
	var target:FlxPoint;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);

	    target = FlxPoint.get();
	}

	override public function update():Void
	{
	    timer.active = owner.isOnScreen();
	}

	override public function init():Void
	{
	    super.init();

	    timer = new FlxTimer(shootInterval, onShootTimerComplete);
	    timer.active = false;
	    player = Reg.player;
	    bulletManager = Reg.currentLevel.enemyBullets;

	    var tObj:TiledObject = Reg.currentLevel.objects.get(owner);
	    if(tObj.custom.contains("shootTarget"))
	    {
	    	switch (tObj.custom.get("shootTarget")) {
	    		case "left":
	    			shootTarget = LEFT;

	    		case "right":
	    			shootTarget = RIGHT;

	    		default:
	    			shootTarget = CLOSEST;
	    	}
	    }
	}

	override public function destroy():Void
	{
		timer.destroy();
		target.put();
	    super.destroy();
	}

	public function setData(shootInterval:Float, shootTarget:Int = 0):Void
	{
	    this.shootInterval = shootInterval;
	    this.shootTarget = shootTarget;
	}

	private function onShootTimerComplete(timer:FlxTimer):Void
	{
		if(!owner.alive)
			return;
			
		switch(shootTarget)
		{
			case LEFT:
				target.set(player.left.x, player.left.y);

			case RIGHT:
				target.set(player.right.x, player.right.y);

			case CLOSEST:
				var left = FlxMath.distanceBetween(owner, player.left);
				var right = FlxMath.distanceBetween(owner, player.right);
				if(left < right)
					target.set(player.left.x, player.left.y);
				else
					target.set(player.right.x, player.right.y);
		}

		bulletManager.shoot(owner.x, owner.y, target.x, target.y, bulletSpeed);

		timer.reset(shootInterval);
	}
}