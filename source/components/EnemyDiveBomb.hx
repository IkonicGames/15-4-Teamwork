
package components;

import flixel.FlxSprite;
import ikutil.IkEntity;
import ikutil.IkComponent;
import haxe.ds.StringMap;

class EnemyDiveBomb extends IkComponent
{
	var direction:Int;
	var target:FlxSprite;

	public function new(params:StringMap<Dynamic> = null)
	{
	    super(params);
	}

	override public function init():Void
	{
	    super.init();

	    owner.immovable = true;
	}

	override public function update():Void
	{
	    super.update();

	    if(target != null)
	    	return;

	    if(Reg.player.left.alive && Math.abs(Reg.player.left.y - owner.y) < 3)
	   	{
	   		owner.velocity.y = 0;
	   		owner.velocity.x = -100;

	   		target = Reg.player.left;
	   	}
	   	else if(Reg.player.right.alive && Math.abs(Reg.player.right.y - owner.y) < 3)
	   	{
	   		owner.velocity.y = 0;
	   		owner.velocity.x = 100;

	   		Reg.player.right;
	   	}
	}

	public function setData(direction:Int):Void
	{
	    this.direction = direction;

	    owner.velocity.y = direction * 100;
	}
}