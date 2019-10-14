clove=require 'clove'

clove.importAll("assets",true,_G) --> _G is returned!
ready:play()

function love.draw()
	love.graphics.draw(mountain_range)

	love.graphics.setFont(Kenney_Mini)
	love.graphics.print("Hello World")
end
