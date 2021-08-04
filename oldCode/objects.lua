local objects = {}

--playerShip object


function objects.spawnPlayerShip(playerShipX, playerShipY)
	objectPlayerShip = {}
	objectPlayerShip.Sprite = playerShip
	objectPlayerShip.Health = 3
	objectPlayerShip.Velocity = 40
	objectPlayerShip.Score = 0
	objectPlayerShip.x = playerShipX
	objectPlayerShip.y = playerShipY
	objectPlayerShip.Thruster = false

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


---asteroid object
asteroidList = {}
asteroidDirList = {"toLeft","toRight"}
asteroidSpinningDir = {"clockwise","counterclockwise"}
asteroidRandomX = {-4,68}

function objects.spawnAsteroid(asteroidX, asteroidY)
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
	objectAsteroid.Velocity = love.math.random(15,40)
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
		elseif v.SpinDir == "countercloclwise" then
			v.Rotation = v.Rotation - v.SpinVel*deltaDebris
		end
	end
end

return objects