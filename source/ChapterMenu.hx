package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

class ChapterMenu extends MusicBeatState
{
	var names:Array<String> = ['a', 'f', 'o', 'e'];
	var selG:FlxSpriteGroup;
	var curSel:Int = 0;
	var fpLock:FlxSprite;
	var canControl:Bool = true;
	var dialogueTxt:FlxTypeText;
	var dialogueNum:Int = 0;
	var dialogue:Array<String> = ['Hey there! To play Freeplay you have to finish Adventure Mode', "But dont worry, we'll all have fun together along the way!"];
	var closing:Bool = false;

	var scaleInTwn:FlxTween;
	var scaleOutTwn:FlxTween;
	override public function create()
	{
		super.create();

		selG = new FlxSpriteGroup();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/story/bg', 'preload'));
		add(bg);

		var sidebar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/story/bar', 'preload'));
		add(sidebar);

		for(i in 0...names.length){
			var sel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/story/${names[i]}', 'preload'));
			sel.ID = i;
			selG.add(sel);
		}
		add(selG);

		var title:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/story/title', 'preload'));
		add(title);

		fpLock = new FlxSprite(0, 545).loadGraphic(Paths.image('delta/story/FPLOCK', 'preload'), true, 598, 172);
		fpLock.animation.add('open', [0,1,2,3,4], 30, false);
		fpLock.animation.add('talk2', [5], 30, false);
		fpLock.animation.add('close', [6,7,8,9,10], 30, false);
		fpLock.visible = false;
		fpLock.screenCenter(X);
		add(fpLock);

		dialogueTxt = new FlxTypeText(520, 575, 385, "", 26);
		dialogueTxt.font = Paths.font("fixedsys.ttf");
		dialogueTxt.antialiasing = ClientPrefs.globalAntialiasing;
		dialogueTxt.visible = false;
		add(dialogueTxt);

		changeSel();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(canControl){
			if(FlxG.keys.justPressed.DOWN){
				changeSel(1);
			}
			if(FlxG.keys.justPressed.UP){
				changeSel(-1);
			}
			if(FlxG.keys.justPressed.ESCAPE){
				MusicBeatState.switchState(new MainMenuState());
			}
			if(FlxG.keys.justPressed.ENTER){
				FlxG.sound.play(Paths.sound('delta/select', 'shared'));
				switch(curSel){
					case 0: MusicBeatState.switchState(new SaveMenuState());
					case 1: 
						//if(FlxG.save.data.fpUnlocked)
							MusicBeatState.switchState(new FreeplayState());
						//else{
						//	canControl = false;
						//	fpDialogue();
						//}
					case 2: MusicBeatState.switchState(new OptionsState());
				}
			}
		}
		else{
			if(FlxG.keys.justPressed.ENTER)
				{
					dialogueNum++;
					fpDialogue();
				}
		}
	}

	function changeSel(change:Int = 0){
		FlxG.sound.play(Paths.sound('delta/menumove', 'shared'));
		var lastSel = curSel;
		curSel += change;
		if(curSel < 0) curSel = 3;
		if(curSel > 3) curSel = 0;

		if(scaleOutTwn != null) scaleOutTwn.cancel();
		if(scaleInTwn != null) scaleInTwn.cancel();

		selG.forEach(spr -> {
			if(spr.ID == curSel){
				spr.loadGraphic(Paths.image('delta/story/${names[spr.ID]}S'));
				spr.scale.set(.95, .95);
				scaleOutTwn = FlxTween.tween(spr.scale, {x: 1, y: 1}, .25, {ease: FlxEase.quartOut});
			}
			else 
				spr.loadGraphic(Paths.image('delta/story/${names[spr.ID]}'));

			if(spr.ID == lastSel){
				spr.scale.set(1.05, 1.05);
				scaleInTwn = FlxTween.tween(spr.scale, {x: 1, y: 1}, .25, {ease: FlxEase.quartOut});
			}
		});
	}

	function fpDialogue(){
		switch(dialogueNum){
			case 0:
				fpLock.visible = dialogueTxt.visible = true;
				fpLock.animation.play('open', true);
				dialogueTxt.resetText(dialogue[dialogueNum]);
				dialogueTxt.start(.065, true);
			case 1:
				fpLock.animation.play('talk2', true);
				dialogueTxt.resetText(dialogue[dialogueNum]);
				dialogueTxt.start(.065, true);
			case 2:
				if(!closing){
					closing = true;
					fpLock.animation.play('close', true);
					dialogueTxt.visible = false;
					FlxTween.tween(fpLock, {alpha: 0}, .2, {onComplete: twn -> {
						fpLock.visible = false;
						fpLock.alpha = 1;
						canControl = true;
						dialogueNum = 0;
						closing = false;
					}});
				}
		}
	}
}
