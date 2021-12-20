//dont read this shit, its a really bad plate of spaghetti
package;

import delta.DeltaPlayState;
import delta.DeltaSaveControl;
import flixel.util.FlxTimer;
import flixel.util.FlxStringUtil;
import openfl.filters.ColorMatrixFilter;
import openfl.geom.Point;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class SaveMenuState extends MusicBeatState
{
	var s1:FlxSprite;
	var s2:FlxSprite;
	var s3:FlxSprite;
	var copy:FlxSprite;
	var erase:FlxSprite;

	var s1Name:FlxText;
	var s2Name:FlxText;
	var s3Name:FlxText;

	var s1Time:FlxText;
	var s2Time:FlxText;
	var s3Time:FlxText;

	var s1Point:FlxText;
	var s2Point:FlxText;
	var s3Point:FlxText;

	var s1TxtG:FlxSpriteGroup;
	var s2TxtG:FlxSpriteGroup;
	var s3TxtG:FlxSpriteGroup;

	var nameArr:Array<String> = ['s1','s2','s3','c','e'];
	var selArr:Array<FlxSprite>;

	var curSelected:Int = 0;

	var modeTxt:FlxText;

	var step:Int = 0;
	var copied:Dynamic;
	var theMode:String = 'def';
	var canControl = true;
	var startSel = false;
	var name:CustFlxInputText;
	var isCutscene = false;
	
	var start:FlxText;

	override public function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('delta/save/bg'));
		add(bg);

		var bgTxt:FlxSprite = new FlxSprite(0, -60).loadGraphic(Paths.image('delta/save/bgtxt'));
		bgTxt.alpha = 0;
		add(bgTxt);
		FlxTween.tween(bgTxt, {alpha: 1, y: 0}, 1.15, {ease: FlxEase.quartOut, startDelay: .5});

		s1 = new FlxSprite().loadGraphic(Paths.image('delta/save/s1s'));
		s2 = new FlxSprite().loadGraphic(Paths.image('delta/save/s2'));
		s3 = new FlxSprite().loadGraphic(Paths.image('delta/save/s3'));
		add(s1);
		add(s2);
		add(s3);

		copy = new FlxSprite().loadGraphic(Paths.image('delta/save/c'));
		erase = new FlxSprite().loadGraphic(Paths.image('delta/save/e'));
		add(copy);
		add(erase);

		s1TxtG = new FlxSpriteGroup();
		s2TxtG = new FlxSpriteGroup();
		s3TxtG = new FlxSpriteGroup();
		add(s1TxtG);
		add(s2TxtG);
		add(s3TxtG);

		//yeah, i could probably do this text with loops
		s1Name = new FlxText(330, 120, 320, FlxG.save.data.save1.saveName, 40);
		s1Name.font = Paths.font('dtm-sans.ttf');
		s1Name.setBorderStyle(SHADOW, 0x80000000, 3);
		s1TxtG.add(s1Name);

		s1Time = new FlxText(750, 120, 200, FlxG.save.data.save1.timePlayed == 0 ? '- - : - -' : FlxStringUtil.formatTime(FlxG.save.data.save1.timePlayed), 40);
		s1Time.font = Paths.font('dtm-sans.ttf');
		s1Time.alignment = RIGHT;
		s1Time.setBorderStyle(SHADOW, 0x80000000, 3);
		s1TxtG.add(s1Time);

		s1Point = new FlxText(330, 220, 320, DeltaSaveControl.savePlaces[FlxG.save.data.save1.savePoint], 40);
		s1Point.font = Paths.font('dtm-sans.ttf');
		s1Point.setBorderStyle(SHADOW, 0x80000000, 3);
		s1TxtG.add(s1Point);

		s2Name = new FlxText(330, 300, 320, FlxG.save.data.save2.saveName, 40);
		s2Name.font = Paths.font('dtm-sans.ttf');
		s2Name.setBorderStyle(SHADOW, 0x80000000, 3);
		s2TxtG.add(s2Name);

		s2Time = new FlxText(750, 300, 200, FlxG.save.data.save2.timePlayed == 0 ? '- - : - -' : FlxStringUtil.formatTime(FlxG.save.data.save2.timePlayed), 40);
		s2Time.font = Paths.font('dtm-sans.ttf');
		s2Time.alignment = RIGHT;
		s2Time.setBorderStyle(SHADOW, 0x80000000, 3);
		s2TxtG.add(s2Time);

		s2Point = new FlxText(330, 400, 320, DeltaSaveControl.savePlaces[FlxG.save.data.save2.savePoint], 40);
		s2Point.font = Paths.font('dtm-sans.ttf');
		s2Point.setBorderStyle(SHADOW, 0x80000000, 3);
		s2TxtG.add(s2Point);

		s3Name = new FlxText(330, 475, 320, FlxG.save.data.save3.saveName, 40);
		s3Name.font = Paths.font('dtm-sans.ttf');
		s3Name.setBorderStyle(SHADOW, 0x80000000, 3);
		s3TxtG.add(s3Name);

		s3Time = new FlxText(750, 475, 200, FlxG.save.data.save3.timePlayed == 0 ? '- - : - -' : FlxStringUtil.formatTime(FlxG.save.data.save3.timePlayed), 40);
		s3Time.font = Paths.font('dtm-sans.ttf');
		s3Time.alignment = RIGHT;
		s3Time.setBorderStyle(SHADOW, 0x80000000, 3);
		s3TxtG.add(s3Time);

		s3Point = new FlxText(330, 575, 320, DeltaSaveControl.savePlaces[FlxG.save.data.save3.savePoint], 40);
		s3Point.font = Paths.font('dtm-sans.ttf');
		s3Point.setBorderStyle(SHADOW, 0x80000000, 3);
		s3TxtG.add(s3Point);

		selArr = [s1,s2,s3,copy,erase];

		name = new CustFlxInputText(30,30, 320, '', 40, FlxColor.WHITE, FlxColor.TRANSPARENT);
		name.caretWidth = 4;
		name.hasFocus = false;
		name.font = Paths.font('dtm-sans.ttf');
		name.maxLength = 14;
		name.callback = confirmName;
		name.setBorderStyle(SHADOW, 0x64000000, 3);

		start = new FlxText(0, 0, 320, 'Start', 40);
		start.font = Paths.font('dtm-sans.ttf');
		start.setBorderStyle(SHADOW, 0x80000000, 3);
		start.color = FlxColor.YELLOW;

		modeTxt = new FlxText(0, 637, 1280, '', 40);
		modeTxt.font = Paths.font('dtm-sans.ttf');
		modeTxt.setBorderStyle(SHADOW, 0xE224222e, 3);
		modeTxt.alignment = CENTER;
		modeTxt.visible = false;
		add(modeTxt);

		changeSel();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(canControl)
			checkControl();
		if(FlxG.keys.justPressed.ENTER && startSel && !isCutscene)
			{
				FlxG.sound.play(Paths.sound('delta/select', 'shared'));
				var curSave = curSelected + 1;
				switch(curSave)
				{
					case 1: DeltaSaveControl.curSave = FlxG.save.data.save1;
					case 2: DeltaSaveControl.curSave = FlxG.save.data.save2;
					case 3: DeltaSaveControl.curSave = FlxG.save.data.save3;
				}
				if(DeltaSaveControl.curSave.savePoint == 0 && !isCutscene){
					isCutscene = true;
					FlxG.sound.music.stop();
					startVideo('cut_1', function(){
						MusicBeatState.switchState(new CharSelectState());
					});
				}
				else{
					MusicBeatState.switchState(new DeltaPlayState(DeltaSaveControl.saveReturn[DeltaSaveControl.curSave.savePoint]));
				}
			}
		if(FlxG.keys.justPressed.ESCAPE && startSel && !isCutscene){
				FlxG.sound.play(Paths.sound('delta/menumove', 'shared'));
				canControl = true;
				startSel = false;
				remove(start);
				switch(curSelected)
				{
					case 0: s1TxtG.add(s1Point);
					case 1: s2TxtG.add(s2Point);
					case 2: s3TxtG.add(s3Point);
				}
			}
	}

	function changeSel(change:Int = 0, ?min:Int = 0, ?max:Int = 4)
		{
			FlxG.sound.play(Paths.sound('delta/menumove', 'shared'));
			var lastSelected = curSelected;
			curSelected += change;
			if (curSelected < min)
				curSelected = min;
			if (curSelected > max)
				curSelected = max;

			selArr[lastSelected].loadGraphic(Paths.image('delta/save/${nameArr[lastSelected]}'));
			selArr[curSelected].loadGraphic(Paths.image('delta/save/${nameArr[curSelected]}s'));

			switch(curSelected)
				{
					case 0:
						s1TxtG.alpha = 1;
						s2TxtG.alpha = .45;
						s3TxtG.alpha = .45;
					case 1:
						s1TxtG.alpha = .45;
						s2TxtG.alpha = 1;
						s3TxtG.alpha = .45;
					case 2:
						s1TxtG.alpha = .45;
						s2TxtG.alpha = .45;
						s3TxtG.alpha = 1;
					default:
						s1TxtG.alpha = .45;
						s2TxtG.alpha = .45;
						s3TxtG.alpha = .45;
				}
		}

	function enterSave()
		{
			switch(curSelected)
			{
				case 0:
					if(FlxG.save.data.save1.saveName == '[EMPTY]')
						{
							canControl = false;
							s1TxtG.remove(s1Name);
							name.setPosition(s1Name.x, s1Name.y);
							name.hasFocus = true;
							add(name);
						}
					else
						{
							canControl = false;
							new FlxTimer().start(.1, tmr -> {
								startSel = true;
							});
							s1TxtG.remove(s1Point);
							start.setPosition(585, 220);
							add(start);
						}
				case 1:
					if(FlxG.save.data.save2.saveName == '[EMPTY]')
						{
							canControl = false;
							s2TxtG.remove(s2Name);
							name.setPosition(s2Name.x, s2Name.y);
							name.hasFocus = true;
							add(name);
						}
					else
						{
							canControl = false;
							new FlxTimer().start(.1, tmr -> {
								startSel = true;
							});
							s2TxtG.remove(s2Point);
							start.setPosition(585, 400);
							add(start);
						}
				case 2:
					if(FlxG.save.data.save3.saveName == '[EMPTY]')
						{
							canControl = false;
							s3TxtG.remove(s3Name);
							name.setPosition(s3Name.x, s3Name.y);
							name.hasFocus = true;
							add(name);
						}
					else
						{
							canControl = false;
							new FlxTimer().start(.1, tmr -> {
								startSel = true;
							});
							s3TxtG.remove(s3Point);
							start.setPosition(585, 575);
							add(start);
						}
			}
		}

	//im gonna throw up
	function checkControl() {
		if(theMode == 'def'){
			if(FlxG.keys.justPressed.DOWN && curSelected != 3 && curSelected != 4)
				{
					changeSel(1);
				}
			if(FlxG.keys.justPressed.UP)
				{
					if(curSelected == 4) changeSel(-2);
					else changeSel(-1);
				}
			if(FlxG.keys.justPressed.RIGHT && curSelected == 3)
				{
					changeSel(1);
				}
			if(FlxG.keys.justPressed.LEFT && curSelected == 4)
				{
					changeSel(-1);
				}
			if(FlxG.keys.justPressed.ENTER)
				{
					if(curSelected < 3){
						enterSave();
						FlxG.sound.play(Paths.sound('delta/select', 'shared'));
					}
					else if(curSelected == 3)
						{
							curSelected = 0;
							changeSel();
							copy.loadGraphic(Paths.image('delta/save/c'));
							theMode = 'copy';
							modeTxt.visible = true;
							modeTxt.text = 'Choose a file to copy.';
							copy.visible = erase.visible = false;
						}
					else{
						curSelected = 0;
						changeSel();
						erase.loadGraphic(Paths.image('delta/save/e'));
						theMode = 'erase';
						modeTxt.visible = true;
						modeTxt.text = 'Choose a file to erase.';
						copy.visible = erase.visible = false;
					}
				}
			if(FlxG.keys.justPressed.ESCAPE)
				{
					MusicBeatState.switchState(new ChapterMenu());
				}
		}
		else if(theMode == 'copy')
			{
				if(FlxG.keys.justPressed.DOWN)
					{
						changeSel(1, 0, 2);
					}
				if(FlxG.keys.justPressed.UP)
					{
						changeSel(-1, 0, 2);
					}
				if(FlxG.keys.justPressed.ENTER)
					{
						var curSave = curSelected + 1;
						if(step == 0){
							switch(curSave)
							{
								case 1: copied = FlxG.save.data.save1;		
								case 2: copied = FlxG.save.data.save2;
								case 3: copied = FlxG.save.data.save3;
							}
							modeTxt.text = 'Choose a file to paste onto.';
							step = 1;
						}
						else {
							switch(curSave)
							{
								case 1: FlxG.save.data.save1 = copied;		
								case 2: FlxG.save.data.save2 = copied;
								case 3: FlxG.save.data.save3 = copied;
							}
							FlxG.save.flush();
							updateTxt();
							changeSel();
							step = 0;
							theMode = 'def';
							modeTxt.visible = false;
							copy.visible = erase.visible = true;
						}
					}
				if(FlxG.keys.justPressed.ESCAPE){
					changeSel();
					step = 0;
					theMode = 'def';
					modeTxt.visible = false;
					copy.visible = erase.visible = true;
				}
			}
		else{
			if(FlxG.keys.justPressed.DOWN)
				{
					changeSel(1, 0, 2);
				}
			if(FlxG.keys.justPressed.UP)
				{
					changeSel(-1, 0, 2);
				}
			if(FlxG.keys.justPressed.ENTER)
				{
					var curSave = curSelected + 1;
					switch(curSave)
						{
							case 1: FlxG.save.data.save1 = {savePoint: 0, timePlayed: 0, saveName: "[EMPTY]", seen: new Map<String, Bool>()};	
							case 2: FlxG.save.data.save2 = {savePoint: 0, timePlayed: 0, saveName: "[EMPTY]", seen: new Map<String, Bool>()};
							case 3: FlxG.save.data.save3 = {savePoint: 0, timePlayed: 0, saveName: "[EMPTY]", seen: new Map<String, Bool>()};
						}
					FlxG.save.flush();
					updateTxt();
					changeSel();
					theMode = 'def';
					modeTxt.visible = false;
					copy.visible = erase.visible = true;
					}
				}
			if(FlxG.keys.justPressed.ESCAPE){
				changeSel();
				theMode = 'def';
				modeTxt.visible = false;
				copy.visible = erase.visible = true;
			}
		}

	function confirmName(txt:String, action:String)
		{
			if(action == "enter" && !canControl && name.text != '')
				{
					remove(name);
					name.hasFocus = false;
					switch(curSelected){
						case 0:
							FlxG.save.data.save1.saveName = name.text;
							s1Name.text = FlxG.save.data.save1.saveName;
							s1TxtG.add(s1Name);
						case 1:
							FlxG.save.data.save2.saveName = name.text;
							s2Name.text = FlxG.save.data.save2.saveName;
							s2TxtG.add(s2Name);
						case 2:
							FlxG.save.data.save3.saveName = name.text;
							s3Name.text = FlxG.save.data.save3.saveName;
							s3TxtG.add(s3Name);
					}
					name.text = '';
					FlxG.save.flush();
					enterSave();
				}
			else if(action == "enter" && name.text == '' && !canControl)
				{
					var noName = new FlxText(name.x, name.y - 20, 0, "Your name must not be blank.", 18);
					noName.font = Paths.font('fixedsys.ttf');
					noName.color = 0x8991ab;
					noName.setBorderStyle(SHADOW, 0x80000000, 1);
					add(noName);
					var toY = name.y - 45;
					FlxTween.tween(noName, {alpha: 0, y: toY}, 1.35, {ease: FlxEase.quadOut});
				}
			else if(action == "escape" && !canControl)
				{
					remove(name);
					name.text = '';
					name.hasFocus = false;
					switch(curSelected){
						case 0: s1TxtG.add(s1Name);
						case 1: s2TxtG.add(s2Name);
						case 2: s3TxtG.add(s3Name);
					}
					new FlxTimer().start(.15, tmr -> {
						canControl = true;
					});
				}
		}

	public function updateTxt(){
		s1Name.text = FlxG.save.data.save1.saveName;
		s1Time.text = FlxG.save.data.save1.timePlayed == 0 ? '- - : - -' : FlxStringUtil.formatTime(FlxG.save.data.save1.timePlayed);
		s1Point.text = DeltaSaveControl.savePlaces[FlxG.save.data.save1.savePoint];

		s2Name.text = FlxG.save.data.save2.saveName;
		s2Time.text = FlxG.save.data.save2.timePlayed == 0 ? '- - : - -' : FlxStringUtil.formatTime(FlxG.save.data.save2.timePlayed);
		s2Point.text = DeltaSaveControl.savePlaces[FlxG.save.data.save2.savePoint];

		s3Name.text = FlxG.save.data.save3.saveName;
		s3Time.text = FlxG.save.data.save3.timePlayed == 0 ? '- - : - -' : FlxStringUtil.formatTime(FlxG.save.data.save3.timePlayed);
		s3Point.text = DeltaSaveControl.savePlaces[FlxG.save.data.save3.savePoint];
	}

	function startVideo(name:String, finishCallback:Void->Void):Void {
		var fileName = Paths.video(name);

		var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		add(bg);

		(new FlxVideo(fileName)).finishCallback = finishCallback;
	}
}