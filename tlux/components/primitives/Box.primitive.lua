
---@class BoxPrimitive: ElementPrimitive
local Box = require("tlux.components.primitives.Item.primitive")

Box.x, Box.y, Box.w, Box.h = 0, 0, 0, 0
Box.color = {0, 0, 0,0}

function Box:__tostring()
    return "BoxPrimitive"
end


return Box