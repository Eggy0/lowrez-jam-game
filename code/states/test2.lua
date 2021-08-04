local game = {}
local collisionCheck = "No"
local blink = 1
local blinkTimer = 0

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end



function game:enter()
    	backgroundX = 0
	backgroundY = 0
	backgroundYTimer = 0
	
	resolutionTest = love.graphics.newImage("test.png")
	gameBackgroundTest = love.graphics.newImage("gameplay_background_test.png")
	
	local resolutionTestGrid = anim8.newGrid(64,64,resolutionTest:getWidth(), resolutionTest:getHeight())
	resolutionTestAnimation = anim8.newAnimation(resolutionTestGrid('1-3',1),0.1)
	
	local gameBackgroundGrid = anim8.newGrid(64,64,gameBackgroundTest:getWidth(), gameBackgroundTest:getHeight())
	gameBackgroundAnimation = anim8.newAnimation(gameBackgroundGrid('1-7',1),0.1)
	

	canvas:setFilter("nearest","nearest")
	



	objects.spawnPlayerShip(31,64)
	objects.spawnPolice(31,128)
	
	if audio.loadedTrack ~= nil then
		audio.loadedTrack:stop() --Stop the track if it's already playing
	end
	audio.setTrack(audio.Track1)
	audio.loadedTrack:play()

end

function game:update(dt)
	distance = distanceFrom(objectPlayerShip.x,objectPlayerShip.y,objectPolice.x,objectPolice.y)
	flux.update(dt)
	objects.policeFollow(dt)
	objectPolice.Velocity = objectPolice.Velocity + 0.2*dt
	blinkTimer = blinkTimer + 1*dt
	if blinkTimer >= 0.05 then
		blink = blink *-1
		blinkTimer = 0
	end
    objects.playerShipControls(dt)
	objects.moveAsteroid(dt)
	objects.rotateAsteroid(dt)
	
	if objectPlayerShip.iframe > 0 then
		objectPlayerShip.iframe = objectPlayerShip.iframe - 1*dt
	end
	
	gameBackgroundAnimation:update(dt)
	backgroundYTimer = backgroundYTimer + 1*dt
	if backgroundYTimer >= 0.1 then
		backgroundY = backgroundY + 1
		backgroundYTimer = 0
	end
	if backgroundY > 64 then --This makes it "tile" seamlessly
		backgroundY = backgroundY - 64
	end

	
	for i,v in ipairs(asteroidList) do
		if CheckCollision(objectPlayerShip.x,objectPlayerShip.y-6,11,11, v.x+3,v.y+3,3,3) then
			collisionCheck = "Yes"
			if objectPlayerShip.iframe <= 0 then
				objectPlayerShip.Health= objectPlayerShip.Health - 1
				objectPlayerShip.iframe = 5
			end
		else
			collisionCheck = "No"
		end

		if v.x >= 70 or v.x <= -10 or v.y >= 70 then --Asteroid removal code
			table.remove(asteroidList,i)
		end
		
	end

	audio.Update()
end

function game:draw()
	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY)
	gameBackgroundAnimation:draw(gameBackgroundTest,backgroundX,backgroundY-gameBackgroundTest:getHeight())
	
	drawPlayerShip()
	love.graphics.draw(objectPolice.Sprite, math.round(objectPolice.x), math.round(objectPolice.y),0,1,1,20,22)
	
	objects.drawThruster()
	for i=0,objectPlayerShip.Health-1 do
			love.graphics.draw(playerShipHealth,0+(i*8),0)
	end
	
	for i,v in ipairs(asteroidList) do
		love.graphics.draw(v.Sprite, math.round(v.x),math.round(v.y),v.Rotation,1,1,4,4)

	end
	
	--We just print variables as a test.
		love.graphics.setFont(font)

		love.graphics.print(distance,24,0)
		love.graphics.print(objectPolice.Velocity,24,8)
		--love.graphics.print(audio.loopStart,8,8)
		--love.graphics.print(audio.position,8,16)
		--love.graphics.print(audio.loopEnd,8,24)
		--love.graphics.print("Collision: " .. collisionCheck,8,40)
		
		graphics.makeCanvas()

end


function love.keypressed(key)
	if key == "space" and Gamestate.current()==game then
		objects.spawnAsteroid(asteroidRandomX[love.math.random(#asteroidRandomX)], love.math.random(0,56))
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
end

return game