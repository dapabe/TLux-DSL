require("globals")


require("core.utils.printTable")

local Watcher = require("watcher")
local Refresh = require("refresh")

local w

function love.load()
    w = Watcher.new("", 0.5)

    love.window.setMode(400, 600)

    RouterManager:hook()
    local RootRoute = require("routes.root").new()
    RouterManager:enter(RootRoute)
end

function love.update(dt)
    local changed = w:update(dt)
    if changed then
        print("[HMR] archivo modificado:", changed)

        -- convierte "src/components/Button.lua" -> "src.components.Button"
        local modulePath = changed
            :gsub("%.lua", "")
            :gsub("/", ".")

        Refresh.reload(modulePath)
    end
    RouterManager:update(dt)
end

function love.draw()
    RouterManager:draw()
end