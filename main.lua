graphics = require("code/graphics")
audio = require ("code/audio")
local anim8 = require ("code/anim8")

local resolutionTest, resolutionTestAnimation
local backgroundX, backgroundY, backgroundYTimer
collisionCheck = "No"

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	
	
	font = love.graphics.newFont(8) --Debug only
	
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
	canvas:setFilter("nearest","nearest")
	
	--Load the objects
	objects = require("code/objects")
	--Spawn asteroid object with random sprite
	objects.spawnPlayerShip(31,64)
	
	audio.setTrack(audio.Track1)
	
	audio.loadedTrack:play()
	
	objects.spawnAsteroid(32,16,0)

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

	
	for i,v in ipairs(asteroidList) do
		if CheckCollision(objectPlayerShip.x-1,objectPlayerShip.y-6,11,11, v.x+3,v.y+3,3,3) then
			collisionCheck = "Yes"
			objectPlayerShip.Health= objectPlayerShip.Health - 1
		else
			collisionCheck = "No"
		end

		if v.x >= 70 or v.x <= -10 or v.y >= 70 then --Asteroid removal code
			table.remove(asteroidList,i)
		end
		
	end
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
		--love.graphics.print(audio.loopStart,8,8)
		--love.graphics.print(audio.position,8,16)
		--love.graphics.print(audio.loopEnd,8,24)
		love.graphics.print("Collision: " .. collisionCheck,8,40)
		

	graphics.makeCanvas()


end

function love.keypressed(key)
	if key == "space" then
		objects.spawnAsteroid(asteroidRandomX[love.math.random(#asteroidRandomX)], love.math.random(0,56))
	end
	if key == "m" then --Load alternate track
		audio.loadedTrack:stop()
		audio.setTrack(audio.Track2)
		audio.loadedTrack:play()
	end
	if key == "l" then --We use this to test the audio loop
		audio.loadedTrack:seek(audio.loopEnd-321935,"samples")
	end
end