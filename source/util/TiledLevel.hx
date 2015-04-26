
package util;

import components.EnemyEmitter;
import components.EnemyShoot;
import entities.BulletManager;
import flixel.FlxState;
import haxe.io.Path;
import ikutil.IkEntity;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledObject;
import flixel.tile.FlxTilemap;
import flixel.util.FlxAngle;
import haxe.ds.ObjectMap;

class TiledLevel extends TiledMap
{
	private static inline var TILESET_ASSET_DIR:String = "assets/images/";
	public static var currentLevel:TiledLevel;

	public var tileMap(default, null):FlxTilemap;
	public var objectGroup(default, null):FlxGroup;
	public var enemyGroup(default, null):FlxGroup;
	public var enemyBullets(default, null):BulletManager;

	public var objects:ObjectMap<IkEntity, TiledObject>;

	public function new(tiledLevel:Dynamic)
	{
	    super(tiledLevel);

	    objectGroup = new FlxGroup();
	    enemyGroup = new FlxGroup();
	    enemyBullets = new BulletManager();

	    objects = new ObjectMap<IkEntity, TiledObject>();
	}


	public function processData():Void
	{
	    for(tileLayer in layers)
	    {
	    	var tileSheetName = tileLayer.properties.get("tileset");

	    	if(tileSheetName == null)
	    		throw "'tileset' property not defined for the " + tileLayer.name + "layer.";

	    	var tileSet:TiledTileSet = null;
	    	for(ts in tilesets)
	    	{
	    		if(ts.name == tileSheetName)
	    		{
	    			tileSet = ts;
	    			break;
	    		}
	    	}

	    	if(tileSet == null)
	    		throw "TileSet '" + tileSheetName + "' not found.";

	    	var imagePath = new Path(tileSet.imageSource);
	    	var processedPath = TiledLevel.TILESET_ASSET_DIR + imagePath.file + "." + imagePath.ext;

	    	var tileMap:FlxTilemap = new FlxTilemap();
	    	tileMap.widthInTiles = width;
	    	tileMap.heightInTiles = height;
	    	tileMap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);

	    	this.tileMap = tileMap;
	    }

	    for (objGroup in this.objectGroups) {
	    	if(objGroup.name == "Enemies")
	    	{
	    		for (obj in objGroup.objects) {
	    			var e = ikutil.factories.ObjectFactory.makeObject(obj.type);
	    			objects.set(e, obj);
	    			if(e != null)
	    			{
	    				e.setPosition(obj.x, obj.y);
	    				enemyGroup.add(e);

	    				e.angle = wrapAngle(obj.angle);
	    				switch(e.angle)
	    				{
	    					case 0:
	    						e.y -= e.height;

	    					case 90:
	    						e.y = e.y;

	    					case 180:
	    						e.x -= e.width;

	    					case 270:
	    						e.x -= e.width;
	    						e.y -= e.height;
	    				}
	    			}
	    		}
	    	}
	    }
	}

	public function addToState(state:FlxState):Void
	{
	    state.add(tileMap);
	    state.add(objectGroup);
	    state.add(enemyGroup);
	    state.add(enemyBullets);
	}

	private function wrapAngle(angle:Float):Float
	{
	    while(angle > 360)
	    	angle -= 360;

	    while(angle < 0)
	    	angle += 360;

	    return angle;
	}
}