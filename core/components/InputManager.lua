---@class MapCursors
---@field hand love.Cursor

---@class DLux.InputManager
---@field cursors MapCursors
---@field hoverables DLux.ElementPrimitive[]
---@field pressed nil | DLux.ElementPrimitive
local InputManager = {}
InputManager.__index = InputManager

---@param element DLux.ElementPrimitive
function InputManager:register(element)
    table.insert(self.hoverables, element)
end

function InputManager:clear()
    self.hoverables = {}
end

---@param mx number
---@param my number
function InputManager:mousemoved(mx, my)
    self._mouseX = mx
    self._mouseY = my
    -- for _, el in ipairs(self.hoverables) do
    --     if el._handleMouseMove then
    --         el:_handleMouseMove(mx, my)
    --     end
    -- end
end

---@param mx number
---@param my number
---@param btn integer # Mouses can have more than 3 buttons, wheel counts as a the 3rd button
function InputManager:mousepressed(mx, my, btn)
    if self.hovered and self.hovered.onPress then
        self.pressed = self.hovered
        self.hovered:onPress(mx, my, btn)
    end
end

---@param mx number
---@param my number
---@param btn integer # Mouses can have more than 3 buttons, wheel counts as a the 3rd button
function InputManager:mousereleased(mx, my, btn)
    for i = #self.hoverables, 1, -1 do
        local el = self.hoverables[i]
        if el._handleMouseRelease then
            el:_handleMouseRelease(mx, my, btn)
        end
    end
end

---@param rootElement DLux.ViewPrimitive
function InputManager:updateHover(rootElement)
    local hit = rootElement:_hitTest(self._mouseX, self._mouseY)
    if hit ~= self.hovered then
        -- salir del anterior
        if self.hovered and self.hovered.onHoverEnd then
            self.hovered:onHoverEnd()
        end

        -- entrar al nuevo
        if hit and hit.onHoverEnter then
            hit:onHoverEnter()
        end

        self.hovered = hit
    end
end

function InputManager:applyCursor()
    if not self.hovered then
        self:clear()
        return
    end
    if self.hovered.cursorHover then
        love.mouse.setCursor(self.cursors[self.hovered.cursorHover])
    else
        love.mouse.setCursor()
    end
end

--- Used in RouterManager
---@param dt number
---@param root DLux.ViewPrimitive
function InputManager:_update(dt, root)
    -- self:updateHover( root)
    -- self:applyCursor()
end

local cbs = {
    "mousemoved", "mousereleased", "mousepressed"
}
function InputManager:_hook()
    for _, event in ipairs(cbs) do
        local oldCallback = love[event]
        love[event] = function(...)
            if oldCallback then oldCallback(...) end
            self[event](self, ...)
        end
    end
end

function InputManager.new()
    local o = setmetatable({}, InputManager)
    o.cursors = {
        hand = love.mouse.getSystemCursor("hand")
    }
    o.hoverables = {}
    o.hovered = nil
    o.pressed = nil
    o:_hook()
    return o
end

return InputManager
