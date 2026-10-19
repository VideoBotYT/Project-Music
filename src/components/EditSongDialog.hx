package components;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.containers.HBox;
import haxe.ui.containers.SideBar;
import haxe.ui.components.Button;
import haxe.ui.components.Label;
import flixel.sound.FlxSound;

import haxe.io.Bytes;

@:build(haxe.ui.ComponentBuilder.build("assets/editSong.xml"))
class EditSongDialog extends Dialog {
	public var sidebar:SongEditor;
    public var tempLib:Library;

	public function new() {
		super();
		destroyOnClose = true;

        tempLib = LibraryFile.library;
		trace(tempLib);
		for (i => song in tempLib.song_library) {
			var box = new HBox();

			var songLabel:Label = new Label();
			songLabel.text = song.name;
			var button:Button = new Button();
			button.text = "Edit";
			button.onClick = function(event) {
				sidebar = new SongEditor(song.name, this);
				sidebar.method = "float";
				sidebar.show();
			}

			box.addComponent(songLabel);
			box.addComponent(button);

			songList.addComponent(box);
		}

		buttons = DialogButton.APPLY | DialogButton.CANCEL;
	}
}

@:build(haxe.ui.ComponentBuilder.build("assets/songEditor.xml"))
class SongEditor extends SideBar {
	var sound:FlxSound;

    var dialogInstance:EditSongDialog;

	var fileBytes:Map<String, Bytes> = [];
	var songPath:String;

	public function new(songName:String, dialog:EditSongDialog) {
		super();

        dialogInstance = dialog;

		sound = new FlxSound();

        var song = LibraryFile.findSongByName(songName, dialogInstance.tempLib);
		songPath = '${LibraryFile.songDir}/$songName';

		addFile.onClick = function(event){

        }

		save.onClick = function(event){
			this.hide();
		}
		generateFiles(song);
	}

    function generateFiles(song:Song){
		for (file in song.files) {
			fileBytes.set(file, File.getBytes('$songPath/$file'));

			var box:HBox = new HBox();
			var label:Label = new Label();
			label.text = file;
			var play:Button = new Button();
			play.text = "Play Sound";
			play.onClick = function(event) {
				if (!FileSystem.exists('$songPath/$file')) {
					Dialogs.messageBox("File does not exist!", "File Not Found", MessageBoxType.TYPE_ERROR);
					return;
				}
				sound.loadByteArray(File.getBytes('$songPath/$file'), false, false);
				sound.play();
			}

			var stop:Button = new Button();
			stop.text = "Stop";
			stop.onClick = function(event) {
				sound.stop();
			}

			var delSound:Button = new Button();
			delSound.text = "Delete Sound File";
			delSound.onClick = function(event) {
				fileList.removeComponent(box);

				song.files.remove(file);
			}

			box.addComponent(label);
			box.addComponent(play);
			box.addComponent(stop);
			box.addComponent(delSound);

			fileList.addComponent(box);
		}
    }
}
