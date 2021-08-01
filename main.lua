local canvas_width = 64
local canvas_height = 64
local canvas

function makeCanvas()
	love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.scale(love.graphics.getWidth() / canvas_width, love.graphics.getHeight() / canvas_height)
    love.graphics.draw(canvas)
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

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