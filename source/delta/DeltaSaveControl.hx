package delta;

import flixel.FlxG;

class DeltaSaveControl
{
    public static var curSave:Dynamic;
    public static var gameTime:Int = 0;
    public static var savePlaces:Array<String> = CoolUtil.coolTextFile(Paths.txt('delta/rpgPlaces'));
    public static var saveReturn:Array<String> = CoolUtil.coolTextFile(Paths.txt('delta/rpgReturn'));
    public static function setSaves()
        {
            FlxG.save.data.save1 = {savePoint: 0, timePlayed: 0, saveName: "[EMPTY]", seen: new Map<String, Bool>()};
			FlxG.save.data.save2 = {savePoint: 0, timePlayed: 0, saveName: "[EMPTY]", seen: new Map<String, Bool>()};
			FlxG.save.data.save3 = {savePoint: 0, timePlayed: 0, saveName: "[EMPTY]", seen: new Map<String, Bool>()};
			FlxG.save.flush();
        }
    public static function updateSave(savePoint:Int)
        {
            curSave.savePoint = savePoint;
            curSave.timePlayed += gameTime;
            gameTime = 0;
            FlxG.save.flush();
        }
}