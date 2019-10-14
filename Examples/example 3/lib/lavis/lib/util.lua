--[[
	Just defines some common functions like aabb collision,etc.
	For users using push you might want to override getCursorPosition
]]

function lavis.aabb(x1,y1,w1,h1, x2,y2,w2,h2)
	w2,h2=w2 or 0,h2 or 0
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

--if something is within bounds of an ellipse
function lavis.pie(x,y,a,b, x0,y0)
	return lavis.aabb(x-a,y-b,2*a,2*b, x0,y0) and 
		(((x-x0)*(x-x0)/(a*a)) + ((y-y0)*(y-y0)/(b*b))<=1)
end

function lavis.getCursorX() return love.mouse.getX() end
function lavis.getCursorY() return love.mouse.getY() end

function lavis.getCursorPosition() return love.mouse.getPosition() end

