local objects = {}

--playerShip object


function objects.spawnPlayerShip(playerShipX, playerShipY)
	objectPlayerShip = {}
	objectPlayerShip.Sprite = playerShip
	objectPlayerShip.Health = 3
	objectPlayerShip.Velocity = 40
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
asteroidDirectionList = {"toLeft","toRight"}
asteroidSpinningDir = {"clockwise","counterclockwise"}
function objects.spawnAsteroid(asteroidX, asteroidY)
	objectAsteroid = {}
	objectAsteroid.Sprite = asteroidGraphics[love.math.random(#asteroidGraphics)]
	objectAsteroid.x = asteroidX
	objectAsteroid.y = asteroidY
	objectAsteroid.direction = 0
	objectAsteroid.Velocity = 0
	table.insert(asteroidList,objectAsteroid)
end

return objects