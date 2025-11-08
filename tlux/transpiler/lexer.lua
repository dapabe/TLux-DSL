
---@class Token
---@field value string
---@field type TokenType



local Lexer = {}

---@param code string
---@return table<Token>
function Lexer.tokenize(code)
    ---@type table<Token>
    local tokens = {}
    local src = code:sub("")
    
    -- Produce tokens until EndOfFile is reached
    while #src > 0 do
        
    end
    
    table.insert(tokens, {type = TokenType["EndOfFile"], value = "EndOfFile"} --[[@as Token]])
    return tokens
end

return Lexer