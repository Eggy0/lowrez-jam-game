local menu = {}


function menu:draw()
    love.graphics.draw(titleScreen, 0, 0)
		graphics.makeCanvas()
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

return menu
