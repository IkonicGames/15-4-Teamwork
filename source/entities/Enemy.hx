
package entities;

import ikutil.IkEntity;

class Enemy extends IkEntity
{

	public function new()
	{
	    super();
	    this.width = 8;
	    this.height = 8;
	}

	override public function update():Void
	{
	    super.update();
	}

}