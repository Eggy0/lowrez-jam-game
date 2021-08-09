local powerup = {}
local powerupEffects = {"speed up", "health up", "invincible", "special"}
powerupList = {}
powerupTimer = 0
powerupFlag = false
powerupActive = false
powerupSpeedValue = 0
powerupOriginalSpeedValue = 0--Needed for temporary effects
--Speed Powerup (default)

powerup.Effect = powerupEffects[1] --Set the effect
powerup.Value = 10 --Strength of effect
powerup.Time = 0 --In seconds (0 if it's permanent)
powerup.x = 0
powerup.y = 0
powerup.Velocity = 2

powerup.__index = powerup

function powerup.spawnSpeed(powerX, powerY)
    SpeedPowerup = setmetatable({
        x = powerX, 
        y = powerY,
        Sprite = powerSpeed,
        Time = 5
        },powerup)
    table.insert(powerupList,SpeedPowerup)
end
function powerup.spawnSuperSpeed(powerX, powerY)
    SuperSpeedPowerup = setmetatable({
        x = powerX, 
        y = powerY,
        Sprite = powerSuperSpeed,
        Time = 5,
        Value = 30
        },powerup)
    table.insert(powerupList,SuperSpeedPowerup)
end
function powerup.spawnPermaSpeed(powerX, powerY)
    PermaSpeedPowerup = setmetatable({
        x = powerX, 
        y = powerY,
        Sprite = powerPermaSpeed,
        Value = 15
        },powerup)
    table.insert(powerupList,PermaSpeedPowerup)
end

function powerup.spawnHealth(powerX, powerY)
    HealthPowerup = setmetatable({
        x = powerX, 
        y = powerY,
        Sprite = powerHealth,
        Value = 1,
        Effect = powerupEffects[2]
        },powerup)
    table.insert(powerupList,HealthPowerup)
end

function powerup.spawnInvincibility(powerX, powerY)
    InvincibilityPowerup = setmetatable({
        x = powerX, 
        y = powerY,
        Sprite = powerInvincible,
        Value = 10,
        Effect = powerupEffects[3]
        },powerup)
    table.insert(powerupList,InvincibilityPowerup)
end





function powerup.movePowerup(deltaPower)
    if powerupTimer < 0 then
        powerupTimer = 0
        if powerupSpeedValue ~= 0 then
            powerupSpeedValue = powerupOriginalSpeedValue
            objectPlayerShip.Velocity = powerupSpeedValue
            powerupFlag = true
        end  
    end
    if powerupTimer > 0 then
        powerupTimer = powerupTimer - 1*deltaPower
        powerupActive = true
    else
        powerupActive = false
    end
    if powerupFlag == true then
      objectPlayerShip.Velocity = powerupSpeedValue
      powerupFlag = false
    end
    for i,v in ipairs(powerupList) do
			v.y = v.y + v.Velocity*deltaPower
      if circleRectangleIntersect(v.x,v.y, 4,objectPlayerShip.hitX,objectPlayerShip.hitY,objectPlayerShip.hitW,objectPlayerShip.hitH) then
        if v.Effect == "speed up" then
          if v.Time >= 0 then
            if powerupActive == false then
              powerupOriginalSpeedValue = objectPlayerShip.Velocity
              powerupSpeedValue = objectPlayerShip.Velocity + v.Value
            elseif powerupActive == true and powerupSpeedValue ~= v.Value then
              poweruppeedValue = powerupOriginalSpeedValue
              powerupSpeedValue = powerupOriginalSpeedValue + v.Value
            end  
            powerupTimer = v.Time
            powerupFlag = true
          else
            objectPlayerShip.Velocity = objectPlayerShip.Velocity + v.Value
          end
        end

        if v.Effect == "health up" and objectPlayerShip.Health < 3 then
            objectPlayerShip.Health = objectPlayerShip.Health + v.Value
        end
        if v.Effect == "invincible" then
            objectPlayerShip.iframe = v.Value
        end
        table.remove(powerupList,i)
      end
		end
end



return powerup