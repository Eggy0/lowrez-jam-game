local objects = {}

--playerShip object
asteroidList = {}

function objects.spawnPlayerShip(playerShipX, playerShipY)
	objectPlayerShip = {}
	objectPlayerShip.Sprite = playerShip
	objectPlayerShip.Health = 3
	objectPlayerShip.Velocity = 1
	objectPlayerShip.x = playerShipX
	objectPlayerShip.y = playerShipY
end


---asteroid object
function objects.spawnAsteroid(asteroidX, asteroidY)
	objectAsteroid = {}
	objectAsteroid.Sprite = asteroidGraphics[love.math.random(#asteroidGraphics)]
	objectAsteroid.x = asteroidX
	objectAsteroid.y = asteroidY
	table.insert(asteroidList,objectAsteroid)
end

return objects