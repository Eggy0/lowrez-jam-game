local mainMenu = {}
local selectionX = -32
local selectionY = -96
local selectionLabel = "PLAY"
	
local menuCam = Camera( 64, 64,{x=selectionX,y=selectionY})
local objectMain = {}
	objectMain.x = 0
	objectMain.y = -64
 
function mainMenu:enter()
    local selectionX = -32
    local selectionY = -96
    audio.setTrack(audio.Track3)
    audio.loadedTrack:play() 
end

function mainMenu:update(dt)
	flux.update(dt)
  menuCam.y = selectionY
	flux.to(menuCam, 0.5, {x = selectionX}):ease("backout")
  menuCam:update()
  
  if selectionX == -32 then
      selectionLabel = "PLAY"
  elseif selectionX == -96 then
      selectionLabel = "HELP"
  end
end

function mainMenu:draw()
  love.graphics.setCanvas(canvas)
	love.graphics.clear()
  
  menuCam:push()
  love.graphics.draw(mainMenuGraphic , 0, 0)
  

  
  love.graphics.setFont(defaultFont)
  defaultFont:setLineHeight(1)
  love.graphics.printf("CREDITS",-90,66,500,"center") 
  love.graphics.printf("CODING N ART\nEGGY0\n\nCODING HELP\nSIR DIEALOT\n\nMUSIC \nJAMIE WHITMARSH",-90,72+4,500,"center") 
  
  menuCam:pop()
  if selectionX >= -96 and selectionY == -96 then
    love.graphics.setFont(defaultFont) 
    love.graphics.printf(selectionLabel, 8, 56,50,"center")
  end
    love.graphics.draw(menuArrowLeft,2,23)
    love.graphics.draw(menuArrowRight,53,23)
  --love.graphics.print(selectionX .. "    " .. selectionY, 8, 56)
  graphics.makeCanvas()
  

end

function mainMenu:keypressed(key, code)

    if key == 'return' and selectionX == -32 then
        --Gamestate.switch(game)
      stateLeaving = Gamestate.current()
      stateEntering = game
      Gamestate.switch(transition,stateLeaving,stateEntering)
    end
	if key == 'right' then 
		if selectionY == -96 and selectionX > -160 then
			selectionX = selectionX-64
		end
    end
	if key == 'left' and selectionX < -32 then
        selectionX = selectionX+64
    end
end

return mainMenu


