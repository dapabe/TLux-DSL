local View = require("View_primitive")
local Rect = require("Rect_primitive")
local applyNodeProps = require("applyNodeProps")

---@class SceneContainer: DLux.ViewPrimitive
---@field offsetX number
---@field opacity number
---@field screen DLux.ViewPrimitive
local SceneContainer = View:_extend()

---@param screen DLux.ViewPrimitive
function SceneContainer:new(screen)
    ---@class SceneContainer
    local base = View.new(self, {
        position = "absolute",
        left = 0,
        top = 0,
        right = 0,
        bottom = 0
    })
    base.x = 0
    base.y = 0
    base.offsetX = 0
    base.opacity = 1
    base.screen = screen

    base:addChild(screen)

    return base
end

---@param x number
function SceneContainer:setX(x)
    self.offsetX = x
    applyNodeProps(self.UINode.style, { left = x })
end

---@param v number
function SceneContainer:setOpacity(v)
    self.opacity = v
    applyNodeProps(self.UINode.style, { opacity = v })
end

function SceneContainer:update(dt)
    View.update(self, dt)
    if self.screen.update then self.screen:update(dt) end
end

function SceneContainer:draw()
    View.draw(self)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    self.screen:draw()
    love.graphics.pop()
end

return SceneContainer
