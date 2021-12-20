package;

import delta.DeltaPlayState;
import openfl.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

class DiffState extends MusicBeatState
{
    var curSelected:Int = 0;
    var diffArr:Array<String> = ['e', 'n', 'h', 'c'];
    var diffG:FlxSpriteGroup = new FlxSpriteGroup();
    var desc:FlxSprite;

    var scaleInTwn:FlxTween;
	var scaleOutTwn:FlxTween;
    var song:String;
    var storyMode:Bool = false;

    public function new(?song:String, ?storyMode:Bool) {
        super();
        this.song = song;
        this.storyMode = storyMode;
    }
	override public function create()
	{
        super.create();

        DeltaPlayState.paused = false;

        var bg = new BGSprite('delta/diff/difficultyBG_assets',0,0,1,1,['difficultyBG_assets'], true);
        bg.dance();
        bg.setGraphicSize(1280, 720);
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        var bar = new FlxSprite().loadGraphic(Paths.image('delta/diff/bar'));
        add(bar);

        for(i in 0...diffArr.length){
            var diff = new FlxSprite(67, 67 + 167 * i).loadGraphic(Paths.image('delta/diff/${diffArr[i]}'));
            diff.ID = i;
            diffG.add(diff);
        }
        add(diffG);

        desc = new FlxSprite().loadGraphic(Paths.image('delta/diff/$curSelected'));
        add(desc);

        changeSel();
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        if(FlxG.keys.justPressed.DOWN) changeSel(1);
        if(FlxG.keys.justPressed.UP) changeSel(-1);
        if(FlxG.keys.justPressed.ENTER && curSelected != 3) confirmSel();
    }

    function changeSel(change:Int = 0){
        var lastSel = curSelected;
        curSelected += change;
        if(curSelected > 3) curSelected = 0;
        if(curSelected < 0) curSelected = 3;

        if(scaleOutTwn != null) scaleOutTwn.cancel();
		if(scaleInTwn != null) scaleInTwn.cancel();

        diffG.forEach(spr -> {
            if(spr.ID == curSelected){
                spr.loadGraphic(Paths.image('delta/diff/${diffArr[curSelected]}s'));
                spr.scale.set(.85, .85);
				scaleOutTwn = FlxTween.tween(spr.scale, {x: .95, y: .95}, .25, {ease: FlxEase.backOut});
            }
            else{
                spr.loadGraphic(Paths.image('delta/diff/${diffArr[spr.ID]}'));
            }

            if(spr.ID == lastSel){
                spr.scale.set(1.075, 1.075);
				scaleInTwn = FlxTween.tween(spr.scale, {x: .95, y: .95}, .25, {ease: FlxEase.backOut});
            }
        });
 
        desc.loadGraphic(Paths.image('delta/diff/$curSelected'));
    }

    function confirmSel(){
        var songLowercase:String = Paths.formatToSongPath(song);
        var poop:String = Highscore.formatSong(songLowercase, curSelected);
        if(!Assets.exists(Paths.json(songLowercase + '/' + poop))) {
            poop = songLowercase;
        }

        PlayState.SONG = Song.loadFromJson(poop, songLowercase);
        PlayState.isStoryMode = storyMode;
        PlayState.storyDifficulty = curSelected;

        //PlayState.storyWeek = songs[curSelected].week;
        LoadingState.loadAndSwitchState(new PlayState(), true);
    }
}