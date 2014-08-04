package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
  public var heart(default,null):FlxSprite;

  inline static private var Y_SPEED = 400;

  public function new()
  {
    super();
    makeGraphic(32, 32, FlxColor.WHEAT);
    heart = new FlxSprite();
    heart.makeGraphic(2, 2, FlxColor.RED);
    y = FlxG.height - height;
  }

  override public function update():Void
  {
    super.update();

    var xMove = 2;
    if (FlxG.keys.pressed.D) xMove += 1;
    if (FlxG.keys.pressed.A) xMove -= 1;
    x = xMove * (FlxG.width / 4) - width / 2;

    var yMove = 0;
    if (FlxG.keys.pressed.S) yMove += 1;
    if (FlxG.keys.pressed.W) yMove -= 1;
    y += yMove * FlxG.elapsed * Y_SPEED;

    bound();

    heart.x = x + (width - heart.width) / 2;
    heart.y = y + (height - heart.height) / 2;
    heart.update();
  }

  override public function draw():Void
  {
    super.draw();
    heart.draw();
  }
}
