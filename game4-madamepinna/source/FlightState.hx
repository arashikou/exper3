package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;

class FlightState extends FlxState
{
  private var _player:Player;
  private var _bullets:Bullet.Group;
  private var _squadrons:FlxTypedGroup<Squadron>;
  private var _personTether:Conveyor;
  private var _predictionTether:Conveyor;

  override public function create():Void
  {
    super.create();
    FlxG.mouse.load("assets/images/Target.png", 1, -8, -8);
    add(new CrazyBackground());

    _player = new Player();
    _bullets = new Bullet.Group();
    _squadrons = new FlxTypedGroup<Squadron>();
    _personTether = new Conveyor(_player);
    _predictionTether = new Conveyor(_player);

    add(_squadrons);
    add(_player);
    add(_bullets);
    add(_personTether);
    add(_predictionTether);
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

    if (FlxG.mouse.justPressed)
    {
      _squadrons.members[0].forEach(function(apparition:Apparition):Void
      {
        if (FlxG.mouse.x >= apparition.x && FlxG.mouse.x < apparition.x + apparition.width &&
            FlxG.mouse.y >= apparition.y && FlxG.mouse.y < apparition.y + apparition.height)
        {
          if (apparition.form == Person)
          {
            _personTether.end = apparition;
            _personTether.revive();
          }
          else
          {
            _predictionTether.end = apparition;
            _predictionTether.revive();
          }
        }
      });
    }

    if (FlxG.keys.justPressed.Y)
    {
      _squadrons.forEach(function(squadron:Squadron):Void
      {
        squadron.kill();
      });
      _squadrons.clear();

      var s = new Squadron(FlxRandom.intRanged(1, 4), _bullets);
      _squadrons.add(s);
      introduce(s);
    }
  }

  private function introduce(squadron:Squadron):Void
  {
    var maxY = 0.0; // Silly Haxe bug. If this is 0, it can't discern the types for Math.max below.
    squadron.forEach(function(app:Apparition)
    {
      maxY = Math.max(maxY, app.y + app.height);
    });
    squadron.forEach(function(app:Apparition)
    {
      var oldY = app.y;
      app.y -= maxY;
      FlxTween.tween(app, { y: oldY }, 1,
                     { type: FlxTween.ONESHOT, ease: FlxEase.expoOut });
    });
  }
}
