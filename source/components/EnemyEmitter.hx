
package components;

import components.EnemyDiveBomb;
import components.EnemyShoot;
import entities.BulletManager;
import entities.Enemy;
import flixel.group.FlxGroup;
import ikutil.IkComponent;
import ikutil.IkEntity;
import flixel.util.FlxTimer;
import flixel.addons.editors.tiled.TiledPropertySet;
import haxe.ds.StringMap;

class EnemyEmitter extends IkComponent
{
	var timer:FlxTimer;

	var enemyGroup:FlxGroup;
	var enemyType:String;
	var enemyCount:Int;
	var emitInterval:Float;
	var emitSpacing:Float;
	var emitDir:Int;

	var isEmitting:Bool;
	var count:Int;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);
	    timer = new FlxTimer();
	    isEmitting = false;
	    enemyGroup = Reg.currentLevel.enemyGroup;
	}

	override public function init():Void
	{
	    super.init();
	    owner.immovable = true;
	}

	override public function update():Void
	{
	    if(!isEmitting && owner.isOnScreen())
	    {
	    	isEmitting = true;
	    	timer.start(emitInterval, onEmitEnemy);
	    }
	}

	override public function destroy():Void
	{
	    timer.destroy();
	}

	private function onEmitEnemy(timer:FlxTimer):Void
	{
		if(!owner.alive)
			return;
			
		var e = ikutil.factories.ObjectFactory.makeObject(enemyType);
		e.setPosition(owner.x, owner.y - 10);
		e.velocity.set(0, -100);
		enemyGroup.add(e);

		// update the count and restart the timer
	    count++;
	    var time = emitSpacing;
	    if(count == enemyCount)
	    {
	    	count = 0;
	    	time = emitInterval;
	    }
	    timer.start(time, onEmitEnemy);
	}
}