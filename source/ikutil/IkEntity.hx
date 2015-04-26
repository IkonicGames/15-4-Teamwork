
package ikutil;

import flixel.FlxSprite;
import haxe.ds.StringMap;

#if IK_USE_NAPE
import flixel.addons.nape.FlxNapeSprite;
class IkEntity extends FlxNapeSprite
#else
import flixel.FlxSprite;
import ikutil.IkComponent;
class IkEntity extends FlxSprite
#end
{
	var components:StringMap<IkComponent>;
	var toInit:Array<IkComponent>;

#if IK_USE_NAPE
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:Dynamic = null, ?CreateRectangularBody:Bool = false, ?EnablePhysics:Bool = true)
#else
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:Dynamic = null)
#end
	{
#if IK_USE_NAPE
		super(X, Y, SimpleGraphic, CreateRectangularBody, EnablePhysics);
#else
		super(X, Y, SimpleGraphic);
#end

		components = new StringMap<IkComponent>();
		toInit = new Array<IkComponent>();
	}

	override public function update():Void
	{
		super.update();

		if(toInit.length != 0)
		{
			do {
				var c = toInit.pop();
				c.init();
			} while (toInit.length != 0);
		}

		for(c in components)
			if(c.enabled)
				c.update();
	}

	override public function draw():Void
	{
		super.draw();
		for(c in components)
			if(c.enabled)
				c.draw();
	}

	override public function destroy():Void
	{
		for (c in components)
			c.destroy();
			
	    super.destroy();
	}
	
	public function addComponent<T:IkComponent>(component:T):T
	{
		var componentClass = Type.getClass(component);
		var className = Type.getClassName(componentClass);
		if(components.exists(className))
			throw "Entities can only contain one of any type of IkComponent: " + className;

		component.owner = this;
		components.set(className, component);
		toInit.push(component);

		return component;
	}

	public function removeComponent(component:IkComponent):IkComponent
	{
		var className = Type.getClassName(Type.getClass(component));
		if(!components.exists(className))
			return null;

		var component = components.get(className);
		components.remove(className);

		return component;
	}

	public function getComponent(type:Class<IkComponent>):IkComponent
	{
		var className = Type.getClassName(type);
		if(!components.exists(className))
			return null;

		return components.get(className);
	}
}
