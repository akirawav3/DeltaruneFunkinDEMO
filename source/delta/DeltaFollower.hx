package delta;

import flixel.FlxSprite;

using StringTools;

class DeltaFollower extends FlxSprite
{
    public var follow:Int = 25;
    public function new(x:Float = 0, y:Float = 0, char:String = 'susieDark')
    {
        super(x, y);
        frames = Paths.getSparrowAtlas('delta/rpg/$char', 'shared');
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

        if(char == 'ralseiDark')
            offset.set(105, 197);
        else
            offset.set(125, 200);
        setSize(50, 20);
        scale.set(.63, .63);

        drag.x = drag.y = 4500;
    }

    override function update(elapsed:Float)
        {
            super.update(elapsed);

            if (!DeltaPlayState.paused)
                updateMovement();
        }

    function updateMovement(){
        x = DeltaPlayer.posArr[follow].x;
        y = DeltaPlayer.posArr[follow].y;
        if(DeltaPlayer.animArr[0].endsWith('i')){
            switch (DeltaPlayer.posArr[follow].facing)
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
        else if(DeltaPlayer.animArr[follow].endsWith('i')){

            var post:String = DeltaPlayer.posArr[follow].running ? 'R' : '';

            switch (DeltaPlayer.posArr[follow].facing)
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
        else
            animation.play(DeltaPlayer.animArr[follow]);
    }
}