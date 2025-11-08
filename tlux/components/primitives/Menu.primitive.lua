
---@class MenuPrimitive: ElementPrimitive
---@field internal table
---@field stack MenuPrimitive[]
---@field items ItemPrimitive[]
---@field funcs table
local Menu = require("tlux.components.primitives.Element.primitive"):extend()

--- Defaults

Menu.current = 1
Menu.background = {.25, .25, .25, .25}
Menu.locked = false
Menu.defaultHeight = 10
Menu.x, Menu.y, Menu.ox, Menu.oy = 0, 0, 0, 0
Menu.w, Menu.h = 0, 0

---@param items table<ItemPrimitive>
---@param props table
function Menu:new(items, props)
    if #items == 0 then
        --- Must be at least 1 item
        items[1] = {selectable = true} --[[@as ItemPrimitive]]
    end
    self.items = items

    if props then
        for k, v in pairs(props) do
            self[k] = props[k]
        end
    end

    self.stack = {}
    self.internal = {}
end

---@return ItemPrimitive
function Menu:currentItem()
    return self.items[self.current]
end

---@param newMenu MenuPrimitive
function Menu:push(newMenu)
    local pushed = {}
    for k, v in pairs(newMenu) do
        if k ~= "stack" then
            pushed[k] = self[k]
            self[k] = v
        end
    end
    self.stack[#self.stack+1] = pushed
end

function Menu:pop()
    --- Don't do anything if already on top menu or menu is locked
    if #self.stack > 0 and not self.locked then
        --- Pop the menu
        local latestMenu = self.stack[#self.stack]
        --- Remove this menu from the stack
        self.stack[#self.stack] = nil

        for k, v in pairs(latestMenu) do
            self[k] = v
        end
    end
end

function Menu:up()
  if not self.locked then
    local old = self.current

    while self.current > 1 do
      self.current = self.current - 1
      if self:currentItem().selectable ~= false then
        return
      end
    end

    self.current = old
  end
end

function Menu:down()
  if not self.locked then
    local old = self.current

    while self.current < #self.items do
      self.current = self.current + 1
      if self:currentItem().selectable then
        return
      end
    end

    self.current = old
  end
end

function Menu:itemViewport(item)
  local found = false
  local y = 0

  -- Find which item it corresponds
  for _, it in ipairs(self.items) do
    if item == it then
      found = true
      break
    end

    y = y + (it.height or self.defaultHeight)
  end
  if not found then return end

  -- ax, ay, bx, by
  return 0, y, self.w, y + (item.height or self.defaultHeight)
end

---@param dt number
function Menu:update(dt)
    for _, item in ipairs(self.items) do
        if item.update then item:update(self, dt) end
    end
end

function Menu:draw(x, y)
    local currentItem = self:currentItem()
    --- Draw each item
    local x, y = (x or self.x) + self.ox, (y or self.y) + self.oy
    local w = self.w - self.ox

    for _, item in ipairs(self.items) do
        local h = item.height or self.defaultHeight

        if currentItem == item then
            self.funcs.drawBackground(self, x, y, w, h)
        end

        if item.draw then
            item:draw(self, x, y, w, h)
        end

        y = y + h
    end
end

---@param key string
---@param state {[string]: any}
function Menu:inputKey(key, state)
  local currentItem = self:currentItem()

  if not self.locked and state == "pressed" then
    -- Control menu navigation
    local simple_key = self.funcs.simple_key(key)

    if simple_key == "up" then
      self:up()
      return
    elseif simple_key == "down" then
      self:down()
      return
    end
  end

  if currentItem and currentItem.input then
    currentItem:input(self, key, state)
  end
end



---@param x number
---@param y number
---@param btn table
function Menu:inputMouse(x, y, btn)
    local currentItem = self:currentItem()
    
    local vx, vy = self.x + self.ox, self.y + self.oy
    local vw, vh = self.w - self.ox, self.h - self.oy

    local item_y = 0

    if vx <= x and x <= vx + vw and vy <= y and y <= vy + vh then
        -- Mouse is inside the viewport, YAY

        if not self.locked then
        local vp_y = y - vy

        local y = 0
        -- Find which item it corresponds
        for i,item in ipairs(self.items) do
            y = y + (item.height or self.defaultHeight)

            if vp_y < y then
            if self.items[i].selectable then
                self.current = i
                currentItem = self:currentItem()
            end
            break
            end

            item_y = item_y + (item.height or self.defaultHeight)
        end
        end

        if currentItem and currentItem.mouse then
            currentItem:mouse(self, x - vx, y - item_y - vy, btn)
        end
    end
end

---@param txt string
function Menu:inputText(txt)
    local currentItem = self:currentItem()
    if currentItem and currentItem.text then currentItem:text(self, txt) end
end

function Menu:__tostring()
    return "MenuPrimitive"
end

return Menu