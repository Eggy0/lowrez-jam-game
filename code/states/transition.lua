local transition = {}




function transition:enter()
love.graphics.setDefaultFilter('nearest', 'nearest')
shipTrans = {}
shipTrans.x = 31
shipTrans.y = 80

end

local function stateWeAreLeaving()
    love.graphics.rectangle("fill",0,0,64,64)
end
local function stateWeAreEntering()
    love.graphics.polygon("fill",polygonVertices)
end

function transition:update(dt)
  flux.update(dt)
  flux.to(shipTrans, 2.5, {y = -70})
  polygonVertices = {shipTrans.x-1, shipTrans.y+1, shipTrans.x+2, shipTrans.y+1,shipTrans.x+40, shipTrans.y+60,shipTrans.x+40, shipTrans.y+150,shipTrans.x-40, shipTrans.y+150,shipTrans.x-40, shipTrans.y+60}

end

function transition:draw()
  love.graphics.setCanvas({canvas, stencil=true})  
  love.graphics.stencil(stateWeAreLeaving, "replace", 1, false)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.setColor(1,0,0)
  love.graphics.rectangle("fill",0,0,64,64)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(playerShip,shipTrans.x,shipTrans.y,0,1,1,4,8)
  love.graphics.stencil(stateWeAreEntering, "replace", 1, false)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.setColor(0,1,1)
  love.graphics.rectangle("fill",0,0,64,64)
  love.graphics.setColor(1,1,1)
  love.graphics.circle("fill", 31, 31, 20)
  love.graphics.setStencilTest()
	graphics.makeCanvas()

end


return transition