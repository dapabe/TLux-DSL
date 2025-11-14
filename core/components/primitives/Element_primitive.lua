
---@class ElementPrimitive
local Element = {}
Element.__index = Element

-- Can be overriden, this instantiates a new element
function Element:new()
end

function Element:extend()
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then cls[k] = v end
    end
    cls.__index = cls
    cls.super = self

    return setmetatable(cls, self)
end

function Element:implement(...)
    for _, cls in pairs({...}) do
        for k, v in pairs(cls) do
            if self[k] == nil then self[k] = v end
        end
    end
end

function Element:isElement(T)
    local mt = getmetatable(self)
    while mt do
        if mt == T then return true
        else mt = getmetatable(mt) end
    end
    return false
end

function Element:__tostring()
    return "ElementPrimitive"
end

function Element:__call(...)
    return setmetatable({}, self):new()
end

return Element