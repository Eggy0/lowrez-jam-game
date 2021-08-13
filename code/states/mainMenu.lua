local mainMenu = {}
local selectionMain = -32
local selectionHelp = -32
local selectionLabel = "PLAY"
local helpToggled = false
local toggleDelay = 0.01
	
local menuCam = Camera( 64, 64,{x=selectionMain,y=-96})
local helpCam = Camera( 64, 64,{x=selectionX,y=-96})

 
function mainMenu:enter()
    local selectionMain = -32
    local selectionHelp = -32
    audio.setTrack(audio.Track3)
    audio.loadedTrack:play() 
end

function mainMenu:update(dt)
	
  flux.update(dt)
  
  flux.to(menuCam,  0.5, {x = selectionMain}):ease("backout")
  flux.to(helpCam,  0.5, {x = selectionHelp}):ease("backout")
  
  menuCam:update()

  
  if selectionMain == -32 and helpToggled == false then
      selectionLabel = "PLAY"
  elseif selectionMain == -96 and helpToggled == false then
      selectionLabel = "HELP"
  elseif helpToggled == true then
      selectionLabel = "BACK"   
  end
  toggleDelay = 0.01
  menuHelpControlsAnimation:update(dt)
  powerInvincibleAnimation:update(dt)
end

function mainMenu:draw()
  love.graphics.setCanvas(canvas)
	love.graphics.clear()
  
  if helpToggled == false then
    menuCam:push()
    love.graphics.draw(mainMenuGraphic , 0, 0)
    love.graphics.setFont(defaultFont)
    defaultFont:setLineHeight(1)
    love.graphics.printf("CREDITS",-90,66,500,"center") 
    love.graphics.printf("CODING N ART\nEGGY0\n\nCODING HELP\nSIR DIEALOT\n\nMUSIC \nJAMIE WHITMARSH",-90,72+4,500,"center") 
    menuCam:pop()
  elseif helpToggled == true then
    helpCam:push()
    love.graphics.draw(mainMenuGraphic , 0, 64)
    love.graphics.setFont(defaultFont)
    defaultFont:setLineHeight(1)
    love.graphics.printf("GREETINGS! YOU ARE WANTED BY THE SPATIAL AUTHORITIES.\n\nHOW FAR CAN YOU AND YOUR SHIP FLY?",-125+(2*64),68,56,"left") 
    love.graphics.printf("USE BELOW CONTROLS TO MOVE. TRAVEL FORWARD (UPWARDS).",-124+(3*64),66,56,"center") 
    love.graphics.draw(playerShip,-110+(3*64)-4,106+4)
    menuHelpControlsAnimation:draw(menuHelpControls,-110+(3*64)+12-8,98+4)
    love.graphics.printf("ASTEROIDS WILL FLOAT INTO YOUR MIDST AND CAUSE DAMAGE ON CONTACT.",-124+(4*64),66,56,"center") 
    for i=1, 4 do
      love.graphics.draw(asteroidGraphics[i],-124+(4*64)+(10*i),106)
    end
    love.graphics.printf("A POLICE SHIP PURSUES YOU. ITS LASERS ARE DEADLY AND BYPASS ALL PROTECTION.",-124+(5*64),66,56,"center")
  
    love.graphics.printf("COLLECT POWERUPS TO HELP YOU ADVANCE.",-124+(6*64),66,56,"center")
    love.graphics.draw(powerSpeed,-108+(6*64),98)
    love.graphics.draw(powerSuperSpeed,-108+(6*64)+10,98)
    love.graphics.draw(powerPermaSpeed,-108+(6*64)+20,98)
    love.graphics.draw(powerHealth,-108+(6*64)+5,98+10)
    powerInvincibleAnimation:draw(powerInvincible,-108+(6*64)+15,98+10)
    helpCam:pop()
  end
  
  
  if (selectionMain >= -96 and helpToggled == false) or (helpToggled == true) then
    love.graphics.setFont(defaultFont) 
    love.graphics.printf("START - " .. selectionLabel, 8, 56,50,"center")
  end
    if (selectionMain < -32 and helpToggled == false) or (selectionHelp < -32 and helpToggled == true) then
      love.graphics.draw(menuArrowLeft,2,23)
    end
    if (selectionMain > -160  and helpToggled == false) or (helpToggled == true and selectionHelp > -288) then
      love.graphics.draw(menuArrowRight,53,23)
    end
  love.graphics.setFont(scoreFont)
  --love.graphics.print(selectionX .. "    " .. selectionY, 8, 56)
  graphics.makeCanvas()
  

end

function mainMenu:keypressed(key, code)

    if key == 'return' then 
      if selectionMain == -32 and helpToggled == false  then
        stateLeaving = Gamestate.current()
        stateEntering = game
        Gamestate.switch(transition,stateLeaving,stateEntering)
      end
      if selectionMain == -96 and helpToggled == false and toggleDelay == 0.01 then
        toggleDelay = 0
        helpToggled = true
        

      end
      if helpToggled == true and toggleDelay == 0.01 then
        toggleDelay = 0
        selectionHelp = -32
        helpToggled = false
          
      end
    end
	if key == 'right' or key =="d" then 
		if (helpToggled == false and selectionMain > -160) then
			selectionMain = selectionMain-64
		end
    if (helpToggled == true and selectionHelp> -288) then
    	selectionHelp = selectionHelp-64
    end
    end
	if key == 'left' or key =="a" then
    if (selectionMain < -32 and helpToggled == false) then 
        selectionMain = selectionMain+64
    end
    if (selectionHelp < -32 and helpToggled == true) then
         selectionHelp = selectionHelp+64
    end  
  end
end


return mainMenu


