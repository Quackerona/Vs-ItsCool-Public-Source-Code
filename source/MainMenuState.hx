package;

import flixel.util.FlxTimer;
import categoryfreeplay.CategoryChooser;
import flixel.util.FlxSave;
import flixel.addons.api.FlxGameJolt;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import options.OptionsState;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	//konami code
	var konamiint:Int = 0;
	var upup:Bool = true;
	var downdown:Bool = false;
	var leftleft:Bool = false;
	var rightright:Bool = false;
	var b:Bool = false;
	var a:Bool = false;
	var secretactivated:FlxSound;
	//hard coding is cool innit

	//bubu you fool what have you done
	var c:Bool = true;
	var o:Bool = false;
	var k:Bool = false;
	var freedomint:Int = 0;
	public static var entereddive:Bool = false;
	//

	//this just say if you're logged in or not
	var loggedin:FlxText;
	public static var isauth:Bool = false;
	public static var autoauth:FlxSave; //pretty scuff auto auth function but :shrug:
	var autologin:FlxSave; // fixed the stupid auto auth but now its lookin more scuff lmao
	//

	//itscool camera bump code is glitchy so im fixing it lmao
	var camtween:FlxTween;	
	//

	public static var psychEngineVersion:String = 'PE 0.5.1 + KE 1.5.4)'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

    var menugang:FlxSprite;
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story_mode', 'freeplay', #if ACHIEVEMENTS_ALLOWED 'awards', #end 'credits', #if !switch 'donate', #end 'options'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var blackbar:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if(!FlxG.sound.music.playing) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		
		FlxG.mouse.visible = true;
		FlxG.sound.music.resume();

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.save.data.dive != null)
			entereddive = FlxG.save.data.dive;
		autoauth = new FlxSave();
		autoauth.bind("AutoAuth");
		autologin = new FlxSave();
		autologin.bind("GameJoltData");
		//trace(autologin.data.gamejoltuser);
		//trace(autologin.data.gamejolttoken);
		persistentUpdate = persistentDraw = true;

		camtween = FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
		secretactivated = new FlxSound();
		secretactivated.loadEmbedded(Paths.sound("secretactivation"), false, true);
		isauth = autoauth.data.auto;
		if (!FlxGameJolt.initialized)
			{	
				if (isauth)
					FlxGameJolt.authUser(autologin.data.gamejoltuser, autologin.data.gamejolttoken);
			}

		loggedin = new FlxText(1190, 700, 0, "m", 10);
		loggedin.scrollFactor.set(0, 0);
		blackbar = new FlxSprite(-700);
		blackbar.loadGraphic(Paths.image('menustuff/menu_side'));
		blackbar.scrollFactor.set(0, 0);
		blackbar.screenCenter(Y);
		FlxTween.tween(blackbar, {x: blackbar.x + 500}, 0.75, {ease: FlxEase.backInOut});
		menugang = new FlxSprite();
		menugang.frames = Paths.getSparrowAtlas('menupeople/Menu_Gang');
		menugang.animation.addByPrefix('story mode', 'story mode');
		menugang.animation.addByPrefix('freeplay', 'freeplay');
		menugang.animation.addByPrefix('donate', 'donate');
		menugang.animation.addByPrefix('awards', 'awards');
		menugang.animation.addByPrefix('options', 'options');
		menugang.animation.addByPrefix('credits', 'credits');
		menugang.scrollFactor.set(0, 0);
		FlxTween.tween(menugang, {y: menugang.y + 10}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(menugang, {x: menugang.x + 10}, 2, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay : 0.15});

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(blackbar);
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(50, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scale.set(0.8, 0.8);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "PE-CUSTOM BUILD(" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

        add(menugang);
		var gamejolt = new FlxButton(1200, 670, "GameJolt", function()
		{	
			MusicBeatState.switchState(new GameJoltLogin());
		});
		gamejolt.scrollFactor.set(0, 0);
		add(gamejolt);
		add(loggedin);
		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!FlxGameJolt.initialized)
		{
			loggedin.text = "Not logged in.";		
		}
		else
		{
			isauth = true;
			autoauth.data.auto = isauth;
			autoauth.flush();
			loggedin.text = "Logged in.";
		}	
		//konami shit
		switch (konamiint)
		{
			case 0:
				#if debug
				trace("LET'S MOVE TO UP YEAH?");
				#end
				upup = true;
				downdown = false;
				rightright = false;
				leftleft = false;
				b = false;
				a = false;
			case 2:
				#if debug
				trace("LET'S MOVE TO DOWN YEAH?");
				#end
				upup = false;
				downdown = true;
				rightright = false;
				leftleft = false;
				b = false;
				a = false;
			case 4:
				#if debug
				trace("LET'S MOVE TO LEFT YEAH?");
				#end
				upup = false;
				downdown = false;
				rightright = false;
				leftleft = true;
				b = false;
				a = false;
			case 5:
				#if debug
				trace("LET'S MOVE TO RIGHT YEAH?");
				#end
				upup = false;
				downdown = false;
				rightright = true;
				leftleft = false;
				b = false;
				a = false;
			case 6:
				#if debug
				trace("LET'S MOVE TO LEFT AGAIN YEAH?");
				#end
				upup = false;
				downdown = false;
				rightright = false;
				leftleft = true;
				b = false;
				a = false;
			case 7:
				#if debug
				trace("LET'S MOVE TO RIGHT AGAIN YEAH?");
				#end
				upup = false;
				downdown = false;
				rightright = true;
				leftleft = false;
				b = false;
				a = false;
			case 8:
				#if debug
				trace("LET'S MOVE TO B YEAH?");
				#end
				upup = false;
				downdown = false;
				rightright = false;
				leftleft = false;
				b = true;
				a = false;
			case 9:
				#if debug
				trace("FINAL CODE LETS GO");
				#end
				upup = false;
				downdown = false;
				rightright = false;
				leftleft = false;
				b = false;
				a = true;
			case 10:
				#if debug
				trace("LETS FUCKING GOOOOOOOOOOOOOOOOO");
				#end
				upup = false;
				downdown = false;
				rightright = false;
				leftleft = false;
				b = false;
				a = false;	
				secretactivated.play();
				MusicBeatState.switchState(new Congrats());
		}
			if (upup && !downdown && !rightright && !leftleft && !b && !a)
			{
				if (FlxG.keys.justPressed.UP)
					konamiint += 1;
				else if (FlxG.keys.justPressed.ANY)
					konamiint = 0;
			}
			if (!upup && downdown && !rightright && !leftleft && !b && !a)
			{
				if (FlxG.keys.justPressed.DOWN)
					konamiint += 1;
				else if (FlxG.keys.justPressed.ANY)
					konamiint = 0;
			}
			if (!upup && !downdown && rightright && !leftleft && !b && !a)
			{
				if (FlxG.keys.justPressed.RIGHT)
					konamiint += 1;
				else if (FlxG.keys.justPressed.ANY)
					konamiint = 0;
			}
			if (!upup && !downdown && !rightright && leftleft && !b && !a)
			{
				if (FlxG.keys.justPressed.LEFT)
					konamiint += 1;
				else if (FlxG.keys.justPressed.ANY)
					konamiint = 0;
			}
			if (!upup && !downdown && !rightright && !leftleft && b && !a)
			{
				if (FlxG.keys.justPressed.B)
					konamiint += 1;
				else if (FlxG.keys.justPressed.ANY)
					konamiint = 0;
			}
			if (!upup && !downdown && !rightright && !leftleft && !b && a)
			{
				if (FlxG.keys.justPressed.A)
					konamiint += 1;
				else if (FlxG.keys.justPressed.ANY)
					konamiint = 0;
			}
			//i dont want to talk about this messy pile of code lmao im still a beginner
			//-quackerona/virginpenguinlol

		switch (freedomint)
		{
			case 0:
				c = true;
				o = false;
				k = false;
			case 1:
				c = false;
				o = true;
				k = false;
			case 2:
				c = true;
				o = false;
				k = false;
			case 3:
				c = false;
				o = false;
				k = true;
			case 4:
				entereddive = true;
				FlxG.save.data.dive = entereddive;
				FlxG.save.flush();
				var poop:String = Highscore.formatSong("freedom", 3);
				PlayState.SONG = Song.loadFromJson(poop, "freedom");
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 3;
				PlayState.storyWeek = 1;
				LoadingState.loadAndSwitchState(new PlayState());	
		}
		if (c && !o && !k)	
		{
			if (FlxG.keys.justPressed.C)
				freedomint += 1;
			else if (FlxG.keys.justPressed.ANY)
				freedomint = 0;
		}
		if (!c && o && !k)	
		{
			if (FlxG.keys.justPressed.O)
				freedomint += 1;
			else if (FlxG.keys.justPressed.ANY)
				freedomint = 0;
		}			
		if (!c && !o && k)	
		{
			if (FlxG.keys.justPressed.K)
				freedomint += 1;
			else if (FlxG.keys.justPressed.ANY)
				freedomint = 0;
		}

		switch (curSelected)
		{
			case 0:
				menugang.animation.play('story mode');
			case 1:	
				menugang.animation.play('freeplay');
			case 2:	
				menugang.animation.play('awards');
			case 3:	
				menugang.animation.play('credits');
			case 4:
				menugang.animation.play('donate');
			case 5:
				menugang.animation.play('options');		
		}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://www.youtube.com/channel/UC50YEMdpvvOGsE9aWD_Si3g');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(!ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(blackbar, {x: blackbar.x - 650}, 1.15, {ease: FlxEase.backInOut});
									spr.kill();
								}
							});
						}
						else
						{
							if(!ClientPrefs.flashing) 
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
									{
										var daChoice:String = optionShit[curSelected];
		
										switch (daChoice)
										{
											case 'story_mode':
												MusicBeatState.switchState(new StoryMenuState());
											case 'freeplay':
												MusicBeatState.switchState(new CategoryChooser());
											case 'awards':
												MusicBeatState.switchState(new AchievementsMenuState());
											case 'credits':
												MusicBeatState.switchState(new CreditsState());
											case 'options':
												MusicBeatState.switchState(new OptionsState());
										}
									});
							}
							else
							{
								new FlxTimer().start(1, function(go:FlxTimer) 
								{
									var daChoice:String = optionShit[curSelected];
		
									switch (daChoice)
									{
										case 'story_mode':
											MusicBeatState.switchState(new StoryMenuState());
										case 'freeplay':
											MusicBeatState.switchState(new CategoryChooser());
										case 'awards':
											MusicBeatState.switchState(new AchievementsMenuState());
										case 'credits':
											MusicBeatState.switchState(new CreditsState());
										case 'options':
											MusicBeatState.switchState(new OptionsState());
									}
								});
							}
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				FlxG.camera.zoom = 1;
				if (!ClientPrefs.flashing)
					camtween.start();
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}
