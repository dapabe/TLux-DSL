local parser = require("tlux.parser")
local codegen = require("tlux.codegen")

local Compiler = {}

---@param path string
function Compiler.load(path)
  local f = assert(io.open(path, "r"))
  local src = f:read("*a")
  f:close()

  local ast = parser:produceAST(src)
  local lua = codegen.generate(ast)

  local chunk, err = load(lua, path)
  if not chunk then error(err) end
  return chunk()
end

return Compiler
