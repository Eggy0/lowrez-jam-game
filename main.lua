graphics = require("graphics")
audio = require ("audio")
local anim8 = require ("anim8")

local resolutionTest, resolutionTestAnimation
local backgroundX, backgroundY, backgroundYTimer

function love.load()

	font = love.graphics.newFont(8)
	
	backgroundX = 0
	backgroundY = 0
	backgroundYTimer = 0


	-- This allows debugging in zbstudio
	if arg[#arg] == '-debug' then require('mobdebug').start() end
	
	math.round = function(n)
		return math.floor(n + 0.5)
	end

	canvas = love.graphics.newCanvas(canvas_width, canvas_height)
	canvas:setFilter("nearest","nearest")
	
	resolutionTest = love.graphics.newImage("test.png")
	gameBackgroundTest = love.graphics.newImage("gameplay_background_test.png")
	
	local resolutionTestGrid = anim8.newGrid(64,64,resolutionTest:getWidth(), resolutionTest:getHeight())
	resolutionTestAnimation = anim8.newAnimation(resolutionTestGrid('1-3',1),0.1)
	
	local gameBackgroundGrid = anim8.newGrid(64,64,gameBackgroundTest:getWidth(), gameBackgroundTest:getHeight())
	gameBackgroundAnimation = anim8.newAnimation(gameBackgroundGrid('1-7',1),0.1)
	
	--Load gameObject graphics (player ship, asteroids etc.)

	graphics.loadGraphics()

	
	--Load the objects
	objects = require("objects")
	--Spawn asteroid object with random sprite
	objects.spawnPlayerShip(31,64)
	
	audio.setTrack(audio.Track1)
	
	audio.loadedTrack:play()

end

function love.update(dt)


	objects.playerShipControls(dt)
	
	objects.moveAsteroid(dt)
	objects.rotateAsteroid(dt)
	
	gameBackgroundAnimation:update(dt)
	backgroundYTimer = backgroundYTimer + 1*dt
	if backgroundYTimer >= 0.1 then
		backgroundY = backgroundY + 1
		backgroundYTimer = 0
	end
	if backgroundY > 64 then --This makes it "tile" seamlessly
		backgroundY = backgroundY - 64
	end
	
	objectPlayerShip.Score = objectPlayerShip.Score + 5*dt
	audio.Update()

end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY)
	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY-gameBackgroundTest:getHeight())
	

	
	--Test gameObject graphics
	love.graphics.draw(objectPlayerShip.Sprite, math.round(objectPlayerShip.x), math.round(objectPlayerShip.y),0,1,1,4,8)
	objects.drawThruster()
	
	for i,v in ipairs(asteroidList) do
		love.graphics.draw(v.Sprite, math.round(v.x),math.round(v.y),v.Rotation,1,1,4,4)
	end
	
	--We just print variables as a test.
		love.graphics.setFont(font)
		love.graphics.print(objectPlayerShip.Health,0,0)
		love.graphics.print(objectPlayerShip.Score,56,0) --Need to figure out how to make it padded so it fits on the screen.
		love.graphics.print(audio.loopStart,8,8)
		love.graphics.print(audio.position,8,16)
		love.graphics.print(audio.loopEnd,8,24)
		

	graphics.makeCanvas()


end

function love.keypressed(key)
	if key == "space" then
		objects.spawnAsteroid(asteroidRandomX[love.math.random(#asteroidRandomX)], love.math.random(0,56))
	end
	if key == "m" then
		audio.loadedTrack:stop()
		audio.setTrack(audio.Track2)
		audio.loadedTrack:play()
	end
	if key == "l" then --We use this to test the audio loop
		audio.loadedTrack:seek(audio.loopEnd-321935,"samples")
	end
end
