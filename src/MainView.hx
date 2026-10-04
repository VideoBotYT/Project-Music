package ;

import flixel.FlxG;
import flixel.sound.FlxSound;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.Dialogs.FileDialogTypes;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.ToolkitAssets;
import components.*;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	var sound:FlxSound;
    public function new() {
        super();

        addSong.onClick = function(event){
            var dialog = new AddSongDialog();
            dialog.showDialog();
			dialog.onDialogClosed = function(e) {
                if (e.button == DialogButton.SAVE){
                    var song:Song = {
                        name: dialog.songName.text
                    };
					LibraryFile.addToLibrary(song);
                }
            }
        }
    }
}