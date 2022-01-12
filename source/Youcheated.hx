package;

import flixel.util.FlxColor;
import flixel.FlxG;
import sys.FileSystem;
import flixel.FlxSprite;

class Youcheated extends MusicBeatState {
    override function create() {
        startVideo("haha");
        super.create();
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
    }
    public function startVideo(name:String):Void { //copied from playstate lmaooooooo
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [FlxG.camera];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
                MusicBeatState.switchState(new MainMenuState());
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
	}
}