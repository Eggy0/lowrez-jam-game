local graphics = {}

local canvas_width = 64
local canvas_height = 64


function graphics.makeCanvas()
	love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.scale(love.graphics.getWidth() / canvas_width, love.graphics.getHeight() / canvas_height)
    love.graphics.draw(canvas)
end

return graphics


