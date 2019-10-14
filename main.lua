clove=require 'clove'
clove.importAll(
	'Images',
	false,
	_G
)


function love.draw()
	love.graphics.draw(img_asset)
end