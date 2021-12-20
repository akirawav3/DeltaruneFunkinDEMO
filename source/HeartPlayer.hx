package;

import flixel.math.FlxAngle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

class HeartPlayer extends FlxSpriteGroup
{
    static inline var SPEED:Float = 200;
    public var grazeBox:FlxSprite;
    public var player:FlxSprite;
    var grazeTween:FlxTween;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        grazeBox = new FlxSprite(-16,-16).loadGraphic(Paths.image("delta/graze", 'shared'));
        grazeBox.alpha = 0;
        add(grazeBox);

        player = new FlxSprite().loadGraphic(Paths.image("delta/soul", 'shared'));
        add(player);

        player.drag.x = player.drag.y = 6300;
    }

    override function update(elapsed:Float)
        {
            super.update(elapsed);

            updateMovement();

            grazeBox.setPosition(player.x - 16, player.y - 16);
        }

    public function hit()
        {
            FlxG.sound.play(Paths.sound('delta/hurt', 'shared'), 2);
            var hitTxt:FlxText = new FlxText(player.x - this.x, player.y - this.y, 50, 'HIT', 10);
            hitTxt.color = FlxColor.RED;
            hitTxt.alpha = .2;
            add(hitTxt);
        
            var newY = hitTxt.y - 16;
        
                FlxTween.tween(hitTxt, {y: newY, alpha: 1}, .3, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween){
                    var newY = hitTxt.y + 16;
                    FlxTween.tween(hitTxt, {y: newY, alpha: .1}, .3, {ease: FlxEase.quartIn, onComplete: function(twn:FlxTween){
                        remove(hitTxt, true);
                    }});
                }});
        }

    public function graze()
        {
            FlxG.sound.play(Paths.sound('delta/graze', 'shared'), 2);
            if(grazeTween != null)
                grazeTween.cancel();
        
            grazeBox.alpha = 1;

            grazeTween = FlxTween.tween(grazeBox, {alpha: 0}, .2);
        }

    function updateMovement()
        {
            var up:Bool = false;
            var down:Bool = false;
            var left:Bool = false;
            var right:Bool = false;

            up = FlxG.keys.anyPressed([UP, W]);
            down = FlxG.keys.anyPressed([DOWN, S]);
            left = FlxG.keys.anyPressed([LEFT, A]);
            right = FlxG.keys.anyPressed([RIGHT, D]);

            if (up && down)
                up = down = false;
            if (left && right)
                left = right = false;

            if (up || down || left || right)
                {
                    var newAngle:Float = 0;
                    if (up)
                    {
                        newAngle = -90;
                        if (left)
                            newAngle -= 45;
                        else if (right)
                            newAngle += 45;
                        facing = 1;
                    }
                    else if (down)
                    {
                        newAngle = 90;
                        if (left)
                            newAngle += 45;
                        else if (right)
                            newAngle -= 45;
                        facing = 2;
                    }
                    else if (left)
                        {
                            newAngle = 180;
                            facing = 3;
                        }
                    else if (right)
                        {
                            newAngle = 0;
                            facing = 4;
                        }

                    player.velocity.set(SPEED, 0);
                    player.velocity.rotate(FlxPoint.weak(0, 0), newAngle);
                }
        }
}