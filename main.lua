require("graphics")
local anim8 = require ("anim8")

local resolutionTest, resolutionTestAnimation

function love.load()

	canvas = love.graphics.newCanvas(canvas_width, canvas_height)
	canvas:setFilter("linear","nearest")
	
	resolutionTest = love.graphics.newImage("test.png")
	local resolutionTestGrid = anim8.newGrid(64,64,resolutionTest:getWidth(), resolutionTest:getHeight())
	resolutionTestAnimation = anim8.newAnimation(resolutionTestGrid('1-3',1),0.3)

end

function love.update(dt)

	resolutionTestAnimation:update(dt)

end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	resolutionTestAnimation:draw(resolutionTest,0,0)

	makeCanvas()


end