local Route = FileRoute:extend()
Route.routeName = "Profile"

function Route:new()
    local o = Route.super.new(self)
    local Header = GUI.View:new({ flexGrow = 1, bgColor = { 0, 0, 1 } })

    o.routeNode:addChild(Header)
    return o
end

function Route:keypressed(key)
    if key == "a" then RouterManager:pop("slide") end
end

return Route
