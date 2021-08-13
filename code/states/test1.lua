local menu = {}
local timer, time
local timerPressStart
local pressStartEnable 
local blink = 1
local blinkTimer = 0

function menu:enter()
    timer, time= 0,0.04
    timerPressStart = 0
    pressStartEnable = false
    fadeIn = 0.9
    audio.setTrack(audio.Track2)
    audio.loadedTrack:play() 
end

function menu:update(dt)
  if fadeIn > 0 then
    timer = timer + 1*dt
    if timer >= time then
      fadeIn = fadeIn-0.3
      timer = 0
    end
  end
  timerPressStart = timerPressStart + 1*dt
  if timerPressStart >= 1.5 then
    pressStartEnable = true
  end
  if pressStartEnable == true then    
      blinkTimer = blinkTimer + 1*dt
    if blinkTimer >= 0.5 then
      blink = blink *-1
      blinkTimer = 0
    end
  end
end

function menu:draw()
  love.graphics.setCanvas(canvas)
	love.graphics.clear()
   love.graphics.draw(titleScreen, 0, 0)
  --Fade-in effect
  love.graphics.setBlendMode("subtract","premultiplied")
  love.graphics.setColor( fadeIn, fadeIn,fadeIn)
  love.graphics.rectangle("fill",0,0,64,64)
 
  love.graphics.setColor( 1, 1, 1)
  love.graphics.setBlendMode("alpha")
  if pressStartEnable == true then
    love.graphics.setFont(defaultFont)
    love.graphics.setColor( 1, 1, 1, blink)
    love.graphics.printf("PRESS START",7,58,50,"center")
     love.graphics.setColor( 1, 1, 1)
  end
  
  graphics.makeCanvas()
    
end

function menu:keyreleased(key)
    if key == 'return' and pressStartEnable == true then
      stateLeaving = Gamestate.current()
      stateEntering = mainMenu
      Gamestate.switch(transition,stateLeaving,stateEntering)
     -- Gamestate.switch(mainMenu)
    end
end


return menu
