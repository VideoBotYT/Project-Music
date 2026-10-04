package ;

import flixel.FlxG;
import flixel.sound.FlxSound;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.Dialogs.FileDialogTypes;
import haxe.ui.ToolkitAssets;
import components.Waveform;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	var sound:FlxSound;
    public function new() {
        super();

        
    }
}