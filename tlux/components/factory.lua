

local draw_queue = {}

local Queue = {}
function Queue.reset() draw_queue = {} end
function Queue.get()
    return draw_queue
end

local __dir = __dirname(...)
local components = {
    View = require(__dir.."View"),
    Text = require(__dir.."Text")
}


return {Queue, components}