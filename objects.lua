local objects = {}

--playerShip object


function objects.spawnPlayerShip(playerShipX, playerShipY)
	objectPlayerShip = {}
	objectPlayerShip.Sprite = playerShip
	objectPlayerShip.Health = 3
	objectPlayerShip.Velocity = 40
	objectPlayerShip.x = playerShipX
	objectPlayerShip.y = playerShipY

end

function objects.playerShipControls(deltaShip)
	if love.keyboard.isDown("up") then
		objectPlayerShip.y = objectPlayerShip.y - objectPlayerShip.Velocity*deltaShip
	end
	if love.keyboard.isDown("down") then
		objectPlayerShip.y = objectPlayerShip.y + objectPlayerShip.Velocity*deltaShip
	end
	if love.keyboard.isDown("left") then
		objectPlayerShip.x = objectPlayerShip.x - objectPlayerShip.Velocity*deltaShip
	end
		if love.keyboard.isDown("right") then
		objectPlayerShip.x = objectPlayerShip.x + objectPlayerShip.Velocity*deltaShip
	end

end


---asteroid object
asteroidList = {}
function objects.spawnAsteroid(asteroidX, asteroidY)
	objectAsteroid = {}
	objectAsteroid.Sprite = asteroidGraphics[love.math.random(#asteroidGraphics)]
	objectAsteroid.x = asteroidX
	objectAsteroid.y = asteroidY
	table.insert(asteroidList,objectAsteroid)
end

return objects