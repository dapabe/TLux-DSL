
---@class ItemPrimitive: ElementPrimitive
---@field selectable boolean
local Item = require("Element_primitive"):extend()

function Item:__tostring()
    return "ItemPrimitive"
end

return Item