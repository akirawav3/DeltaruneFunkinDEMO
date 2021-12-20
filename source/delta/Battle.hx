package delta;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;

class Battle extends FlxSpriteGroup
{
    var hitbox:FlxSpriteGroup;
    var attacks:Attack;
    var player:HeartPlayer;
    var arena:FlxSprite;

    var touched:Array<Int> = [];
    var grazed:Array<Int> = [];

    //public var scaleFactor:Float = 2;

	public function new(x:Float = 0, y:Float = 0)
        {
            super(x, y);

            hitbox = new FlxSpriteGroup();
            add(hitbox);

            //makes a square for the hitbox, its kinda weird but works, uses sprites instead of objects because i want to make this class a spritegroup
            for(i in 0...4)
                {
                    var box:FlxSprite;
                    if(i % 2 == 0)
                        box = new FlxSprite(0, i == 2 ? 146 : 0).makeGraphic(150, 4);
                    else
                        box = new FlxSprite(i == 3 ? 146 : 0, 0).makeGraphic(4, 150);
                    box.ID = i;
                    box.immovable = true;
                    box.visible = false;
                    hitbox.add(box);
                }

            arena = new FlxSprite().loadGraphic(Paths.image('delta/battleBox', 'shared'));
            add(arena);

            attacks = new Attack();
            add(attacks);

            player = new HeartPlayer(75, 75);
            add(player);
/* 
            new FlxTimer().start(2, timer -> {
                attacks.arrowAttack(10, player.player.x, player.player.y);
            }, 0); */

            FlxG.watch.add(player.player, 'x', 'playerX');
        }

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.J)
            attacks.arrowAttack(10, player.player.x, player.player.y);
        if (FlxG.keys.justPressed.K)
            attacks.circleAttack(.155);
        if (FlxG.keys.justPressed.V)
            attacks.sideAttack(0);
        if (FlxG.keys.justPressed.B)
            attacks.sideAttack(1);
        if (FlxG.keys.justPressed.N)
            attacks.sideAttack(2);
        if (FlxG.keys.justPressed.M)
            attacks.sideAttack(3);

        FlxG.collide(player.player, hitbox);

        attacks.forEach(function(spr:FlxSprite)
            {
                //makes it so you only get hit once by objects, but you can still get hit by them more than once
                if(player.player.overlaps(spr) && !touched.contains(spr.ID)){
                    touched.push(spr.ID);
                    player.hit();
                }
                else if (!player.player.overlaps(spr))
                    touched.remove(spr.ID);

                if(player.grazeBox.overlaps(spr) && !grazed.contains(spr.ID) && !touched.contains(spr.ID)){
                    grazed.push(spr.ID);
                    player.graze();
                }
                else if (!player.grazeBox.overlaps(spr))
                    grazed.remove(spr.ID);
            });
	}
}