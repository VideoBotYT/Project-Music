package components;

import haxe.ui.containers.dialogs.Dialog;

@:build(haxe.ui.ComponentBuilder.build("assets/addSong.xml"))
class AddSongDialog extends Dialog{
    public function new(){
        super();
        buttons = DialogButton.SAVE | DialogButton.CANCEL;
    }
}