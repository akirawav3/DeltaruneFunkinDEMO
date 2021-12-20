package delta;

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

class DeltaPlayState extends MusicBeatState
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

    var intGroup:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();
    var doorGroup:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

    var save:FlxSprite;
    var saveNum:Int;
    var saveBox:FlxObject;

    var leaving:Bool = false;

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

        follower = new DeltaFollower();
        peopleGroup.add(follower);

        var follower2 = new DeltaFollower(0,0,'ralseiDark');
        follower2.follow = 50;
        peopleGroup.add(follower2);

        player = new DeltaPlayer(0,0,'kris');
        peopleGroup.add(player);

        map.loadEntities(placeEntities, "entites");

        add(peopleGroup);

        var seen:Map<String, Bool> = DeltaSaveControl.curSave.seen;
        if (seen[room] == null)
            DeltaSaveControl.curSave.seen.set(room, false);

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

                if (!seen[room])
                    {
                        var dialogue = new DeltaruneCutscene('schoolCut', ['start', 'yawn', 'look', 'slam', 'ask', 'smile', 'oh', 'byeLMAO'], CoolUtil.coolTextFile(Paths.txt('delta/schoolDialogue')));
                        dialogue.cameras = [dialogueCam];
                        add(dialogue);
                    }

                camGame.setPosition(-128, -24);
                camGame.follow(null);
            case 'hall':
                if (lastRoom == 'class'){
                    player.animation.play('downi');
                }
                else{
                    player.setPosition(985, 464);
                    player.animation.play('lefti');
                }

                if (!seen[room])
                    {
                        var dialogue = new DeltaruneCutscene('hallCut', ['walkout', 'lookup', 'sus', 'hellnaw', 'OHNO', 'yum', 'lolwait', 'toss', 'getup', 'LMAOO', 'smile', 'WTF'], CoolUtil.coolTextFile(Paths.txt('delta/hallDialogue')), ['grab'], 'delta/dialogue/hallCut/walk', 22);
                        dialogue.cameras = [dialogueCam];
                        add(dialogue);
                        DeltaSaveControl.curSave.seen.set(room, true);
                        FlxG.save.flush();
                    }

                camGame.setPosition(190, -24);
                camGame.setScrollBoundsRect(0, 0, 1280 + 500, 720);
            case 'hallAfter':
                if (lastRoom == 'class' || lastRoom == null){
                    player.animation.play('downi');
                }
                else{
                    player.setPosition(985, 464);
                    player.animation.play('lefti');
                }
                camGame.setPosition(190, -24);
                camGame.setScrollBoundsRect(0, 0, 1280 + 500, 720);
            case 'hallMiddle':
                camGame.setScrollBoundsRect(200, 0, 845, 1350);
                if (lastRoom == 'hall' || lastRoom == 'hallAfter'){
                    player.animation.play('righti');
                }
                else{
                    player.animation.play('lefti');
                    player.setPosition(664, 960);
                }
            case 'hallRight':
                camGame.setPosition(190, -24);
                camGame.setScrollBoundsRect(0, 0, 1280 + 500, 720);
            case 'dark4':
                camGame.setScrollBoundsRect(200, 0, 3097 - 200, 2892);
            case 'dark9':
/*                 if (!seen[room])
                    { */
                        var dialogue = new DeltaruneCutscene('dark9Cut', ['beforeReveal', 'beforeDG1', 'beforeDG2', 'beforeDG3', 'lancerReveal', 'afterDG', 'afterReveal'], CoolUtil.coolTextFile(Paths.txt('delta/lancerDialogue')));
                        dialogue.cameras = [dialogueCam];
                        add(dialogue);
                        DeltaSaveControl.curSave.seen.set(room, true);
                        FlxG.save.flush();
                    //}
        }
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

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
            if (!leaving)
                leaving = true;
                lastRoom = room;
                camGame.fade(FlxColor.BLACK, .2, false, function(){
                    FlxTransitionableState.skipNextTransIn = true;
                    FlxTransitionableState.skipNextTransOut = true;
                    MusicBeatState.switchState(new DeltaPlayState(doorMap[door]));
                });
        }

    function playerInteract(player:DeltaPlayer, obj:FlxObject)
        {
            paused = true;
            var dialogue = new DeltaBox(CoolUtil.coolTextFile(Paths.txt('delta/$room/' + interactMap[obj])));
            dialogue.cameras = [dialogueCam];
            add(dialogue);
        }

     function playerTouchSave(player:DeltaPlayer, save:FlxObject)
        {
            paused = true;
            var saveBox = new SaveBox(saveNum);
            saveBox.cameras = [dialogueCam];
            saveBox.screenCenter();
            add(saveBox);
        }

    function checkCollision()
        {
            FlxG.collide(player, walls);
            FlxG.collide(player, save);
    
            if(FlxG.keys.justPressed.ENTER)
                FlxG.overlap(player, saveBox, playerTouchSave);

            if(FlxG.keys.justPressed.ENTER){
                intGroup.forEach(function(obj:FlxObject)
                    {
                        FlxG.overlap(player, obj, playerInteract);
                    });
                }
    
            doorGroup.forEach(function(obj:FlxObject)
                {
                    FlxG.overlap(player, obj, playerTouchDoor);
                });

            peopleGroup.sort(FlxSort.byY, FlxSort.ASCENDING);
        }
}