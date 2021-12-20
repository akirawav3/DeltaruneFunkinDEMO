package;

import delta.DeltaFreePlay;
import delta.DeltaSaveControl;
import delta.DeltaPlayState;
#if cpp
import cpp.abi.Abi;
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var opened:Bool = false;

	var ch2:FlxSprite;
	var pissTwn:FlxTween;

	var isCutscene:Bool = false;

	var selectedSomethin:Bool = false;

	var sprTween:FlxTween;
	var sprBackTween:FlxTween;

	var openTween:FlxTween;

	var lastSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['ch1', 'ch2', 'options', 'credits'];

	var chPreview:FlxSprite;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	var bg:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = false;

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('delta/menu_assets');
		bg.animation.addByIndices('first', 'menu_bg', [1], "", 24, false);
		bg.animation.addByIndices('second', 'menu_bg', [2], "", 24, false);
		bg.animation.play('first');
		bg.scrollFactor.set();
		bg.scale.set(.72, .72);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(1000, 150 + (i * 100));
			menuItem.loadGraphic(Paths.image('delta/' + optionShit[i]));
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			
			FlxTween.tween(menuItem, {x: 775}, .5 + (i * 0.25), {ease: FlxEase.quartInOut});
		}

		//FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = ClientPrefs.globalAntialiasing;
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = ClientPrefs.globalAntialiasing;
		add(versionShit);

		chPreview = new FlxSprite(-600);
		chPreview.frames = Paths.getSparrowAtlas('delta/ch1_preview');
		chPreview.scale.set(.72, .72);
		chPreview.screenCenter(Y);
		chPreview.animation.addByPrefix('open', 'opening', 30, false);
		chPreview.animation.addByPrefix('close', 'closing', 30, false);
		chPreview.antialiasing = ClientPrefs.globalAntialiasing;
		add(chPreview);

		FlxTween.tween(chPreview, {x: -250}, 1, {ease: FlxEase.quartInOut});

		// NG.core.calls.event.logEvent('swag').send();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (!Achievements.achievementsUnlocked[achievementID][1] && leDate.getDay() == 5 && leDate.getHours() >= 18) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
			Achievements.achievementsUnlocked[achievementID][1] = true;
			giveAchievement();
			ClientPrefs.saveSettings();
		}
		#end

		changeItem();

		ch2 = new FlxSprite().loadGraphic(Paths.image('delta/ch2pr'));
		ch2.scale.set(.72, .72);
		ch2.updateHitbox();
		ch2.screenCenter();
		ch2.antialiasing = ClientPrefs.globalAntialiasing;
		ch2.alpha = 0;
		add(ch2);

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	var achievementID:Int = 0;
	function giveAchievement() {
		add(new AchievementObject(achievementID, camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement ' + achievementID);
	}
	#end

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
 				else if(curSelected == 1){
					FlxG.sound.play(Paths.sound('boom', 'shared'));
					ch2.alpha = 1;
					if(pissTwn != null) pissTwn.cancel();
					pissTwn = FlxTween.tween(ch2, {alpha: 0}, 1);
				} 
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
					FlxTween.tween(FlxG.camera, {zoom: 1.125}, 1.75, {ease: FlxEase.quartIn});

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1.25, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'ch1':
										DeltaSaveControl.curSave = FlxG.save.data.save1;
										MusicBeatState.switchState(new DeltaFreePlay('hall'));
									case 'ch2':
										//MusicBeatState.switchState(new FreeplayState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		//aw hell nah who wants them at screencenter x :rofl: (answer is not me)
/*  		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		}); */
	}

	override function beatHit()
		{
			super.beatHit();

			if (curBeat % 2 == 1)
				{
					bg.animation.play('first');
				}
			if (curBeat % 2 == 0)
				{
					bg.animation.play('second');
				}

		}

	function changeItem(huh:Int = 0)
	{
		if (openTween != null)
			openTween.cancel();

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if(curSelected != 0)
				{
					if(opened)
						{
							opened = false;
							chPreview.animation.play('close', true);
						}
					openTween = FlxTween.tween(chPreview, {alpha: 0}, .2);
				}
			else
				{
					opened = true;
					chPreview.animation.play('open', true);
					openTween = FlxTween.tween(chPreview, {alpha: 1}, .1);
				}
			
			spr.loadGraphic(Paths.image('delta/' + optionShit[spr.ID]));
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.x = 850;
				sprTween = FlxTween.tween(spr, {x: 775}, .4, {ease: FlxEase.quartOut});
				spr.loadGraphic(Paths.image('delta/' + optionShit[curSelected] + 'P'));
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}
