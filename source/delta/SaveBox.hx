package delta;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class SaveBox extends FlxSpriteGroup
{
    var timeTxt:FlxText;
    var save:Dynamic;
    var heart:FlxSprite;
    var curSelected:Int = 0;
    var txtG:FlxTypedSpriteGroup<FlxText>;
    var close:Bool = false;
    var canMove:Bool = true;
    var saveTxt:FlxText;
    var returnTxt:FlxText;
    var saveNum:Int;
    var placeTxt:FlxText;
	public function new(saveNum:Int = 0)
	{
		super(x, y);

        this.saveNum = saveNum;

        FlxG.sound.play(Paths.sound('delta/powerup', 'shared'));

        var box:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/rpg/saveBox', 'shared'));
        add(box);

        save = DeltaSaveControl.curSave;

        txtG = new FlxTypedSpriteGroup<FlxText>();
        add(txtG);

        var nameTxt:FlxText = new FlxText(60, 35, 0, save.saveName, 42);
        nameTxt.font = Paths.font('dtm-sans.ttf');
        txtG.add(nameTxt);

        placeTxt = new FlxText(60, 100, 0, DeltaSaveControl.savePlaces[save.savePoint], 42);
        placeTxt.font = Paths.font('dtm-sans.ttf');
        txtG.add(placeTxt);

        saveTxt = new FlxText(100, 200, 0, 'Save', 42);
        saveTxt.font = Paths.font('dtm-sans.ttf');
        txtG.add(saveTxt);

        returnTxt = new FlxText(400, 200, 0, 'Return', 42);
        returnTxt.font = Paths.font('dtm-sans.ttf');
        txtG.add(returnTxt);

        timeTxt = new FlxText(430, 35, 200, FlxStringUtil.formatTime(save.timePlayed + DeltaSaveControl.gameTime), 42);
        timeTxt.alignment = RIGHT;
        timeTxt.font = Paths.font('dtm-sans.ttf');
        txtG.add(timeTxt);

        heart = new FlxSprite(60, 215).loadGraphic(Paths.image('delta/soul', 'shared'));
        heart.scale.set(1.75, 1.75);
        add(heart);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
            
        timeTxt.text = FlxStringUtil.formatTime(save.timePlayed + DeltaSaveControl.gameTime);

        if(canMove){
            if(FlxG.keys.justPressed.LEFT)
                changeSel(-1);
            if(FlxG.keys.justPressed.RIGHT)
                changeSel(1);
        }

        if(FlxG.keys.justPressed.ENTER)
            if(curSelected == 0 && !close)
                {
                    close = true;
                    txtG.forEach(txt -> {
                        txt.color = FlxColor.YELLOW;
                    });
                    returnTxt.visible = false;
                    saveTxt.text = 'File saved.';
                    FlxG.sound.play(Paths.sound('delta/save', 'shared'));
                    DeltaSaveControl.updateSave(saveNum);
                    placeTxt.text = DeltaSaveControl.savePlaces[save.savePoint];
                }
            else if(curSelected == 1)
                {
                    //timer so you dont instantly try to save again lololololos
                    new FlxTimer().start(.1, tmr -> {
                        DeltaPlayState.paused = false;
                    });
                    kill();
                }
            else
                {
                    new FlxTimer().start(.1, tmr -> {
                        DeltaPlayState.paused = false;
                    });
                    kill();
                }
	}

    function changeSel(change:Int)
        {
            FlxG.sound.play(Paths.sound('delta/menumove', 'shared'));
            curSelected += change;
            if(curSelected < 0) curSelected = 0;
            if(curSelected > 1) curSelected = 1;

            if(curSelected == 0)
                heart.setPosition(60 + this.x, 215 + this.y);
            else
                heart.setPosition(358 + this.x, 215 + this.y);
        }
}
