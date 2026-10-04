package backend;

import flixel.util.FlxSave;
import flixel.FlxG;

class SaveVars {
    public function new(){}
}

class ClientPrefs{
    public static var data:SaveVars = null;
    public static var defaultData:SaveVars = null;

    public static function savePrefs(){
        for (field in Reflect.fields(data)){
            Reflect.setField(FlxG.save.data, field, Reflect.field(data, field));
        }
        FlxG.save.data.volume = FlxG.sound.volume;
        FlxG.save.flush();

        trace("Prefs Saved!");
    }

    public static function loadPrefs(){
        if (data == null) data = new SaveVars();
        if (defaultData == null) defaultData = new SaveVars();

        for (field in Reflect.fields(FlxG.save.data)){
            if (Reflect.hasField(data, field))
                Reflect.setField(data, field, Reflect.field(FlxG.save.data, field));
        }
        FlxG.sound.volume = FlxG.save.data.volume;
    }
}