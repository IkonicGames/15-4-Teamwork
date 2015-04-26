
package components;

import ikutil.IkEntity;
import ikutil.IkComponent;
import components.MoveOnPath;
import flixel.util.FlxTimer;
import flixel.addons.editors.tiled.TiledPropertySet;
import entities.BulletManager;
import entities.Player;
import haxe.ds.StringMap;

class RunAndGun extends IkComponent
{
	var moveOnPath:MoveOnPath;

	var timer:FlxTimer;
	
	var runTime:Float;
	var waitTime:Float;
	var shootTime:Float;
	var numBullets:Int;

	var player:Player;
	var shotsTaken:Int;
	var bulletManager:BulletManager;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);

	    timer = new FlxTimer();
	}

	override public function init():Void
	{
	    super.init();
	    moveOnPath = cast owner.getComponent(MoveOnPath);

	    timer.start(runTime, onRunTimeComplete);
	    player = Reg.player;
	}

	override public function destroy():Void
	{
		timer.destroy();

	    super.destroy();
	}
	
	private function onRunTimeComplete(timer:FlxTimer):Void
	{
		// stop running
		moveOnPath.enabled = false;
	    timer.start(waitTime, onWaitTimeComplete);
	}

	private function onWaitTimeComplete(timer:FlxTimer):Void
	{
		// start shooting
		shoot();
	}

	private function onShootTimeComplete(timer:FlxTimer):Void
	{
	    shoot();
	}

	public function setBulletManager(bulletManager:BulletManager):Void
	{
	    this.bulletManager = bulletManager;
	}

	private function shoot():Void
	{
		var target = player.getClosestTo(owner);
		bulletManager.shoot(owner.x, owner.y, target.x, target.y, 300);
	    shotsTaken++;
	    if(shotsTaken >= numBullets)
	    {
	    	shotsTaken = 0;
	    	timer.start(runTime, onRunTimeComplete);
	    	moveOnPath.enabled = true;
	    }
	    else
	    {
	    	timer.start(shootTime, onShootTimeComplete);
	    }
	}
}