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

end

function drawPlayerShip()
	if objectPlayerShip.iframe >0 then
	love.graphics.setColor( 1, 1, 1, blink)
	end
	love.graphics.draw(objectPlayerShip.Sprite, math.round(objectPlayerShip.x), math.round(objectPlayerShip.y),0,1,1,4,8)
	love.graphics.setColor( 1, 1, 1, 1)
end


function objects.playerShipControls(deltaShip)
	if love.keyboard.isDown("up") then
		objectPlayerShip.y = objectPlayerShip.y - objectPlayerShip.Velocity*deltaShip
		objectPlayerShip.Thruster = true
	elseif love.keyboard.isDown("down") then
		objectPlayerShip.y = objectPlayerShip.y + objectPlayerShip.Velocity*deltaShip
		objectPlayerShip.Thruster = false
	elseif love.keyboard.isDown("left") then
		objectPlayerShip.x = objectPlayerShip.x - objectPlayerShip.Velocity*deltaShip
		objectPlayerShip.Thruster = false
	elseif love.keyboard.isDown("right") then
		objectPlayerShip.x = objectPlayerShip.x + objectPlayerShip.Velocity*deltaShip
		objectPlayerShip.Thruster = false
	
	else
		objectPlayerShip.x = math.round(objectPlayerShip.x)
		objectPlayerShip.y = math.round(objectPlayerShip.y)
		objectPlayerShip.Thruster = false
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
		flux.to(objectPolice, 20*deltaPolice*(distance/objectPolice.Velocity), {x = objectPlayerShip.x, y = objectPlayerShip.y + 32}):ease("quadout"):delay(10*deltaPolice)
        
end

        



---asteroid object
asteroidList = {}
asteroidDirList = {"toLeft","toRight"}
asteroidSpinningDir = {"clockwise","counterclockwise"}
asteroidRandomX = {-4,68}

function objects.spawnAsteroid(asteroidX, asteroidY,asteroidVelocity)
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
	objectAsteroid.Velocity = asteroidVelocity or love.math.random(15,40)
	table.insert(asteroidList,objectAsteroid)
end

function objects.moveAsteroid(deltaDebris)
	for i,v in ipairs(asteroidList) do
		if v.Dir == "toLeft" then
			v.x = v.x - v.Velocity*deltaDebris
		elseif v.Dir == "toRight" then
			v.x = v.x + v.Velocity*deltaDebris
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