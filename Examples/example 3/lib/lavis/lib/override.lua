--[[
	This will initialise some callback functions that Love2d requires.
	To override these functions just add your stuff *below* the lavis calls
	... So that your code never sees them again (unless you make some use of them)
]]

function love.mousepressed(...)
	lavis.mousepressed(...)
end

function love.mousereleased(...)
	lavis.mousereleased(...)
end

function love.keypressed(...)
	lavis.keypressed(...)
end

function love.mousemoved(...)
	lavis.mousemoved(...)
end

function love.wheelmoved(...)
	lavis.wheelmoved(...)
end