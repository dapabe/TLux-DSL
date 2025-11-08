
---@class ItemPrimitive: ElementPrimitive
---@field selectable boolean
local Item = require("tlux.components.primitives.Element.primitive"):extend()

function Item:__tostring()
    return "ItemPrimitive"
end

return Item