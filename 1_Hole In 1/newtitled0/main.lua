-- to do list
--[[
0. save
1. slider
2. start -> theme -> stage -> map
]]--

-- local list
local _W = display.contentWidth
local _H = display.contentHeight
local physcis = require "physics"
local widget = require "widget"
local json = require "json"

display.setDrawMode( "physics" )

--Conver Color
local function CC(hex)
	local r = tonumber( hex:sub(1,2), 16) / 255
	local g = tonumber( hex:sub(3,4), 16) / 255
	local b = tonumber( hex:sub(5,6), 16) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7,8), 16) / 255 end
	return r,g,b,a
end

--audioAsset List
local crackRock = audio.loadSound( "/AudioAssets/effect_crackRock.wav" )
local footstep = audio.loadSound( "/AudioAssets/effect_footstep.wav" )
local gameOver = audio.loadSound( "/AudioAssets/effect_gameOver.wav" )
local hamHit = audio.loadSound( "/AudioAssets/effect_hmrHit.wav" )
local hamSwing = audio.loadSound( "/AudioAssets/effect_hmrSwing.wav" )
local jump = audio.loadSound( "/AudioAssets/effect_jump.wav" )
local moveMap = audio.loadSound( "/AudioAssets/effect_mapMove.wav" )
local damageMonster = audio.loadSound( "/AudioAssets/effect_monDamage.wav" )
local dieMonster = audio.loadSound( "/AudioAssets/effect_monDie.wav" )
local noise = audio.loadSound( "/AudioAssets/effect_noise.wav" )
local damagePlayer = audio.loadSound( "/AudioAssets/effect_playerDamage.wav" )
local diePlayer = audio.loadSound( "/AudioAssets/effect_playerDie.wav" )
local respawn = audio.loadSound( "/AudioAssets/effect_respawn.wav" )
local shutDown = audio.loadSound( "/AudioAssets/effect_shutdown.wav" )
local ui = audio.loadSound( "/AudioAssets/effect_ui.wav" ) --이건 무슨 음악인가.. 생각해보자-
local rebootm = audio.loadSound( "/AudioAssets/effect_reboot.wav" )

--data
local path = system.pathForFile( "Data.txt" , system.DocumentsDirectory )
local theme
local stage
local savePoint
local runningTime

local myData = 
{
	["theme"] = 1,
	["stage"] = 1,
	["savePoint"] = 1,
	["runningTime"] = 0
}
local selectData = 
{
	["theme"] = 1,
	["stage"] = 1,
	["savePoint"] = 1,
	["runingTime"] = 0
}

local saveData = function ( )
	-- w : 덮어쓰기. 전 내용은 사라짐.
	local encoded = json.encode( myData )
	print( "encoded : " .. encoded )

	local file, errorString = io.open( path, "w" )

	if not file then
		print( "File error : ".. errorString )
	else
		file:write( encoded )

		io.close( file )
	end

	file = nil
end

local loadData = function ( )
	local file, errorString = io.open( path, "r" )


	if not file then
		print( "File error: " .. errorString )
	else
		local decoded, pos, msg  = json.decodeFile( path )

		if not decoded then
			print( "decode failed at".. tostring(pos)..": "..tostring(msg))
		else
			theme = decoded.theme
			stage = decoded.stage
			savePoint = decoded.savePoint
			runningTime = decoded.runningTime

		end

		io.close ( file )
	end

	file = nil
end


--function list
local start
local selectTheme
local selectStage
local stage
local turnSelectTheme
local turnSelectStage
local turnStage
local newTouch
local localTouch
local themeTouch
local inGame


--local list
local bg
local bgPhysics
local bgData
local floor
local isTouch = false
local alertBox
local alertBox_t
--start
local load = nil
local new = nil
local curser = nil

--theme
local themeMax = 3
local themeButton = {}
local themeRock = {}
local themeText = {}
local themeName = { "드넓은 초원", "포근한 집", "좋은 노트북" }
local themeT

--stage
local stageButton = {}
local stageRock = {}
local stageText = {}
local themeShow
local themeShow_t

--inGame
local life = 3
local life_t

local timerUI
local timer2UI
local timerText
local rebootUI
local rebootBox

local attackButton
local jumpButton
local upButton
local downButton
local leftButton
local rightButton

local isClear
local char
local charSet
local charData
local charSheet

--move
local moveLeft
local moveRight
local moveJump
local moveAttack

local isJumping = false

--character list


--function start

--touch event
turnSelectTheme = function ( )
	selectTheme( )
end

turnSelectStage = function ( n )
	for i = 1, themeMax, 1 do
		if i ~= n then
			themeButton[i]:removeEventListener( "tap", themeTouch )

			themeButton[i]:removeSelf()

			themeText[i]:removeSelf()
		end
	end

	transition.to( themeButton[n], { alpha = 0, x = _W * 0.5 - themeButton[n].contentWidth * 0.5, time = 300, delay = 150 } )
	transition.to( themeButton[n], { alpha = 1, time = 300, delay = 450 } )
	transition.to( themeButton[n], { alpha = 0, time = 300, delay = 750 })
	transition.to( themeText[n], { alpha = 0, x = _W * 0.5, time = 300, delay = 150 } )
	transition.to( themeText[n], { alpha = 1, time = 300, delay = 450 } )
	transition.to( themeText[n], { alpha = 0, time = 300, delay = 750 })
	transition.to( bg, { alpha = 0, time = 300, delay = 850, onStart = selectStage })
end

turnStage = function ( )
	for i = 1, 2, 1 do
		for j = 1, 3, 1 do
			stageButton[10*i+j]:removeEventListener( "tap", stageTouch )
			stageButton[10*i+j]:removeSelf()
			stageText[10*i+j]:removeSelf()
		end
	end
	bg:removeSelf()
	floor:removeSelf()
	themeShow:removeSelf()
	themeShow_t:removeSelf()
	ingame()
end

newTouch = function ( )
	system.vibrate( )
	curser.x, curser.y = _W * 0.07, _H * 0.795
	curser.alpha = 1
	new:removeEventListener( "touch", newTouch )
	load:removeEventListener( "touch", loadTouch )
	audio.play(ui)
	saveData()
	load.alpha = 0
	transition.to( curser, { alpha = 0, time = 300 } )
	transition.to( new, { alpha = 0, time = 300 } )
	transition.to( curser, { alpha = 1, time = 300, delay = 300 } )
	transition.to( new, { alpha = 1, time = 300, delay = 300 } )	
	transition.to( curser, { alpha = 0, time = 300, delay = 600 } )
	transition.to( new, { alpha = 0, time = 300, delay = 600 } )
	transition.to( bg, { alpha = 0, time = 450, delay = 900, onStart = turnSelectTheme } )	
end

loadTouch = function ( )
	system.vibrate( )
	curser.x, curser.y = _W * 0.07, _H * 0.885
	curser.alpha = 1
	new:removeEventListener( "touch", newTouch )
	load:removeEventListener( "touch", loadTouch )
	audio.play(ui)
	loadData( )
	new.alpha = 0
	transition.to( curser, { alpha = 0, time = 300 } )
	transition.to( load, { alpha = 0, time = 300 } )
	transition.to( curser, { alpha = 1, time = 300, delay = 300 } )
	transition.to( load, { alpha = 1, time = 300, delay = 300 } )	
	transition.to( curser, { alpha = 0, time = 300, delay = 600 } )
	transition.to( load, { alpha = 0, time = 300, delay = 600 } )
	transition.to( bg, { alpha = 0, time = 450, delay = 900, onStart = turnSelectTheme } )	
end

themeTouch = function ( e )
	local n = e.target.name

	if myData.theme >= n then
		selectData.theme = n
		turnSelectStage(n)
		audio.play(ui)
	end
end

stageTouch = function ( e )
	local n = e.target.name
	selectData.stage = n

	if ( myData.theme > selectData.theme ) or ( myData.theme == selectData.theme and myData.stage >= selectData.stage ) then
		selectData.stage = n
		turnStage(n)
		audio.play(ui)
	end
end

buttonTouch = function ( e )
	local n = e.target.name
--	print( "name : " .. n .. "   phase : " .. e.phase )
	if e.phase == "began" then
		if n == "attack" then
			char:setSequence("attack")
			char:play()
			timer.performWithDelay( 150, moveAttack, 3 )
		elseif n == "jump" then
			moveJump() 
		elseif n == "right" then
			char:setSequence("walR")
			char.xScale = 1
			char:play()
		elseif n == "left" then
			char:setSequence("walkL")
			char.xScale = -1
			char:play()
		end
	elseif e.phase == "ended" then
		if n == "attack" then
			physics.removeBody( char )
			physics.addBody( char, "dynamic", charPhysics:get("normal"))
			char:setSequence("normal")
			char:play()
		elseif n == "jump" then
			char:setSequence("normal")
			char:play()
		elseif n == "right" then
			char:setSequence("normal")
			char:play()
		elseif n == "left" then
			char:setSequence("normal")
			char:play()
		end
	end
end



--event.other

--screen
start = function ( )
	bg = display.newImage("/image/title/title_bg.png")
	bg.anchorX, bg.anchorY = 0, 0

	new = display.newImage("/image/title/new_game.png")
	new.anchorX, new.anchorY = 0, 0
	new.x, new.y = _W * 0.1, _H * 0.8
	new.name = "new"

	load = display.newImage("/image/title/load_game.png")
	load.anchorX, load.anchorY = 0, 0
	load.x, load.y = _W * 0.1 , _H * 0.89
	load.name = "load"

	curser = display.newImage("/image/title/icon_curser.png")
	curser.anchorX, curser.anchorY = 0, 0
	curser.alpha = 0

	load:addEventListener( "touch", loadTouch )
	new:addEventListener( "touch", newTouch )

end

selectTheme = function ( )
	audio.play(respawn)
	bg:removeSelf( )
	new:removeSelf( )
	load:removeSelf( )
	curser:removeSelf( )
	bg = display.newImage("/image/stage/chapter_bg.png",0,0)
	bg.anchorX, bg.anchorY = 0, 0
	bg.alpha = 0
	bg:setFillColor( CC("E3F6FF" ))
	transition.to( bg, { alpha = 1, time = 300, delay = 50 } )
	floor = display.newImage("/image/stage/floor.png",0,_H)
	floor.anchorX, floor.anchorY = 0, floor.contentHeight
	floor.alpha = 0
	transition.to( floor, { alpha = 1, time = 300, delay = 50 } )

	for i = 1, themeMax, 1 do
		if myData.theme > i then
			themeButton[i] = display.newImage("/image/stage/stage_clear.png", _W*0.15 + 4101*(i-1), _H*0.3875 )
		elseif myData.theme == i then
			themeButton[i] = display.newImage( "/image/stage/stage_unlock.png", _W*0.15 + 410*(i-1), _H*0.3875 )
		else
			themeButton[i] = display.newImage("/image/stage/stage_locked.png", _W*0.15 + 410*(i-1), _H*0.3875)
		end
		themeButton[i].anchorX, themeButton[i].anchorY = 0, 0
		themeButton[i].name = i
		themeButton[i].alpha = 0

		themeButton[i]:addEventListener( "tap", themeTouch )

		themeText[i] = display.newText( themeName[i], 0, 0, native.newFont( "정9체.ttf" ) )
		themeText[i].size = 60
		themeText[i].x, themeText[i].y = themeButton[i].x + themeButton[i].contentWidth * 0.5 , themeButton[i].y + themeButton[i].contentHeight * 1.3
		themeText[i]:setFillColor( CC("000000"))
		themeText[i].alpha = 0
	end

	for i = 1, themeMax, 1 do
		transition.to( themeButton[i], { alpha = 1, time = 300, delay = 50 } )
		transition.to( themeText[i], { alpha = 1, time = 300, delay = 50 } )
	end


end

selectStage = function ( )
	audio.play(respawn)
	themeButton[selectData.theme]:removeSelf()
	bg:removeSelf()
	floor:removeSelf()
	bg = display.newImage("/image/stage/chapter_bg.png", 0, 0)
	bg.anchorX, bg.anchorY = 0, 0
	bg.alpha = 0
	transition.to( bg, { alpha = 1, time = 300, delay = 50 })
	floor = display.newImage("/image/stage/floor.png",0,_H)
	floor.anchorX, floor.anchorY = 0, floor.contentHeight
	floor.alpha = 0
	transition.to( floor, { alpha = 1, time = 300, delay = 50 } )
	themeShow = display.newImage("/image/stage/ui_chapter_title_bg.png",0,0)
	themeShow.anchorX, themeShow.anchorY = 0, 0
	themeShow.alpha = 0
	transition.to( themeShow, { alpha = 1, time = 300, delay = 50 } )
	themeShow_t = display.newText(themeName[selectData.theme], _W*0.0875, _H*0.05, native.newFont("정9체.ttf") )
	themeShow_t.align = "left"
	themeShow_t.alpha = 0
	transition.to( themeShow_t, { alpha = 1, time = 300, delay = 50 } )
	-- selectData.theme
	-- 1 2 3 4 5 (i)
	-- 2
	-- 3
	-- 4
	-- (j)

	for i = 1, 2, 1 do
		for j = 1, 3, 1 do
			if ( myData.theme > selectData.theme ) or ( ( myData.theme == selectData.theme ) and ( myData.stage > 3*(i-1)+j ) ) then
				stageButton[10*i+j] = display.newImage("/image/stage/stage_clear.png", _W*0.25+250*(j-1), _H*0.2 + 275*(i-1) )
			elseif ( myData.theme == selectData.theme ) and ( myData.stage == 3*(i-1)+j ) then
				stageButton[10*i+j] = display.newImage("/image/stage/stage_unlock.png", _W*0.25+250*(j-1), _H*0.2 + 275*(i-1) )
			else
				stageButton[10*i+j] = display.newImage("/image/stage/stage_locked.png", _W*0.25+250*(j-1), _H*0.2 + 275*(i-1) )
			end
			stageButton[10*i+j].anchorX, stageButton[10*i+j].anchorY = 0, 0
			stageButton[10*i+j].name = (i-1)+j
			stageButton[10*i+j].alpha = 0

			stageButton[10*i+j]:addEventListener( "tap", stageTouch )

			stageText[10*i+j] = display.newText( selectData.theme .. "-" .. 3*(i-1)+j, 0, 0, native.newFont("정9체.ttf") )
			stageText[10*i+j].size = 60
			stageText[10*i+j].x, stageText[10*i+j].y = stageButton[10*i+j].x + stageButton[10*i+j].contentWidth * 0.5, stageButton[10*i+j].y + stageButton[10*i+j].contentHeight * 1.3
			stageText[10*i+j]:setFillColor( CC("000000") )
		end
	end

	for i = 1, 2, 1 do
		for j = 1, 3, 1 do
			transition.to( stageButton[10*i+j], { alpha = 1.0, time = 300 } )
			transition.to( stageText[10*i+j], { alpha = 1.0, time = 300 } )
		end
	end
end

inGame = function ( )
	--game settings
	physics.start()
	display.setDrawMode( "hybrid" )
	local th = selectData.theme
	local st = selectData.stage
	local physicsName

	bg = display.newImage("/image/UI/bg.png", 0, 0 )
--	bg = display.newImage("/image/UI/sample2.png", 0, 0)
	if th == 1 then
		if st == 1 then

			bgPhysics = display.newImage("/image/map/00.png", 0, 0)
			bgData = ( require "image.map.00").physicsData(1,0)
			physicsName = "00"
		elseif st == 2 then
		elseif st == 3 then
		elseif st == 4 then
		elseif st == 5 then
		elseif st == 6 then
		end
	else
	end
	bg.anchorX, bg.anchorY = 0, 0
	bgPhysics.x, bgPhysics.y = 0, 144*3
	bgPhysics.anchorX = 0
	bgPhysics.name = "map"
	physics.addBody( bgPhysics, "static", bgData:get(physicsName))

	--UI Settings
	timerUI = display.newImage("/image/UI/ui_time.png", 0,0)
	timerUI.x, timerUI.y = _W * 0.351, _H * 0.052

	timerUI2 = display.newImage("/image/UI/ui_time_guage.png",0,0)
	timerUI2.x, timerUI2.y = _W * 0.379, _H * 0.028

	timerText = display.newText( "99:99", 0,0, native.newFont("정9체.ttf"))
	timerText.size = 55
	timerText.x, timerText.y = _W * 0.438, _H * 0.085

	rebootUI = display.newImage("/image/UI/ui_quest.png",0,0)
	rebootUI.x, rebootUI.y = _W * 0.634, _H * 0.051

	--char set
	charData = 
	{
		width = 100,
		height = 64,
		numFrames = 12,
		sheetContentWidth = 400 ,
		sheetContentHeight = 192 ,
	}
	charSet = 
	{
		{ name = "normal", frames = { 1 }, time = 459, loopCount = 0 },
		{ name = "walkL", frames = { 2, 3, 4 }, time = 450, loopCount = 0 },
		{ name = "walkR", frames = { 2, 3, 4 }, time = 450, loopCount = 0 },
		{ name = "jump", frames = { 5, 6, 7 }, time = 450, loopCount = 1 },
		{ name = "attack", frames = { 9, 10, 11 }, time = 450, loopCount = 1 },
	}

	charSheet = graphics.newImageSheet( "/image/char.png", charData )
	char = display.newSprite( charSheet, charSet )
	charPhysics = ( require "image.char").physicsData(1.0)

	char.x, char.y = _W * 0.3, _H * 0.8750
	char.name = "char"
	char:play()
	physics.addBody( char, "dynamic", charPhysics:get("normal") )
	--button
	attackButton = display.newImage("/image/UI/ui_btn_hammer.png",0,0)
	attackButton.x, attackButton.y = _W * 0.921, _H * 0.864
	attackButton.name = "attack"
	attackButton:addEventListener( "touch", buttonTouch )

	jumpButton = display.newImage("/image/UI/ui_btn_jump.png",0,0)
	jumpButton.x, jumpButton.y = _W * 0.8, _H * 0.907
	jumpButton.name = "jump"	
	jumpButton:addEventListener( "touch", buttonTouch )

	upButton = widget.newButton({
		left = _W * 0.1,
		top = _H * 0.7,
		defaultFile = "/image/UI/ui_joystick_up_idle.png",
		overFile = "/image/UI/ui_joystick_up_push.png",
		onEvent = buttonTouch
	})
	upButton.name = "up"

	
	downButton = widget.newButton({
		left = _W * 0.1,
		top = _H * 0.8,
		defaultFile = "/image/UI/ui_joystick_down_idle.png",
		overFile = "/image/UI/ui_joystick_down_push.png",
		onEvent = buttonTouch
	})
	downButton.name = "down"

	leftButton = widget.newButton({
		left = _W * 0.064,
		top = _H * 0.766,
		defaultFile = "/image/UI/ui_joystick_left_idle.png",
		overFile = "/image/UI/ui_joystick_left_push.png",
		onEvent = buttonTouch
		})
	leftButton.name = "left"

	rightButton = widget.newButton({
		left = _W * 0.12,
		top = _H * 0.766,
		defaultFile = "/image/UI/ui_joystick_right_idle.png",
		overFile = "/image/UI/ui_joystick_right_push.png",
		onEvent = buttonTouch
	})
	rightButton.name = "right"


--	upButton = display.newImage("/image/UI/ui_joystick_up_idle.png",0,0)
--	upButton.x, upButton.y = _W * 0.12, _H * 0.743
--	upButton.name = "up"
--	upButton.alpha = 0.7
--	upButton:addEventListener( "touch", buttonTouch )

--	downButton = display.newImage("/image/UI/ui_joystick_down_idle.png",0,0)
--	downButton.x, downButton.y = _W * 0.12, _H * 0.841
--	downButton.name = "down"
--	downButton.alpha = 0.7
--	downButton:addEventListener( "touch", buttonTouch )
	
--	leftButton = display.newImage("/image/UI/ui_joystick_left_idle.png",0,0)
--	leftButton.x, leftButton.y = _W * 0.092, _H * 0.793
--	leftButton.name = "left"
--	leftButton.alpha = 0.7	
--	leftButton:addEventListener( "touch", buttonTouch )


--	rightButton = display.newImage("/image/UI/ui_joystick_right_idle.png",0,0)
--	rightButton.x, rightButton.y = _W * 0.148, _H * 0.793
--	rightButton.name = "right"
--	rightButton.alpha = 0.7
--	rightButton:addEventListener( "touch", buttonTouch )

	bg.alpha = 0
	bgPhysics.alpha = 0

	--dissolve
	transition.to( bg, { alpha = 1, time = 300 } )
	transition.to( bgPhysics, { alpha = 1, time = 300 } )





	--start Game

end

--move
moveLeft = function ( )
end

moveRight = function ( )
end

collisionWithMap = function ( e )
	isJumping = false
	print(isJumping)
end

moveJump = function ( )
	if not isJumping then
		audio.play(jump)
		char:setLinearVelocity( 0, -10 )
		isJumping = true
		char:setSequence("jump")
		char:addEventListener( "collision", collisionWithMap )
	end
end

n = 1
moveAttack = function ( )
	if n == 1 then
		n = 2 
		physics.removeBody( char )
		physics.addBody( char, "dynamic", charPhysics:get("attack_01"))
	elseif n == 2 then
		n = 3
		physics.removeBody( char )
		physics.addBody( char, "dynamic", charPhysics:get("attack_02"))
	elseif n == 3 then
		n = 1
		physics.removeBody( char )
		physics.addBody( char, "dynamic", charPhysics:get("attack_03"))
	end
end

--start()
inGame()