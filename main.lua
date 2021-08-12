graphics = require("code/graphics")
audio = require ("code/audio")
objects = require("code/objects")
Gamestate = require ("code/gamestate")
anim8 = require ("code/anim8")
flux = require("code/flux")
Camera = require("code/camera")
konami = require("code/konami")

local resolutionTest, resolutionTestAnimation
stateLeft, stateEntering = nil, nil
musicVolume = 1


menu = require("code/states/test1")
test = require("code/states/testFont")

mainMenu = require("code/states/mainMenu")
game = require("code/states/game")
transition = require("code/states/transition")
--testGame = require("code/states/gameTest")



function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
	scoreFont = love.graphics.newImageFont('graphics/gameplayFont.png', '0123456789',1)
  defaultFont = love.graphics.newImageFont('graphics/defaultFont.png',' ?!.,-ABCDEFGHIJKLMNOPQRSTUVWXYZ',-1)



	-- This allows debugging in zbstudio
	if arg[#arg] == '-debug' then require('mobdebug').start() end
	
	math.round = function(n)
		return math.floor(n + 0.5)
	end

	canvas = love.graphics.newCanvas(canvas_width, canvas_height)
	canvas:setFilter("nearest","nearest")
  

	
	graphics.loadGraphics()
	Gamestate.registerEvents()
    Gamestate.switch(menu)
	--Gamestate.switch(transition)
end

function love.update(dt)
    audio.Update() --This is outside the pause function because the music needs to loop
end

--[[function love.draw()
  love.graphics.setCanvas(canvas)
	love.graphics.clear()
  love.graphics.setCanvas()

  love.graphics.draw(canvas)

end]]
