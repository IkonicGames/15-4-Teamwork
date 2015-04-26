
package components;

import flixel.util.FlxPoint;
import ikutil.IkEntity;
import ikutil.IkComponent;
import flixel.util.FlxPath;
import haxe.ds.StringMap;

class MoveOnPath extends IkComponent
{
	public var nodes(default, null):Array<FlxPoint>;

	var speed:Float;

	override private function set_enabled(value:Bool):Bool
	{
		path.active = value;
	    return super.set_enabled(value);
	}

	var path:FlxPath;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);

	    path = new FlxPath();
	    path.autoCenter = false;
	}

	override public function init():Void
	{
	    super.init();

	    path.start(owner, path.nodes, speed);
	}

	override public function destroy():Void
	{
	    path.destroy();

	    super.destroy();
	}
	
	private function onPathComplete(path:FlxPath):Void
	{
		if(!owner.isOnScreen())
		{
			owner.kill();
			path.active = false;
		}
	}

	public function startOnPath():Void
	{
	    path.start(owner, nodes, speed, FlxPath.YOYO);
	    path.onComplete = onPathComplete;
	    owner.setPosition(nodes[0].x, nodes[0].y);
	}

	public function setNodes(nodes:Array<FlxPoint>):Void
	{
	   this.nodes = nodes; 
	}

	public function setSpeed(speed:Float):Void
	{
	    this.speed = speed;
	}
}