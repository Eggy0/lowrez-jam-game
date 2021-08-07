local test = {}


function test:draw()
    defaultFont:setLineHeight(1.1)
    love.graphics.setFont(defaultFont)
    love.graphics.print("THE QUICK BROWN\nFOX JUMPS OVER\nTHE LAZY DOG.\n?!.,-", 0, 16)
		graphics.makeCanvas()
end



return test
