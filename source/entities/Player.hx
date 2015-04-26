
package entities;

import components.PlayerShooter;
import entities.BulletManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import ikutil.IkEntity;

class Player extends FlxGroup
{
	public var left(default, null):IkEntity;
	var leftShooter:PlayerShooter;
	public var right(default, null):IkEntity;
	var rightShooter:PlayerShooter;

	public var bullets(default, null):FlxGroup;

	var buffer:Float = 64;
	var verticalPadding:Float = 8;
	var moveSpeed:Float = 200;
	var shootTime:Float = .1;
	var bulletSpeed:Float = 500;

	var explosion:FlxSound;

	public function new()
	{
	    super();

	    left = new IkEntity();
	    left.y = FlxG.height / 2;
	    left.loadGraphic(AssetPaths.smalBlock__png);
	    left.color = 0xEC4863;
	    leftShooter = new PlayerShooter();
	    left.addComponent(leftShooter);
	    this.add(left);

	    right = new IkEntity();
	    right.y = FlxG.height / 2;
	    right.loadGraphic(AssetPaths.smalBlock__png);
	    right.color = 0x1FA8D1;
	    rightShooter = new PlayerShooter();
	    right.addComponent(rightShooter);
	    this.add(right);

	    leftShooter.setTarget(right);
	    rightShooter.setTarget(left);

	    bullets = new FlxGroup();
	    bullets.add(leftShooter.bulletManager);
	    bullets.add(rightShooter.bulletManager);

	    explosion = FlxG.sound.load(AssetPaths.playerExplosion__mp3);
	}

	override public function update():Void
	{
		if(FlxG.keys.pressed.UP) right.y -= moveSpeed * FlxG.elapsed;
		if(FlxG.keys.pressed.DOWN) right.y += moveSpeed * FlxG.elapsed;

		if(FlxG.keys.pressed.W) left.y -= moveSpeed * FlxG.elapsed;
		if(FlxG.keys.pressed.S) left.y += moveSpeed * FlxG.elapsed;

		shoot();

	    super.update();

	    var camY:Float = FlxG.camera.scroll.y;
		FlxSpriteUtil.bound(left, buffer, buffer, camY + verticalPadding, camY + FlxG.height - verticalPadding);
		FlxSpriteUtil.bound(right, FlxG.width - buffer, FlxG.width - buffer, camY + verticalPadding, camY + FlxG.height - verticalPadding);
	}

	public function getClosestTo(target:FlxSprite):FlxSprite
	{
	    var ld = FlxMath.distanceBetween(left, target);
	    var rd = FlxMath.distanceBetween(right, target);

	    return (ld > rd) ? right : left;
	}

	public function killShooter(shooter:FlxSprite):Void
	{
		shooter.kill();
	}

	private function shoot():Void
	{
		leftShooter.shoot();
		rightShooter.shoot();
	}
}