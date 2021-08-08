local objects = {}
local bulletTimerCount = 0


--playerShip object


function objects.spawnPlayerShip(playerShipX, playerShipY)
	objectPlayerShip = {}
	objectPlayerShip.Sprite = playerShip
	objectPlayerShip.Health = 3
	objectPlayerShip.Score = 0
	objectPlayerShip.Velocity = 40
	objectPlayerShip.Score = 0
	objectPlayerShip.x = playerShipX
	objectPlayerShip.y = playerShipY
	objectPlayerShip.Thruster = false
	objectPlayerShip.iframe = 0
  objectPlayerShip.isDead = false
  objectPlayerShip.hitX = objectPlayerShip.x-1
  objectPlayerShip.hitY = objectPlayerShip.y-8
  objectPlayerShip.hitW = 3
  objectPlayerShip.hitH = 8
  

end

function drawPlayerShip()
	if objectPlayerShip.iframe >0 then
	love.graphics.setColor( 1, 1, 1, blink)
	end
	love.graphics.draw(objectPlayerShip.Sprite, math.round(objectPlayerShip.x), math.round(objectPlayerShip.y),0,1,1,4,8)
	love.graphics.setColor( 1, 1, 1, 1)
end


function objects.playerShipControls(deltaShip)
    if objectPlayerShip.isDead == false then
        objectPlayerShip.hitX = objectPlayerShip.x-1
        objectPlayerShip.hitY = objectPlayerShip.y-8
    
      local direction = {0, 0} -- Create a table with two elements for x and y respectively.
      local isMoving = false
      
      objectPlayerShip.Thruster = false
      
      
      if love.keyboard.isDown("up") then
          direction[2] = direction[2] - 1 -- Subtract 1 from y
          objectPlayerShip.Thruster = true
          isMoving = true

      end
      if love.keyboard.isDown("down") then
          direction[2] = direction[2] + 1 -- Add 1 to y
          isMoving = true
      end
      if love.keyboard.isDown("left") then
          direction[1] = direction[1] - 1 -- Subtract 1 from x
          isMoving = true
      end
      if love.keyboard.isDown("right") then
          direction[1] = direction[1] + 1 -- Add 1 to x
          isMoving = true
      end

      if not isMoving then
          -- Snap to the nearest pixel if we are not moving
          objectPlayerShip.x = math.round(objectPlayerShip.x)
          objectPlayerShip.y = math.round(objectPlayerShip.y)
      else
          -- But if we are moving, then move in the vector represented by direction
          -- now the thing is, for diagonal movement, we'll actually be moving at about 1.414x speed, so we need to divide the movement by the magnitude of the vector
          -- This ensures that the length of this vector is always 1, so when we multiply by our velocity, our speed is (1 * velocity) in that direction (as opposed to 1.414 * velocity)
          -- The 1.414 comes from the fact that our direction needs to be a point on the unit circle.
          -- If we just leave both axes as 1, then that's a point on a *square*, not a circle.
          -- The distance to the corner of a square is longer than the distance to the middle of a square's side.
          -- And, to be precise, the distance is sqrt(2) times the normal distance (1.414x)
          local magnitude = math.sqrt(direction[1]^2 + direction[2]^2)
          if magnitude == 0 then return end
          local velocity = objectPlayerShip.Velocity
          direction[1] = direction[1] / magnitude * velocity
          direction[2] = direction[2] / magnitude * velocity
          
          objectPlayerShip.x = objectPlayerShip.x + direction[1] * deltaShip
          objectPlayerShip.y = objectPlayerShip.y + direction[2] * deltaShip
      end
      if objectPlayerShip.Health <= 0 then
          objectPlayerShip.isDead = true
          
      end
    end

end


function objects.drawThruster()
	if objectPlayerShip.Thruster then
		love.graphics.draw(playerShipThruster, math.round(objectPlayerShip.x-4), math.round(objectPlayerShip.y))
	end
end

---police ship
onPlayerDeathX = {-96,96}

function objects.spawnPolice(policeX, policeY) --The police ship will always follow the player ship's x.
	objectPolice = {}
	objectPolice.Sprite = policeShip
	objectPolice.Health = 3
	objectPolice.Score = 0
	objectPolice.Velocity = 5
	objectPolice.x = policeX
	objectPolice.y = policeY
  objectPolice.BulletTimer = 0.35
  objectPolice.onPlayerDeathX = onPlayerDeathX[love.math.random(#onPlayerDeathX)]
  
  
end

function objects.policeFollow(deltaPolice)
    if objectPlayerShip.isDead == false then
      flux.to(objectPolice, 20*deltaPolice*distance/objectPolice.Velocity, {x = objectPlayerShip.x, y = objectPlayerShip.y + 24}):ease("linear"):delay(10*deltaPolice)
    elseif objectPlayerShip.isDead == true then
      flux.to(objectPolice, 5, {x = objectPolice.onPlayerDeathX, y = objectPlayerShip.y + 96}):ease("linear"):delay(50*deltaPolice)
    end
    if distance <= 48 and objectPlayerShip.isDead == false and (objectPolice.x >= objectPlayerShip.x - 4 or objectPolice.x <= objectPlayerShip.x + 4) then --Produce bullets when in range
        bulletTimerCount = bulletTimerCount + 1*deltaPolice
        if bulletTimerCount >= objectPolice.BulletTimer then
          objects.spawnBullet(objectPolice.x-4, objectPolice.y-20)
          objects.spawnBullet(objectPolice.x+3, objectPolice.y-20)
          bulletTimerCount = 0
        end
    end
    
    if CheckCollision(objectPlayerShip.hitX,objectPlayerShip.hitY,objectPlayerShip.hitW,objectPlayerShip.hitH, objectPolice.x-3,objectPolice.y-18,7,19) or CheckCollision(objectPlayerShip.hitX,objectPlayerShip.hitY,objectPlayerShip.hitW,objectPlayerShip.hitH, objectPolice.x-16,objectPolice.y-10,34,10) then
        objectPlayerShip.Health = 0
    end 
  
end

bulletList = {}

function objects.spawnBullet(bulletX, bulletY)
  objectBullet = {}
  objectBullet.width = 1
  objectBullet.length = 2
  objectBullet.x = bulletX
  objectBullet.y = bulletY
  objectBullet.Velocity = objectPlayerShip.Velocity + 50
  table.insert(bulletList,objectBullet)
end

function objects.moveBullet(deltaBullet)
  for i,v in ipairs(bulletList) do
    v.y = v.y - v.Velocity*deltaBullet
    if CheckCollision(v.x,v.y,v.width,v.length,objectPlayerShip.hitX,objectPlayerShip.hitY,objectPlayerShip.hitW,objectPlayerShip.hitH) and objectPlayerShip.isDead == false then
      objectPlayerShip.Health = 0
      table.remove(bulletList,i)
    end
    if v.y < objectPlayerShip.y - 70 then
      table.remove(bulletList,i)
      end
  end
  
end



---asteroid object
asteroidList = {}
asteroidDirList = {"toLeft","toRight"}
asteroidSpinningDir = {"clockwise","counterclockwise"}
asteroidRandomX = {-4,68}

function objects.spawnAsteroid(asteroidX, asteroidY,asteroidVelocityX)
	objectAsteroid = {}
  
	objectAsteroid.Sprite = asteroidGraphics[love.math.random(#asteroidGraphics)]
	objectAsteroid.x = asteroidX
	objectAsteroid.y = asteroidY
	
	if objectAsteroid.x < 32 then
		objectAsteroid.Dir = asteroidDirList[2]
	else
		objectAsteroid.Dir = asteroidDirList[1]
	end
	
	objectAsteroid.SpinDir = asteroidSpinningDir[love.math.random(#asteroidSpinningDir)]
	objectAsteroid.SpinVel = love.math.random(0,10)
	objectAsteroid.Rotation = love.math.random(0,10)
	objectAsteroid.VelocityX = asteroidVelocityX or love.math.random(15,40)
	objectAsteroid.VelocityY = 0
  objectAsteroid.offsetX = 5
  objectAsteroid.offsetY = 4
  objectAsteroid.radius = 4
	table.insert(asteroidList,objectAsteroid)
end

function objects.moveAsteroid(deltaDebris)
	for i,v in ipairs(asteroidList) do
		if v.Dir == "toLeft" then
			v.x = v.x - v.VelocityX*deltaDebris
		elseif v.Dir == "toRight" then
			v.x = v.x + v.VelocityX*deltaDebris
		end
	end
end

function objects.rotateAsteroid(deltaDebris)
	for i,v in ipairs(asteroidList) do
		if v.SpinDir == "clockwise" then
			v.Rotation = v.Rotation + v.SpinVel*deltaDebris
		else
			v.Rotation = v.Rotation - v.SpinVel*deltaDebris
		end
	end
end

--Medium asteroid object


function objects.spawnMedAsteroid(asteroidX, asteroidY,asteroidVelocityX)
  objectMedAsteroid = {}
  
	objectMedAsteroid.Sprite = asteroidGraphics[love.math.random(#asteroidGraphics)]
	objectMedAsteroid.x = asteroidX
	objectMedAsteroid.y = asteroidY
	
	if 	objectMedAsteroid.x < 32 then
			objectMedAsteroid.Dir = asteroidDirList[2]
	else
			objectMedAsteroid.Dir = asteroidDirList[1]
	end
	
  objectMedAsteroid.SpinDir = asteroidSpinningDir[love.math.random(#asteroidSpinningDir)]
  objectMedAsteroid.SpinVel = love.math.random(0,10)
	objectMedAsteroid.Rotation = love.math.random(0,10)
	objectMedAsteroid.VelocityX = asteroidVelocityX or love.math.random(15,40)
	objectMedAsteroid.VelocityY = 0
  objectMedAsteroid.offsetX = 5
  objectMedAsteroid.offsetY = 4
  objectMedAsteroid.radius = 1
	table.insert(asteroidList,objectMedAsteroid)

end



return objects