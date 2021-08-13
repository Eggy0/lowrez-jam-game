local transition = {}


function transition:enter(stateLeaving,stateEntering)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  soundTransition:play()
  prevState = love.graphics.newImage(canvas:newImageData())

  shipTrans = {}
  shipTrans.x = 31
  shipTrans.y = 80

  musicFade = musicVolume
end

local function stateWeAreLeaving()
    love.graphics.rectangle("fill",0,0,64,64)
end
local function stateWeAreEntering()
    love.graphics.polygon("fill",polygonVertices)
end

function transition:update(dt)
  if musicFade > 0 then
    musicFade = musicFade -2.5*dt
  end  
  audio.loadedTrack:setVolume(musicFade)
      if musicFade <= 0 then
        audio.loadedTrack:stop()
      end
  
  if shipTrans.y <= -50 then
   --     love.graphics.setCanvas()
   Gamestate.switch(stateEntering)
   --love.keypressed("return")

  else

      flux.update(dt)
      flux.to(shipTrans, 1, {y = -70})
      polygonVertices = {shipTrans.x-1, shipTrans.y+1, shipTrans.x+2, shipTrans.y+1,shipTrans.x+40, shipTrans.y+60,shipTrans.x+40, shipTrans.y+150,shipTrans.x-40, shipTrans.y+150,shipTrans.x-40, shipTrans.y+60}
  end
end

function transition:draw()
  
    love.graphics.setCanvas({canvas, stencil=true})
    love.graphics.stencil(stateWeAreLeaving, "replace", 1, false)
    love.graphics.setStencilTest("greater", 0)
    
    love.graphics.draw(prevState,0,0)
    
    love.graphics.draw(playerShip,shipTrans.x,shipTrans.y,0,1,1,4,8)

    
    love.graphics.stencil(stateWeAreEntering, "replace", 1, false)
    love.graphics.setStencilTest("greater", 0)
    
    if stateEntering == mainMenu then
        love.graphics.draw(mainMenuGraphic, 0, -64)
         graphics.makeCanvas()
    elseif stateEntering == game then
        gameBackgroundAnimation:draw(gameBackgroundTest,0,32)
        gameBackgroundAnimation:draw(gameBackgroundTest,0,32-64)
        graphics.makeCanvas()
    end
  
    love.graphics.setStencilTest()
    love.graphics.setCanvas(canvas)
    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.draw(canvas)
 
  
end
function transition:keypressed(key, code)
  if key == 'return'  then
    love.keypressed(nil)
      --love.graphics.setCanvas(canvas)
      --Gamestate.switch(stateEntering)
  end
end
return transition