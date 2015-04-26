
package ikutil.factories;

import ikutil.IkEntity;
import ikutil.data.GameData;
import ikutil.data.ObjectDef;

class ObjectFactory 
{
	public static function makeObject(name:String):IkEntity
	{
		var def:ObjectDef = GameData.getDef(name);
	    var entity = new IkEntity();
	    entity.health = def.health;
	    if(def.graphic != null) 
	    	entity.loadGraphic("assets/images/" + def.graphic + ".png");

	    entity.immovable = def.immovable;

	    for (component in def.components)
	    {
	    	var classType = Type.resolveClass("components." + component.get("type"));
	    	var c = Type.createInstance(classType, [component.get("params")]);
	    	entity.addComponent(c);
	    }

	    return entity;
	}

}