local mainMenu = {}
local selectionX = 0
local selectionY = 0
	
	mainMenuGraphic = love.graphics.newImage('graphics/gameAssetMainMenu.png')

local objectMain = {}
	objectMain.Sprite = mainMenuGraphic
	objectMain.x = 0
	objectMain.y = 0

function mainMenu:update(dt)
	flux.update(dt)
	flux.to(objectMain, 0.5, {x = selectionX, y = selectionY}):ease("backout")
end

function mainMenu:draw()
    love.graphics.draw(objectMain.Sprite, math.round(objectMain.x), math.round(objectMain.y))
	graphics.makeCanvas()
end

function mainMenu:keypressed(key, code)
    if key == 'return' and selectionX == 0 then
        Gamestate.switch(game)
    end
	if key == 'right' and selectionX > -128 then
        selectionX = selectionX-64
    end
	if key == 'left' and selectionX < 0 then
        selectionX = selectionX+64
    end
end

return mainMenu


