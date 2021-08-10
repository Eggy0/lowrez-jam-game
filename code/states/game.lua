local game = {}
local collisionCheck = "No"
local blink = 1
local blinkTimer = 0
local worldY = 0
local distanceMeter, asteroidTimerCount = 0, 0, 0
local asteroidTimer = love.math.random(0.2,3)
local camDelay = 10
local isPaused = false
local powerup = require('code/powerups')
local chance = require('code/chance')
local powerupTimer, powerupChoice = 0, nil
chance.core.seed (love.math.random(4294967296))




function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function circleRectangleIntersect(cx, cy, cr, rx, ry, rw, rh)
	local circle_distance_x = math.abs(cx - rx - rw/2)
	local circle_distance_y = math.abs(cy - ry - rh/2)

	if circle_distance_x > (rw/2 + cr) then return false end
	if circle_distance_y > (rh/2 + cr) then return false end

	if circle_distance_x <= (rw/2) then return true end
	if circle_distance_y <= (rh/2) then return true end

	local corner_distance_sq = math.pow(circle_distance_x - rw/2, 2) +
						 math.pow(circle_distance_y - rh/2, 2)

	return corner_distance_sq <= math.pow(cr, 2)
end
function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

cam = Camera(64, 64, { x = -32, y = worldY, offsetY = 40})
  


function game:enter()

  deathFinished = false --So the death sound only plays once
  
  backgroundX = 0
	backgroundY = worldY
	backgroundYTimer = 0
  
  

	canvas:setFilter("nearest","nearest")
	
	objects.spawnPlayerShip(31,worldY)
	objects.spawnPolice(31,worldY+100)
  policeFollowFlag = false

  if stateRestarting == false or stateRestarting == nil then
    if audio.loadedTrack ~= nil then
      audio.loadedTrack:stop() --Stop the track if it's already playing
    end
    audio.setTrack(audio.Track1)
    audio.loadedTrack:play() 
  end
  stateRestarting = false



end


function gameUpdate(dt) --Need this to be able to pause the game
  
  
  distance = distanceFrom(objectPlayerShip.x,objectPlayerShip.y,objectPolice.x,objectPolice.y)
  shipScreenX, shipScreenY = cam:getScreenCoordinates(objectPolice.x, objectPolice.y)
  powerupTimer = powerupTimer + 1*dt
  if powerupTimer >= 10 and objectPlayerShip.isDead == false then
    powerupChoice = chance.misc.weighted ({"speed","superspeed","permaspeed","health","invincible"}, {35,15,10,25,15})
    
    if powerupChoice == "speed" then
      powerup.spawnSpeed(love.math.random(8,56), objectPlayerShip.y - 64)
    end
    if powerupChoice == "superspeed" then
      powerup.spawnSuperSpeed(love.math.random(8,56), objectPlayerShip.y - 64)
    end  
    if powerupChoice == "permaspeed" then
      powerup.spawnPermaSpeed(love.math.random(8,56), objectPlayerShip.y - 64)
    end
    if powerupChoice == "health" then
        if objectPlayerShip.Health < 3 then --Spawn health only if the player is not at max health
          powerup.spawnHealth(love.math.random(8,56), objectPlayerShip.y - 64)
        else
          powerup.spawnSpeed(love.math.random(8,56), objectPlayerShip.y - 64) --If the player is at full health when it picks health, spawn speed instead
        end
    end 
    if powerupChoice == "invincible" then
      powerup.spawnInvincibility(love.math.random(8,56), objectPlayerShip.y - 64)
    end
    powerupTimer = 0
  end  

	flux.update(dt)
  
  flux.to(cam, camDelay*dt, {y = (objectPlayerShip.y-5)*-1})
  if camDelay ~= 10 then
    camDelay = 10
  end
  if objectPlayerShip.isDead == false then
    asteroidTimerCount = asteroidTimerCount + 1*dt
    if asteroidTimerCount >= asteroidTimer then
       objects.spawnAsteroid(asteroidRandomX[love.math.random(#asteroidRandomX)], objectPlayerShip.y-love.math.random(32,64),love.math.random(20,50))
       asteroidTimerCount = 0
       asteroidTimer = love.math.random(0.2,3) 
    end    
  end
  
	objects.playerShipControls(dt)
	if  policeFollowFlag == true then
  objects.policeFollow(dt)
  end
  policeFollowFlag = true --There was a bug where the police ship would sometimes instantly catch up with the player on spawn despite being created far beneath.
	objectPolice.Velocity = objectPolice.Velocity + 0.2*dt
	blinkTimer = blinkTimer + 1*dt
	if blinkTimer >= 0.05 then
		blink = blink *-1
		blinkTimer = 0
	end
    
	objects.moveAsteroid(dt)
	objects.rotateAsteroid(dt)
  objects.moveBullet(dt)
  powerup.movePowerup(dt)
	
	if objectPlayerShip.iframe > 0 then
		objectPlayerShip.iframe = objectPlayerShip.iframe - 1*dt
	end
	if objectPlayerShip.isDead == true then
    playerShipExplosionAnimation:resume()
    playerShipExplosionAnimation:update(dt)
  elseif objectPlayerShip.isDead == false then
    playerShipExplosionAnimation:gotoFrame(1)
    playerShipExplosionAnimation:pause()
  end
	gameBackgroundAnimation:update(dt)
	backgroundYTimer = backgroundYTimer + 1*dt
	if backgroundYTimer >= 0.1 then
		backgroundY = backgroundY + 1
		backgroundYTimer = 0
	end
	if backgroundY > objectPlayerShip.y + 64 then --This makes it "tile" seamlessly
		backgroundY = backgroundY - 64
  elseif backgroundY < objectPlayerShip.y - 64 then --Just in case the player goes backwards
		backgroundY = backgroundY + 64
	end

	
	for i,v in ipairs(asteroidList) do
		if circleRectangleIntersect(v.x,v.y, v.radius,objectPlayerShip.hitX,objectPlayerShip.hitY,objectPlayerShip.hitW,objectPlayerShip.hitH) and objectPlayerShip.isDead == false then

			if objectPlayerShip.iframe <= 0 then
				objectPlayerShip.Health= objectPlayerShip.Health - 1
				objectPlayerShip.iframe = 5
        table.remove(asteroidList,i)
			end
		else

		end

		if v.x >= 70 or v.x <= -10 or v.y >= objectPlayerShip.y + 70 then --Asteroid removal code
			table.remove(asteroidList,i)
		end
		
	end

	
  cam:update()
  distanceMeter = -2+distance/2
    if distanceMeter < 24 then
      distanceMeter = 24
    elseif distanceMeter > 60 then
      distanceMeter = 60
    end
  if -(objectPlayerShip.y/10)>objectPlayerShip.Score then
      objectPlayerShip.Score = -(objectPlayerShip.y/10)
  end
   powerInvincibleAnimation:update(dt)
     
end  

function game:update(dt)
  if isPaused == false then
    gameUpdate(dt)
  end
  audio.Update() --This is outside the pause function because the music needs to loop

end


function game:draw()
	
  
	cam:push()
    --Debug test some hitboxes

    
    for i=-1,2 do
      gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY-(gameBackgroundTest:getHeight())*i)
    end
    love.graphics.setColor( 1, 0, 0, 1)
   
    love.graphics.setColor( 1, 1, 1, 1)
	
		if objectPlayerShip.iframe >0 then
      love.graphics.setColor( 1, 1, 1, blink)
    end
    if objectPlayerShip.isDead == false then
      love.graphics.draw(objectPlayerShip.Sprite, objectPlayerShip.x, objectPlayerShip.y,0,1,1,4,8)
    end
    love.graphics.setColor( 1, 1, 1, 1)
  
    love.graphics.draw(objectPolice.Sprite, math.floor(objectPolice.x), math.floor(objectPolice.y),0,1,1,20,22)
	
    if objectPlayerShip.isDead == false then
      objects.drawThruster()
    end

  
	
    for i,v in ipairs(asteroidList) do
      love.graphics.draw(v.Sprite, v.x,v.y,v.Rotation,1,1,4,4)
    end
    for i,v in ipairs(powerupList) do
      if v.Sprite == powerInvincible then
        powerInvincibleAnimation:draw(powerInvincible,v.x,v.y,0,1,1,3,3)
      else
        love.graphics.draw(v.Sprite, v.x,v.y,0,1,1,3,3)
      end
    end    
    for i,v in ipairs(bulletList) do
      love.graphics.setColor( 1, 1, 1, 1)
      love.graphics.rectangle("fill", v.x,v.y,v.width,v.length)

    end
	
    if objectPlayerShip.isDead == true then
      if deathFinished == false then
        soundExplosion:play()
        deathFinished = true
      end
      playerShipExplosionAnimation:draw(playerShipExplosion,objectPlayerShip.x-4,objectPlayerShip.y-8)
    end
		
		
    cam:pop()--Pop the cam before drawing the HUD
    
   
		love.graphics.setFont(scoreFont) 
    love.graphics.print(string.format("%06d",objectPlayerShip.Score),28,1)
    if objectPlayerShip.isDead == false then
    
      --love.graphics.print(objectPolice.Velocity,32,8)
      --love.graphics.print(audio.loopStart,8,8)
      --love.graphics.print(audio.position,8,16)
      --love.graphics.print(audio.loopEnd,8,24)
      --love.graphics.print("Collision: " .. collisionCheck,8,40)
      
      for i=0,objectPlayerShip.Health-1 do
        love.graphics.draw(playerShipHealth,(i*8),0)
      end
      love.graphics.draw(playerIcon,0,8)
      love.graphics.draw(policeIcon,0,distanceMeter-2,0,1,1,0,7)
      love.graphics.setLineWidth(1)
      love.graphics.setLineStyle("rough")
      if distanceMeter-10 > 15 then
        love.graphics.line( 4, 15, 4, distanceMeter-10)
      end
    end
    if isPaused == true then
      love.graphics.setBlendMode("subtract","premultiplied")
      love.graphics.setColor( 0.5, 0.5, 0.5)
      love.graphics.rectangle("fill",0,0,64,64)
      love.graphics.setColor( 1, 1, 1)
      love.graphics.setBlendMode("alpha")
      defaultFont:setLineHeight(1.1)
      love.graphics.setFont(defaultFont)
      love.graphics.printf("PAUSED",7,16,50,"center")
    end
    if objectPlayerShip.isDead == true then
      love.graphics.setColor( 1, 1, 1)
      defaultFont:setLineHeight(1.1)
      love.graphics.setFont(defaultFont)
      love.graphics.printf("YOU DIED\n\nPRESS R TO\nRESPAWN",7,16,50,"center")
    end
    graphics.makeCanvas()
	
end



function love.keypressed(key)
    if isPaused == false then  
      if key == "r" then --Reset the state
        camDelay = 0 --Temporarily set cam move time to 0 to prevent whipping on respawn
        asteroidList = {} --Clear all the asteroids
        bulletList = {} --Clear all the bullets if some still exist
        powerupList = {} --Clear all the bullets if some still exist
        powerupTimer, powerupChoice = 0, nil
        stateRestarting = true
        Gamestate.switch(game)
      end
      if key == "m" then --Go to main menu
        camDelay = 0 --Temporarily set cam move time to 0 to prevent whipping on respawn
        asteroidList = {} --Clear all the asteroids
        bulletList = {} --Clear all the bullets if some still exist
        powerupList = {} --Clear all the powerups if some still exist
        stateLeaving = Gamestate.current()
        stateEntering = mainMenu
        Gamestate.switch(transition,stateLeaving,stateEntering)
      end
      
    end
    

  if key == "p" and isPaused == false and objectPlayerShip.isDead == false then
      isPaused = true
  elseif key == "p" and isPaused == true and objectPlayerShip.isDead == false then
      isPaused = false
  end
end


return game