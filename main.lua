require("graphics")
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
	canvas:setFilter("linear","nearest")
	
	resolutionTest = love.graphics.newImage("test.png")
	gameBackgroundTest = love.graphics.newImage("gameplay_background_test.png")
	
	local resolutionTestGrid = anim8.newGrid(64,64,resolutionTest:getWidth(), resolutionTest:getHeight())
	resolutionTestAnimation = anim8.newAnimation(resolutionTestGrid('1-3',1),0.1)
	
	local gameBackgroundGrid = anim8.newGrid(64,64,gameBackgroundTest:getWidth(), gameBackgroundTest:getHeight())
	gameBackgroundAnimation = anim8.newAnimation(gameBackgroundGrid('1-7',1),0.1)
	
	--Load gameObject graphics (player ship, asteroids etc.)
	playerShip = love.graphics.newImage('graphics/gameObjectShip.png')
	asteroid1 = love.graphics.newImage('graphics/gameObjectAsteroid1.png')
	asteroid2 = love.graphics.newImage('graphics/gameObjectAsteroid2.png')
	asteroid3 = love.graphics.newImage('graphics/gameObjectAsteroid3.png')

end

function love.update(dt)

	--Note to self: make the background infinitely tile, somehow
	
	gameBackgroundAnimation:update(dt)
	backgroundYTimer = backgroundYTimer + 1*dt
	if backgroundYTimer >= 0.5 then
		backgroundY = backgroundY + 1
		backgroundYTimer = 0
	end

end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY)
	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY-gameBackgroundTest:getHeight())
	
	--Test gameObject graphics
	love.graphics.draw(playerShip, 31,50)
	love.graphics.draw(asteroid1, 24,24)
	love.graphics.draw(asteroid2, 31,24)
	love.graphics.draw(asteroid3, 40,24)

	makeCanvas()


end