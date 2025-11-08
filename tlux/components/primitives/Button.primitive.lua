
---@class ButtonPrimitive: TextPrimitive
local Button = require("tlux.components.primitives.Text.primitive"):extend()

Button.eventFn = function() end

function Button:new(event, props)
    if event then self.eventFn = event end
end

---@param menu MenuPrimitive
---@param key string
---@param state table
function Button:onEnter(menu, key, state)
    if menu.funcs.simpleKey(key) == "enter" and state == "pressed" then
        self:eventFn(menu)
    end
end

---@param menu MenuPrimitive
---@param x number
---@param y number
---@param btn 1 | 2
function Button:onPress(menu, x, y, btn)
    if btn == 1 then self:eventFn(menu) end
end

function Button:__tostring()
    return "ButtonPrimitive"
end

return Button