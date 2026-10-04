package backend;

import haxe.Json;

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
    public static var libDir:String = "library";
    public static var libFile:String = "library.json";
    public static var library:Library;

    public static function loadLibrary():Library{
        var rawFile:String = null;

		if (FileSystem.exists('$libDir/$libFile'))
			rawFile = getContent('$libDir/$libFile');
        else
            return null;

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

    public static function addToLibrary(content:Song){
		library?.song_library?.push(content);

		File.saveContent('$libDir/$libFile', Json.stringify(library));
    }

    public static function parseJson(text:String):Dynamic{
        return cast Json.parse(text);
    }

    static function getContent(file:String):String{
        return File.getContent(file);
    }
}