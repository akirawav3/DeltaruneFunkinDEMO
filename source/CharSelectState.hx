/*
god looking back at this i couldve done a lot of stuff a lot better, 
but i kinda dont feel like redoing it
*/
package;

import delta.DeltaPlayState;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class CharSelectState extends MusicBeatState
{
	public static var leftState:Bool = false;
	
	var camGame:FlxCamera;
	var border:FlxCamera;
	var glowText:FlxCamera;
	
	var curPart:String;

	var startText:FlxTypeText;

	var canControl:Bool = false;

	var curGroupID:Int = 0;
	var curSelected:Int = 0;
	var toX:Float = 0;

	var curGroup:FlxTypedSpriteGroup<FlxSprite>;
	var item:FlxSprite;
	var groupTween:FlxTween;

	var selMax:Int;

	var warnText:FlxText;
	var bg:FlxSprite;
	var ccBG:FlxSprite;

	var iterate:Float = 0;

	var blackBars:FlxSprite;

	var outColor:FlxColor = 0xBFFFFFFF; 
	var sineThing:Float = 0;

	var textFormat:FlxTextFormat;

	var selArray:Array<Int> = [];

	var fSpeaker:FlxSprite;
	var fLeg:FlxSprite;
	var fBody:FlxSprite;
	var fHead:FlxSprite;

	//for reference: files:Int, part:String, startX:Int, offsetX:Int, offsetY:Int, sprScale:Float

	var dataArray:Array<Dynamic> = [
		[5, 'speaker', 300, 475, 300, .7, 'SPEAKER'],
		[3, 'leg', 545, 200, 300, .7, 'LEGS'],
		[6, 'body', 535, 200, 275, .7, 'TORSO'],
		[8, 'head', 500, 200, 125, .7, 'HEAD']
	];

	override function create()
		{
			//New cameras so border can go above everything
			camGame = new FlxCamera();
			FlxG.cameras.reset(camGame);
			FlxCamera.defaultCameras = [camGame];

			border = new FlxCamera();
			border.bgColor.alpha = 0;
			FlxG.cameras.add(border);

			glowText = new FlxCamera();
			glowText.bgColor.alpha = 0;
			FlxG.cameras.add(glowText);

			var blur = new BlurFilter(1.25, 1.25);

			var filters:Array<BitmapFilter> = [blur];

			glowText.setFilters(filters);

			FlxG.sound.music.play();
			FlxG.sound.playMusic(Paths.music('charSelect'), 0);
			FlxG.sound.music.fadeIn();

			blackBars = new FlxSprite().loadGraphic(Paths.image('delta/character/black'));
			add(blackBars);
			blackBars.cameras = [border];

			bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			add(bg);

			ccBG = new FlxSprite();
			ccBG.frames = Paths.getSparrowAtlas('delta/character/ccBG_assets');
			ccBG.animation.addByPrefix('loop', 'cc move', 12);
			ccBG.animation.play('loop');
			ccBG.scale.set(.75, .75);
			ccBG.alpha = 0;
			ccBG.screenCenter();
			add(ccBG);

			startText = new FlxTypeText(300, 100, 0, 'FIRST.', 32);
			startText.setFormat(Paths.font('fixedsys.ttf'), 46, FlxColor.WHITE, LEFT, OUTLINE_FAST, outColor);
			startText.borderSize = 1.75;
			startText.antialiasing = ClientPrefs.globalAntialiasing;
			startText.cameras = [glowText];
			add(startText);

			FlxTween.tween(ccBG, {alpha: 1}, 3, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
				{
					startText.start(.15, true, false, null, fadeText.bind('YOU MUST CREATE\nA VESSEL.', true));
				}
			});

			curGroup = new FlxTypedSpriteGroup<FlxSprite>();
			curGroup.antialiasing = ClientPrefs.globalAntialiasing;

			super.create();
		}

	override function update(elapsed:Float)
		{
			#if debug
			if(FlxG.keys.justPressed.K)
				{
					FlxG.switchState(new DeltaPlayState('class'));
				}
			#end
			//Similar to the title logo, makes the text "glow" fade in/out
			sineThing += .05;

			outColor.alpha = 75 + Std.int(Math.sin(sineThing / 1.5 * elapsed * 60) * 45);
			startText.borderColor = outColor;

			if (canControl)
				{
					if (FlxG.keys.justPressed.LEFT)
						changeSel(-1, true);
					if (FlxG.keys.justPressed.RIGHT)
						changeSel(1, true);
					if (FlxG.keys.justPressed.ENTER)
						{
							if (dataArray[curGroupID][6] == 'HEAD')
								{
									canControl = false;
									selArray.push(curSelected);
									trace('FINAL SELECTION: ' + selArray);
									fHead = new FlxSprite(500, 125).loadGraphic(Paths.image('delta/character/head/' + selArray[3], 'preload'));
									fHead.antialiasing = ClientPrefs.globalAntialiasing;
									fHead.scale.set(.7, .7);
									remove(fBody);
									remove(fLeg);
									add(fHead);
									add(fBody);
									add(fLeg);
									curGroup.forEach(function(spr:FlxSprite)
										{
											FlxTween.tween(spr, {alpha: 0}, 1.5);
										});
									FlxTween.tween(startText, {alpha: 0}, 1.5, {onComplete: function(twn:FlxTween) 
										{
											curSelected = 0;
											startText.resetText('THANK YOU\nFOR YOUR TIME.');
											startText.alpha = 1;
											startText.start(.10, true, false, null, endShit.bind('YOUR WONDERFUL\nCREATION'));
										}});
								}
							else
								{
									canControl = false;
									curGroupID++;
									selArray.push(curSelected);
									trace(selArray);
									curGroup.forEach(function(spr:FlxSprite)
										{
											FlxTween.tween(spr, {alpha: 0}, 1);
										});
									FlxTween.tween(startText, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) 
										{
											curSelected = 0;
											startText.resetText('SELECT THE ' + dataArray[curGroupID][6] + '\nTHAT YOU PREFER.');
											startText.alpha = 1;
											startText.start(.15);
											newSelection(dataArray[curGroupID][0], dataArray[curGroupID][1], dataArray[curGroupID][2], dataArray[curGroupID][3], dataArray[curGroupID][4], dataArray[curGroupID][5]);
										}});
									if (fSpeaker != null)
										FlxTween.tween(fSpeaker, {alpha: 0}, 1);
									if (fLeg != null)
										FlxTween.tween(fLeg, {alpha: 0}, 1);
									if (fBody != null)
										FlxTween.tween(fBody, {alpha: 0}, 1);
								}
						}
					
				}

			super.update(elapsed);
		}

	function fadeText(txt:String, repeat:Bool)
		{
			new FlxTimer().start(.5, function(tmr:FlxTimer)
				{
					FlxTween.tween(startText, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) 
						{
							startText.resetText(txt);
							startText.alpha = 1;
							if (repeat)
								{
									startText.start(.15, true, false, null, fadeText.bind('SELECT THE SPEAKER\nTHAT YOU PREFER.', false));
								}
							else
								{
									startText.start(.15, true, false, null);
									new FlxTimer().start(.5, function(tmr:FlxTimer)
										{
											newSelection(dataArray[0][0], dataArray[0][1], dataArray[0][2], dataArray[0][3], dataArray[0][4], dataArray[0][5]);
										});
								}
						}});
				});
		}

	function newSelection(files:Int, part:String, startX:Int, offsetX:Int, offsetY:Int, sprScale:Float)
    {
		changeSel(0, false);
        curGroup.clear();
		curPart = part;
		switch(curPart)
		{
			case 'leg':
				fSpeaker = new FlxSprite(300, 300).loadGraphic(Paths.image('delta/character/speaker/' + selArray[0], 'preload'));
				fSpeaker.scale.set(.7, .7);
				fSpeaker.alpha = 0;
				fSpeaker.antialiasing = ClientPrefs.globalAntialiasing;
				add(fSpeaker);
				FlxTween.tween(fSpeaker, {alpha: 1}, 1, {ease: FlxEase.quartOut});
			case 'body':
				fLeg = new FlxSprite(545, 300).loadGraphic(Paths.image('delta/character/leg/' + selArray[1], 'preload'));
				fLeg.scale.set(.7, .7);
				fLeg.alpha = 0;
				fLeg.antialiasing = ClientPrefs.globalAntialiasing;
				fSpeaker.alpha = 0;
				FlxTween.tween(fSpeaker, {alpha: 1}, 1, {ease: FlxEase.quartOut});
				FlxTween.tween(fLeg, {alpha: 1}, 1, {ease: FlxEase.quartOut});
			case 'head':
				fBody = new FlxSprite(535, 275).loadGraphic(Paths.image('delta/character/body/' + selArray[2], 'preload'));
				fBody.scale.set(.7, .7);
				fBody.alpha = 0;
				fBody.antialiasing = ClientPrefs.globalAntialiasing;
				fLeg.alpha = 0;
				fSpeaker.alpha = 0;
				remove(fLeg);
				FlxTween.tween(fSpeaker, {alpha: 1}, 1, {ease: FlxEase.quartOut});
				FlxTween.tween(fLeg, {alpha: 1}, 1, {ease: FlxEase.quartOut});
				FlxTween.tween(fBody, {alpha: 1}, 1, {ease: FlxEase.quartOut});
		}
        for (i in 0...files)
            {
                item = new FlxSprite(startX + (i * offsetX), offsetY);
                item.loadGraphic(Paths.image('delta/character/' + part + '/' + i, 'preload'));
				item.scale.set(sprScale, sprScale);
				item.antialiasing = ClientPrefs.globalAntialiasing;
				item.ID = i;
                curGroup.add(item);
            }
		curGroup.alpha = 0;
		add(curGroup);
		curGroup.forEach(function(spr:FlxSprite)
			{
				remove(spr);
				add(spr);
				if (spr.ID == curSelected)
					FlxTween.tween(spr, {alpha: 1}, 1);
				else if (spr.ID  == curSelected -1 || spr.ID  == curSelected +1)
					FlxTween.tween(spr, {alpha: .5}, 1);
				else if (spr.ID  == curSelected -2 || spr.ID  == curSelected +2)
					FlxTween.tween(spr, {alpha: .2}, 1);
				else
					FlxTween.tween(spr, {alpha: 0}, 1);
			});
		add(fBody);
		add(fLeg);
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				canControl = true;
			});
    }

	function changeSel(change:Int, fade:Bool)
		{
			if (groupTween != null)
				groupTween.cancel();

			curSelected += change;

			switch(curPart)
				{
					case 'speaker':
						selMax = 4;
					case 'leg':
						selMax = 2;
					case 'body':
						selMax = 5;
					case 'head':
						selMax = 7;
				}
			
			if (curSelected < 0)
				curSelected = 0;
			if (curSelected > selMax)
				curSelected = selMax;

			if (fade)
				{
					curGroup.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == curSelected)
								FlxTween.tween(spr, {alpha: 1}, .1, {ease: FlxEase.quartOut});
							else if (spr.ID  == curSelected -1 || spr.ID  == curSelected +1)
								FlxTween.tween(spr, {alpha: .5}, .1, {ease: FlxEase.quartOut});
							else if (spr.ID  == curSelected -2 || spr.ID  == curSelected +2)
								FlxTween.tween(spr, {alpha: .2}, .1, {ease: FlxEase.quartOut});
							else
								FlxTween.tween(spr, {alpha: 0}, .1, {ease: FlxEase.quartOut});
						});
					toX = curSelected * -dataArray[curGroupID][3];

					groupTween = FlxTween.tween(curGroup, {x: toX}, .3, {ease: FlxEase.quartOut});
				}
			else 
				{
					toX = curSelected * -dataArray[curGroupID][3];
					curGroup.x = toX;
				}
			trace("Current Selection: " + curSelected);
		}

	function endShit(txt:String)
		{
			new FlxTimer().start(.75, function(tmr:FlxTimer)
				{
					FlxTween.tween(startText, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) 
						{
							startText.resetText(txt);
							startText.alpha = 1;
							startText.start(.15, true, false, null, fuckIt.bind());
						}});
				});
		}

	function fuckIt() 
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.sound.music.stop();
					FlxG.sound.play(Paths.sound('delta/text', 'shared'));
					remove(ccBG);
					remove(startText);
					remove(fLeg);
					remove(fBody);
					remove(fHead);
					remove(fSpeaker);

					new FlxTimer().start(.75, function(tmr:FlxTimer)
						{
							var endText = new FlxTypeText(300, 100, 0, 'Will now be\ndiscarded.', 32);
							endText.screenCenter(X);
							endText.x -= 150;
							endText.setFormat(Paths.font('fixedsys.ttf'), 46, FlxColor.WHITE);
							endText.antialiasing = ClientPrefs.globalAntialiasing;
							add(endText);
							endText.start(.075);
							new FlxTimer().start(3.25, function(tmr:FlxTimer)
								{
									endText.resetText('No one can choose\nwho they are\nin this world.');
									endText.start(.075);
									new FlxTimer().start(4, function(tmr:FlxTimer)
										{
											endText.x += 100;
											FlxG.sound.play(Paths.sound('delta/wind', 'shared'));
											endText.resetText('Your\n\n         \nname\n\n         \n\nis');
											endText.start(.075);
											FlxTween.tween(FlxG.camera, {zoom: .8}, 5.5);
											new FlxTimer().start(.25, function(tmr:FlxTimer)
												{
													iterate += .00025;
													FlxG.camera.shake(iterate, .25);
												}, 22);
											border.fade(FlxColor.WHITE, 5.5, false, function()
												{
													FlxG.switchState(new DeltaPlayState('class'));
												});
										});
								});
						});
				});
		}
}