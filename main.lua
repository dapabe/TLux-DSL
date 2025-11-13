require("core.utils.printTable")
package.path = "./libs/share/lua/5.4/?.lua;./libs/share/lua/5.4/?/init.lua;" .. package.path
package.cpath = "./libs/lib/lua/5.4/?.so;" .. package.cpath

local Yoga = require("luyoga")

---@type luyoga.Node
local root
local items = {}
local scrollY = 0
local layoutHeight, layoutWidth = 600, 400
local itemHeight = 60
local totalItems = 30
local maxVisible = math.ceil(layoutHeight / itemHeight) + 1

local function createItemNode(i)
    local node = Yoga.Node.new()
    node.style:setPositionType(Yoga.Enums.PositionType.Absolute)
    node.style:setWidth(layoutWidth)
    node.style:setHeight(itemHeight)
    -- node.style:setMargin(Yoga.Enums.Edge.Right, 5)
    node.text = "Elemento " .. i
    return node
end

-- Actualiza posición y contenido del nodo según el índice visible
---@param node luyoga.Node
local function updateItemNode(node, i)
    node.style:setPosition(Yoga.Enums.Edge.Top, i * itemHeight)
    node.text = "Elemento " .. i
end

-- Calcula índice inicial y final según el scroll
local function getVisibleRange()
    local startIdx = math.floor(scrollY / itemHeight)
    local endIdx = math.min(totalItems - 1, startIdx + maxVisible)
    return startIdx, endIdx
end

function love.load()
    love.window.setMode(800, 700)
    love.window.setTitle("DLux Testing")

    root = Yoga.Node.new()
    root.style:setWidth(layoutWidth)
    root.style:setHeight(totalItems * itemHeight)
    root.style:setFlexDirection(Yoga.Enums.FlexDirection.Column)

    for i = 1, maxVisible do
        local node = createItemNode(i)
        root:insertChild(node, i)
        table.insert(items, node)
    end

    root:calculateLayout(layoutWidth, layoutHeight * itemHeight, Yoga.Enums.Direction.LTR)
end

function love.update(dt)
    local scrollSpeed = 300
    if love.keyboard.isDown("down") then
        scrollY = math.min(scrollY + scrollSpeed * dt, totalItems * itemHeight - layoutHeight)
    elseif love.keyboard.isDown("up") then
        scrollY = math.max(scrollY - scrollSpeed * dt, 0)
    end

    -- Actualiza las posiciones visibles sin recrear nodos
    local startIdx, endIdx = getVisibleRange()

    for i, node in ipairs(items) do
        local idx = startIdx + (i - 1)
        if idx < totalItems then
            updateItemNode(node, idx)
        else
            node.text = ""
        end
    end

    root:calculateLayout(layoutWidth, layoutHeight, Yoga.Enums.Direction.LTR)
end

function love.wheelmoved(x,y)
    local maxScroll = math.max(0, root.layout:getHeight() - layoutHeight)
    scrollY = math.max(0, math.min(scrollY - y * 40, maxScroll))
    end

function love.draw()
    love.graphics.clear(0.15, 0.15, 0.15)

    love.graphics.setScissor(0, 0, layoutWidth, layoutHeight)
    love.graphics.push()
    love.graphics.translate(0, -scrollY)

    for _, node in ipairs(items) do
        local x = node.layout:getLeft()
        local y =  node.layout:getTop()
        love.graphics.setColor(0.25, 0.25, 0.25)
        love.graphics.rectangle("fill", x + 10, y, layoutWidth - 20, itemHeight - 5, 6, 6)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(node.text, x + 30, y + 25)
    end

    -- Borde del layout total (azul)
    -- love.graphics.setColor(0, 0.6, 1)
    -- love.graphics.setLineWidth(2)
    -- love.graphics.rectangle("line", 0, 0, layoutWidth, totalItems * itemHeight)

    love.graphics.pop()
    love.graphics.setScissor()


    -- Scrollbar
    local contentHeight = root.layout:getHeight()
    if contentHeight > layoutHeight then
        local ratio = layoutHeight / contentHeight
        local barHeight = layoutHeight * ratio
        local barY = (scrollY / contentHeight) * layoutHeight
        love.graphics.setColor(0.6, 0.6, 0.6, 0.8)
        love.graphics.rectangle("fill", layoutWidth - 8, barY, 6, barHeight, 3, 3)
    end

    -- Borde visible del viewport
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, layoutWidth, layoutHeight)
end
