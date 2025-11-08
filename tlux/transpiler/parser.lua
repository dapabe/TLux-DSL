require("tlux.ast")
local lexer = require("tlux.lexer")

---@class Parser
---@field tokens table<Token>
local Parser = {}
Parser.tokens = {}

---@returns Token
function Parser:at()
  return self.tokens[1] --[[@as Token]]
end

---@returns Token
function Parser:consumeToken()
  local prev = table.remove(self.tokens, 1) --[[@as Token]]
  return prev
end

---@param src string
---@return string
---@return string
local function parse_frontmatter(src)
  local a, b = src:find("^%s*%-%-%-[\r\n]")
  if not a then return "", src end
  local c = src:find("[\r\n]%-%-%-[\r\n]", b+1)
  assert(c, "missing closing ---")
  local lua_block = src:sub(b+1, c-1)
  local body = src:sub(c+4)
  return lua_block, body
end

---@param attr_text string
local function parse_tag_attrs(attr_text)
  local attrs = {}
  for k,v in attr_text:gmatch("([%w_]+)%s*=%s*{(.-)}") do
    attrs[k] = v
  end
  for k,v in attr_text:gmatch("([%w_]+)%s*=%s*\"([^\"]+)\"") do
    attrs[k] = string.format("%q", v)
  end
  for k,v in attr_text:gmatch("([%w_]+)%s*=%s*([%w_%.%-]+)") do
    if not attrs[k] then attrs[k] = v end
  end
  return attrs
end

---@param src string
local function parse_nodes(src)
  local nodes = {}
  for name, attrs, inner in src:gmatch("<([%w_]+)(.-)>(.-)</%1>") do
    table.insert(nodes, {name=name, attrs=parse_tag_attrs(attrs), children=parse_nodes(inner)})
  end
  for name, attrs in src:gmatch("<([%w_]+)(.-)/>") do
    table.insert(nodes, {name=name, attrs=parse_tag_attrs(attrs), children={}})
  end
  for text in src:gmatch(">([^<>]+)<") do
    local t = text:match("^%s*(.-)%s*$")
    if #t > 0 then table.insert(nodes, {name="__text", value=t}) end
  end
  return nodes
end

---@returns Expr
function Parser:parseExpr()

end


---@returns Expr
function Parser:parseExprPrimary()
  local tk = self:at().type

  ---@type table<TokenType, fun(): Expr>
  local switch = {
    [TokenType["Identifier"]] = function ()
      return {kind = "Identifier", symbol = self:consumeToken()}
    end,
    [TokenType["Number"]] = function ()
      return {kind = "NumericLiteral", value = tonumber(self:consumeToken().value)}
    end,
  }
  local switchVal = switch[tk]
  if not switchVal then
    print("Unexpected token found during parsing: "..self:at())
    return {}
   end
  return switch[tk]()
end


---@returns boolean
function Parser:notEOF() return Parser.tokens[1].type ~= TokenType["EndOfFile"] end

---@returns Stmt
function Parser:parseStmt()
  ---@type Stmt
  local stmt = {}

  return self:parseExpr()
end

---@param code string
---@return StmtProgram
function Parser:produceAST(code)
  ---@type StmtProgram
  local program = {kind = "Program", body = {}}

  while self:notEOF() do
    table.insert(program.body, self:parseStmt())
  end

  return program
end

-- ---@param src string
-- function Parser.parse(src)
--   local lua, body = parse_frontmatter(src)
--   local comps = parse_nodes(body)
--   return {lua_block=lua, components=comps}
-- end

return Parser
