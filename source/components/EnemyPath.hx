package components;

import components.RunAndGun;
import components.MoveOnPath;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import entities.BulletManager;
import ikutil.IkEntity;
import ikutil.IkComponent;
import haxe.ds.StringMap;
import flixel.addons.editors.tiled.TiledObject;

class EnemyPath extends IkComponent
{
	var nodes:Array<FlxPoint>;
	var enemyType:String;
	var spawnDelay:Float;
	var spawnInterval:Float;
	var numEnemies:Int;
	var camPos:Float = 1.1;

	var triggered:Bool;
	var spawnTimer:FlxTimer;
	var numSpawned:Int;

	var enemyGroup:FlxGroup;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);

	    spawnTimer = new FlxTimer();
	    triggered = false;
	    numSpawned = 0;

	    this.enemyGroup = Reg.currentLevel.enemyGroup;
	}

	override public function init():Void
	{
	    super.init();

	    var levelObj = Reg.currentLevel.objects.get(owner);
	    nodes = levelObj.points;

	    for (node in nodes) 
	    	node.add(owner.x, owner.y);

	    owner.visible = false;
	    owner.allowCollisions = flixel.FlxObject.NONE;

	    var tObj:TiledObject = Reg.currentLevel.objects.get(owner);
	    if(tObj.custom.contains("camPos"))
	    	camPos = Std.parseFloat(tObj.custom.get("camPos"));
	}

	override public function update():Void
	{
	    super.update();

	    if(!triggered && Reg.camTarget.y + Reg.camTarget.height * camPos >= owner.y)
	    {
	    	triggered = true;
	    	startSpawning();
	    }
	}

	private function onSpawnTimerComplete(timer:FlxTimer):Void
	{
		spawnEnemy();
	}

	private function onSpawnDelayComplete(timer:FlxTimer):Void
	{
	    startSpawning();
	}

	private function startSpawning():Void
	{
		spawnEnemy();

	    if(numEnemies > 1)
	    	spawnTimer.start(spawnInterval, onSpawnTimerComplete, numEnemies - 1);
	    else
	    	startDelay();
	}

	private function startDelay():Void
	{
		spawnTimer.start(spawnDelay, onSpawnDelayComplete);
	}

	private function spawnEnemy():Void
	{
	    var e = ikutil.factories.ObjectFactory.makeObject(enemyType);
	    Reg.currentLevel.enemyGroup.add(e);
	    var mop:MoveOnPath = cast e.getComponent(MoveOnPath);
	    mop.setNodes(nodes);
	    mop.startOnPath();
	}
}