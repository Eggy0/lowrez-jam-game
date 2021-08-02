local graphics = {}

local canvas_width = 64
local canvas_height = 64


function graphics.loadGraphics()

	playerShip = love.graphics.newImage('graphics/gameObjectShip.png')
	playerShipThruster = love.graphics.newImage('graphics/gameObjectShipThruster.png')
	
	asteroidGraphics = {}
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid1.png'))
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid2.png'))
	table.insert(asteroidGraphics,love.graphics.newImage('graphics/gameObjectAsteroid3.png'))
	
end


function graphics.makeCanvas()
	love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.scale(love.graphics.getWidth() / canvas_width, love.graphics.getHeight() / canvas_height)
    love.graphics.draw(canvas)
end

return graphics


