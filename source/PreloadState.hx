package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.graphics.FlxGraphic;

class PreloadState extends MusicBeatState{
    var assets:Array<Array<String>> = [
        ['delta/diff/difficultyBG_assets', 'preload'],
    ];
    var done:Int = 0;
    var txt:FlxText;
    var l:Int = 0;
    var iter:Int = 0;

    override function create(){
        FlxGraphic.defaultPersist = true;
        FlxG.mouse.visible = false;
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loading'));
		add(bg);
        txt = new FlxText(0,600,100,'0/${assets.length}\n',24);
        txt.setFormat(Paths.font('DTMC.ttf'), 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        txt.borderSize = 2.5;
        txt.screenCenter(X);
        add(txt);

        loadThing();

        super.create();
    }

    function loadThing(){
        sys.thread.Thread.create(() -> {
            for(file in 0...assets.length){
                trace('preloading img: ${assets[done][0]}');
                var img = FlxGraphic.fromAssetKey(Paths.image(assets[done][0], assets[done][1]));
                img.persist = true;
                img.destroyOnNoUse = false;
                done++;

                txt.text = '$done/${assets.length}\n';
                
                if(file == assets.length - 1){
                    new FlxTimer().start(.25, tmr -> {
                        MusicBeatState.switchState(new TitleState());
                    });
                } 
            }
        });
    }
}