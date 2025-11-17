local loadTimeStart = love.timer.getTime()
require("globals")


function love.threaderror(thread, errorMessage)
    print("Thread error!\n" .. errorMessage, thread)
    love.window.showMessageBox("Error", errorMessage, "error")
end

function love.load()
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
    RouterManager:update(dt)
end

function love.draw()
    local drawTimeStart = love.timer.getTime()
    RouterManager:draw()
    local drawTimeEnd = love.timer.getTime()
    local drawTime = drawTimeEnd - drawTimeStart
end
