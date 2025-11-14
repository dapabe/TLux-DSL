local Yoga = require("luyoga")

---@class ViewPrimitive: BoxPrimitive, DLux.UINode
---@field _update? fun(self: self) # Should be overriden when extended
local View = require("Box_primitive"):extend()

---@type luyoga.Node
View.children = nil
View.accumulatedHeight = 0

View.flexDirection = "row"
View.flexJustify = "start"
View.flexAlign = "start"

---@param children luyoga.Node
function View:setChildren(children)
    self.children = children
    -- If the children doesn't have a width set, give it the width's of this node
    if self.children and (self.children.layout:getWidth() == 0) then
        self.children.style:setWidth(self.w)
    end
end

-- Sync this rect with the computed parent node
function View:syncFromParentNode()
    if not self.UINode then return end
    -- Read computed layout (after root:calculateLayout)
    local lx = self.UINode.layout:getLeft() or 0
    local ly = self.UINode.layout:getTop() or 0
    local lw = self.UINode.layout:getWidth() or self.w
    local lh = self.UINode.layout:getHeight() or self.h

    self.x = lx
    self.y = ly
    self.w = lw
    self.h = lh

    -- Ensure children uses the available space
    if self.children then self.children.style:setWidth(self.w) end
end

function View:_updateLayout()
    if not self.children then return end
    -- Prefer declared height if exists
    local declaredH = self.children.layout:getHeight()
    local calcH = declaredH and declaredH > 0 and declaredH or math.max(self.h, 2000)

    -- Pass real width, uses an exagerated calculated height if height its not declared
    self.children:calculateLayout(self.w, calcH, Yoga.Enums.Direction.LTR)

    -- Update accumulatedHeight
    local realH = self.children.layout:getHeight() or calcH
    self.accumulatedHeight = realH
end

function View:_draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",
        self._computed.x, self._computed.y,
        self._computed.width, self._computed.height
    )
end

return View