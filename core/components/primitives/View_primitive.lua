local Rect = require("Rect_primitive")

---@class DLux.ViewPrimitiveProps: DLux.RectPrimitive
---@field children? DLux.RectPrimitive[] # [INTERNAL]

---@class DLux.ViewPrimitive: DLux.ViewPrimitiveProps
local View = Rect:_extend()

--------------------------------------------------------------------
-- OVERRIDES
--------------------------------------------------------------------

function View:_hitTest(mx, my)
    -- Checks children first, z-order
    for i = #self.children, 1, -1 do
        local h = self.children[i]:_hitTest(mx, my)
        if h then return h end
    end

    return Rect._hitTest(self, mx, my)
end

--------------------------------------------------------------------
-- CHILDREN MANAGEMENT
--------------------------------------------------------------------

---@param child DLux.ElementPrimitive
---@param inherit? boolean
function View:addChild(child, inherit)
    assert(child ~= self, "ERROR: trying to add view as child of itself")
    assert(child.UINode ~= self.UINode, "ERROR: trying to add UINode as child of itself")

    -- if inherit or false then child:_inheritParentStyles(self) end

    table.insert(self.children, child)
    self.UINode:insertChild(child.UINode, #self.children)
end

---@param child DLux.RectPrimitive
function View:removeChild(child)
    for i, v in ipairs(self.children) do
        if v == child then
            self.UINode:removeChild(child.UINode)
            table.remove(self.children, i)
            return
        end
    end
end

function View:clearChildren()
    for _, child in ipairs(self.children) do
        self.UINode:removeChild(child.UINode)
    end
    self.children = {}
end

--------------------------------------------------------------------
-- Love2D API
--------------------------------------------------------------------
---@param dt number
function View:update(dt)
    for _, child in ipairs(self.children) do
        if child.update then
            child:update(dt)
        end
    end
end

function View:draw()
    self.super.draw(self)

    -- Draw children
    local l = self.UINode.layout

    love.graphics.push()

    love.graphics.translate(l:getLeft(), l:getTop())

    for _, child in ipairs(self.children) do
        child:draw()
    end

    love.graphics.pop()
end

---@param props? DLux.ViewPrimitiveProps
function View:new(props)
    ---@class DLux.ViewPrimitive
    local o = View.super.new(self, props)
    o._ElementName = "ViewPrimitive"
    o.children = {}
    return o
end

return View
