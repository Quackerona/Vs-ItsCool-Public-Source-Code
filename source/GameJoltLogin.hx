package;

import openfl.system.System;
import flixel.util.FlxSave;
import flixel.addons.api.FlxGameJolt;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;

class GameJoltLogin extends MusicBeatState //spent 4 hours on this lmao
//i really need to learn haxe more dont i
//-quackerona/virginpenguinlol
{
    var username:FlxInputText;
    var token:FlxInputText;
    var texttut:FlxText;
    var gamejoltdata:FlxSave;
    override function create() 
    {
        //UI
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
        bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
        texttut = new FlxText(0, 0, 0, "click here if you don't know how to get game tokens", 10);
        add(texttut);
        var text = new FlxText(0, 50, 0, "GAMEJOLT INTEGRATION", 30);
        text.screenCenter(X);
        add(text);
        //
        //Real deal
        gamejoltdata = new FlxSave();
        gamejoltdata.bind("GameJoltData");
        username = new FlxInputText(0, 100, 300, "Enter Username Here", 20);
        username.screenCenter(X);
        add(username);
        token = new FlxInputText(0, 200, 300, "Enter Token Here", 20);
        token.screenCenter(X);
        add(token);
        var itscoolspinning = new FlxSprite(0, 400).loadGraphic(Paths.image('titlelogo'));
        itscoolspinning.scale.set(0.7, 0.7);
        itscoolspinning.updateHitbox();
        itscoolspinning.screenCenter(X);
        add(itscoolspinning);
        FlxTween.angle(itscoolspinning, 0, 360, 4, {type: LOOPING});
        var login = new FlxButton(0, 330, "LOGIN", login);
        login.scale.set(2, 2);
        login.updateHitbox();
        login.screenCenter(X);
		add(login);
        var clear = new FlxButton(1200, 670, "CLEAR LOGIN DATA (will close the game)", erasedata);
		add(clear);
        var text = new FlxText(0, 50, 0, "i know it looks fucked but im too lazy to make a sprite sooo ->", 10);
        text.x = login.x - 400;
        text.y = login.y + 10;
        add(text);
        //
        super.create();
    }

    function login() {
        if (!FlxGameJolt.initialized)
            FlxGameJolt.authUser(username.text, token.text);
        gamejoltdata.data.gamejoltuser = username.text;
        gamejoltdata.data.gamejolttoken = token.text;
        gamejoltdata.flush();
        MusicBeatState.switchState(new MainMenuState());
    }

    function erasedata(){
        gamejoltdata.erase();
        MainMenuState.autoauth.erase();
        System.exit(1);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.overlaps(texttut)) //hi brightfyre
        {
            if (FlxG.mouse.justPressed)
                FlxG.openURL("https://www.youtube.com/watch?v=T5-x7kAGGnE&ab_channel=BrightFyre");
        }
        if (FlxG.mouse.overlaps(username) || FlxG.mouse.overlaps(token))
        {
            if (FlxG.mouse.justPressed && (username.text == "Enter Username Here" || token.text == "Enter Token Here"))
            {
                username.text = "";
                token.text = "";
            }
        }
        if (FlxG.keys.justPressed.ESCAPE) //if you dont want to integrate just press esc lmao
            MusicBeatState.switchState(new MainMenuState());
        super.update(elapsed);
    }    
}