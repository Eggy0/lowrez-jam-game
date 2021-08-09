local testGame = {}
local collisionCheck = "No"
local blink = 1
local blinkTimer = 0
local worldY = 0
asteroidTimerCount = 0
local asteroidTimer = love.math.random(0.2,3)
local camDelay = 10
local isPaused = false
local powerup = require('code/powerups')




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

cam = Camera(64, 64, { x = -32, y = worldY, offsetY = 40})
  
if audio.loadedTrack ~= nil then
		audio.loadedTrack:stop() --Stop the track if it's already playing
end
audio.setTrack(audio.Track1)
audio.loadedTrack:play()

function testGame:enter()

  backgroundX = 0
	backgroundY = worldY
	backgroundYTimer = 0

	canvas:setFilter("nearest","nearest")
	
	objects.spawnPlayerShip(31,worldY)




end


function testGameUpdate(dt) --Need this to be able to pause the game
  

  powerup.movePowerup(dt)
	flux.update(dt)
  
  flux.to(cam, camDelay*dt, {y = objectPlayerShip.y*-1})
  if camDelay ~= 10 then
    camDelay = 10
  end

  
	objects.playerShipControls(dt)

	blinkTimer = blinkTimer + 1*dt
	if blinkTimer >= 0.05 then
		blink = blink *-1
		blinkTimer = 0
	end
    
	objects.moveAsteroid(dt)
	objects.rotateAsteroid(dt)
  objects.moveBullet(dt)
	
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
  
  if -(objectPlayerShip.y/10)>objectPlayerShip.Score then
      objectPlayerShip.Score = -(objectPlayerShip.y/10)
  end
     
end  

function testGame:update(dt)
  if isPaused == false then
    testGameUpdate(dt)
  end
  audio.Update() --This is outside the pause function because the music needs to loop
   powerInvincibleAnimation:update(dt)

end


function testGame:draw()
	
	cam:push()
    --Debug test some hitboxes

     love.graphics.setLineStyle("rough")
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
      love.graphics.setColor( 1, 0, 0, 1)
     
      love.graphics.rectangle("line",objectPlayerShip.hitX,objectPlayerShip.hitY,objectPlayerShip.hitW,objectPlayerShip.hitH)
    end
    love.graphics.setColor( 1, 1, 1, 1)
  

	
    if objectPlayerShip.isDead == false then
      objects.drawThruster()
    end

  
	
    for i,v in ipairs(asteroidList) do
      love.graphics.draw(v.Sprite, v.x,v.y,v.Rotation,1,1,4,4)
      love.graphics.setColor( 1, 0, 0, 1)
      love.graphics.circle("line",v.x,v.y,v.radius)
      love.graphics.setColor( 1, 1, 1, 1)
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
      playerShipExplosionAnimation:draw(playerShipExplosion,objectPlayerShip.x-4,objectPlayerShip.y-8)
    end
		
		
    cam:pop()--Pop the cam before drawing the HUD
    
   
		love.graphics.setFont(scoreFont) 
    love.graphics.print(string.format("%06d",objectPlayerShip.Score),28,1)
    if objectPlayerShip.isDead == false then
    
--      love.graphics.print(objectPlayerShip.iframe,32,8)
--      love.graphics.print(objectPlayerShip.Velocity,8,8)
     -- love.graphics.print(worldX .. " " .. worldY,8,8)
--      love.graphics.print(powerupTimer,8,16)
--      love.graphics.print(powerupSpeedValue,8,24)
      --love.graphics.print("Collision: " .. collisionCheck,8,40)
      
      for i=0,objectPlayerShip.Health-1 do
        love.graphics.draw(playerShipHealth,(i*8),0)
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


--The commands below are for debug.

function love.keypressed(key)
  if isPaused == false and Gamestate.current()==testGame then  
    if key == "space" and Gamestate.current()==testGame then
        powerup.spawnSpeed(objectPlayerShip.x, objectPlayerShip.y-64)
    end
    if key == "lctrl" and Gamestate.current()==testGame then
        powerup.spawnSuperSpeed(objectPlayerShip.x, objectPlayerShip.y-64)
    end
    if key == "rctrl" and Gamestate.current()==testGame then
        powerup.spawnPermaSpeed(objectPlayerShip.x, objectPlayerShip.y-64)
    end
    if key == "lshift" and Gamestate.current()==testGame then
        powerup.spawnHealth(objectPlayerShip.x, objectPlayerShip.y-64)
    end 
    if key == "rshift" and Gamestate.current()==testGame then
        powerup.spawnInvincibility(objectPlayerShip.x, objectPlayerShip.y-64)
    end   
    if key == "n" and Gamestate.current()==testGame then
        objects.spawnAsteroid(asteroidRandomX[love.math.random(#asteroidRandomX)], objectPlayerShip.y-love.math.random(0,48))
    end
    
    if key == "m" and audio.loadedTrack ~= nil then --Load alternate track
      audio.loadedTrack:stop()
      audio.setTrack(audio.Track2)
      audio.loadedTrack:play()
    end
    if key == "l" and audio.loadedTrack ~= nil then --We use this to test the audio loop
      audio.loadedTrack:seek(audio.loopEnd-321935,"samples")
    end

    if key == "g" then --Make the player die
      objectPlayerShip.Health = 0
    end
  end

end


return testGame