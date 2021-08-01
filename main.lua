require("graphics")



function love.load()

	canvas = love.graphics.newCanvas(canvas_width, canvas_height)
	canvas:setFilter("linear","nearest")
	
	resolution_test = love.graphics.newImage("test.png")
	animation = newAnimation(resolution_test,64,64,0.3)
	

end

function love.update(dt)
	animation.currentTime = animation.currentTime + dt
	if animation.currentTime >= animation.duration then
		animation.currentTime = animation.currentTime - animation.duration
	end

end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum])
	makeCanvas()


end