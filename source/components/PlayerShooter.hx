
package components;

import ikutil.IkEntity;
import ikutil.IkComponent;
import entities.BulletManager;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import haxe.ds.StringMap;

class PlayerShooter extends IkComponent
{
	public var bulletManager(default, null):BulletManager;
	var timer:FlxTimer;

	var canShoot:Bool;
	var shootTime:Float = .1;
	var bulletSpeed:Float = 500;
	var maxBullets:Int = 2;

	var target:FlxSprite;

	var sfx:FlxSound;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);

	    bulletManager = new BulletManager();
	    timer = new FlxTimer(0, onTimerComplete);

	    sfx = FlxG.sound.load(AssetPaths.peaShooter__mp3);
	    sfx.amplitude = 0.5;
	}

	override private function init():Void
	{
	    super.init();

	    bulletManager.maxBullets = maxBullets;

	    canShoot = true;
	}

	private function onTimerComplete(timer:FlxTimer):Void
	{
	    canShoot = true;
	}

	public function setTarget(target:FlxSprite):Void
	{
	    this.target = target;
	}

	public function shoot():Void
	{
		if(!owner.alive)
			return;
			
		var t:FlxPoint = FlxPoint.get(target.x, target.alive ? target.y : owner.y);

	    if(canShoot && bulletManager.shoot(owner.x, owner.y, t.x, t.y, bulletSpeed))
	    {
	    	canShoot = false;
	    	timer.reset(shootTime);

	    	sfx.play(true);
	    }
	}
}