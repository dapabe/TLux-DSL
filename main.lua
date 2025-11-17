local loadTimeStart = love.timer.getTime()
require("globals")

local Watcher = require("watcher")
local Refresh = require("refresh")

local w

function love.threaderror(thread, errorMessage)
    print("Thread error!\n" .. errorMessage, thread)
    love.window.showMessageBox("Error", errorMessage, "error")
end

function love.load()
    if DEBUG then w = Watcher.new("", 0.5) end
    love.window.setMode(400, 600)

    RouterManager:initYoga(400, 600)
    RouterManager:hook()

    RouterManager:enter(RouteList.Root)

    if DEBUG then
        local loadTimeEnd = love.timer.getTime()
        local loadTime = loadTimeEnd - loadTimeStart
        print(("Load app in %.3f seconds."):format(loadTime))
    end
end

function love.update(dt)
    if DEBUG and w then
        local changed = w:update(dt)
        if changed then
            print("[HMR] File modified:", "<rootDir>" .. changed)

            -- Converts "core/components/Button.lua" -> "core.components.Button"
            local modulePath = changed
                :gsub("%.lua", "")
                :gsub("/", ".")
            Refresh.reload(modulePath)
            RouterManager:refresh()
        end
    end
    RouterManager:update(dt)
end

function love.draw()
    local drawTimeStart = love.timer.getTime()
    RouterManager:draw()
    local drawTimeEnd = love.timer.getTime()
    local drawTime = drawTimeEnd - drawTimeStart
end
