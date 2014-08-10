package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class FlightState extends FlxState
{
  private var _player:Player;
  private var _bullets:Bullet.Group;
  private var _squadrons:FlxTypedGroup<Squadron>;

  override public function create():Void
  {
    super.create();
    FlxG.mouse.load("assets/images/Target.png", 1, -8, -8);
    add(new CrazyBackground());

    _player = new Player();
    _bullets = new Bullet.Group();
    _squadrons = new FlxTypedGroup<Squadron>();

    add(_squadrons);
    add(_player);
    add(_bullets);

    var conveyor = new Conveyor(_player, FlxG.mouse);
    add(conveyor);
  }

  override public function destroy():Void
  {
    super.destroy();
    FlxG.mouse.load();
  }

  override public function update():Void
  {
    super.update();
    _bullets.forEachAlive(function(bullet:Bullet):Void
    {
      if (bullet.x < -100 || bullet.x > FlxG.width + 100 ||
          bullet.y < -100 || bullet.y > FlxG.height + 100)
      {
        bullet.kill();
      }
    });
  }

  private function introduce(squadron:Squadron):Void
  {
    var maxY = 0.0; // Silly Haxe bug. If this is 0, it can't discern the types for Math.max below.
    squadron.forEachAlive(function(app:Apparition)
    {
      maxY = Math.max(maxY, app.y + app.height);
    });
    squadron.forEachAlive(function(app:Apparition)
    {
      var oldY = app.y;
      app.y -= maxY;
      FlxTween.tween(app, { y: oldY }, 1,
                     { type: FlxTween.ONESHOT, ease: FlxEase.expoOut });
    });
  }
}
