package ;

import haxe.ui.HaxeUIApp;
import flixel.FlxG;
import haxe.Json;

@:access(flixel.util.FlxSharedObject)
class Main {
    public static function main() {
        var app = new HaxeUIApp();
        app.ready(function() {
			haxe.ui.Toolkit.theme = 'dark';
			haxe.ui.backend.flixel.CursorHelper.useCustomCursors = false;

            ClientPrefs.savePrefs();
            ClientPrefs.loadPrefs();
            trace(FlxG.save.isBound);
            if (!FileSystem.exists(LibraryFile.libDir))
				FileSystem.createDirectory(LibraryFile.libDir);
			if (!FileSystem.exists('${LibraryFile.libDir}/${LibraryFile.libFile}')){
                File.saveContent('${LibraryFile.libDir}/${LibraryFile.libFile}', 
                    Json.stringify(LibraryFile.library = {
					    song_library: []
                    }
                ));
            }

			LibraryFile.library = LibraryFile.loadLibrary();
            
            app.addComponent(new MainView());

            app.start();
        });
    }
}
