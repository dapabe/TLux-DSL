require("core.utils.printTable")
local localLibs = "./libs/share/lua/5.4/?.lua;./libs/share/lua/5.4/?/init.lua;"
local localLibs_C = "./libs/lib/lua/5.4/?.so;"
local coreLib = "./core/components/primitives/?.lua;"

package.path =  localLibs..coreLib..package.path
package.cpath =  localLibs_C..package.cpath

local Yoga = require("luyoga")

local ScrollView = require ("ScrollView_primitive")

local items = {}
for i = 1, 40 do
    table.insert(items, "Item " .. i)
end


local root
---@type DLux.ScrollViewPrimitive
local sv

function love.load()
    sv = ScrollView:new({
        x = 50,
        y = 50,
        w = 300,
        h = 250,
        accumulatedHeight = #items * 40
    })
end



function love.mousepressed(x, y, b)
    sv:mousePressed(x, y, b)
end

function love.mousereleased(x, y, b)
    sv:mouseReleased(x, y, b)
end

local wheelY = 0

function love.wheelmoved(x, y)
    wheelY = y
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    sv:_update(dt, mx, my, wheelY)
    wheelY = 0 -- Consume the event
end

function love.draw()
    love.graphics.clear(0.15, 0.15, 0.15)
    sv:_draw(function()
        love.graphics.setColor(1, 1, 1)
        for i, text in ipairs(items) do
            love.graphics.print(text, 10, (i - 1) * 40)
        end
    end)
end