local textOptionsArray = {};

function onCreate()
	local textOptions = getTextFromFile("defaultOptions.txt", false)
	local curCharacters = "";
	if checkFileExists("options.txt", false) then
		textOptions = getTextFromFile("options.txt", false)
		for i = 1, #textOptions do
			if textOptions:sub(i, i) == "," then
				curCharacters = string.gsub(curCharacters, "", "")
				textOptionsArray[#textOptionsArray + 1] = curCharacters;
				curCharacters = "";
			else
				local currentCharacertsy = textOptions:sub(i, i);
				curCharacters = curCharacters..currentCharacertsy;
			end
		end
	else
		for i = 1, #textOptions do
			if textOptions:sub(i, i) == "," then
				curCharacters = string.gsub(curCharacters, "", "")
				textOptionsArray[#textOptionsArray + 1] = curCharacters;
				curCharacters = "";
			else
				local currentCharacertsy = textOptions:sub(i, i);
				curCharacters = curCharacters..currentCharacertsy;
			end
		end
	end

	initSaveData("globalOptions", 'Options')
	--settings
	setDataFromSave("globalOptions", "cameraFPS", textOptionsArray[1])
	setDataFromSave("globalOptions", "autoAntialiasing", convertStringToType(textOptionsArray[2], "bool"))
	setDataFromSave("globalOptions", "cameraMovement", textOptionsArray[3])
end

function onCreatePost()
	if string.lower(getDataFromSave("globalOptions", "cameraFPS")) == "true-basefps" then setProperty("cameraSpeed", 0.0165 * framerate + 0.01) end
end

function onUpdate(elapsed)
	if string.lower(getDataFromSave("globalOptions", "cameraFPS")) == "true-constant" then setProperty("cameraSpeed", 0.0165 * getPropertyFromClass("Main", "fpsVar.currentFPS") + 0.01) end
	if getDataFromSave("globalOptions", "autoAntialiasing") then --helps performance (which is good!)
		if stringStartsWith(version, '0.6') then
			runHaxeCode([[
				for (integer in game.modchartSprites.keys()) {
					if (game.modchartSprites[integer].antialiasing == true) {
						game.modchartSprites[integer].antialiasing = ClientPrefs.globalAntialiasing; }
				}
			]])
		else
			runHaxeCode([[
				for (integer in game.modchartSprites.keys()) {
					if (game.modchartSprites[integer].antialiasing == true) {
						game.modchartSprites[integer].antialiasing = backend.ClientPrefs.data.antialiasing; }
				}
			]])
		end
	end
end

function convertStringToType(str, convertType)
	local stringButLowered = string.lower(str)
	local convertTypeButLowered = string.lower(convertType)

	if convertTypeButLowered == "bool" then
		if stringButLowered == "true" then return true; end
		if stringButLowered == "false" then return false; end
		if stringButLowered == "nil" then return nil; end
		if stringButLowered == "null" then return nil; end
	end
	return "";
end