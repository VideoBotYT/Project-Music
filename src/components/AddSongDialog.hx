package components;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.components.Button;
import haxe.ui.containers.HBox;
import haxe.ui.components.Label;
import flixel.sound.FlxSound;

@:build(haxe.ui.ComponentBuilder.build("assets/addSong.xml"))
class AddSongDialog extends Dialog{
    public var files:Array<String> = [];
    public function new(){
        super();

		var sound = new FlxSound();

        addFile.onClick = function(event){
			Dialogs.openBinaryFile("Load Song", [{label: "Audio File", extension: "ogg"}], function(selectedFile) {
                if (selectedFile != null && selectedFile.bytes != null) {
					trace("Selected Song File: " + selectedFile.name);
					if (!FileSystem.exists('${LibraryFile.songDir}/${songName.text}'))
						FileSystem.createDirectory('${LibraryFile.songDir}/${songName.text}');
					File.saveBytes('${LibraryFile.songDir}/${songName.text}/${selectedFile.name}', selectedFile.bytes);

                    files.push(selectedFile.name);

                    var box:HBox = new HBox();
                    var label:Label = new Label();
                    label.text = selectedFile.name;
					var play:Button = new Button();
					play.text = "Play Sound";
					play.onClick = function(event){
                        sound.loadByteArray(selectedFile.bytes, false, false);
                        sound.play();
                    }

                    var stop:Button = new Button();
                    stop.text = "Stop";
                    stop.onClick = function(event){
                        sound.stop();
                    }

                    box.addComponent(label);
                    box.addComponent(play);
                    box.addComponent(stop);

					fileList.addComponent(box);
				}
			});
        }
        buttons = DialogButton.SAVE | DialogButton.CANCEL;
    }
}