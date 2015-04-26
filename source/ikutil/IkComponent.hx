package ikutil;

import ikutil.IkEntity;
import haxe.ds.StringMap;

class IkComponent 
{
	@:allow(ikutil.IkEntity)
	public var owner(default, null):IkEntity;
	
	public var enabled(default, set):Bool = true;
	private function set_enabled(value:Bool):Bool
	{
	    return enabled = value;
	}
	
	public function new(params:StringMap<Dynamic> = null)
	{
		if(params != null)
		{
			for (key in params.keys()) 
				Reflect.setField(this, key, params.get(key));
		}
	}

	@:allow(ikutil.IkEntity)
	private function init():Void {}

	public function update():Void {}

	@:allow(ikutil.IkEntity)
	private function draw():Void {}

	public function destroy():Void {}

	public function setEnabled(enabled:Bool):Bool
	{
		return this.enabled = enabled;
	}
}