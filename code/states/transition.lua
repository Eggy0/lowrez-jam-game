local transition = {}




function transition:enter(stateLeaving,stateEntering)
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
  flux.to(shipTrans, 1.5, {y = -70})
  polygonVertices = {shipTrans.x-1, shipTrans.y+1, shipTrans.x+2, shipTrans.y+1,shipTrans.x+40, shipTrans.y+60,shipTrans.x+40, shipTrans.y+150,shipTrans.x-40, shipTrans.y+150,shipTrans.x-40, shipTrans.y+60}
  if shipTrans.y <= -55 then
    Gamestate.registerEvents()
    Gamestate.switch(stateEntering)
  end

end

function transition:draw()
  

  --love.graphics.stencil(stateWeAreLeaving, "replace", 1, false)
  --love.graphics.setStencilTest("greater", 0)
  
  --stateLeaving:draw()
  
  love.graphics.draw(playerShip,shipTrans.x,shipTrans.y,0,1,1,4,8)
 
  
  love.graphics.setCanvas({canvas, stencil=true})  
  
  love.graphics.stencil(stateWeAreEntering, "replace", 1, false)
  love.graphics.setStencilTest("greater", 0)
  
  stateEntering:draw()
  
  love.graphics.setStencilTest()
  love.graphics.setCanvas()
  love.graphics.clear()
  love.graphics.draw(canvas)
  

end


return transition