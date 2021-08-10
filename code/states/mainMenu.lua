local mainMenu = {}
local selectionX = 0
local selectionY = 0
	

local objectMain = {}
	objectMain.x = 0
	objectMain.y = 0
 

function mainMenu:update(dt)
	flux.update(dt)
	flux.to(objectMain, 0.5, {x = selectionX, y = selectionY}):ease("backout")
end

function mainMenu:draw()
  
  love.graphics.setCanvas(canvas)
  if love.graphics.getCanvas() == nil then
      error("mainMenu:draw() was called but love's current canvas is nil.")
  end
  love.graphics.draw(mainMenuGraphic , math.round(objectMain.x), math.round(objectMain.y))
  graphics.makeCanvas()
  

end

function mainMenu:keypressed(key, code)

    if key == 'return' and selectionX == 0 then
        --Gamestate.switch(game)
      stateLeaving = Gamestate.current()
      stateEntering = game
      Gamestate.switch(transition,stateLeaving,stateEntering)
    end
	if key == 'right' then 
		if selectionY == 0 and selectionX > -128 then
			selectionX = selectionX-64
		end
    end
	if key == 'left' and selectionX < 0 then
        selectionX = selectionX+64
    end
end

return mainMenu


