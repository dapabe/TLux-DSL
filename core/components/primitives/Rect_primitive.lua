local Element = require("Element_primitive")
local applyStyleProps = require("applyStyleProps")

---@class DLux.RectPrimitiveProps: DLux.ElementPrimitive

---@class DLux.RectPrimitive: DLux.RectPrimitiveProps
---@field update? fun(self: self, dt: number)
local Rect = Element:_extend()

--------------------------------------------------------------------
-- INTERNAL
--------------------------------------------------------------------

---@param parent DLux.RectPrimitive
function Rect:_inheritParentStyles(parent)
    self.bgColor = parent.bgColor
    self.borderRadius = parent.borderRadius
end

function Rect:_hitTest(mx, my)
    local l = self.UINode.layout
    if not l then return nil end
    local x = l:getLeft()
    local y = l:getTop()
    local w = l:getWidth()
    local h = l:getHeight()

    if mx >= x and mx <= x + w and my >= y and my <= y + h then
        return self
    end
    return nil
end

--------------------------------------------------------------------
-- PUBLIC
--------------------------------------------------------------------

function Rect:draw()
    if not self.UINode or not self.UINode.layout then return end

    local l = self.UINode.layout
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill",
        l:getLeft(), l:getTop(),
        l:getWidth(), l:getHeight(),
        self.borderRadius[1], self.borderRadius[2]
    )
    if self.debugOutline then
        love.graphics.setColor(0, 1, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", l:getLeft(), l:getTop(), l:getWidth(), l:getWidth())
    end
end

---@param props? DLux.RectPrimitiveProps
function Rect:new(props)
    local o = Rect.super.new(self, props)
    o._ElementName = "RectPrimitive"
    return o
end

return Rect
