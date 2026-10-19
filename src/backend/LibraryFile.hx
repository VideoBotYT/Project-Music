package backend;

import haxe.Json;

typedef Library = {
    var song_library:Array<Song>;
}

typedef Song = {
    var name:String;
    var files:Array<String>;
}

typedef Playlist = {
    var name:String;
    var song_list:Array<Song>;
}

class LibraryFile{
    public static var libDir:String = "library";
    public static var libFile:String = "library.json";

    public static var songDir:String = '${libDir}/songs';

    public static var library:Library;
    public static var playlists:Array<Playlist> = [];

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
        saveLibraryFile();
    }

    public static function saveLibraryFile(){
		File.saveContent('$libDir/$libFile', Json.stringify(library));
    }

    public static function parseJson(text:String):Dynamic{
        return cast Json.parse(text);
    }

	public static function findSongByName(name:String, ?libraryTemp:Library):Song{
        trace(libraryTemp);
        if (libraryTemp == null) libraryTemp = library;
		for (s in libraryTemp.song_library){
            if (s.name == name)
                return s;
        }
        return null;
    }

    public static function removeSongByName(name:String){
		for (s in library.song_library){
            if (s.name == name){
                library.song_library.remove(s); break;
            }
        }
    }

    static function getContent(file:String):String{
        return File.getContent(file);
    }
}