package ;

import haxe.ui.HaxeUIApp;
import flixel.FlxG;

import sys.FileSystem;

@:access(flixel.util.FlxSharedObject)
class Main {
    public static function main() {
        var app = new HaxeUIApp();
        app.ready(function() {
			haxe.ui.Toolkit.theme = 'dark';
			haxe.ui.backend.flixel.CursorHelper.useCustomCursors = false;

            ClientPrefs.loadPrefs();
            if (!FileSystem.exists("library"))
                FileSystem.createDirectory("library");

            app.addComponent(new MainView());

            app.start();
        });
    }
}
