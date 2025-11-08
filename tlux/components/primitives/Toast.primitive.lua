
---@class ToastPrimitive: TextPrimitive
local Toast = require("tlux.components.primitives.Text.primitive")



function Toast:new(props)

end

---@param x number
---@param y number
---@param btn 1 | 2
function Toast:onPress(x, y, btn)
end

function Toast:onPressEnd()

end

function Toast:__tostring()
    return "ToastPrimitive"
end

return Toast