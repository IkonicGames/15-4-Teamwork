package states;

import ikutil.data.GameData;
import entities.BulletManager;
import entities.Player;
import entities.Enemy;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import util.TiledLevel;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var level:TiledLevel;
	var player:Player;

	var scrollSpeed:Float = 24;
	var camTarget:FlxObject;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xD9FF5B;
		GameData.init();

		player = cast this.add(new Player());
		Reg.player = player;
		this.add(player.bullets);

		// level = new TiledLevel(AssetPaths.testLevel__tmx);
		level = new TiledLevel(AssetPaths.level01__tmx);
		Reg.currentLevel = level;
		level.processData();
		FlxG.worldBounds.set(0, 0, level.tileMap.width, level.tileMap.height);
		level.addToState(this);

		camTarget = new FlxObject();
		Reg.camTarget = camTarget;
		camTarget.width = FlxG.width;
		camTarget.height = FlxG.height;
		FlxG.camera.follow(camTarget);
		this.add(camTarget);

		// camTarget.y = 2150;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		FlxG.collide(level.tileMap, player.bullets, onBulletHitLevel);
		FlxG.collide(level.enemyBullets, level.tileMap, onBulletHitLevel);
		FlxG.collide(level.enemyBullets, player, onBulletHitPlayer);

		FlxG.collide(player, level.enemyGroup, onPlayerHitEnemy);
		FlxG.collide(player.bullets, level.enemyGroup, onBulletHitEnemy);

		camTarget.velocity.y = scrollSpeed;
	}	

	function onBulletHitLevel(tile:FlxObject, bullet:FlxObject):Void
	{
		if(bullet == level.tileMap)
		{
			tile.kill();
			return;
		}

		bullet.kill();
	}

	function onBulletHitEnemy(bullet:FlxObject, enemy:FlxObject):Void
	{
		bullet.kill();
		enemy.hurt(1);

		if(!enemy.alive)
			FlxG.sound.play(AssetPaths.explosionSmall__mp3);
	}

	function onPlayerHitEnemy(player:FlxObject, enemy:FlxObject):Void
	{
		player.kill();
		enemy.kill();

		FlxG.sound.play(AssetPaths.playerExplosion__mp3);
	}

	function onBulletHitPlayer(bullet:FlxObject, player:FlxObject):Void
	{
		bullet.kill();
		player.kill();

		FlxG.sound.play(AssetPaths.playerExplosion__mp3);
	}
}