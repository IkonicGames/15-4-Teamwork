
package ikutil.data;

import haxe.ds.StringMap;

class ObjectDef 
{
	public var name(default, null):String;
	public var graphic:String;
	public var health:Float = 1;
	public var immovable:Bool;

	@:allow(ikutil.data.GameData)
	@:allow(ikutil.factories.ObjectFactory)
	var components:StringMap<StringMap<Dynamic>>;

	public function new(name:String)
	{
		this.name = name;
		components = new StringMap<StringMap<Dynamic>>();
	}
}