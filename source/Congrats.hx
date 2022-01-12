package;

import Discord.DiscordClient;
import flixel.addons.api.FlxGameJolt;
import Achievements.AchievementObject;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

class Congrats extends MusicBeatState // it took me a while to realize not everything is an FlxState -quackerona/virginpenguinlol
{
    var eggbody:FlxSprite;
    var egghead:FlxSprite;
    var rick:FlxSprite;
    var egcrak:FlxSound;
    var youdeserveit:FlxText;
    var clickbool:Bool = true;
    override function create() {
        DiscordClient.changePresence("saying goodbye to their loved ones", null);
        egcrak = new FlxSound();
        egcrak.loadEmbedded(Paths.sound("eggcrack", "shared"));
        FlxG.sound.music.pause();
        FlxG.mouse.visible = true;
        eggbody = new FlxSprite();
        eggbody.loadGraphic(Paths.image("secretsshit/lmao", 'shared'));
        eggbody.screenCenter();
        add(eggbody);
        egghead = new FlxSprite(534, 190);
        egghead.loadGraphic(Paths.image("secretsshit/lmao2", 'shared'));
        add(egghead);
        rick = new FlxSprite(534, 190);
        rick.loadGraphic(Paths.image("secretsshit/perish", 'shared'));
        rick.screenCenter();
        add(rick);
        rick.visible = false;
        youdeserveit = new FlxText(0, 550, 0, "Open It, You Deserve It", 20);
        youdeserveit.screenCenter(X);
        add(youdeserveit);
        super.create();
    }   
    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(eggbody) ||FlxG.mouse.overlaps(egghead))
        {
            if (FlxG.mouse.justPressed && clickbool)
            {
                egcrak.time += 1000;
                egcrak.play();
                clickbool = false;
                new FlxTimer().start(1, function(timerlol:FlxTimer)
                    {    
                        FlxTween.tween(egghead, {y: -190}, 5,{onComplete: function(lol:FlxTween) {
                            rick.visible = true;
                            FlxG.sound.play(Paths.music("perish", "shared"));
                            remove(youdeserveit);
                            if (FlxGameJolt.initialized)
                                FlxGameJolt.addTrophy(154345);
                            new FlxTimer().start(2, function(timerlol:FlxTimer)
                            {    
                                var achieve:String = checkForAchievement(['secret']);
                                if (achieve != null) {
                                    startAchievement(achieve);
                                }
                                new FlxTimer().start(3, function(timerlol:FlxTimer)
                                    {    
                                        MusicBeatState.switchState(new MainMenuState());
                                    });
                            });
                        }}); 
                    });
            }   
        } 
        super.update(elapsed);
    }
    #if ACHIEVEMENTS_ALLOWED //LMAO LEGIT JUST COPIED THIS FROM PLAYSTATE
    //IM A FUCKING GENIUS
    //-quackerona/virginpenguinlol
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, FlxG.camera);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
	}
    private function checkForAchievement(achievesToCheck:Array<String>):String {
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName)) {
				Achievements.unlockAchievement(achievementName);
					return achievementName;
			}
		}
		return null;
	}
	#end
}