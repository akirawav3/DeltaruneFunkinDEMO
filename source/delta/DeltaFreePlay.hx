package delta;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxSort;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;

class DeltaFreePlay extends MusicBeatState
{
    public static var dialogueCam:FlxCamera;
    var camGame:FlxCamera;

    public static var lastRoom:String;
    public static var paused:Bool;

    var peopleGroup:FlxSpriteGroup = new FlxSpriteGroup();

    var follower:DeltaFollower;
    var player:DeltaPlayer;

    var map:FlxOgmo3Loader;
    var walls:FlxTilemap;
    var room:String;

    var interactMap:Map<FlxObject, String> = new Map();
    var doorMap:Map<FlxObject, String> = new Map();
    var songMap:Map<FlxObject, String> = new Map();

    var intGroup:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();
    var doorGroup:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();
    var songGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    var songIntGroup:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();
    var nameGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

    var save:FlxSprite;
    var saveNum:Int;
    var saveBox:FlxObject;

    var leaving:Bool = false;

    var songs:Array<String> = ['rude buster', 'chefs symphony', 'field of hopes and dreams', 'lantern'];

    public function new(room:String)
        {
            super();
            this.room = room;
        }

	override public function create()
	{
        super.create();

        trace('lastroom: $lastRoom');

        //DELTARUNE SAVE COUNT TIMER
		new FlxTimer().start(1, tmr -> {
            DeltaSaveControl.gameTime += 1;
        }, 0);

        Paths.setCurrentLevel('shared');

        camGame = new FlxCamera();
        FlxG.cameras.reset(camGame);
        FlxCamera.defaultCameras = [camGame];

        dialogueCam = new FlxCamera();
        dialogueCam.bgColor.alpha = 0;
        FlxG.cameras.add(dialogueCam);

        camGame.fade(FlxColor.BLACK, .25, true);

        add(intGroup);
        add(doorGroup);

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/rpg/${room}BG', 'shared'));
        add(bg);

        map = new FlxOgmo3Loader(Paths.ogmo('delta/rpg/data/school', 'shared'), Paths.ogmoJ('delta/rpg/data/$room', 'shared'));
        walls = map.loadTilemap(Paths.image('delta/rpg/wall', 'shared'), "walls");
        walls.follow();
        walls.setTileProperties(1, FlxObject.NONE);
        walls.setTileProperties(2, FlxObject.ANY);
        walls.visible = false;
        add(walls);

        for(i in 0...songs.length){
            var song = new FlxSprite(755 + (95*i), 432).loadGraphic(Paths.image('note', 'preload'));
            song.immovable = true;
            songGroup.add(song);
            var int = new FlxObject(song.x - 2, song.y - 2, song.width + 4, song.height + 4);
            songIntGroup.add(int);
            songMap.set(int, songs[i]);
            int.ID = i;
            var name = new FlxText(song.x - 40, song.y - 35, 120, songs[i].toUpperCase(), 12);
            name.alignment = CENTER;
            name.alpha = 0;
            nameGroup.add(name);
            name.ID = i;
            name.setBorderStyle(OUTLINE, 0xFF000000, 1.5);
            var toY = name.y - 30;
            FlxTween.tween(name, {y: toY}, 1.75, {ease:FlxEase.sineInOut, type: PINGPONG, startDelay: 1 * i});
        }

        player = new DeltaPlayer(0,0,'kris');
        peopleGroup.add(player);

        add(songGroup);
        add(songIntGroup);
        add(peopleGroup);
        add(nameGroup);

        map.loadEntities(placeEntities, "entites");

        camGame.follow(player, TOPDOWN_TIGHT, 1);

        switch (room)
        {
            case 'class':
                if (lastRoom == 'hall'){
                    player.setPosition(792, 256);
                    player.animation.play('downi');
                }

                var desks:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/rpg/desks', 'shared'));
                add(desks);

                camGame.setPosition(-128, -24);
                camGame.follow(null);
            case 'hall':
                player.animation.play('downi');

                camGame.setPosition(190, -24);
                camGame.setScrollBoundsRect(0, 0, 1280 + 500, 720);
        }
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

        FlxG.collide(player, walls);

        if(!paused)
            checkCollision();
    }

    function placeEntities(entity:EntityData)
        {
            switch(entity.name)
            {
                case "player":
                    player.setPosition(entity.x, entity.y);
                case "door":
                    var door:FlxObject = new FlxObject(entity.x, entity.y, entity.width, entity.height);
                    doorGroup.add(door);
                    doorMap.set(door, entity.values.nextRoom);
                    var name = new FlxText(entity.x - 20, 256, 0, 'Leave to Main Menu', 14);
                    name.setBorderStyle(OUTLINE, 0xFF000000, 1.75);
                    var toY = name.y - 20;
                    FlxTween.tween(name, {y: toY}, 1.75, {ease:FlxEase.sineInOut, type: PINGPONG});
                    add(name);
                case "interactable":
                    var intObj:FlxObject = new FlxObject(entity.x, entity.y, entity.width, entity.height);
                    intGroup.add(intObj);
                    interactMap.set(intObj, entity.values.object);
                case 'save':
                    save = new FlxSprite(entity.x, entity.y).loadGraphic(Paths.image('delta/rpg/save', 'shared'), true, 40, 38);
                    save.animation.add('idle', [0,1,2,3,4,5], 6);
                    save.animation.play('idle');
                    save.immovable = true;
                    add(save);
                    saveBox = new FlxObject(entity.x - 4, entity.y - 5, 48, 46);
                    add(saveBox);
                    saveNum = entity.values.saveNum;
                default:
                    trace('Unrecognized actor type ${entity.name}');
            }
        }

    function playerTouchDoor(player:DeltaPlayer, door:FlxObject)
        {
            if (!leaving){
                leaving = true;
                lastRoom = room;
                MusicBeatState.switchState(new MainMenuState());
            }
        }

    function playerInteract(player:DeltaPlayer, obj:FlxObject)
        {
            paused = true;
            var dialogue = new DeltaBox(CoolUtil.coolTextFile(Paths.txt('delta/$room/' + interactMap[obj])));
            dialogue.cameras = [dialogueCam];
            add(dialogue);
        }

    function playerTouchSong(player:DeltaPlayer, obj:FlxObject)
        {
            MusicBeatState.switchState(new DiffState(songMap[obj], true));
        }


     function playerTouchSave(player:DeltaPlayer, save:FlxObject)
        {
            paused = true;
            var saveBox = new SaveBox(saveNum);
            saveBox.cameras = [dialogueCam];
            saveBox.screenCenter();
            add(saveBox);
        }

    function playerOverlapSong(player:DeltaPlayer, obj:FlxObject) {
        nameGroup.forEach(txt -> {
            if(obj.ID == txt.ID){
                txt.alpha = 1;
            }
        });
    }

    function checkCollision()
        {
            FlxG.collide(player, save);
    
            if(FlxG.keys.justPressed.ENTER)
                FlxG.overlap(player, saveBox, playerTouchSave);

            nameGroup.forEach(txt -> {
                txt.alpha = 0;
            });

            songIntGroup.forEach(function(obj:FlxObject)
                {
                    FlxG.overlap(player, obj, playerOverlapSong);
                });

            if(FlxG.keys.justPressed.ENTER){
                songIntGroup.forEach(function(obj:FlxObject)
                    {
                        FlxG.overlap(player, obj, playerTouchSong);
                    });
                }

            doorGroup.forEach(spr -> {
                FlxG.overlap(player, spr, playerTouchDoor);
            });

            songGroup.forEach(function(obj:FlxObject)
                {
                    FlxG.collide(player, obj);
                });

            peopleGroup.sort(FlxSort.byY, FlxSort.ASCENDING);
        }
}