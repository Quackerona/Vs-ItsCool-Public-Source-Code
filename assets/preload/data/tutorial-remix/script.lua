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
 
    if spin == true and curBeat >= 136 then
        for i = 0,7 do 
            --setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + arrowMoveX * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + arrowMoveY * math.cos((currentBeat + i*0.25) * math.pi))
        end
    end

end