package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		["Deltarune Funkin' Socials"],
		['Deltarune Funkin Twitter',			'drftwitter',		"Deltarune Funkin's Official Twitter",				'https://mobile.twitter.com/deltarunefunkin',	0xFF7289da],
		['Deltarune Funkin Discord',			'drfdiscord',		"Deltarue Funkin's Official Discord",				'https://discord.com/invite/deltarunefunkin',	0xFF00acee],
		[''],
		["The Deltateam"],
		[''],
		['The Creators'],
		['Akirawav3',			'akirawave',		"Creator and Director of DRF\nthey thought i was gei",						'https://akirawave.carrd.co/',				0xFFEF3B70],
		['Ironik0422',			'ironik',			"Co-Creator and Head-Musician\ncool",				'https://twitter.com/Ironik0422',				0xFFf21818],
		['EpicGamer',			'epicgamer',		"Head-Programmer, Carried the mod",					'https://twitter.com/Epic2469',					0xFF0de6fe],
		[''],
		["The Musicians"],
		['Ironik0422',			'ironik',			"Head-Musician\ncool",									'https://twitter.com/Ironik0422',				0xFFf21818],
		['Stargazer008',		'stargazer',		"Musician",											'https://twitter.com/Stargazer_008',			0xFFFF9300],
		['FlameAgain',			'flame',			"Musician",											'https://twitter.com/BlameItOnTheFl2',			0xFFFFFFFF],
		['Luca',				'luca',				"Musician\nwho even reads these?",											'https://gamebanana.com/members/1994032',		0xFFD10616],
		['Amelia',				'amelia',			"Musician",											'https://twitter.com/Chocolatta621',			0xFF61536A],
		[''],
		["The Charters"],
		['chxrlix',				'charlie',			"Head-Charter\nfemale",								'https://twitter.com/chxrlixwastaken',			0xFF9c2bf9],
		['Billy8475',	 		'billy',			"Charter",											'https://twitter.com/Billy86794337',			0xFFFFBB1B],
		['Luckyy',				'lucky',			"Charter\nJoJo poses menacingly",					'https://twitter.com/LuckyyStars_',				0xFF69C2FA],
		['NickD',				'nick',				"Charter\npog",										'https://www.youtube.com/channel/UCJNJXzOUt2vF6xByhph_2og',				0xFF005EFF],
		['CeoOfBruh',			'ceo',				"Charter",											'https://twitter.com/CEOOf_Bruh',				0xFF53E52C],
		['SpaceCakes',			'space',			"Charter",											'https://www.youtube.com/channel/UCyGAAGFJtyJygUNeuX5HTdw',				0xFF53E52C],
		['Hacky',				'hacky',			"Charter\nI did something for once",				'https://twitch.tv/hackynatur',				0xFF6475F3],
		[''],
		["The Programmers"],
		['EpicGamer',	 		'epicgamer',		"Head-Programmer, goated asf",						'https://twitter.com/Epic2469',					0xFF0de6fe],
		['chxrlix',				'charlie',			"Programmer\nfemale",								'https://twitter.com/chxrlixwastaken',			0xFF9c2bf9],
		['Aikoyori',			'aiko',				"Programmer",										'https://twitter.com/AikoyoriPlus',				0xFF53E52C],
		['Stargazer008',		'stargazer',		"Programmer",										'https://twitter.com/Stargazer_008',			0xFFFF9300],
		['Person.Exe',			'person',			"Programmer",										'https://www.youtube.com/channel/UCmAI7f48iRxkG2RuFRwL9TQ',			0xFF53E52C],
		['Akirawav3',			'akirawave',		"Programmer",										'https://akirawave.carrd.co/',				0xFFEF3B70],
		[''],
		["The Animators"],
		['Giggie Draws',	 	'depo',				"Head-Animator, swag and poggers",					'https://twitter.com/Dep0_Rep0',				0xFFC67EF8],
		['Stargazer008',		'stargazer',		"Animator",											'https://twitter.com/Stargazer_008',			0xFFF73838],
		['Akirawav3',			'akirawave',		"Animator\nthey thought i was gei",					'https://akirawave.carrd.co/',				0xFFEF3B70],
		[''],
		["The Artists"],
		['Akirawav3',			'akirawave',		"Head-Artist\nthey thought i was gei",				'https://akirawave.carrd.co/',				0xFFEF3B70],
		['Giggie Draws',	 	'depo',				"Artist, swag and poggers",							'https://twitter.com/Dep0_Rep0',				0xFFC67EF8],
		['Shammah',	 			'shammah',			"Artist\n19.234.12.198",							'https://twitter.com/The_Shammah',				0xFF0B0B45],
		['chxrlix',				'charlie',			"Artist\nfemale",									'https://twitter.com/chxrlixwastaken',			0xFF9c2bf9],
		['Rem',					'rem',				"Artist",											'https://twitter.com/LuckyyStars_',				0xFF53E52C],
		['Rakko',				'rakko',			"Artist",											'https://twitter.com/R4KK0_',					0xFF53E52C],
		['CeoOfBruh',			'ceo',				"Artist",											'https://twitter.com/CEOOf_Bruh',				0xFF53E52C],
		['Amelia',				'amelia',			"Artist",											'https://twitter.com/Chocolatta621',			0xFF61536A],
		['Cosmo',				'cosmo',			"Artist\nvery cool artist",							'https://twitter.com/cosmo00003',				0xFF61536A],
		[''],
		["The Background Artists"],
		['Giggie Draws',	 	'depo',				"Head-BG Artist, swag and poggers",					'https://twitter.com/Dep0_Rep0',				0xFFC67EF8],
		['Amelia',				'amelia',			"BG Artist",										'https://twitter.com/Chocolatta621',			0xFF61536A],
		['Shammah',	 			'shammah',			"BG Artist\n19.234.12.198",							'https://twitter.com/The_Shammah',				0xFF0B0B45],
		['Wrcts',	 			'wrcts',			"BG Artist\new furry",								'https://www.youtube.com/channel/UCCt-Ic54ogSEAUOdxTpf_eQ',				0xFFFF0367],
		['Kip',	 				'kip',				"BG Artist",										'https://twitter.com/The_Shammah',				0xFFFFBB1B],
		['Rakko',				'rakko',			"BG Artist",										'https://twitter.com/R4KK0_',					0xFF53E52C],
		[''],
		["The Pose Artists"],
		['Amelia',				'amelia',			"Pose Artist",										'https://twitter.com/Chocolatta621',			0xFF61536A],
		['Giggie Draws',	 	'depo',				"Pose Artist, swag and poggers",					'https://twitter.com/Dep0_Rep0',				0xFFC67EF8],
		['Cosmo',				'cosmo',			"Pose Artist\nvery cool artist",					'https://twitter.com/cosmo00003',				0xFF61536A],
		['Rakko',				'rakko',			"Pose Artist",										'https://twitter.com/R4KK0_',					0xFF53E52C],
		[''],
		["Special Thanks"],
		['Banbuds',				'banbuds',			"Chaos King VA",									'https://twitter.com/Banbuds',					0xFF53E52C],
		['shadowAOD',			'aod',				"Custom RPG Sprites",								'https://twitter.com/shadowAOD',				0xFF53E52C],
		['Adam',				'adam',				"Akiras gay wife",									'https://www.twitch.tv/rerumu',					0xFF53E52C],
		['Rem',					'rem',				"Dev Emotional Therapy",							'https://twitter.com/LuckyyStars_',				0xFF53E52C],
		[''],
		["Deltarune Creators"],
		['Deltarune Website',	'deltarune',		'Deltarune Offical Website',						'https://deltarune.com/',						0xFFFFDD33],
		['Tobyfox',				'tobyfox',			'Creator and Composer of Deltarune',				'https://twitter.com/tobyfox',					0xFFFFDD33],
		['Temmie Chang',		'temmie',			'Deltarune Artist',									'https://twitter.com/tuyoki',					0xFFFFDD33],
		[''],
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',					'https://twitter.com/Shadow_Mario_',			0xFFFFDD33],
		['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/river_oaken',				0xFFC30085],
		[''],
		['Engine Contributors'],
		['shubs',				'shubs',			'New Input System Programmer',						'https://twitter.com/yoshubs',					0xFF4494E6],
		['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',						'https://twitter.com/polybiusproxy',			0xFFE01F32],
		['gedehari',			'gedehari',			'Chart Editor\'s Sound Waveform base',				'https://twitter.com/gedehari',					0xFFFF9300],
		['Keoiki',				'keoiki',			'Note Splash Animations',							'https://twitter.com/Keoiki_',					0xFFFFFFFF],
		['SandPlanet',			'sandplanet',		'Psych Engine Preacher\nAlso cool guy lol',			'https://twitter.com/SandPlanetNG',				0xFFD10616],
		['bubba',				'bubba',			'Guest Composer for "Hot Dilf"',					'https://www.youtube.com/channel/UCxQTnLmv0OAS63yzk9pVfaw',			0xFF61536A],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',			0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',			0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',					0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',				0xFF6475F3]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var scrollTmr:Float = 0;

	override function create()
	{
		FlxG.mouse.visible = true;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

        var banner:FlxSprite = new FlxSprite().loadGraphic(Paths.image('banner'));
        add(banner);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		FlxG.watch.add(FlxG.mouse, 'wheel');
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if(scrollTmr > 0) scrollTmr -= .25;

		if(FlxG.mouse.wheel == 1 && scrollTmr == 0){
			changeSelection(-1);
			scrollTmr = .75;
		}
		if(FlxG.mouse.wheel == -1  && scrollTmr == 0){
			changeSelection(1);
			scrollTmr = .75;
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
