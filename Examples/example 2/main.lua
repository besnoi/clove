clove=require 'clove'

gAssets=clove.importAll("assets",true)

gAssets['ready']:play()

function love.draw()
	love.graphics.draw(gAssets['mountain range'])

	love.graphics.setFont(gAssets['Kenney Mini'])
	love.graphics.print("Hello World")
end
