--[[
	About this module-
	Think of it as WidgetManager Class. It manages all the widgets you created
	so you can be sure none of them flys to space. Moreover instead of rendering
	each widget (which is not recommended for a reason) you render all of them
	at one go- thanks to *this* module
]]

local LIB_PATH=(...)


lavis={
	widgets={} --note widget is a class and widgets is a collection of its objects
}

lavis.Class=require(LIB_PATH..'.lib.third-party.class')
require(LIB_PATH..'.lib.util')
require(LIB_PATH..'.widgets.Widget')
require(LIB_PATH..'.widgets.ImageButton')

function forEachWidgetC(func,cond,...)
	for _,widget in ipairs(lavis.widgets) do
		if widget[cond] then
			widget[func](widget,...)
		end
	end
end
function lavis.forEachWidget(func)
	for _,widget in ipairs(lavis.widgets) do func(widget) end
end

function lavis.getWidget(id)
	return lavis.widgets[id]
end

function lavis.getWidgetID(id)
	if type(id)=='string' then
		_,id=lavis.getWidgetByName(id)
		return id
	end
	for i=1,#lavis.widgets do
		if lavis.widgets[i]==id then
			return i
		end
	end
end

function lavis.getWidgetByName(name)
	for i,widget in ipairs(lavis.widgets) do
		if widget.name==name then
			return widget,i
		end
	end
end

function lavis.removeWidget(id)
	id=type(id)=='number' and id or lavis.getWidgetID(id)
	table.remove(lavis.widgets,id)
end

function lavis.mousepressed(...) forEachWidgetC('mousepressed','enabled',...) end
function lavis.keypressed(...) forEachWidgetC('keypressed','enabled',...) end
function lavis.mousereleased(...) forEachWidgetC('mousereleased','enabled',...) end
function lavis.mousemoved(...) forEachWidgetC('mousemoved','enabled',...) end
function lavis.wheelmoved(...) forEachWidgetC('wheelmoved','enabled',...) end
function lavis.update(dt) forEachWidgetC('update','enabled',dt) end
function lavis.draw() forEachWidgetC('render','visible') end
function lavis.setWireframe(val) lavis.forEachWidget(function(w) w:setWireframe(val) end) end
function lavis.enableAll() lavis.forEachWidget(function(w) w.enabled=true end) end
function lavis.disableAll() lavis.forEachWidget(function(w) w.enabled=false end) end
function lavis.showAll() lavis.forEachWidget(function(w) w.visible=true end) end
function lavis.hideAll() lavis.forEachWidget(function(w) w.visible=false end) end
function lavis.toggleVisibility() lavis.forEachWidget(function(w) w.visible=not w.visible end) end

function lavis.new(...) return lavis.widget(...) end

require (LIB_PATH..'.lib.override')

