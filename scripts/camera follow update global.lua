local camMovementType = ''; --("", regular camera movement), ("charSize", moves camera depending by how big the character is.), ("camZoom", moves camera by how much the "defaultCamZoom" is.)
local bfCamIdle = {};
local dadCamIdle = {};

local offsets = 30; --offset is 20 in vsdave
local posBFX = {}
local posBFY = {}

local yoffset = 0;

local curNoteData = 0;
local camMovement = true;

function onCreatePost()
	if string.lower(getDataFromSave("globalOptions", "cameraMovement")) == "true-fpsbased" then offsets = 1800 / framerate; end
end

function onUpdate() --camera now follows characters!!!!
	if string.lower(getDataFromSave("globalOptions", "cameraMovement")) == "false" then return; end
	bfCamIdle[1] = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]')
	bfCamIdle[2] = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
	dadCamIdle[1] = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
	dadCamIdle[2] = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')

	if mustHitSection == true and (getProperty('boyfriend.animation.curAnim.name') == 'idle' or getProperty('boyfriend.animation.curAnim.name') == 'danceLeft' or getProperty('boyfriend.animation.curAnim.name') == 'danceRight') then
		callCamMovemt(bfCamIdle[1] -(yoffset * 2.5), bfCamIdle[2] -yoffset);
	elseif mustHitSection == true then
		if camMovementType == 'charSize' then
			offsets = 30 + (0.000025 * getProperty('boyfriend.width') * getProperty('boyfriend.height'));
		elseif camMovementType == 'camZoom' then
			offsets = 33.35 * getProperty('defaultCamZoom');
		end
		if curNoteData == 0 then
			callCamMovemt(bfCamIdle[1] -offsets -(yoffset * 2.5), bfCamIdle[2] -yoffset);
		end
		if curNoteData == 1 then
			callCamMovemt(bfCamIdle[1] -(yoffset * 2.5), bfCamIdle[2] +offsets -yoffset);
		end
		if curNoteData == 2 then
			callCamMovemt(bfCamIdle[1] -(yoffset * 2.5), bfCamIdle[2] -offsets -yoffset);
		end
		if curNoteData == 3 then
			callCamMovemt(bfCamIdle[1] +offsets -(yoffset * 2.5), bfCamIdle[2] -yoffset);
		end
	end
	if mustHitSection == false and (getProperty('dad.animation.curAnim.name') == 'idle' or getProperty('dad.animation.curAnim.name') == 'danceLeft' or getProperty('dad.animation.curAnim.name') == 'danceRight') then
		callCamMovemt(dadCamIdle[1] -yoffset, dadCamIdle[2] -yoffset);
	elseif mustHitSection == false then
		if camMovementType == 'charSize' then
			offsets = 30 + (0.000025 * getProperty('dad.width') * getProperty('dad.height'));
		elseif camMovementType == 'camZoom' then
			offsets = 33.35 * getProperty('defaultCamZoom');
		end
		if curNoteData == 0 then
			callCamMovemt(dadCamIdle[1] -offsets -yoffset, dadCamIdle[2] -yoffset);
		end
		if curNoteData == 1 then
			callCamMovemt(dadCamIdle[1] -yoffset, dadCamIdle[2] +offsets -yoffset);
		end
		if curNoteData == 2 then
			callCamMovemt(dadCamIdle[1] -yoffset, dadCamIdle[2] -offsets -yoffset);
		end
		if curNoteData == 3 then
			callCamMovemt(dadCamIdle[1] +offsets -yoffset, dadCamIdle[2] -yoffset);
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote) if mustHitSection then curNoteData = direction; end end
function noteMiss(direction) if mustHitSection then curNoteData = direction; end end
function noteMissPress(direction) if mustHitSection then curNoteData = direction; end end
function goodNoteHit(id, direction, noteType, isSustainNote) if mustHitSection then curNoteData = direction; end end
function opponentNoteHit(id, direction, noteType, isSustainNote) if not mustHitSection then curNoteData = direction; end end

function callCamMovemt(x, y)
	if not camMovement then return; end
	triggerEvent("Camera Follow Pos", ""..x, ""..y)
end