--playerShip object
function spawnPlayerShip(playerShipX, playerShipY)
	objectPlayerShip = {}
	objectPlayerShip.Sprite = playerShip
	objectPlayerShip.Health = 3
	objectPlayerShip.Velocity = 1
	objectPlayerShip.x = playerShipX
	objectPlayerShip.y = playerShipY
end


---asteroid object
function spawnAsteroid(asteroidX, asteroidY)
	objectAsteroid = {}
	objectAsteroid.Sprite = asteroidGraphics[math.random(#asteroidGraphics)]
	objectAsteroid.x = asteroidX
	objectAsteroid.y = asteroidY
end