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
                    Dialogs.openBinaryFile("Load Song", [{label: "Audio File", extension: "ogg"}], function(selectedFile){
                        if (selectedFile != null && selectedFile.bytes != null){
                            trace("Selected Song File: "+selectedFile.name);
							if (!FileSystem.exists('${LibraryFile.songDir}'))
								FileSystem.createDirectory('${LibraryFile.songDir}');
							File.saveBytes('${LibraryFile.songDir}/${song.name}.ogg', selectedFile.bytes);
                        }
                    });
					LibraryFile.addToLibrary(song);

					libraryGrid.removeAllComponents();
					setupSongs();
                }
            }
        }

        removeSong.onClick = function(event){
            var dialog = new RemoveSongDialog();
            dialog.showDialog();
            dialog.onDialogClosed = function(e){
                if (e.button == DialogButton.APPLY){
					for (i => songName in dialog.songsToRemove){
                        LibraryFile.removeSongByName(songName);
                        LibraryFile.saveLibraryFile();
                        FileSystem.deleteFile('${LibraryFile.songDir}/$songName.ogg');
                    }
					libraryGrid.removeAllComponents();
                    setupSongs();
                }
            }
        }

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