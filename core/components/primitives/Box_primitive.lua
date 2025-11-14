
---@class BoxPrimitive: ElementPrimitive, DLux.UILayoutPrimitive
local Box = require("Item_primitive"):extend()

---@type luyoga.Node
Box.UINode = nil
Box.debugOutline = false

Box.x, Box.y, Box.w, Box.h = 0, 0, 0, 0
Box.color = {0, 0, 0, 0}
Box.padding = 0
Box.size = {flexGrow = 1}
Box.hasFocus = false

function Box:drawDebugOutline()
    local l = self.UINode.layout
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", l:getLeft(), l:getTop(), l:getWidth(), l:getWidth())
end

function Box:__tostring()
    return "BoxPrimitive"
end

function Box:_updateLayout()
end

return Box