
package components;

import flixel.util.FlxPoint;
import ikutil.IkComponent;
import ikutil.IkEntity;
import entities.Player;
import haxe.ds.StringMap;

class TrackPlayerOnPath extends IkComponent
{
	public static inline var LEFT:Int = -1;
	public static inline var CLOSEST:Int = 0;
	public static inline var RIGHT:Int = 1;

	var player:Player;
	var nodes:Array<FlxPoint>;

	var shootTarget:Int;

	var currentSegment:Int = 1;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);
	}

	override public function update():Void
	{
	    super.update();

	    if(nodes != null && player != null)
	    {

	    }
	}

	public function setPlayer(player:Player):Void
	{
	    this.player = player;
	}

	public function setNodes(nodes:Array<FlxPoint>):Void
	{
	    this.nodes = nodes;
	}

	public function findTarget():Void
	{
	    
	}
}