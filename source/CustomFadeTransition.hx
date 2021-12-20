package;

import haxe.xml.Fast;
import flixel.group.FlxSpriteGroup;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBar1:FlxSprite;
	var transBar2:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

		transBar1 = new FlxSprite(-640).makeGraphic(Math.floor(FlxG.width/2), FlxG.height, FlxColor.BLACK);
		transBar1.scrollFactor.set();
		add(transBar1);
		transBar2 = new FlxSprite(1280).makeGraphic(Math.floor(FlxG.width/2), FlxG.height, FlxColor.BLACK);
		transBar2.scrollFactor.set();
		add(transBar2);

		if(isTransIn) {
			transBar1.x = 0;
			transBar2.x = 640;
			FlxTween.tween(transBar1, {x: -640}, .7, {ease: FlxEase.quartIn});
			FlxTween.tween(transBar2, {x: 1280}, .7, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.quartIn});
		}
		else {
			FlxTween.tween(transBar1, {x: 0}, .7, {ease: FlxEase.quartOut});
			FlxTween.tween(transBar2, {x: 640}, .7, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.quartOut});
		}

		if(nextCamera != null) {
			transBar1.cameras = [nextCamera];
			transBar2.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function destroy() {
		if(leTween != null) {
			#if MODS_ALLOWED
			if(isTransIn) {
				Paths.destroyLoadedImages();
			}
			#end
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}