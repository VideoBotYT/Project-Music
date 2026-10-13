package components;

import haxe.ui.containers.VBox;
import haxe.ui.components.Button;

@:xml('
<vbox width="100" height="100" horizontalAlign="center" verticalAlign="center">
<button id="songBtn" width="100%" height="100%"/>
</vbox>
')
class SongItem extends VBox{
    public var song(default, set):Null<String>;

    function set_song(value:String):String{
        songBtn.text = value;
        return song = value;
    }

    public function new(song:String){
        super();

        this.song = song;
		songBtn.onClick = function(event) {
			trace(song);
		}
    }
}