---@class DLux.FileRoute
---@field super self
local FileRoute = {}
FileRoute.__index = FileRoute

function FileRoute:new()
    local o = setmetatable({}, self)
    o.routeNode = GUI.View:new({ flexGrow = 1 })
    return o
end

function FileRoute:extend()
    local cls = setmetatable({}, self)
    cls.__index = cls
    cls.super = self
    return cls
end

function FileRoute:update(dt)
    self.routeNode:update(dt)
end

function FileRoute:draw()
    self.routeNode:draw()
end

return FileRoute
