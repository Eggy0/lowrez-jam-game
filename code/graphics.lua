local graphics = {}

local canvas_width = 64
local canvas_height = 64


function graphics.loadGraphics()

	titleScreen = love.graphics.newImage('graphics/gameAssetTitleScreenTest.png')
  mainMenuGraphic = love.graphics.newImage('graphics/gameAssetMainMenu.png')
  menuArrowLeft = love.graphics.newImage('graphics/gameAssetMainMenuArrowLeft.png')
  menuArrowRight = love.graphics.newImage('graphics/gameAssetMainMenuArrowRight.png')
	
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
  table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid4.png'))
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid5.png'))
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid6.png'))
  table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid7.png'))
  
  asteroidMedGraphics = {}
  table.insert(asteroidMedGraphics,love.graphics.newImage('graphics/gameObjectMedAsteroid1.png'))
	table.insert(asteroidMedGraphics,love.graphics.newImage('graphics/gameObjectMedAsteroid2.png'))
	table.insert(asteroidMedGraphics,love.graphics.newImage('graphics/gameObjectMedAsteroid3.png'))
  table.insert(asteroidMedGraphics,love.graphics.newImage('graphics/gameObjectMedAsteroid4.png'))
  
  gameBackgroundTest = love.graphics.newImage("graphics/gameplay_background_test.png")
	gameBackgroundGrid = anim8.newGrid(64,64,gameBackgroundTest:getWidth(), gameBackgroundTest:getHeight())
	gameBackgroundAnimation = anim8.newAnimation(gameBackgroundGrid('1-7',1),0.1)
  
  playerShipExplosion = love.graphics.newImage("graphics/gameAssetExplosion.png")
	playerShipExplosionGrid = anim8.newGrid(8,8,playerShipExplosion:getWidth(), playerShipExplosion:getHeight())
	playerShipExplosionAnimation = anim8.newAnimation(playerShipExplosionGrid('1-6',1),0.07,'pauseAtEnd')
  
  --powerups
  powerInvincible = love.graphics.newImage("graphics/gameObjectInvincible.png")
  powerHealth = love.graphics.newImage("graphics/gameObjectHealthUp.png")
  powerSpeed = love.graphics.newImage("graphics/gameObjectSpeed.png")
  powerSuperSpeed = love.graphics.newImage("graphics/gameObjectSuperSpeed.png")
  powerPermaSpeed = love.graphics.newImage("graphics/gameObjectPermaSpeed.png")
  powerGun = love.graphics.newImage("graphics/gameObjectGun.png")
  
  powerInvincibleGrid = anim8.newGrid(7,7,powerInvincible:getWidth(), powerInvincible:getHeight())
	powerInvincibleAnimation = anim8.newAnimation(powerInvincibleGrid('1-2',1),0.1)
	
end


function graphics.makeCanvas()
    love.graphics.setCanvas()
    --love.graphics.clear()
    love.graphics.scale(love.graphics.getWidth() / canvas_width, love.graphics.getHeight() / canvas_height)
    love.graphics.draw(canvas)
end


return graphics


