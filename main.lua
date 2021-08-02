graphics = require("graphics")
local anim8 = require ("anim8")


local resolutionTest, resolutionTestAnimation
local backgroundX, backgroundY, backgroundYTimer

function love.load()

	
	
	backgroundX = 0
	backgroundY = 0
	backgroundYTimer = 0


	-- This allows debugging in zbstudio
	if arg[#arg] == '-debug' then require('mobdebug').start() end

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
	objects.spawnAsteroid(16, 8)
	objects.spawnAsteroid(24, 8)
	objects.spawnAsteroid(31, 8)
	objects.spawnAsteroid(40, 8)
	objects.spawnAsteroid(48, 8)
	objects.spawnPlayerShip(31,50)

end

function love.update(dt)


	objects.playerShipControls(dt)
	
	gameBackgroundAnimation:update(dt)
	backgroundYTimer = backgroundYTimer + 1*dt
	if backgroundYTimer >= 0.1 then
		backgroundY = backgroundY + 1
		backgroundYTimer = 0
	end
	if backgroundY > 64 then --This makes it "tile" seamlessly
		backgroundY = backgroundY - 64
	end

end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY)
	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY-gameBackgroundTest:getHeight())
	

	
	--Test gameObject graphics
	love.graphics.draw(objectPlayerShip.Sprite, objectPlayerShip.x, objectPlayerShip.y)
	love.graphics.draw(asteroidGraphics[1], 24,24)
	love.graphics.draw(asteroidGraphics[2], 31,24)
	love.graphics.draw(asteroidGraphics[3], 40,24)
	
	for i,v in ipairs(asteroidList) do
		love.graphics.draw(v.Sprite, v.x,v.y)
	end


	graphics.makeCanvas()


end