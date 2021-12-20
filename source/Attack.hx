package;

import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;

typedef SideData = {
    x:Float,
    y:Float,
    vel:Float,
    ang:Float
}

class Attack extends FlxSpriteGroup
{
	public function new(x:Float = 0, y:Float = 0)
        {
            super(x, y);
        }

	public function arrowAttack(amount:Int, daX:Float = 0, daY:Float = 0)
        {
            var daIndex:Int = 0;
            var point = new FlxPoint(daX + 9, daY + 9);
            var positions:Array<Array<Float>> = [[170, 5],[170, 50],[170, 95],[170, 145],[170, 170],[145, 170],[95, 170],[50, 170],[5, 170],[-25, 170],[-25, 145],[-25, 95],[-25, 50],[-25, -25],[5, -25],[50, -25],[95, -25],[145, -25]];
            var takenIndex:Array<Int> = [];
            for(i in 0...amount)
                {
                    daIndex = FlxG.random.int(0, positions.length - 1);
                    while(takenIndex.contains(daIndex))
                        {
                            daIndex = FlxG.random.int(0, positions.length);
                            trace(daIndex);
                            if(!takenIndex.contains(daIndex))
                                takenIndex.push(daIndex);
                                break;
                        }
                    var arrow:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/arrow', 'shared'));
                    arrow.setPosition(positions[daIndex][0], positions[daIndex][1]);
                    arrow.alpha = 0;
                    add(arrow);

                    arrow.angularAcceleration = 175;
                    FlxVelocity.accelerateTowardsPoint(arrow, point, 150, 150);

                    FlxTween.tween(arrow, {alpha: 1}, .3);

                    new FlxTimer().start(1.5, tmr -> {
                        FlxTween.tween(arrow, {alpha: 0}, .25, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){
                            remove(arrow, true);
                        }});
                    });
                }
        }

    public function sideAttack(side:Int)
        {
            //typedefs are kinda cool
            var sides:Array<SideData> = [{x: 4, y: 0, vel: 150, ang: 180}, {x: 130, y: 0, vel: -150, ang: -90}, {x: 4, y: 130, vel: -150, ang: 0}, {x: 4, y: 0, vel: 150, ang: 90}];
            for(i in 0...4)
                {
                    var arrow:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/arrow', 'shared'));
                    if(side == 0 || side == 2){
                        arrow.setPosition(sides[side].x + (i * (28 + arrow.frameWidth)), sides[side].y);
                        arrow.acceleration.y = sides[side].vel;
                    }
                    else{
                        arrow.setPosition(sides[side].x, sides[side].y + (i * (28 + arrow.frameHeight)));
                        arrow.acceleration.x = sides[side].vel;
                    }
                    arrow.alpha = 0;
                    arrow.angle = sides[side].ang;
                    add(arrow);

                    FlxTween.tween(arrow, {alpha: 1}, .25);

                    new FlxTimer().start(1.5, tmr -> {
                        FlxTween.tween(arrow, {alpha: 0}, .25, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){
                            remove(arrow, true);
                        }});
                    });
                }
        }

    public function circleAttack(offset:Float)
        {
            for(i in 0...10)
                {
                    var center = new FlxPoint(75 + this.x, 75 + this.y);
                    var centerT = new FlxPoint(75, 75);
                    var arrow:FlxSprite = new FlxSprite(75, 75).loadGraphic(Paths.image('delta/arrow', 'shared'));
                    arrow.x += 75 * Math.cos(37 * i);
                    arrow.y += 75 * Math.sin(37 * i);
                    arrow.angle = FlxAngle.angleBetweenPoint(arrow, centerT, true) + 90;
                    add(arrow);

                    new FlxTimer().start(offset * i, tmr -> {
                        FlxVelocity.accelerateTowardsPoint(arrow, center, 150, 150);
                    });

                    new FlxTimer().start(2 + (offset * i), tmr -> {
                        FlxTween.tween(arrow, {alpha: 0}, .25, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){
                            remove(arrow, true);
                        }});
                    });
                }
        }

}