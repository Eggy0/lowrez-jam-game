splash = {}
local timer = 0
local splashSound = love.audio.newSource('audio/bg/splash.ogg',"static")

function splash:update(dt)
  timer = timer + 1*dt
  
  if timer >= 0.7 and timer <= 0.8 then
    splashSound:play()
  end
  if timer >= 3 then
    Gamestate.switch(menu)
  end
end

function splash:draw()
  love.graphics.setCanvas(canvas)
	love.graphics.clear()
  if timer >=0.7 and timer <=2.5 then
    love.graphics.setFont(defaultFont)
    love.graphics.printf("MADE FOR LOWREZJAM",8,24,50,"center")
  end 
  graphics.makeCanvas()
end  
  

return splash