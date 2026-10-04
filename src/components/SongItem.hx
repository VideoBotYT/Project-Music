package components;

class SongItem extends Button{
    public var song(get, set):String;

    function get_song():String{
        return song;
    }

    function set_song(value:String){
        this.text = value;
        return song = value;
    }

    public function new(){
        super();

        onClick = function(event){
            trace(song);
        }
    }
}