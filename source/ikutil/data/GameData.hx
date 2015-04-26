package ikutil.data;

import ikutil.data.ObjectDef;
import haxe.ds.StringMap;
import openfl.Assets;

class GameData 
{
	private static var objectDefs:StringMap<ObjectDef>;

	public static function init(data:String = "assets/data/gameData.xml"):Void
	{
		var xml = Xml.parse(Assets.getText(data));
		var data = xml.elementsNamed("data").next();
		var objects = data.elementsNamed("objects").next();

		objectDefs = new StringMap<ObjectDef>();
		var objDef:ObjectDef;
		for (object in objects.elementsNamed("object")) {
			var name = object.get("name");
			if(objectDefs.exists(name))
				throw "Object defined more than once in game data: " + name;

			objDef = new ObjectDef(name);
			if(object.exists("graphic"))
				objDef.graphic = object.get("graphic");

			if(object.exists("health"))
				objDef.health = Std.parseFloat(object.get("health"));

			if(object.exists("immovable"))
				objDef.immovable = true;

			var components = object.elementsNamed("components").next();
			for (component in components.elementsNamed("component"))
			{
				var comp = new StringMap<Dynamic>();
				comp.set("type", component.get("type"));
				var params = new StringMap<Dynamic>();
				comp.set("params", params);
				for (value in component.elementsNamed("params").next().elements())
				{
					switch(value.get("type"))
					{
						case "int":
							params.set(value.nodeName, Std.parseInt(value.firstChild().toString()));

						case "float":
							params.set(value.nodeName, Std.parseFloat(value.firstChild().toString()));

						case "string":
							params.set(value.nodeName, value.firstChild().toString());
					}
				}
				objDef.components.set(component.get("name"), comp);
			}

			objectDefs.set(name, objDef);
		}
	}

	public static function getDef(name:String):ObjectDef
	{
	    if(!objectDefs.exists(name))
	    	throw "Object Definition does not exist: " + name;

	    return objectDefs.get(name);
	}

}