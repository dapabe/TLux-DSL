local applyStyleProps = require "applyStyleProps"

---@class CursorMap
---@field hover love.Cursor

---@class PrimitiveEventProps
---@field _isHovered? boolean
---@field _isPressed? boolean

---@class DLux.ElementPrimitiveProps: DLux.UIPropsExtra, PrimitiveEventProps
---@field _ElementName? string
---@field bgColor? table<number, number, number, number>
---@field borderRadius? table<number, number> # X, Y
---@field cursorHover? string

---@class DLux.ElementPrimitive: DLux.ElementPrimitiveProps
---@field super? self
---@field _hitTest? fun(self: self, mx: number, my: number): self | nil
local Element = {}
Element.__index = Element

--------------------------------------------------------------------
-- INTERNAL
--------------------------------------------------------------------

function Element:_extend()
    local cls = setmetatable({}, self)
    -- for k, v in pairs(self) do
    --     if k:find("__") == 1 then cls[k] = v end
    -- end
    cls.__index = cls
    cls.super = self

    return cls
end

function Element:_implement(...)
    for _, cls in pairs({ ... }) do
        for k, v in pairs(cls) do
            if self[k] == nil then self[k] = v end
        end
    end
end

function Element:_isElement(T)
    local mt = getmetatable(self)
    while mt do
        if mt == T then
            return true
        else
            mt = getmetatable(mt)
        end
    end
    return false
end

-- function Element:__call(...)
--     return setmetatable({}, self):new()
-- end

function Element:_resetEventState()
    self._isHovered = false
    self._isPressed = false
end

--------------------------------------------------------------------
-- HIT TEST (Triggered by input manager)
--------------------------------------------------------------------

function Element:_handleMouseMove(mx, my)
    local inside = self:_hitTest(mx, my)

    if inside and not self._isHovered then
        self._isHovered = true
        self:onHoverEnter()
    elseif not inside and self._isHovered then
        self._isHovered = false
        self:onHoverEnd()
    end
end

function Element:_handleMousePress(mx, my, button)
    if self:_hitTest(mx, my) then
        self._isPressed = true
        self:onPress(mx, my, button)
    end
end

function Element:_handleMouseRelease(mx, my, button)
    if self._isPressed then
        self._isPressed = false
        self:onRelease(mx, my, button)
    end
end

--------------------------------------------------------------------
-- PUBLIC OVERRIDABLE EVENTS
--------------------------------------------------------------------
function Element:onHoverEnter() end

function Element:onHoverEnd() end

---@param mx number
---@param my number
---@param btn integer # Mouses can have more than 3 buttons, wheel counts as a the 3rd button
function Element:onPress(mx, my, btn) end

---@param mx number
---@param my number
---@param btn integer # Mouses can have more than 3 buttons, wheel counts as a the 3rd button
function Element:onRelease(mx, my, btn) end

---@param dt number
function Element:update(dt) end

function Element:draw() end

---@param props? DLux.ElementPrimitiveProps
function Element:new(props)
    local o = setmetatable({}, self)
    o._ElementName = "ElementPrimitive"
    o.UINode = Yoga.Node.new()
    props = props or {}
    applyStyleProps(o.UINode.style, props)
    o.debugOutline = props.debugOutline or false
    o.bgColor = props.bgColor or { 0, 0, 0, 0 }
    o.borderRadius = props.borderRadius or { 0, 0 }


    o:_resetEventState()
    InputManager:register(o)
    return o
end

return Element
