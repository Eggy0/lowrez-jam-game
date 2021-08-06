local graphics = {}

local canvas_width = 64
local canvas_height = 64


function graphics.loadGraphics()

	titleScreen = love.graphics.newImage('graphics/gameAssetTitleScreenTest.png')

	
	playerShip = love.graphics.newImage('graphics/gameObjectShip.png')
	playerShipThruster = love.graphics.newImage('graphics/gameObjectShipThruster.png')
	playerShipHealth = love.graphics.newImage('graphics/gameObjectHealth.png')
	policeShip = love.graphics.newImage('graphics/gameObjectPolice.png')
  
  playerIcon = love.graphics.newImage('graphics/gameObjectShipIcon.png')
  policeIcon = love.graphics.newImage('graphics/gameObjectPoliceIcon.png')
	
	asteroidGraphics = {}
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid1.png'))
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid2.png'))
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid3.png'))
  
  gameBackgroundTest = love.graphics.newImage("graphics/gameplay_background_test.png")
	gameBackgroundGrid = anim8.newGrid(64,64,gameBackgroundTest:getWidth(), gameBackgroundTest:getHeight())
	gameBackgroundAnimation = anim8.newAnimation(gameBackgroundGrid('1-7',1),0.1)
  
  playerShipExplosion = love.graphics.newImage("graphics/gameplay_background_test.png")
	playerShipExplosionGrid = anim8.newGrid(8,8,playerShipExplosion:getWidth(), playerShipExplosion:getHeight())
	playerShipExplosionAnimation = anim8.newAnimation(playerShipExplosionGrid('1-5',1),0.1)
	
end


function graphics.makeCanvas()
	love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.scale(love.graphics.getWidth() / canvas_width, love.graphics.getHeight() / canvas_height)
    love.graphics.draw(canvas)
end

return graphics


