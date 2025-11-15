
---@class DLux.FileRoute
local FileRoute = {}
FileRoute.__index = FileRoute

function FileRoute:new()
end

function FileRoute:__call(...)
    return setmetatable({}, self):new()
end

return FileRoute