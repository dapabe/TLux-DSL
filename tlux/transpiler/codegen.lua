local Codegen = {}

local function emit_node(node)
  if node.name == "__text" then
    return string.format("q.Text{ value=%q }", node.value)
  end

  local attrs = {}
  for k,v in pairs(node.attrs or {}) do
    table.insert(attrs, k .. "=" .. v)
  end
  local children = {}
  for _,c in ipairs(node.children or {}) do
    table.insert(children, emit_node(c))
  end

  local args = table.concat(attrs, ", ")
  if #children > 0 then
    if #args > 0 then args = args .. ", " end
    args = args .. "children={" .. table.concat(children, ",") .. "}"
  end

  return string.format("q.%s{%s}", node.name, args)
end

function Codegen.generate(ast)
  local out = {ast.lua_block}
  for _,c in ipairs(ast.components) do
    table.insert(out, "return " .. emit_node(c))
  end
  return table.concat(out, "\n")
end

return Codegen
