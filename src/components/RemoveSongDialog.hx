package components;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.components.CheckBox;

@:build(haxe.ui.ComponentBuilder.build("assets/removeSong.xml"))
class RemoveSongDialog extends Dialog{
    public var songsToRemove:Array<String> = [];
    public function new(){
        super();

		for (i => song in LibraryFile.library.song_library) {
            if (!FileSystem.exists('${LibraryFile.songDir}/${song.name}.ogg')) continue;

            var songCheck = new CheckBox();
            songCheck.text = song.name;

            songCheck.onChange = function(event) {
                if (event.value)
                    songsToRemove.push(songCheck.text)
                else
                    songsToRemove.remove(songCheck.text);

                trace(songsToRemove);
            }

            songList.addComponent(songCheck);
        }

        buttons = DialogButton.APPLY | DialogButton.CANCEL;
    }
}