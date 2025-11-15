local View = require("View_primitive")
local Rect = require("Rect_primitive")

---@class DLux.FileRoute
local Route = {}
Route.__index = Route

function Route.__tostring()
    return "/"
end

function Route.new()
    local o = setmetatable({}, Route)
    o.routeNode = View:new({flexGrow=1, bgColor={1,1,1}})

    local header = View:new({h=50, flexDir="row", flexJustify = "between", bgColor={1,1,1}}) -- White
    local box1 = Rect:new({ w=50, h=50, bgColor={0,0,1}})
    local box2 = Rect:new({ w=50, h=50, bgColor={0,1,1}})
    header:addChild(box1)
    header:addChild(box2)

    local body = View:new({flexGrow=.2, bgColor={.8,0.1,0.3}, debugOutline = true}) -- Red box

    o.routeNode:addChild(header)
    o.routeNode:addChild(body)
    return o
end

function Route:enter(next)

end

function Route:update()

end

function Route:draw()
end

return Route