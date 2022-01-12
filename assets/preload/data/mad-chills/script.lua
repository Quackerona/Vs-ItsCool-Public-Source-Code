local defaultNotePos = {};
local spin = true;
local arrowMoveX = 30;
local arrowMoveY = 30;
local anglevar = 1;
local angleshit = 1;
-- stolen from bbpanzu credit to him (this code was from vsaflac so shoutout to him too)!!!
-- angle shit thing i didnt make it, it was from vsaflac.
-- some of the modchart code credit to lunarcleint
local angleshit = 1;
local anglevar = 1;
local turn = 10
local turn2 = 20
local y = 0;
local x = 0;
local canBob = true
local Strums = 'opponentStrums'
function onCreate()
    math.randomseed(os.clock() * 1000);
    
    --doTweenAlpha("gone","camHUD",0,0.01)
end
 
function onSongStart()
    for i = 0,7 do 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x,y})
    end
end
 
function onUpdate(elapsed)
 
    songPos = getPropertyFromClass('Conductor', 'songPosition');
 
    currentBeat = (songPos / 1000) * (bpm / 80)
 
    if spin == true and curBeat >= 304 then
        for i = 0,7 do 
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + arrowMoveX * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + arrowMoveY * math.cos((currentBeat + i*0.25) * math.pi))
        end
    end
function onBeatHit()
    -- triggered 4 times per section
    
    if curBeat >= 304 then
        if curBeat % 2 == 0 then
                angleshit = anglevar;
            else
                angleshit = -anglevar;
            end
            --setProperty('camHUD.angle',angleshit*3)
            --setProperty('camGame.angle',angleshit*3)
            doTweenAngle('turn', 'camHUD', angleshit*-1.5, stepCrochet*0.01, 'quadInOut')
            doTweenX('tuin', 'camHUD', -angleshit*-10, crochet*0.001, 'quadInOut')
            doTweenY('tuin2', 'camHUD', -angleshit*-4, crochet*0.002, 'quadInOut')
            --doTweenAngle('tt', 'camGame', angleshit*2, stepCrochet*0.005, 'quadInOut')
            doTweenX('ttrn', 'camGame', -angleshit*7, crochet*0.001, 'quadInOut')
            doTweenY('ttrn2', 'camGame', -angleshit*4, crochet*0.002, 'quadInOut')
        end
        if curBeat == 320 then
            doTweenAngle('turn2', 'camHUD', 0, stepCrochet*0.03, 'quadOut')
            doTweenX('tuin4', 'camHUD', 0, crochet*0.001, 'quadInOut')
            doTweenY('tuin5', 'camHUD', 0, crochet*0.002, 'quadInOut')
           doTweenX('ttrn4', 'camGame', 0, crochet*0.001, 'quadInOut')
            doTweenY('ttrn5', 'camGame', 0, crochet*0.002, 'quadInOut')
        end
        if curBeat >= 304 then
        cameraShake(game,0.0025,1)
        triggerEvent('Add Camera Zoom', 0.01,0.02)
        allowCountdown = false
        end

    end
end