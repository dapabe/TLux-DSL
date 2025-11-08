
---@param path string
_G.__dirname = function(path) return  path:match("(.-)[^%.]+$") end