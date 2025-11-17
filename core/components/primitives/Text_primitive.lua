---@class DLux.TextPrimitiveProps: DLux.RectPrimitiveProps
---@field _text? string # [INTERNAL]
---@field textColor? table<number, number, number, number>
---@field textAlign? string
---@field rotation? number # 0 - 360 deg
---@field font? love.Font | nil

---@class DLux.TextPrimitive: DLux.TextPrimitiveProps
local Text = require("Rect_primitive"):_extend()

local DEFAULT_COLOR = { 0, 0, 0, 1 }

--------------------------------------------------------------------
-- INTERNAL
--------------------------------------------------------------------
---
function Text:_computeNaturalSize()
    local f = self.font
    self._naturalWidth = f:getWidth(self._text)
    self._naturalHeight = f:getHeight()
end

function Text:_recalculateSize()
    local font = self.font

    local parentWidth = self.UINode:getParent()
        and self.UINode:getParent().layout:getWidth()
        or love.graphics.getWidth()

    local _, lines = font:getWrap(self._text, parentWidth)

    local textWidth = 0
    for _, line in ipairs(lines) do
        local w = font:getWidth(line)
        if w > textWidth then textWidth = w end
    end

    local textHeight = #lines * font:getHeight()

    -- NO llamamos a calculateLayout aquí

    self.UINode.style:setWidth(textWidth)
    self.UINode.style:setHeight(textHeight)

    self._naturalWidth = textWidth
    self._naturalHeight = textHeight
end

--------------------------------------------------------------------
-- PUBLIC
--------------------------------------------------------------------
---@param value string | number | boolean
function Text:setText(value)
    self._text = tostring(value)
    self._needsRecalc = true
end

function Text:update(dt)
    Text.super.update(self, dt)

    local parent = self.UINode:getParent()
    local pw, ph = nil, nil
    if parent then
        pw = parent.layout:getWidth()
        ph = parent.layout:getHeight()
    end

    -- Cambió tamaño del padre → necesita wrap
    if parent and (pw ~= self._lastParentWidth or ph ~= self._lastParentHeight) then
        self._needsRecalc = true
        self._lastParentWidth = pw
        self._lastParentHeight = ph
    end

    -- Solo recalcula su propio width/height (NO llama a calculateLayout)
    if self._needsRecalc then
        self:_recalculateSize()
        self._needsRecalc = false
    end
end

function Text:draw()
    Text.super.draw(self)
    local l = self.UINode.layout
    local x = l:getLeft()
    local y = l:getTop()
    love.graphics.setColor(self.textColor)
    love.graphics.print(self._text, x, y, self.rotation)

    if self.debugOutline then
        love.graphics.setColor(0, 1, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", x, y, l:getWidth(), l:getHeight())
    end
end

---@param value string | number | boolean
---@param props? DLux.TextPrimitiveProps
function Text:new(value, props)
    props = props or {}
    ---@class DLux.TextPrimitive
    local o = Text.super.new(self, props)

    o._ElementName = "TextPrimitive"

    o._text = tostring(value)
    o.textColor = props.textColor or DEFAULT_COLOR
    o.textAlign = props.textAlign or "left"
    o.rotation = props.rotation or 0
    o.font = props.font or love.graphics.getFont()

    o._naturalWidth = 0
    o._naturalHeight = 0

    o._needsRecalc = true
    return o
end

return Text
