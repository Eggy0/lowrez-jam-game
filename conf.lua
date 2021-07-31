function love.conf(t)
	t.window.title = "Title goes here"
	t.appendidentity = "Identity"           -- Search files in source directory before save directory (boolean)
	t.version = "11.3"                  -- The LÖVE version this game was made for (string)
	t.console = false                   -- Attach a console (boolean, Windows only)

	t.window.width = 64                -- The window width (number)
	t.window.height = 64               -- The window height (number)
	t.window.resizable = false          -- Let the window be user-resizable (boolean)
	t.window.fullscreen = false         -- Enable fullscreen (boolean)
	t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
	t.window.vsync = 1                  -- Vertical sync mode (number)

	t.modules.joystick = true
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.thread = true
	t.modules.physics = true
end
