graphics = require("code/graphics")
audio = require ("code/audio")
objects = require("code/objects")
Gamestate = require ("code/gamestate")
anim8 = require ("code/anim8")
flux = require("code/flux")
local resolutionTest, resolutionTestAnimation
local backgroundX, backgroundY, backgroundYTimer

menu = require("code/states/test1")
game = require("code/states/test2")

mainMenu = require("code/states/mainMenu")


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
	font = love.graphics.newFont(8) --Debug only	



	-- This allows debugging in zbstudio
	if arg[#arg] == '-debug' then require('mobdebug').start() end
	
	math.round = function(n)
		return math.floor(n + 0.5)
	end

	canvas = love.graphics.newCanvas(canvas_width, canvas_height)
	canvas:setFilter("nearest","nearest")
	
	graphics.loadGraphics()
	Gamestate.registerEvents()
    --Gamestate.switch(menu)
	Gamestate.switch(game)
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

end
