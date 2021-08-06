local objects = {}

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

function objects.spawnPolice(policeX, policeY) --The police ship will always follow the player ship's x.
	objectPolice = {}
	objectPolice.Sprite = policeShip
	objectPolice.Health = 3
	objectPolice.Score = 0
	objectPolice.Velocity = 5
	objectPolice.x = policeX
	objectPolice.y = policeY
	objectPlayerShip.Thruster = false
end

function objects.policeFollow(deltaPolice)
		flux.to(objectPolice, 20*deltaPolice*distance/objectPolice.Velocity, {x = objectPlayerShip.x, y = objectPlayerShip.y + 24}):ease("linear"):delay(10*deltaPolice)
    if objectPlayerShip.isDead == true then
          flux.to(objectPolice, 5, {x = objectPlayerShip.x, y = objectPlayerShip.y + 128}):ease("linear"):delay(50*deltaPolice)
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

--main menu



return objects