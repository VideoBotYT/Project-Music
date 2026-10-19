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
                        name: dialog.songName.text,
                        files: dialog.files
                    };
                    
					LibraryFile.addToLibrary(song);

					libraryGrid.removeAllComponents();
					setupSongs();
                }
                if (e.button == DialogButton.CANCEL){
                    var path = '${LibraryFile.songDir}/${dialog.songName.text}';
					for (i => file in FileSystem.readDirectory(path))
						FileSystem.deleteFile('$path/$file');

					FileSystem.deleteDirectory(path);
                }
            }
        }

        removeSong.onClick = function(event){
            var dialog = new RemoveSongDialog();
            dialog.showDialog();
            dialog.onDialogClosed = function(e){
                if (e.button == DialogButton.APPLY){
					for (i => songName in dialog.songsToRemove){
                        var path = '${LibraryFile.songDir}/${songName}';

						if (!FileSystem.exists(path))
							continue;

						for (i => file in FileSystem.readDirectory(path))
                            FileSystem.deleteFile('$path/$file');

						FileSystem.deleteDirectory(path);

						LibraryFile.removeSongByName(songName);
						LibraryFile.saveLibraryFile();
                    }
					libraryGrid.removeAllComponents();
                    setupSongs();
                }
            }
        }

        /* editSong.onClick = function(event){
            var dialog = new EditSongDialog();
            dialog.showDialog();
            dialog.onDialogClosed = function(e){
				dialog.sidebar.hide();
            }
        } */

		setupSongs();
    }

    function setupSongs(){
        for (i => song in LibraryFile.library.song_library){
            var songItem = new SongItem(song.name);
            songItem.id = song.name;
			libraryGrid.addComponent(songItem);
        }
    }
}