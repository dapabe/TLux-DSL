local SceneContainer = require("core.components.SceneContainer")

---@alias RouteEvent "enter" | "leave" | "pause" | "resume" |"push" | string

local loveCallbacks = {
	'directorydropped',
	'draw',
	'filedropped',
	'focus',
	'gamepadaxis',
	'gamepadpressed',
	'gamepadreleased',
	'joystickaxis',
	'joystickhat',
	'joystickpressed',
	'joystickreleased',
	'joystickremoved',
	'keypressed',
	'keyreleased',
	'load',
	'lowmemory',
	'mousefocus',
	'mousemoved',
	'mousepressed',
	'mousereleased',
	'quit',
	'resize',
	'run',
	'textedited',
	'textinput',
	'threaderror',
	'touchmoved',
	'touchpressed',
	'touchreleased',
	'update',
	'visible',
	'wheelmoved',
	'joystickadded',
}

---@param duration number
---@param callback function
---@param finish? function
---@return fun(dt: number): boolean
local function animate(duration, callback, finish)
	local t = 0

	local function update(dt)
		t = t + dt
		local k = math.min(t / duration, 1)
		callback(k)
		if k == 1 and finish then
			finish(); return true
		end
	end

	return update
end

-- returns a list of all the items in t1 that aren't in t2
local function exclude(t1, t2)
	local set = {}
	for _, item in ipairs(t1) do set[item] = true end
	for _, item in ipairs(t2) do set[item] = nil end
	local t = {}
	for item, _ in pairs(set) do
		table.insert(t, item)
	end
	return t
end

---@alias AnimMode "slide" | "fade"

---@class TransitionAnimation
---@field mode AnimMode
---@field prev DLux.FileRoute
---@field next DLux.FileRoute
---@field reverse? boolean

---@class RouterManager
---@field _routes DLux.FileRoute[]
---@field _tabs DLux.FileRoute[]
---@field rootNode luyoga.Node
local Manager = {}
Manager.__index = Manager

-------------------------------------------------------------------
-- INTERNAL
-------------------------------------------------------------------

---@param route DLux.FileRoute
---@return DLux.FileRoute
function Manager:_mountRoute(route)
	if route.new then route = route:new() end

	assert(route.routeNode,
		("[RouterManager] ERROR(_mountRoute) <%s> requires luyoga node"):format(route.routeName))
	self.rootNode:removeAllChildren()
	self.rootNode:insertChild(route.routeNode.UINode, 1)
	self.rootNode:calculateLayout(self.rootNode.layout:getWidth(), self.rootNode.layout:getHeight(),
		Yoga.Enums.Direction.LTR)
	return route
end

function Manager:refresh(...)
	local top = self:_getTopRoute()
	if not top then return end

	local cls = top.class or top.__index or top.super or nil

	assert(cls, ("[RouterManager] ERROR(refresh): <%s> has no class reference"):format(top.routeName))

	local previous = top

	-- Reinstanciar
	local newInstance = self:_mountRoute(cls)

	-- Mantener el tipo para llamadas posteriores
	newInstance.class = cls

	self._routes[#self._routes] = newInstance

	-- Llamar eventos de refresco
	if newInstance.enter then newInstance:enter(previous, ...) end

	print("[RouterManager] Refreshed: ", newInstance.routeName)
end

function Manager:_getTopRoute()
	return self._routes[#self._routes]
end

---@param event RouteEvent
function Manager:emit(event, ...)
	local route = self:_getTopRoute()
	if route and route[event] then route[event](route, ...) end
end

-------------------------------------------------------------------
-- ROUTING API
-------------------------------------------------------------------

---@param next DLux.FileRoute
-- ---@param animation AnimMode
---@param ... any[]
function Manager:enter(next, ...)
	assert(next, "[RouterManager] ERROR(enter): route cannot be nil")
	local previous = self:_getTopRoute()

	self:emit("leave", next, ...)
	self._routes[#self._routes] = self:_mountRoute(next)
	self._routes[#self._routes].class = next

	self:emit("enter", previous, ...)
end

---@param next DLux.FileRoute
---@param mode AnimMode
---@param ... any[]
function Manager:push(next, mode, ...)
	assert(next, ("[RouterManager] ERROR(push): <%s> cannot be nil"):format(next.routeName))
	local previous = self:_getTopRoute()

	self:emit("pause", next, ...)
	self._routes[#self._routes + 1] = self:_mountRoute(next)
	self._routes[#self._routes].class = next

	self:emit("enter", previous, ...)
end

--- Deletes the current route from the stack and returns to the previous one
function Manager:pop(...)
	local next = self._routes[#self._routes - 1]
	if not next then
		print("[RouterManager] ERROR(pop): no more routes in stack")
		return
	end
	local previous = self:_getTopRoute()


	self:emit("leave", next, ...)
	self._routes[#self._routes] = nil

	self:emit("resume", previous, ...)
end

-------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------

function Manager:setTabs(tabs, index)
	self._tabs = tabs
end

-------------------------------------------------------------------
-- Love2D CALLBACK HOOKING
-------------------------------------------------------------------

---@param options? {include: string[], exclude: string[]}
function Manager:hook(options)
	options = options or {}
	local callbacks = options.include or loveCallbacks
	if options.exclude then callbacks = exclude(callbacks, options.exclude) end
	for _, callbackName in ipairs(callbacks) do
		local oldCallback = love[callbackName]
		love[callbackName] = function(...)
			if oldCallback then oldCallback(...) end
			self:emit(callbackName, ...)
		end
	end
end

-------------------------------------------------------------------
-- PUBLIC
-------------------------------------------------------------------

---@param dt number
function Manager:update(dt)
	local top = self:_getTopRoute()
	InputManager:_update(dt, top.routeNode)
	if top and top.update then top:update(dt) end
end

function Manager:draw()
	local top = self:_getTopRoute()
	if top and top.draw then top:draw() end
	-- if not self.transition then
	-- 	return
	-- end

	-- local mode = self.transition.mode
	-- local prev = self.transition.prev
	-- local next = self.transition.next
	-- local t = self.t / self.duration
	-- local w = love.graphics.getWidth()

	-- if mode == "slide" then
	-- 	love.graphics.push()
	-- 		love.graphics.translate(-w * t, 0)
	-- 		prev:draw()
	-- 	love.graphics.pop()

	-- 	love.graphics.push()
	-- 		love.graphics.translate(w - w * t, t)
	-- 		next:draw()
	-- 	love.graphics.pop()
	-- elseif mode == "fade" then
	-- 	prev:draw()
	-- 	love.graphics.setColor(1, 1, 1, t)
	-- 	next:draw()
	-- 	love.graphics.setColor(1, 1, 1, 1)
	-- end
end

local Router = {}

function Manager:initYoga(width, height)
	self.rootNode = Yoga.Node.new()
	self.rootNode.style:setFlexGrow(1)
	self.rootNode.style:setFlexDirection(Yoga.Enums.FlexDirection.Column)
	self.rootNode:calculateLayout(width, height, Yoga.Enums.Direction.LTR)
end

function Router.new()
	local o = setmetatable({}, Manager)
	o._routes = {}
	o._tabs = {}
	return o
end

return Router
