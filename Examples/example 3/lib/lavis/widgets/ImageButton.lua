lavis.imageButton=lavis.Class
{
	__includes=lavis.widget,
}

function lavis.imageButton:init(url,x,y,...)
	self:setImage(url)
	x,y=x or 0,y or 0
	if (...) then
		self:initWidget(x,y,...)
	else
		self:initWidget(x,y,"box",self.image:getDimensions())
	end		
end

