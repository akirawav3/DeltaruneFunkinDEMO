//based off the haxeflixel rpg
package delta;

import flixel.util.FlxDirectionFlags;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

class DeltaPlayer extends FlxSprite
{
    public static var posArr:Array<PosData> = [];
    public static var animArr:Array<String> = [];

    static inline var SPEED:Float = 300;
    var run:Float = 1;

    var xPrev:Float = 0;
    var yPrev:Float = 0;

    public function new(x:Float = 0, y:Float = 0, char:String = 'krisDark')
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('delta/rpg/$char', 'shared');
        if(char == 'kris'){
            animation.addByIndices('up', 'walk_up', [1,2,3],'',6, false);
            animation.addByIndices('down', 'walk_down', [1,2,3],'',6, false);
            animation.addByIndices('left', 'walk_left', [1,2,3],'',6, false);
            animation.addByIndices('right', 'walk_right', [1,2,3],'',6, false);
            animation.addByIndices('upR', 'walk_up', [1,2,3],'',12, false);
            animation.addByIndices('downR', 'walk_down', [1,2,3],'',12, false);
            animation.addByIndices('leftR', 'walk_left', [1,2,3],'',12, false);
            animation.addByIndices('rightR', 'walk_right', [1,2,3],'',12, false);
            animation.addByIndices('upi', 'walk_up', [0],'',6, false);
            animation.addByIndices('downi', 'walk_down', [0],'',6, false);
            animation.addByIndices('lefti', 'walk_left', [0],'',6, false);
            animation.addByIndices('righti', 'walk_right', [0],'',6, false);

            setSize(50, 20);
            offset.set(35, 165);
        }
        else{
            animation.addByPrefix('up', 'walk_up', 12, false);
            animation.addByPrefix('down', 'walk_down', 12, false);
            animation.addByPrefix('left', 'walk_left', 12, false);
            animation.addByPrefix('right', 'walk_right', 12, false);
            animation.addByPrefix('upR', 'run_up', 12, false);
            animation.addByPrefix('downR', 'run_down', 12, false);
            animation.addByPrefix('leftR', 'run_left', 12, false);
            animation.addByPrefix('rightR', 'run_right', 12, false);
            animation.addByPrefix('upi', 'idle_up', 12, false);
            animation.addByPrefix('downi', 'idle_down', 12, false);
            animation.addByPrefix('lefti', 'idle_left', 12, false);
            animation.addByPrefix('righti', 'idle_right', 12, false);

            offset.set(85, 190);
            setSize(50, 20);
        }
        animation.play('upi');

        scale.set(.63, .63);

        drag.x = drag.y = 4550;

        for(i in 0...75){
            posArr[i] = {x: x, y: y, facing: facing, running: false};
            animArr[i] = animation.curAnim.name;
        }
    }

    override function update(elapsed:Float)
        {
            xPrev = x;
            yPrev = y;

            super.update(elapsed);

            if (!DeltaPlayState.paused)
                updateMovement();
        }

    function updateMovement()
        {
            var up:Bool = false;
            var down:Bool = false;
            var left:Bool = false;
            var right:Bool = false;
            var running:Bool = false;

            up = FlxG.keys.anyPressed([UP, W]);
            down = FlxG.keys.anyPressed([DOWN, S]);
            left = FlxG.keys.anyPressed([LEFT, A]);
            right = FlxG.keys.anyPressed([RIGHT, D]);
            running = FlxG.keys.pressed.SHIFT;

            running ? run = 1.7 : run = 1;

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
                        facing = UP;
                    }
                    else if (down)
                    {
                        newAngle = 90;
                        if (left)
                            newAngle += 45;
                        else if (right)
                            newAngle -= 45;
                        facing = DOWN;
                    }
                    else if (left)
                        {
                            newAngle = 180;
                            facing = LEFT;
                        }
                    else if (right)
                        {
                            newAngle = 0;
                            facing = RIGHT;
                        }

                    velocity.set(SPEED * run, 0);
                    velocity.rotate(FlxPoint.weak(0, 0), newAngle);

                    var post:String = running ? 'R' : '';

                    if (velocity.x != 0 || velocity.y != 0) 
                        {
                            switch (facing)
                                {
                                    case LEFT:
                                        animation.play("left" + post);
                                    case RIGHT:
                                        animation.play("right" + post);
                                    case UP:
                                        animation.play("up" + post);
                                    case DOWN:
                                        animation.play("down" + post);
                                    case _:
                                }
                        }
                }
             else if(!up && !down && !right && !left)
                {
                    switch (facing)
                        {
                            case LEFT:
                                animation.play("lefti");
                            case RIGHT:
                                animation.play("righti");
                            case UP:
                                animation.play("upi");
                            case DOWN:
                                animation.play("downi");
                            case _:
                        } 
                }

            var len:Int = 74;

            for(i in 0...75){
                if(x != xPrev || y != yPrev){
                    posArr[len] = posArr[len-1];
                }
                animArr[len] = animArr[len-1];
                len--;
            }

            if(x != xPrev || y != yPrev) posArr[0] = {x: x, y: y, facing: facing, running: running};

            animArr[0] = animation.curAnim.name;
        }
}

typedef PosData = {
    x:Float,
    y:Float,
    facing:FlxDirectionFlags,
    running:Bool
}