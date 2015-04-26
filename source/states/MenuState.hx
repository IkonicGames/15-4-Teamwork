package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxUIState
{
	public function new(menu:String = "menu_title"):Void
	{
		super();
    	_xml_id = menu;
	}
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		var music = _ui.getAsset("chk_music");
		if(music != null)
			cast(music, flixel.addons.ui.FlxUICheckBox).checked = FlxG.sound.music.volume == 1;

		var sound = _ui.getAsset("chk_sound");
		if(sound != null)
			cast(sound, flixel.addons.ui.FlxUICheckBox).checked = !FlxG.sound.muted;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	

	override public function getEvent(name:String, sender:IFlxUIWidget, data:Dynamic, ?params:Array<Dynamic>):Void
	{
	    switch(name)
	    {
	    	case "click_button":
	    		if(params != null && params.length != 0)
	    		{
	    			switch(cast(params[0], String))
	    			{
	    				case "play_game": FlxG.switchState(new states.PlayState());
	    				case "menu_title": FlxG.switchState(new MenuState("menu_title"));
	    				case "menu_settings": FlxG.switchState(new MenuState("menu_settings"));
	    			}
	    		}

	    	case "click_check_box":
	    		if(params!= null && params.length > 1)
	    		{
	    			switch(cast(params[0], String))
	    			{
	    				case "music_toggled": FlxG.sound.music.volume = cast(params[1], Bool) ? 1 : 0;
	    				case "sound_toggled": FlxG.sound.muted = cast params[1];
	    			}
	    		}
	    }
	}
}