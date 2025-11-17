local Route = FileRoute:extend()
Route.routeName = "Root"

function Route:new()
    local o = Route.super.new(self)

    local header = GUI.View:new({ h = 50, flexDir = "row", flexJustify = "between", bgColor = { 1, 1, 1 } })
    local box1 = GUI.Rect:new({ w = 50, h = 50, bgColor = { 0, 0, 1 } })
    local box2 = GUI.Rect:new({ w = 50, h = 50, bgColor = { 0, 1, 1 } })
    header:addChild(box1)
    header:addChild(box2)

    local body = GUI.View:new({ flexGrow = 1, bgColor = { .8, 0.1, 0.3 }, debugOutline = true, cursorHover = "hand" })
    o.routeNode:addChild(header)
    o.routeNode:addChild(body)
    return o
end

function Route:enter(next)
end

function Route:update(dt)
    Route.super.update(self, dt)
end

function Route:keypressed(key)
    if key == "a" then RouterManager:push(RouteList.Profile, "slide") end
    if key == "s" then RouterManager:pop("fade") end
end

function Route:draw()
    Route.super.draw(self)
    -- FileRoute.draw(self)
end

return Route
