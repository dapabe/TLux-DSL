
---@class ButtonPrimitive: TextPrimitive
local Button = require("Text_primitive"):extend()

Button.pressed = false
Button.hovered = false

Button.color = {.5, .5, .8}
Button.colorHover = {.7, .7, .9}


Button.eventFn = function() end

function Button:isHovered()
    local mx, my = love.mouse.getPosition()
    return mx > self.x and mx < self.x + self.w and my > self.y and my < self.y + self.h
end

---@param btn 1 | 2
---@param x number
---@param y number
function Button:onPress(btn, x, y)
    if btn == 1 then
        self.pressed = true
        self:eventFn()
     end
end

function Button:__tostring()
    return "ButtonPrimitive"
end

---@param callback function
---@param props ButtonPrimitive
function Button:new(callback, props)
    if callback then self.eventFn = callback end
    for key, value in pairs(props) do
        if key == "children" then goto continue end
        self[key] = value
        ::continue::
    end
    return self
end

function Button:_update()
    self.hovered = self:isHovered()
end

function Button:_draw()
    local prevColor = self.color
    if self.hovered then self.color = self.colorHover
    else self.color = prevColor end

    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",
        self._computed.x, self._computed.y,
        self._computed.width, self._computed.height
    )
end


return Button