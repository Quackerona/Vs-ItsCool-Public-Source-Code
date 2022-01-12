package categoryfreeplay;

import Discord.DiscordClient;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;

class CategoryChooser extends MusicBeatState //freeplay is messy without a category
//your wish has been granted,bubu
{
	private static var vocals:FlxSound = null;
	var portrait:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	static var portraitvalue:Int = 0;
	var camtween:FlxTween;	
	var accepted:Bool = false;
	//unlocking the bonus songs lmao
	var unlocksave:FlxSave;
	override function create() 
	{
		DiscordClient.changePresence("Choosing A Freeplay Category", null);
		FlxG.mouse.visible = false;

		unlocksave = new FlxSave();
		unlocksave.bind("BONUS");
		unlocksave.data.isunlocked = FlxG.save.data.freeplay;
		unlocksave.flush();

		camtween = FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
		
		var bg = new FlxSprite();
		bg.loadGraphic(Paths.image("freeplay/menuFreeplayBG"));
		bg.screenCenter();
		add(bg);

		switchportrait(0);
		
		leftArrow = new FlxSprite(portrait.getMidpoint().x - 500, portrait.getMidpoint().y);
		leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(portrait.getMidpoint().x + 500, portrait.getMidpoint().y);
		rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		add(rightArrow);
		super.create();
	}	
	override function update(elapsed:Float) 
	{
		if (controls.UI_RIGHT && !accepted)
			rightArrow.animation.play('press')
		else
			rightArrow.animation.play('idle');

		if (controls.UI_LEFT && !accepted)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');
		if (controls.UI_LEFT_P && !accepted)
		{	
			switchportrait(-1);
			if (!ClientPrefs.flashing)
				camtween.start();
			leftArrow.animation.play("press", true);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_RIGHT_P && !accepted)
		{	
			switchportrait(1);
			if (!ClientPrefs.flashing)
				camtween.start();
			rightArrow.animation.play("press", true);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.BACK && !accepted)
			MusicBeatState.switchState(new MainMenuState());
		if (controls.ACCEPT && !accepted)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			if (portraitvalue == 1 || portraitvalue == 2)
				{
					if (!unlocksave.data.isunlocked)	
						FlxG.camera.shake();
					else 
					{
						if (!ClientPrefs.flashing)
						{
							FlxFlicker.flicker(portrait, 1, 0.04, true, true, function(haha:FlxFlicker)
								{	
									FreeplayState.category = portraitvalue;
									MusicBeatState.switchState(new FreeplayState());
								});
						}	
						else
						{	
							new FlxTimer().start(1, function(lol:FlxTimer) 
							{
								FreeplayState.category = portraitvalue;
								MusicBeatState.switchState(new FreeplayState());
							});
						}
						accepted = true;	
					}
				}
			else	
			{
				if (!ClientPrefs.flashing)
					{
						FlxFlicker.flicker(portrait, 1, 0.04, true, true, function(haha:FlxFlicker)
							{	
								FreeplayState.category = portraitvalue;
								MusicBeatState.switchState(new FreeplayState());
							});
					}	
				else
						{	
							new FlxTimer().start(1, function(lol:FlxTimer) 
							{
								FreeplayState.category = portraitvalue;
								MusicBeatState.switchState(new FreeplayState());
							});
						}	
				accepted = true;	
			}	
		}	
		super.update(elapsed);
	}
	function switchportrait(value:Int = 0) 
	{
		portraitvalue += value;

		if (portraitvalue > 2)
			portraitvalue = 0;
		if (portraitvalue < 0)
			portraitvalue = 2;

		remove(portrait);
		portrait = new FlxSprite();
		if (portraitvalue == 1 || portraitvalue == 2)
		{
			if (!unlocksave.data.isunlocked)	
				portrait.loadGraphic(Paths.image("freeplay/" + Std.string(portraitvalue) + "-locked"));
			else 
				portrait.loadGraphic(Paths.image("freeplay/" + Std.string(portraitvalue)));
		}
		else 
			portrait.loadGraphic(Paths.image("freeplay/" + Std.string(portraitvalue)));
		portrait.scale.set(0.3, 0.3);
		portrait.screenCenter();
		add(portrait);
	}
	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
}