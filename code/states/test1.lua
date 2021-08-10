local menu = {}

function menu:enter()
    audio.setTrack(audio.Track2)
    audio.loadedTrack:play() 
end

function menu:draw()
    love.graphics.setCanvas(canvas)
	love.graphics.clear()
    love.graphics.draw(titleScreen, 0, 0)
		graphics.makeCanvas()
    
end

function menu:keyreleased(key)
    if key == 'return' then
      stateLeaving = Gamestate.current()
      stateEntering = mainMenu
      Gamestate.switch(transition,stateLeaving,stateEntering)
     -- Gamestate.switch(mainMenu)
    end
end

return menu
