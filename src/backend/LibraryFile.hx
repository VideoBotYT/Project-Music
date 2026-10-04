package backend;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

typedef Library = {
    var song_library:Array<Song>;
}

typedef Song = {
    var name:String;
    @:optional var cover:String;
}

typedef Playlist = {
    var name:String;
    var song_list:Array<Song>;
}

class LibraryFile{
    var libDir:String = "library";

    public static function loadLibrary():Library{
        var rawFile:String = null;

        if (FileSystem.exists('$libDir/library.json'))
            rawFile = getContent('$libDir/library.json');

        return parseJson(rawFile);
    }

    public static function loadPlaylists():Array<Playlist>{
        var rawFile:String = null;
        var playlists:Array<Playlist> = [];
		if (FileSystem.exists('$libDir/playlists')){
            for (file in FileSystem.readDirectory('$libDir/playlists')){
                if (file.endsWith(".json")){
			        rawFile = getContent('$libDir/playlists/$file.json');
                    playlists.push(parseJson(rawFile));
                }
            }
        }

        return playlists;
    }

    public static function parseJson(text:String):Dynamic{
        return cast Json.parse(text);
    }

    static function getContent(file:String):String{
        return File.getContent(file);
    }
}