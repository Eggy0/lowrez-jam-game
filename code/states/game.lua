local game = {}
local collisionCheck = "No"
local blink = 1
local blinkTimer = 0
local worldY = 0
local distanceMeter asteroidTimerCount = 0
local asteroidTimer = love.math.random(0.2,3)



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
  mainLayer = cam:addLayer('mainLayer', 1)
  parallax = cam:addLayer('parallax',1, { relativeScale = 0.5 })
  

function game:enter()


  
  backgroundX = 0
	backgroundY = worldY
	backgroundYTimer = 0
	
	
	

	canvas:setFilter("nearest","nearest")
	



	objects.spawnPlayerShip(31,worldY)
	objects.spawnPolice(31,objectPlayerShip.y+128)

	
	if audio.loadedTrack ~= nil then
		audio.loadedTrack:stop() --Stop the track if it's already playing
	end
	audio.setTrack(audio.Track1)
	audio.loadedTrack:play()

end

function game:update(dt)

	distance = distanceFrom(objectPlayerShip.x,objectPlayerShip.y,objectPolice.x,objectPolice.y)
  hudX, hudY = cam:getViewportPosition()
  shipScreenX, shipScreenY = cam:getScreenCoordinates(objectPlayerShip.x, objectPlayerShip.y)

	flux.update(dt)
  
  --if shipScreenY > 
  flux.to(cam, 30*dt, {y = objectPlayerShip.y*-1})
 
  asteroidTimerCount = asteroidTimerCount + 1*dt
  if asteroidTimerCount >= asteroidTimer then
     objects.spawnAsteroid(asteroidRandomX[love.math.random(#asteroidRandomX)], objectPlayerShip.y-love.math.random(4,32),love.math.random(20,50))
     asteroidTimerCount = 0
     asteroidTimer = love.math.random(0.2,3) 
  end    
	objects.playerShipControls(dt)
	objects.policeFollow(dt)
	--objectPolice.Velocity = objectPolice.Velocity + 0.2*dt
	blinkTimer = blinkTimer + 1*dt
	if blinkTimer >= 0.05 then
		blink = blink *-1
		blinkTimer = 0
	end
    
	objects.moveAsteroid(dt)
	objects.rotateAsteroid(dt)
	
	if objectPlayerShip.iframe > 0 then
		objectPlayerShip.iframe = objectPlayerShip.iframe - 1*dt
	end
	
  playerShipExplosionAnimation:update(dt)
	gameBackgroundAnimation:update(dt)
	backgroundYTimer = backgroundYTimer + 1*dt
	if backgroundYTimer >= 0.1 then
		backgroundY = backgroundY + 1
		backgroundYTimer = 0
	end
	if backgroundY > objectPlayerShip.y + 64 then --This makes it "tile" seamlessly
		backgroundY = backgroundY - 64
	end

	
	for i,v in ipairs(asteroidList) do
		if circleRectangleIntersect(v.x+5,v.y+4, 1,objectPlayerShip.x,objectPlayerShip.y-6,11,11) then         --CheckCollision(objectPlayerShip.x,objectPlayerShip.y-6,11,11, v.x+3,v.y+3,3,3) then
			collisionCheck = "Yes"
			if objectPlayerShip.iframe <= 0 then
				objectPlayerShip.Health= objectPlayerShip.Health - 1
				objectPlayerShip.iframe = 5
			end
		else
			collisionCheck = "No"
		end

		if v.x >= 70 or v.x <= -10 or v.y >= objectPlayerShip.y + 70 then --Asteroid removal code
			table.remove(asteroidList,i)
		end
		
	end

	audio.Update()
  cam:update()
  distanceMeter = -2+distance/2
    if distanceMeter < 24 then
      distanceMeter = 24
    elseif distanceMeter > 60 then
      distanceMeter = 60
    end

end

function game:draw()
	
	cam:push()
    cam:push('parallax')

      for i=0,2 do
      gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY-(gameBackgroundTest:getHeight())*i)
      end
    cam:pop('parallax')
  
  cam:push('mainLayer')
  
	
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
if objectPlayerShip.isDead == true then
  playerShipExplosionAnimation:draw(playerShipExplosion,objectPlayerShip.x-4,objectPlayerShip.y-8)
end
  
	
	for i,v in ipairs(asteroidList) do
		love.graphics.draw(v.Sprite, v.x,v.y,v.Rotation,1,1,4,4)

	end
	

		
		
		cam:pop('mainLayer') 
    cam:pop()--Pop the cam before drawing the HUD
    
   
		love.graphics.setFont(scoreFont)
    if objectPlayerShip.isDead == false then
      love.graphics.print(string.format("%06d",objectPlayerShip.Score),28,1)
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
    graphics.makeCanvas()
	
end


--The commands below are for debug.

function love.keypressed(key)
	if key == "space" and Gamestate.current()==game then
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
	if key == "b" then --Switch back to the other state
		Gamestate.switch(menu)
	end
  	if key == "g" then --Make the player die
		objectPlayerShip.Health = 0
	end
end


return game