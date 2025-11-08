require("tlux.utils.enums")
require("tlux.ast")

local compiler = require("tlux.compiler")
local Queue = require("tlux.components.factory")[1]

local Runtime = {}
local root

function Runtime.bootstrap(entry)
  root = compiler.load(entry)
end

function Runtime.draw()
  Queue.reset()
  if root and root.draw then root:draw() end
  for _, f in ipairs(Queue.get()) do f() end
end

return Runtime
